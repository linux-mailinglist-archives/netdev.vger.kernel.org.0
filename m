Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B3F1030C9
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfKTAfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:35:34 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40782 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKTAfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:35:33 -0500
Received: by mail-lf1-f66.google.com with SMTP id v24so7759020lfi.7
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 16:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ullADfQgkA48BrR4+aJPh9qmRppfYHkw29yHAiIZ8XM=;
        b=Q3O21H/clKlhd2sfP3lVeCOw87BdpWOJrFnw7vk5Wb20L26gsWhv5iZlE+C8bE5RvO
         G1WRGbrS9Td3eLwaofuPL+IABWSf5EJDWFjCwJYLfl05I4ev7S70xJAErShd9tO4J1g0
         Prpn5hq6zgbuHKiyoC9ctin5JpQ7cG4Rs7UeskH+bdz1qBkOMXEzwNm6UtcG3G4DFItr
         Xia8CFCTBUmYmdg5Bo3uCuwz3HTfk6pmxD0gYCsVR/VgVfEgEOdgNOpsTXbirO5FELgj
         1sKKOErfhqUT27bgfOmx6mrKFRwxYN5PMBpNFEgnuT5h1/lfvmZzTugMVV+kc1savN6U
         c2Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ullADfQgkA48BrR4+aJPh9qmRppfYHkw29yHAiIZ8XM=;
        b=hLW+xXq5dDD+z4vN2cffnUiq3lexFnDMIwrGwsFtQly+LzviGb79TyqTNbGGw+zvTm
         BVk77rj3esxb3+xkL0Z4sWXf6PcelRY50OCcDRD85Fm2Wd1WE7GgmbgwyD62e40ls83P
         /sl/XmeeHsMXFYVZmKa5t0VvUt8zvOyM1fya4enQ47yt/5WTMQ4AdlB6OyuNlCsihN7n
         kP3ZCiyqDIwL8q8stZQQT9oI/mRcBa1JOziNPqkvTjMlmqodxIcMjroAUnjN/p+2Kx9v
         GAV7VP2ldOQyf91W3JH+XF6eRX2Bga+OraNl+sxHrcfp7cwc5yW5fAZ84lcbwM00vlPZ
         cEzA==
X-Gm-Message-State: APjAAAVtPTnN8DCH/rV8xBbupzEoALaWq3yqvbLxfwg3WvJ6lqjkyCxg
        slZFXdUeBZ4kD3kyTruU/hSHIkRWtgg=
X-Google-Smtp-Source: APXvYqxPkYuSHQIMaEaXea8dxZNOItOwx9KvXao2LrHCCP8mtm021f3GgHMPjo/s+ybGouKBA9Yf4A==
X-Received: by 2002:ac2:5119:: with SMTP id q25mr287290lfb.175.1574210131608;
        Tue, 19 Nov 2019 16:35:31 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 12sm10837481lju.55.2019.11.19.16.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 16:35:31 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:35:19 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@resnulli.us,
        nirranjan@chelsio.com, vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v5 0/3] cxgb4: add TC-MATCHALL classifier
 offload
Message-ID: <20191119163519.07765c0c@cakuba.netronome.com>
In-Reply-To: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 05:46:05 +0530, Rahul Lakkireddy wrote:
> This series of patches add support to offload TC-MATCHALL classifier
> to hardware to classify all outgoing and incoming traffic on the
> underlying port. Only 1 egress and 1 ingress rule each can be
> offloaded on the underlying port.
> 
> Patch 1 adds support for TC-MATCHALL classifier offload on the egress
> side. TC-POLICE is the only action that can be offloaded on the egress
> side and is used to rate limit all outgoing traffic to specified max
> rate.
> 
> Patch 2 adds logic to reject the current rule offload if its priority
> conflicts with existing rules in the TCAM.
> 
> Patch 3 adds support for TC-MATCHALL classifier offload on the ingress
> side. The same set of actions supported by existing TC-FLOWER
> classifier offload can be applied on all the incoming traffic.
> 
> Thanks,
> Rahul
> 
> v5:
> - Fixed commit message and comment to include comparison for equal
>   priority in patch 2.

LGTM, thanks!
