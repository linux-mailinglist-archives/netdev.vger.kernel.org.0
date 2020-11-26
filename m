Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17C82C5C0D
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 19:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404929AbgKZSbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 13:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404553AbgKZSbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 13:31:13 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA41EC0613D4;
        Thu, 26 Nov 2020 10:31:12 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id u2so1492079pls.10;
        Thu, 26 Nov 2020 10:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=+v07REWnnzENKrJ+DKBOFO9MF0WIxUweMXdA5GAB/a8=;
        b=LEfhlCMh9kipTDWJ7p7GpHTqaKo4PWqH7wxrdAB7ZIoaqbLoV4k0PtoPZDF+1R/jlk
         NWQvVbhaWq+xVN5rDzkVdoT7QD5OadczzSZ0xqJzQBMywlc9awNavJPLjr9hmUAMUIkH
         LiOVLsTdPfji0zOPh8hqAN3GkkCpGIOfZ7PNQ9ut1m4kvZklp3QPvjguXxVgX/crJhQv
         XNDE9JzrqqZUHYEJ5vGQ7u4wAx5MlxGphVUSOoUxJIkr9wbDn2+ppQQBYmk4ukSmkIGs
         1ye1Tb1hk+iAg8phsTG+Yj5dax7KaGyFHvhjjkLKNKdRRBl6Msu86g7ocxBVFSS9xshZ
         k/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+v07REWnnzENKrJ+DKBOFO9MF0WIxUweMXdA5GAB/a8=;
        b=B4jn4vSeralL5floKhITGBrDMe1RTtl8ku4aq3Wir17bbMaac0YoiuiVViZMIgEusd
         PsH3+JPjIaqwrfjb2movRRYj5cFdCzNqX64/tgZh+/fAb6ogMfoZJni4cc4oxJSXJ2ov
         YeTMzt4bai4Vab5KDMv9QL0e3FnKLkhKR2FJE+7SWLjWYpYVB0kgbIM4raN5165wa/YO
         GwwU9OJ7VgNDt/MgCftUUd/TLl3p+6AgcWAnpt8QGcGXqf+Z7FRXxW+m81D4/9xtAE80
         6YN2Mk9lDq8JvRLO+vMFJrT9ud5MFlvQLXBJJZCRYz4cUTMOSiKzWatZdel92s64PFw/
         0yaQ==
X-Gm-Message-State: AOAM531PTrt+qT9gzHykrymCZ0RWAZNeAy7qKHaMgmKiKhQkFzkfGUkI
        pNmxd2qgZy19YmseOwcxkD0=
X-Google-Smtp-Source: ABdhPJyuRi0WDD8c1FJ22qb8BEWNE4PG5SQFCTK7rtVUhl3YMpWMtwzrTvqfKEnKXhsdCR17gJbj1g==
X-Received: by 2002:a17:902:bf0b:b029:d8:f677:30f2 with SMTP id bi11-20020a170902bf0bb02900d8f67730f2mr3770386plb.25.1606415472382;
        Thu, 26 Nov 2020 10:31:12 -0800 (PST)
Received: from [192.168.1.155] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id x16sm7052116pjh.39.2020.11.26.10.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 10:31:11 -0800 (PST)
Message-ID: <e3962839410ba396a21edf8a6c481ec42ada1bdc.camel@gmail.com>
Subject: Re: [PATCH] mwifiex: pcie: add enable_device_dump module parameter
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Date:   Fri, 27 Nov 2020 03:31:05 +0900
In-Reply-To: <CA+ASDXNPcXtTWS8pOjfoxiYOAcRMmsqZwXe3mnxOw388MCEu9g@mail.gmail.com>
References: <20201028142625.18642-1-kitakar@gmail.com>
         <CA+ASDXPX+fadTKLnxNVZQ0CehsHNwvWHXEdLqZVDoQ6hf6Wp8Q@mail.gmail.com>
         <7db5b6cba1548308a63855ec1dda836b6d6d9757.camel@gmail.com>
         <CA+ASDXNPcXtTWS8pOjfoxiYOAcRMmsqZwXe3mnxOw388MCEu9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-20 at 12:53 -0800, Brian Norris wrote:
> (Sorry if anything's a bit slow here. I don't really have time to
> write out full proposals myself.)

Don’t worry, I (and other owners) am already glad to hear from upstream
devs, including you :)

(and I'm also sorry for the late reply from me. It was difficult to find
spare time these days.)

> On Fri, Oct 30, 2020 at 3:30 AM Tsuchiya Yuto <kitakar@gmail.com> wrote:
> > Let me know if splitting this patch like this works. 1) The first patch
> > is to add this module parameter but don't change the default behavior.
> 
> That *could* be OK with me, although it's already been said that there
> are many people who dislike extra module parameters. I also don't see
> why this needs to be a module parameter at all. If you do #2 right,
> you don't really need this, as there are already several standard ways
> of doing this (e.g., via Kconfig, or via nl80211 on a per-device
> basis).
> 
> > 2) The second patch is to change the parameter value depending on the
> > DMI matching or something so that it doesn't break the existing users.
> 
> Point 2 sounds good, and this is the key point. Note that you can do
> point 2 without making it a module parameter. Just keep a flag in the
> driver-private structures.

I chose to also provide the module parameter because I thought it would
be a little bit complicated for users to re-enable this dump feature if
I chose not to provide this parameter.

If I don't provide the parameter but still want to allow users to
re-enable this dump feature, we can provide a way to change the bit flags
of quirks (via a new debugfs entry or another module parameter). That
said, is there a way to easily change the quirk flags only for this dump
feature?

For example, assume that the following three quirks are enabled by default:

/* quirks */
#define QUIRK_FW_RST_D3COLD	BIT(0)
#define QUIRK_NO_DEVICE_DUMP	BIT(1)
#define QUIRK_FOO		BIT(2)

.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
			QUIRK_NO_DEVICE_DUMP |
			QUIRK_FOO),

card->quirks = (uintptr_t)dmi_id->driver_data;

/* and assume that card->quirks can be changed by users by a file named
 * "quirks" under debugfs.
 */

So, the card->quirks will be "7" in decimal by default. Then, if users
want to re-enable the dump feature, as far as I know, users need to know
the default value "7", then need to know that device_dump is controlled
by bit 1. Finally, users can set the new quirk flags "5" in decimal (101
in binary).

echo 5 > /sys/kernel/debug/mwifiex/mlan0/quirks

I'm glad if there is another nice way to control only the device_dump
quirk flag, if we only provide a way to change quirk flags.

But at the same time I also think that if someone dare to want to
re-enable this feature, maybe the person won't feel it's complicated haha.
So, I'll drop the device_dump module parameter and switch to use the quirk
framework, adding a way to change the quirk flags value by users.

That said, we may even drop disabling the dump. Take a look at my comment
I wrote below.

> > But what I want to say here as well is that, if the firmware can be fixed,
> > we don't need a patch like this.
> 
> Sure. That's also where we don't necessarily need more ways to control
> this from user space (e.g., module parameters), but just better
> detection of currently broken systems (in the driver). And if firmware
> ever gets fixed, we can undo the "broken device" detection.

There are two types of firmware crashes we observes:
1) cmd_timedout (other than ps_mode-related)
2) Firmware wakeup failed (ps_mode-related)

The #2 is observed when we enabled ps_mode. The #1 is observed for the
other causes. And hopefully, verdre (in Cc) found a "fix" [1] for the
#1 fw crash. We are trying the fix now.

The pull req (still WIP) basically addresses fw crashing by using
"non-posted" register writes and uninterruptible wait queue for PCI
operations in the kernel driver side.

We still don't have any ideas to "fix" the #2 fw crash, but now we don't
see the #1 crash anymore so far.

I'd like to see where the attempt goes before I start working on this
patch here again.

Thank you, everyone.

[1] https://github.com/linux-surface/kernel/pull/70
    [WIP] Properly fix wifi firmware crashes by jonas2515 · Pull Request #70 · linux-surface/kernel

> Brian


