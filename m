Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0332FEEFF
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733096AbhAUPgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733063AbhAUPeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:34:07 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8923C061788
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:32:26 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id l9so3197196ejx.3
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sHNbXPxata53f3vdfOMRm5qAa62hPF704O/9xB9VcCs=;
        b=Sj4PdSErx4mLI+LXKSbwZpCi9C9SoGjH8KYHHZuKOodoQgweknZoXBj05IP5OFiNDQ
         p+uWVKzFuRah7H6DV4rFd90eElqxOT8y8sMoRmZq8KMe7e9vJROKoBcbbP0g0xL+vv4J
         Lb5XhDKOkFz//aYSvgdqn5cb1y/gTLDHyNwYnI33udQMhr1OtcOlOlZG4favlNTZbLdk
         IQXQiL4O+ojUnAcoMARmoOntyodbn/NgGcOx1HC4EiHUnnBwgWJYa0b/kwd/0v5mT9Nb
         0B8rY3FHvSrHIpJQ/6jqzubs81K7nLc74olZCDBqE/ekc1QjQ3YtdpQzsi1OB1k5wX4b
         G3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sHNbXPxata53f3vdfOMRm5qAa62hPF704O/9xB9VcCs=;
        b=IfoDvPg7EtqkXBmVxRxidOmTWaMrrQfIJu0ZpEf1C930q6MhQXS+Lh4vEgB2clBYHS
         ZhBk+er3TIEf8HIQcKfkJgFyELO9/iCVTcoomd5XUHUR7RTJx2F5zppyFTox8nCfEPlN
         wDhE6zq1wn7Ede6Oh8DsIeRuuSLGVa+JBDeKH66A2wwCt8gCcBSPWrAHEmwCmTnZxjrq
         xdaVKFwZDg5CbYRpOnE0KE25CR3v1cnwrJ7LipxTFB4yM7oDoJuDxcmhy0z+sc8rV9V4
         5iOL7oavp0DX4VqQNGOB9Uei+WhSp5hsbTLncp0tDewT1rXL9gxZxBaKDbOLJQG0h5gv
         SIdw==
X-Gm-Message-State: AOAM530OXG7TOKawP1H7burz4Yj6xYVBm/MiFooL/D6pCAn0LhnCLiSL
        mFmYXJuzfBJrQJrYKRDAArayMUI6FKgnYP0b7sc=
X-Google-Smtp-Source: ABdhPJwWiXMc4Q947mHh91I7BYKtAcy9tVMwlm0kpcugLy23MHpy3RJGgh+cWGjJXisQKwzSqBJ3pQ==
X-Received: by 2002:a17:906:4690:: with SMTP id a16mr25339ejr.442.1611243145733;
        Thu, 21 Jan 2021 07:32:25 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id x6sm2368542ejw.69.2021.01.21.07.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 07:32:25 -0800 (PST)
Date:   Thu, 21 Jan 2021 16:32:24 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, jacob.e.keller@intel.com, roopa@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210121153224.GE3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch>
 <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 21, 2021 at 12:41:58AM CET, kuba@kernel.org wrote:
>On Wed, 20 Jan 2021 14:56:46 +0100 Andrew Lunn wrote:
>> > No, the FW does not know. The ASIC is not physically able to get the
>> > linecard type. Yes, it is odd, I agree. The linecard type is known to
>> > the driver which operates on i2c. This driver takes care of power
>> > management of the linecard, among other tasks.  
>> 
>> So what does activated actually mean for your hardware? It seems to
>> mean something like: Some random card has been plugged in, we have no
>> idea what, but it has power, and we have enabled the MACs as
>> provisioned, which if you are lucky might match the hardware?
>> 
>> The foundations of this feature seems dubious.
>
>But Jiri also says "The linecard type is known to the driver which
>operates on i2c." which sounds like there is some i2c driver (in user
>space?) which talks to the card and _does_ have the info? Maybe I'm
>misreading it. What's the i2c driver?

That is Vadim's i2c kernel driver, this is going to upstream.
