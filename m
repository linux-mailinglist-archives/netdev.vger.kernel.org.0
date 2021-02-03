Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5681E30DD64
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 15:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhBCO6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 09:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbhBCO6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 09:58:35 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC10C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 06:57:54 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id r12so36221580ejb.9
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 06:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pSYv+khRvsbNf3JLj4jUwsjV7dEBBUnrTGHDrcWnC98=;
        b=BMTgodEjkqKS2yo1DFfoMjBNNOfnxegrkP8gdFwpkUEk3YuZvBqJV9AEaQXwD9OARr
         cnxslI4lZl2i/w6cnpGOIx2VCtjAC3VXulRQjMzU9q2tsV0XUIp4ntHZXRaBHdPJ98in
         4jCRAEJPNmtqY0gCLRJ5nbdJLeCm6u/H2iH1z7zhQqwK0ZoOXZ4qHDvha4OQ6i1ToTEd
         wQReG36sSJqS+IKm58CU4jmy5FPuvTQEP7t/dhcbTbwNW75IEz1RaxwafYATLokE0Uh7
         hhoj8HtkJ1hVH/OO9Egjm1az7ExosizdQU/XN7dZe0CE685CJzvlgtnRhhIb8u1gbS4r
         tyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pSYv+khRvsbNf3JLj4jUwsjV7dEBBUnrTGHDrcWnC98=;
        b=osC0IpeQLjNPlcPAYKfJg95+NCbP+gkxhzqD1729At0C/snZAzPUHLx7OVxVUnCzaK
         XeJ6vVCe96nLUCicDNbpguLbZ9r9/OHO1bYg5vV1NH5944dufens3QRBLNdObFd8GMRJ
         xvX4OMRbt3LOLtZidFrSJ+OTBd/GMAs1xdx2IfVggoo3lzbZQzpcB2DxCQjrnMAbuo12
         XF/8p+6xOto4Lg/g/9fUD4Ubterp7FU4JQ8zCNzhgw1y+EIFqixYqhr1jzyApbv5bTKF
         ezJONJEr1IfiyC6E6T05Zvm2VzHjqJxMkKHIRZfdgjxu6IoDswk7PCJNeS67q1POBMNM
         5GdA==
X-Gm-Message-State: AOAM533Bj2smk28YACgmIF3UwkmTVw6U/X7dJqSw775j0BEZiHgN6awP
        u0PxMc3/+pqW3aRMx93OQHYigg==
X-Google-Smtp-Source: ABdhPJwTPU2ABZEJJOlwIDxF++zYCOtUxBjh39Lit5fpIMbxV/XpIob+YsCdGcn9UbggV+9lFcwEjA==
X-Received: by 2002:a17:906:2cd4:: with SMTP id r20mr3592574ejr.291.1612364273457;
        Wed, 03 Feb 2021 06:57:53 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id go20sm1070502ejc.91.2021.02.03.06.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:57:52 -0800 (PST)
Date:   Wed, 3 Feb 2021 15:57:51 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Ahern <dsahern@gmail.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Roopa Prabhu <roopa@nvidia.com>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210203145751.GD4652@nanopsycho.orion>
References: <20210128081434.GV3565223@nanopsycho.orion>
 <YBLHaagSmqqUVap+@lunn.ch>
 <20210129072015.GA4652@nanopsycho.orion>
 <YBQujIdnFtEhWqTF@lunn.ch>
 <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
 <YBRGj5Shy+qpUUgS@lunn.ch>
 <20210130141952.GB4652@nanopsycho.orion>
 <251d1e12-1d61-0922-31f8-a8313f18f194@gmail.com>
 <20210201081641.GC4652@nanopsycho.orion>
 <YBgE84Qguek7r27t@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBgE84Qguek7r27t@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 01, 2021 at 02:41:07PM CET, andrew@lunn.ch wrote:
>On Mon, Feb 01, 2021 at 09:16:41AM +0100, Jiri Pirko wrote:
>> Sun, Jan 31, 2021 at 06:09:24PM CET, dsahern@gmail.com wrote:
>> >On 1/30/21 7:19 AM, Jiri Pirko wrote:
>> >> Fri, Jan 29, 2021 at 06:31:59PM CET, andrew@lunn.ch wrote:
>> >>>> Platform line card driver is aware of line card I2C topology, its
>> >>>> responsibility is to detect line card basic hardware type, create I2C
>> >>>> topology (mux), connect all the necessary I2C devices, like hotswap
>> >>>> devices, voltage and power regulators devices, iio/a2d devices and line
>> >>>> card EEPROMs, creates LED instances for LED located on a line card, exposes
>> >>>> line card related attributes, like CPLD and FPGA versions, reset causes,
>> >>>> required powered through line card hwmon interface.
>> >>>
>> >>> So this driver, and the switch driver need to talk to each other, so
>> >>> the switch driver actually knows what, if anything, is in the slot.
>> >> 
>> >> Not possible in case the BMC is a different host, which is common
>> >> scenario.
>> >> 
>> >
>> >User provisions a 4 port card, but a 2 port card is inserted. How is
>> >this detected and the user told the wrong card is inserted?
>> 
>> The card won't get activated.
>> The user won't see the type of inserted linecard. Again, it is not
>> possible for ASIC to access the linecard eeprom. See Vadim's reply.
>> 
>> 
>> >
>> >If it is not detected that's a serious problem, no?
>> 
>> That is how it is, unfortunatelly.
>> 
>> 
>> >
>> >If it is detected why can't the same mechanism be used for auto
>> >provisioning?
>> 
>> Again, not possible to detect.
>
>If the platform line card driver is running in the host, you can
>detect it. From your wording, it sounds like some systems do have this
>driver in the host. So please add the needed code.

But if not, it cannot. We still need the provisioning then.


>
>When the platform line card driver is on the BMC, you need a proxy in
>between. Isn't this what IPMI and Redfish is all about? The proxy
>driver can offer the same interface as the platform line card driver.

Do you have any example of kernel driver which is doing some thing like
that?


>
>    Andrew
