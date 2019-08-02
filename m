Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6607EDBD
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 09:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390028AbfHBHng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 03:43:36 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:43208 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfHBHng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 03:43:36 -0400
Received: by mail-wr1-f43.google.com with SMTP id p13so1572807wru.10
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 00:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zwQXAb3Ly66kHn6geM7bxIgPbEdjsLwC+Uob1l0AiJw=;
        b=JmKbQlMkDNj9VrPqfK+/aVhBGSB4xkMRnXx3xmv6h22iLsO3sHMF/rpq3qcUG+wQMi
         pl9sR7Q+LTeM1zU8WFydY9yKz2mjaZMMTmu/+9SpY39W86SPqNNEuWparSYxVYM5rcnw
         6SNyNL7h3Z1P6ktgSmqVKD4Gb33GZ2bkJqMpEfIyKdAZFxGSTcX8DkAHV2jQh+THq06/
         NVrSbHLksrZeGOgJc67mn0OBpkj+vn1rcdTy4U79dqXHLqiLKNwRNB9rZvYX8UkzKQqm
         37L2H4FOmgbqbqA12GTIC/nam0KTyKMohrSCY0hvs2gMXpvNYUYsXdDn+6MDsgFqw6pP
         ERmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zwQXAb3Ly66kHn6geM7bxIgPbEdjsLwC+Uob1l0AiJw=;
        b=Ei4PCHuZyhQJA4ggGCDSWeY/ApkcVmYvWGhgs9p1Tw1j/e3bNX6J+ClA5pm9nm7s/d
         qHXfwTNOXtWfBjxZyCKNUp5v5P0T4TIkTw5m5R1vaEHtoR9st4Bsr/l0yab75c0/3Wbp
         2XfVAn4DxFkTMSI4NlxYmY6MN8EpHj/7sNMCOrum3vFHuOiHvuhzf2IWRLOj6OyWDraz
         aVKPsKb2zexHlvLbt1DtxLq/7IKSOj98/ReEUoQZj2xJ2fjWDV6u7PRE82IEADSla0mI
         xcwX4mpF6GggdwpaXMWWreOibc02mpDUxbbJxj3BdhyPa6UuQFer7bSkzA0YS332sESG
         0DFg==
X-Gm-Message-State: APjAAAXGAYcjH95DoGGFJHkmamqHScIfVcTMIVFtLE+T6tEiL9s0ovkS
        npr5WmYWcWDQazKaDiBUpQQ=
X-Google-Smtp-Source: APXvYqw/CdIwumcWegg5x3zhs7MsJdZJo59sPWMaCxR0+vYCuvXBfn27IpJboSq/XQ75kMLdB4HM0Q==
X-Received: by 2002:a5d:4a02:: with SMTP id m2mr143469269wrq.78.1564731814275;
        Fri, 02 Aug 2019 00:43:34 -0700 (PDT)
Received: from localhost ([80.82.155.62])
        by smtp.gmail.com with ESMTPSA id k9sm4598189wrd.46.2019.08.02.00.43.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 00:43:33 -0700 (PDT)
Date:   Fri, 2 Aug 2019 09:43:31 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Message-ID: <20190802074331.GB2203@nanopsycho>
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 31, 2019 at 09:46:13PM CEST, dsahern@gmail.com wrote:
>On 7/31/19 1:45 PM, Jiri Pirko wrote:
>>> check. e.g., what happens if a resource controller has been configured
>>> for the devlink instance and it is moved to a namespace whose existing
>>> config exceeds those limits?
>> 
>> It's moved with all the values. The whole instance is moved.
>> 
>
>The values are moved, but the FIB in a namespace could already contain
>more routes than the devlink instance allows.


There is no relation between fib and devlink.
>
