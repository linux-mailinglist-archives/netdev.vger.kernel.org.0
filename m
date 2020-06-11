Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAA01F67C2
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 14:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgFKMS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 08:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbgFKMSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 08:18:24 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98935C08C5C3
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 05:18:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q11so5942281wrp.3
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 05:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sRWbDkWYC9nAJ025IRpbFE/lsotHSaYZvRXdkx9meq8=;
        b=h9ZDfCmR0YS08+PTFkGw2gZVSqhrHw/UmrHbYlzU9f0Dn5QXGMVMJftpUyXymoA0VI
         fPKaRMj6HsWvV84ZyaZzyPK1eJWeHtQObzPllZBdrEo27HzZIXGuU/6suX4aKPZXb63e
         DPPrSW4DFI5LAb4EO/zU6AqUY9QKoS6x+bt3pkp5w6u/M4sRHCLdBBF0lxYW1eyPr3ZT
         Cq7tm/SVcjqkObP5Wvr9NCkYPXiUioOaGWG3guBsAN0wFcQ9SmHH2hZhgvUS06e2N2LH
         vIsc/gydaUHLiYzn0EcPLCH+iuqnv3es7iiKSfsi599GMuZAmNAFpJkQ7fZb4fAG4kMK
         s+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sRWbDkWYC9nAJ025IRpbFE/lsotHSaYZvRXdkx9meq8=;
        b=o8fnhPtNH7OB+y8F0ZOaOkqQdMP8PErkLMdx/gH5jSe0VQSRx3oh8i38kTxz1CV5SL
         ganki388jdyhGXD0VGpUj+DXzkjCLiGSp24UlP8qTgs2m0OY+QYQSmgEC06tykMknTp5
         40w/xQtcB4J6MnOnjV8wofKVc92qEh/GU0GQMoQJdjo950TYbBNwbKfOWW+HS4Fwqirg
         b/w9D/SX2Fq1Y46hk5vqbFfXAWzRGq8masgvfFw7+ybfd+InfKgEPtHDZbUCVIIHX2Cx
         LRZEP5CCL/oJAwesG957FDTIBclGpzsff9jJYq5UT7a2NeeZ/jTyFZsnP5bE3auGnk2S
         7JUQ==
X-Gm-Message-State: AOAM532nbutZ5yjUlmZCj1OpdEssqbNxpD7OBNW+Kg9zZR/bnRYBwjzy
        DI/vfxR0DudJ8ap1hdfDrnvKXg==
X-Google-Smtp-Source: ABdhPJwV4cNRc7kQ9MQt7bsBO3bUK8LbyLuwLd5XrSLb9TpeWBsSCelIgdtSfc+VZ1dfciCoR7aebQ==
X-Received: by 2002:adf:ab09:: with SMTP id q9mr9041005wrc.79.1591877901073;
        Thu, 11 Jun 2020 05:18:21 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id v19sm3769655wml.26.2020.06.11.05.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 05:18:19 -0700 (PDT)
Date:   Thu, 11 Jun 2020 13:18:17 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
Message-ID: <20200611121817.narzkqf5x7cvl6hp@holly.lan>
References: <20200609104604.1594-7-stanimir.varbanov@linaro.org>
 <20200609111414.GC780233@kroah.com>
 <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
 <20200610133717.GB1906670@kroah.com>
 <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
 <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
 <20200611062648.GA2529349@kroah.com>
 <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
 <20200611105217.73xwkd2yczqotkyo@holly.lan>
 <ed7dd5b4-aace-7558-d012-fb16ce8c92d6@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed7dd5b4-aace-7558-d012-fb16ce8c92d6@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 02:31:07PM +0300, Stanimir Varbanov wrote:
> On 6/11/20 1:52 PM, Daniel Thompson wrote:
> > On Wed, Jun 10, 2020 at 11:42:43PM -0700, Joe Perches wrote:
> >> On Thu, 2020-06-11 at 08:26 +0200, Greg Kroah-Hartman wrote:
> >>> On Wed, Jun 10, 2020 at 01:23:56PM -0700, Joe Perches wrote:
> >>>> On Wed, 2020-06-10 at 12:49 -0700, Joe Perches wrote:
> >>>>> On Wed, 2020-06-10 at 15:37 +0200, Greg Kroah-Hartman wrote:
> >>>>>> Please work with the infrastructure we have, we have spent a lot of time
> >>>>>> and effort to make it uniform to make it easier for users and
> >>>>>> developers.
> >>>>>
> >>>>> Not quite.
> >>>>>
> >>>>> This lack of debug grouping by type has been a
> >>>>> _long_ standing issue with drivers.
> >>>>>
> >>>>>> Don't regress and try to make driver-specific ways of doing
> >>>>>> things, that way lies madness...
> >>>>>
> >>>>> It's not driver specific, it allows driver developers to
> >>>>> better isolate various debug states instead of keeping
> >>>>> lists of specific debug messages and enabling them
> >>>>> individually.
> >>>>
> >>>> For instance, look at the homebrew content in
> >>>> drivers/gpu/drm/drm_print.c that does _not_ use
> >>>> dynamic_debug.
> >>>>
> >>>> MODULE_PARM_DESC(debug, "Enable debug output, where each bit enables a debug category.\n"
> >>>> "\t\tBit 0 (0x01)  will enable CORE messages (drm core code)\n"
> >>>> "\t\tBit 1 (0x02)  will enable DRIVER messages (drm controller code)\n"
> >>>> "\t\tBit 2 (0x04)  will enable KMS messages (modesetting code)\n"
> >>>> "\t\tBit 3 (0x08)  will enable PRIME messages (prime code)\n"
> >>>> "\t\tBit 4 (0x10)  will enable ATOMIC messages (atomic code)\n"
> >>>> "\t\tBit 5 (0x20)  will enable VBL messages (vblank code)\n"
> >>>> "\t\tBit 7 (0x80)  will enable LEASE messages (leasing code)\n"
> >>>> "\t\tBit 8 (0x100) will enable DP messages (displayport code)");
> >>>> module_param_named(debug, __drm_debug, int, 0600);
> >>>>
> >>>> void drm_dev_dbg(const struct device *dev, enum drm_debug_category category,
> >>>> 		 const char *format, ...)
> >>>> {
> >>>> 	struct va_format vaf;
> >>>> 	va_list args;
> >>>>
> >>>> 	if (!drm_debug_enabled(category))
> >>>> 		return;
> >>>
> >>> Ok, and will this proposal be able to handle stuff like this?
> >>
> >> Yes, that's the entire point.
> > 
> > Currently I think there not enough "levels" to map something like
> > drm.debug to the new dyn dbg feature. I don't think it is intrinsic
> > but I couldn't find the bit of the code where the 5-bit level in struct
> > _ddebug is converted from a mask to a bit number and vice-versa.
> 
> Here [1] is Joe's initial suggestion. But I decided that bitmask is a
> good start for the discussion.
> 
> I guess we can add new member uint "level" in struct _ddebug so that we
> can cover more "levels" (types, groups).

I don't think it is allocating only 5 bits that is the problem!

The problem is that those 5 bits need not be encoded as a bitmask by
dyndbg, that can simply be the category code for the message. They only
need be converted into a mask when we compare them to the mask provided
by the user.


Daniel.
