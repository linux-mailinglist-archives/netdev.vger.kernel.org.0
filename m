Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960D7318FD7
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhBKQYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbhBKQU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:20:56 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB5BC061574
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 08:20:15 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id f3so2938507oiw.13
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 08:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MAyrtQhdnPi+THVCt2Y8nxvlrp3tKuk+brgAb9FMscw=;
        b=FsmxhQxF0emlFfSXthi+V3JWArCjwumQlBUqeLMSuMQGPb6hyDklW+q7Heb1Aj05wf
         pWGJERgO7LzfpysHMCZmQ6A2GHf4N1Ov79EYpvDYsoFpwMXqbk7Ar8adEqdkAb6lxaF8
         9tR604y5mbJNBYc3U0+YT51EjOaeACCnuVkaZpeRZwAoXgh1cYNaNaIx1YUsDnuGnIEK
         B1X4hIdKIXl0xvH8uTQWHzaMyTcnnmrJPw3i8yuVxcL9Do36Ow3ZmGBEwE/DmEvD1eKS
         2GyKN9dc6MjSxm5uBaYEHEryNn2YEGrhY9n5TfYB+p+UEK1dz87XrL5UbjDqOhPh/SZw
         /M+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MAyrtQhdnPi+THVCt2Y8nxvlrp3tKuk+brgAb9FMscw=;
        b=Rs5Pr0seN5Fdcp4TJFjI0COfRttSzqG4pJo3QW37rB4vawV3SNzMR44IVaeRo94GRz
         mAyTkMT/TAq11w/fyzs3KGeahLWxhyNfGqd3/9fRP2hPrMVC+9liuEYkY0VPmxWEoE37
         MBfWZo/fFcaPln65hOydJhgq3rYjwevHHdQ/Qst02y1tr0+zn5kLLqDuvwrs1biHjLPB
         Mock4V3e2MSP9b1EXCIjZBq7tQ8r49PO+xh+LPfAw0CaS0rKPCbVCKDoPoNj4qqc3/qH
         9k9Qq74FxnsHrpVoXiHd2FcTK9ToR+ildCQ08lqBv2us2+ts0STWFbVNa13RoQfixWdb
         16Zw==
X-Gm-Message-State: AOAM532wZuV8PI5E5BLApODeK6TR5a4Yutq6PcJOWRmAuMw19Sdjtng/
        Irr5tqlfwNCPGWdCPbVVV2s=
X-Google-Smtp-Source: ABdhPJzE0w8a1EUnCb8+N+o88195mo8zyCfk7RaMpAeEMwDqODLOd41DhbRcU4JE0L8TzBro5r+qtg==
X-Received: by 2002:aca:52d1:: with SMTP id g200mr3364497oib.44.1613060415125;
        Thu, 11 Feb 2021 08:20:15 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id g66sm1081686otg.54.2021.02.11.08.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 08:20:14 -0800 (PST)
Subject: Re: [PATCH iproute2-next v5 0/5] Add vdpa device management tool
To:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stephen@networkplumber.org, mst@redhat.com, jasowang@redhat.com
References: <20210210183445.1009795-1-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f5748e77-0004-4452-c413-15272a594d76@gmail.com>
Date:   Thu, 11 Feb 2021 09:20:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210183445.1009795-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/21 11:34 AM, Parav Pandit wrote:
> Linux vdpa interface allows vdpa device management functionality.
> This includes adding, removing, querying vdpa devices.
> 
> vdpa interface also includes showing supported management devices
> which support such operations.
> 
> This patchset includes kernel uapi headers and a vdpa tool.
> 

applied to iproute2-next.

I am expecting a followup converting devlink to use the indent and mnl
helpers.

