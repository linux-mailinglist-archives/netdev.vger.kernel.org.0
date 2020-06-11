Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A801F65FA
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 12:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgFKKw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 06:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgFKKwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 06:52:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A06C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 03:52:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so5669639wrp.2
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 03:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RcwomoC+Ma2mWugiGJC6MsfrL5L8dR3rfJt4NSp2F1A=;
        b=LpJtM6ydrDbbhtItKZv2qWLETVFuKYqehoy0/u7rITHuUcoPswXsgTwlrq1L/Xz5sS
         cX38+CtF/0s982isrNgOw1gU+VnYdGwhYGN3SvWXcy2GKCejOXvH7DtPdc2FYgLzghXg
         pwB553g48U+lMNMQmz7Gpr67q6gyVB5f2x/I0qRsaLNrYhE4QqD6W6gdUnbKBMNMKwTM
         ImxtNRhaUo5A+b+XlGD/ha3fYdNI+Bj2f/s+tBf473k+HvbErQw52mPJM+FHYtuaQbIZ
         byERlh/+fSQLZJX6jL3mRVhB//6kfiCk1hn1KxCDpg2brcXrAunaX/y1caMhA+q3DanH
         fgvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RcwomoC+Ma2mWugiGJC6MsfrL5L8dR3rfJt4NSp2F1A=;
        b=XK9G9KO0eZb9uv4Kl3Tv1pWVw6IYylucEskzz8QESOxusg8JqxvM3LXmACyAoOT26K
         e6KH8FxiwfQfy99QQHVjUc1x1O2xvePYr/6+BVDXklIbmsiImnQxobLBW8kPePKey+GS
         LwxzckorSIZu7tHqrr/MN00ISxm5+zXrGgzKatAVMe54RgOEED6nlUmjslmgETuvoxnR
         ldD5jdZ7U1giQYar5lvIQu12pd7G+nmEru7ZosQUjnjSgxz0+DggnGh/diUWGLDjiXpe
         lkJdyhXWC8o62a+OIethSHTfYE7fa+z1JhVfRnp6ckW+Z9f871DHk0XhQdKniSCXKFrt
         n9Ig==
X-Gm-Message-State: AOAM530jI5AehLX8JxfTpcJdh7Jb4cK2xN0TEgmdtiOySG4IhROaorxh
        S9KV+bmZRvA0LTx/oF8yn9h8Lw==
X-Google-Smtp-Source: ABdhPJxRDOlxqgu72sbIjFJnoqPirslj0v0jSqfMN3rVOPmEkZMzmS6dsNJsp6VRHW5n4kPM4nvvZg==
X-Received: by 2002:a5d:6150:: with SMTP id y16mr9531737wrt.219.1591872740691;
        Thu, 11 Jun 2020 03:52:20 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id z8sm4361959wru.33.2020.06.11.03.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 03:52:19 -0700 (PDT)
Date:   Thu, 11 Jun 2020 11:52:17 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Joe Perches <joe@perches.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
Message-ID: <20200611105217.73xwkd2yczqotkyo@holly.lan>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-7-stanimir.varbanov@linaro.org>
 <20200609111414.GC780233@kroah.com>
 <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
 <20200610133717.GB1906670@kroah.com>
 <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
 <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
 <20200611062648.GA2529349@kroah.com>
 <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 11:42:43PM -0700, Joe Perches wrote:
> On Thu, 2020-06-11 at 08:26 +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jun 10, 2020 at 01:23:56PM -0700, Joe Perches wrote:
> > > On Wed, 2020-06-10 at 12:49 -0700, Joe Perches wrote:
> > > > On Wed, 2020-06-10 at 15:37 +0200, Greg Kroah-Hartman wrote:
> > > > > Please work with the infrastructure we have, we have spent a lot of time
> > > > > and effort to make it uniform to make it easier for users and
> > > > > developers.
> > > > 
> > > > Not quite.
> > > > 
> > > > This lack of debug grouping by type has been a
> > > > _long_ standing issue with drivers.
> > > > 
> > > > > Don't regress and try to make driver-specific ways of doing
> > > > > things, that way lies madness...
> > > > 
> > > > It's not driver specific, it allows driver developers to
> > > > better isolate various debug states instead of keeping
> > > > lists of specific debug messages and enabling them
> > > > individually.
> > > 
> > > For instance, look at the homebrew content in
> > > drivers/gpu/drm/drm_print.c that does _not_ use
> > > dynamic_debug.
> > > 
> > > MODULE_PARM_DESC(debug, "Enable debug output, where each bit enables a debug category.\n"
> > > "\t\tBit 0 (0x01)  will enable CORE messages (drm core code)\n"
> > > "\t\tBit 1 (0x02)  will enable DRIVER messages (drm controller code)\n"
> > > "\t\tBit 2 (0x04)  will enable KMS messages (modesetting code)\n"
> > > "\t\tBit 3 (0x08)  will enable PRIME messages (prime code)\n"
> > > "\t\tBit 4 (0x10)  will enable ATOMIC messages (atomic code)\n"
> > > "\t\tBit 5 (0x20)  will enable VBL messages (vblank code)\n"
> > > "\t\tBit 7 (0x80)  will enable LEASE messages (leasing code)\n"
> > > "\t\tBit 8 (0x100) will enable DP messages (displayport code)");
> > > module_param_named(debug, __drm_debug, int, 0600);
> > > 
> > > void drm_dev_dbg(const struct device *dev, enum drm_debug_category category,
> > > 		 const char *format, ...)
> > > {
> > > 	struct va_format vaf;
> > > 	va_list args;
> > > 
> > > 	if (!drm_debug_enabled(category))
> > > 		return;
> > 
> > Ok, and will this proposal be able to handle stuff like this?
> 
> Yes, that's the entire point.

Currently I think there not enough "levels" to map something like
drm.debug to the new dyn dbg feature. I don't think it is intrinsic
but I couldn't find the bit of the code where the 5-bit level in struct
_ddebug is converted from a mask to a bit number and vice-versa.


Daniel.
