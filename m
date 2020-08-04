Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7065E23B869
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgHDKEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbgHDKEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 06:04:21 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7707CC061756
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 03:04:21 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so1844649wmc.0
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 03:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pegb0ogFlCOGFMDWVKjVJSjrV23uFfG+68FKgoAHUYg=;
        b=qQ/w6vAtQCyNq/N4PY2sly/z47Hs2FmYbLoaFwozntW55ABMjsTts2O+Es0m+jaOyG
         ndtUKCdb1yI2DENSgvww2GO8gUK9+zwzLZsL/5tXQOHh7buHn0aN1mb42LcU96AwSlOU
         PUhRcvOjTh3gr+RqpKJhaCIb6gKkvEXoRy5KrT3L+8Dhd6Q86WoDNtvU3T/LhpBFexCq
         g4Nd4JtUMXVXPWTZ04C2ZDXxzik3XgVOQXl/dbMhM/jOZHYP0hB0m0ajaC6T2Xwf8GcY
         xPSSpTuhFtOoR9wZN5cXyunYxhySi3pw/P4B3DFJ/Iqd5aaYi6PZ2M+j1cROPpCEiCgq
         wgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pegb0ogFlCOGFMDWVKjVJSjrV23uFfG+68FKgoAHUYg=;
        b=h9e4Rm87lfYEa6hRszDni/ZYjAIs9QY3SSdH6iwpEksXiY51z9VtsgUteag3pEDejV
         3rgJ9Sbo1ZBdIr4o+q/fY0Dk5a9RmmIPJj/A71/bcXy7W6he7jwBjozTMY5gu14ZUNcy
         W4LqqmNSWoj/bn/ofuWURgOqgz/rwWu8cm1NeXvV/etrTRBDEKEy86boN+UJeoRwhxM6
         YT+CW5tA+B+8DHVrxS9CXpe18SuK/ppcz4W7WRCorYtI97geERorlj22ffVYHcaCQCD1
         52unIyuvmxiw/K/zrFZkCB7+85ZpopsiL/Hgn5yJilomY2FfdBhpZv+pCJqe1kTnBqnd
         eA8A==
X-Gm-Message-State: AOAM531HYTslQF3QD92wC4NFG/YFNGpScBAFdE/pkiUA7Rq/gZJ2t3QZ
        LHlGeIc27jrxF3KbJlCGchdcNQ==
X-Google-Smtp-Source: ABdhPJwPnDHvQ5rfJ7GM0+ImQIFOM19YzN0zd70NhwTMWU/JLhOpoZSqNUQXGrlv00D6sRZCPVyXWw==
X-Received: by 2002:a1c:e107:: with SMTP id y7mr3143467wmg.99.1596535460198;
        Tue, 04 Aug 2020 03:04:20 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z15sm28680490wrn.89.2020.08.04.03.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 03:04:19 -0700 (PDT)
Date:   Tue, 4 Aug 2020 12:04:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200804100418.GA2210@nanopsycho>
References: <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
 <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
 <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
 <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
 <20200803141442.GB2290@nanopsycho>
 <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 03, 2020 at 10:57:03PM CEST, kuba@kernel.org wrote:
>On Mon, 3 Aug 2020 16:14:42 +0200 Jiri Pirko wrote:
>> >devlink dev reload [ net-ns-respawn { PID | NAME | ID } ] [ driver-param-init
>> >] [ fw-activate [ --live] ]  
>> 
>> Jakub, why do you prefer to have another extra level-specific option
>> "live"? I think it is clear to have it as a separate level. The behaviour
>> of the operation is quite different.
>
>I was trying to avoid having to provide a Cartesian product of
>operation and system disruption level, if any other action can
>be done "live" at some point.
>
>But no strong feelings about that one.
>
>Really, as long as there is no driver-specific defaults (or as 
>little driver-specific anything as possible) and user actions 
>are clearly expressed (fw-reset does not necessarily imply
>fw-activation) - the API will be fine IMO.

Clear actions, that is what I'm fine with.

But not sure how you think we can achieve no driver-specific defaults.
We have them already :/ I don't think we can easily remove them and not
break user expectations.

