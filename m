Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1995D2FCCDB
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 09:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbhATIin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 03:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730679AbhATIhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 03:37:34 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2012C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 00:36:08 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id by1so25938663ejc.0
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 00:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c+j24Mm9EDc0Nm1u1SfM0jRPOO22Iok7+TXDeLGyYd0=;
        b=BBf8iIgovgix29pKobAJuDzFMBvwBn8zWN4oobdstADWLTIVIdo1kwCWx19l82dVVP
         Qrs2UvXomdBeLuaqsqsLNkiupavrdW4ZGnhlRQCbnHefjkRYLaqXM3bWMuyH8Gjpc1uK
         /Q2itYz2Gu26Ss1+uxrSlRid0nca4zLOCRuqaRHINf8/Md++JPjXF3jSRgMXjAvsteQC
         zqh0T0zRc/tHCTmER4TGuN9upSnaY3YHsAn5QzPgEQo5BNAlj7tzJJDIMkiJfJDhh6Ey
         8ziL13vNuqsKanD1GEhurwpSiPomoKKxQvDCH/kgZsDeEg+XEXI8Xbu2yqYkc79iOkVe
         KL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c+j24Mm9EDc0Nm1u1SfM0jRPOO22Iok7+TXDeLGyYd0=;
        b=Rr2oKZcIPXeIgf22ZFjA7OfyqGWArrX8Ix8jDQORyUMSyQtjaWWxFy64rguUGHJclL
         bMa12YVpjo6lH4HFGywkCsVDkfD5Y1p1A96LlAG9ZaHrdgppwy1wlWQ8LeByqURFJKVw
         m0mjp2CwB1DgPrHYMmT3ljb8CEUhyB/8EcD541cLZqMPgISh0EUaRqCYQ/LAcmgnFygS
         8XrDmcKBQQMvILjdP4eBN5+9TrPKIlAMTeM9iWD88glAd/LzhwSPC36RebjrdSRHDnmX
         njLzs1MNP9Go/Whflq9xRsrweUj2mE+I2MqJ+z7vJalY10wRzAYXWg1KAevuiSB2Fvgf
         S+MQ==
X-Gm-Message-State: AOAM531O1sepq0fiRHTN5tAOmNJCSJeOPccH0NGRG9hb71qCETnliQRz
        RpfDeek19bRb1Yf9oQOcZ2LqtA==
X-Google-Smtp-Source: ABdhPJz6OcWlMX0pb5efNje9TedSSBBmEsUD/1eD5YXDzhM78xCQ/OXYUZUTcJCOw1aQnOx9JD5X2w==
X-Received: by 2002:a17:906:19c3:: with SMTP id h3mr5389107ejd.429.1611131767639;
        Wed, 20 Jan 2021 00:36:07 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id s1sm577722ejx.25.2021.01.20.00.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 00:36:07 -0800 (PST)
Date:   Wed, 20 Jan 2021 09:36:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210120083605.GB3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAbyBbEE7lbhpFkw@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 19, 2021 at 03:51:49PM CET, andrew@lunn.ch wrote:
>On Tue, Jan 19, 2021 at 12:56:10PM +0100, Jiri Pirko wrote:
>> Thu, Jan 14, 2021 at 03:07:18AM CET, andrew@lunn.ch wrote:
>> >> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
>> >> $ devlink lc
>> >> netdevsim/netdevsim10:
>> >>   lc 0 state provisioned type card4ports
>> >>     supported_types:
>> >>        card1port card2ports card4ports
>> >>   lc 1 state unprovisioned
>> >>     supported_types:
>> >>        card1port card2ports card4ports
>> >
>> >Hi Jiri
>> >
>> >> # Now activate the line card using debugfs. That emulates plug-in event
>> >> # on real hardware:
>> >> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>> >> $ ip link show eni10nl0p1
>> >> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>> >>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
>> >> # The carrier is UP now.
>> >
>> >What is missing from the devlink lc view is what line card is actually
>> >in the slot. Say if i provision for a card4port, but actually insert a
>> >card2port. It would be nice to have something like:
>> 
>> I checked, our hw does not support that. Only provides info that
>> linecard activation was/wasn't successful.
>
>Hi Jiri
>
>Is this a firmware limitation? There is no API to extract the
>information from the firmware to the host? The firmware itself knows
>there is a mismatch and refuses to configure the line card, and
>prevents the MAC going up?

No, the FW does not know. The ASIC is not physically able to get the
linecard type. Yes, it is odd, I agree. The linecard type is known to
the driver which operates on i2c. This driver takes care of power
management of the linecard, among other tasks.


>
>Even if you cannot do this now, it seems likely in future firmware
>versions you will be able to, so maybe at least define the netlink

Sure, for netdevsim that is not problem. Our current hw does not support
it, the future may.


>attributes now? As well as attributes indicating activation was
>successful.

State "ACTIVATED" is that indication. It is in this RFC.


>
>	Andrew
