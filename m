Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D48F22E261
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 21:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGZTx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 15:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgGZTx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 15:53:29 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31D4C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 12:53:28 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b13so8213216edz.7
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 12:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4+AXbyv/cMS0t7t/Xg6M8pmAw1HTiM7iiBvASg56QqM=;
        b=DuTlNvdRPmfFXTPHoyKjFf/RYRacJZujewnnm4kWcddT/xq7mZ2ulgyiVriaELcdVg
         A6XRQkfUx7m3vWh/Xihn0TiiIjv86U6c0HVry73LDtrkHbiSrmqb1B0SYLkTacJpEckJ
         9YZWcKmEuCfBEX/9aThyBIcl4xAxhdQ/JkuO8IFyWmlT7XBhsvKeU0IOvfD/hdU0P+7E
         T/y2l1rSOOB9f4+TsRYjVpb8GqVZ+UiJNQog/iZeE18k5tfx7vZBsl5A0Th8Q+MrlIWd
         OP0DbxntD6+4U0dWZtFLxrHrA9pSHWR1n607vR6Fjk15vpqf67NbNBECx1NDWUTlHFXn
         wltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4+AXbyv/cMS0t7t/Xg6M8pmAw1HTiM7iiBvASg56QqM=;
        b=YQlrMedXrjPxEBOee6U2NkL3AXmZR55QbbBfpZGFrr5KgBcbk/tBKDt9MYfcbOGOYS
         TeJnYJa6xnjoCHEuJctOnp3jvUvWF04a3Ia2p7SuCa5wU/Vl4svf/EUo1iiWOnv2X7TU
         i2pz7jYcI6kHzTdNtYSAZqnIHD1LRAfa9/SJWAK/efE4SNtGKuNofu/yYSrvIHz9wo/p
         ErUWzVvWpx6PKW6Edsfu0x0sMbI/+GV1NehHuLJciyr0c7pZOEoimd4BZDl/OjQGh6F5
         XSPcvDYP8cAjLOfP0It3wq18AhsJYsyx9I+Gt7wPPkskfmZAzlfhz52/pHpS6yO0DbuQ
         CADQ==
X-Gm-Message-State: AOAM532KHwWPzrn6NfszX88bblvBOav50DGPVSxcJeAHb0tCf5OI/nCR
        Ucnn6Y0JPaS8N4R2zOdqT2I=
X-Google-Smtp-Source: ABdhPJxz7qHVFKtfLK5YJXMh/n/gzkj/KC5qRQQm0CqjRhHzLnF/Q3nIVd6eiRMsHpLKHh9F9/sXpg==
X-Received: by 2002:a05:6402:1d0b:: with SMTP id dg11mr17960645edb.212.1595793204349;
        Sun, 26 Jul 2020 12:53:24 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id e1sm5877045edn.16.2020.07.26.12.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 12:53:23 -0700 (PDT)
Date:   Sun, 26 Jul 2020 22:53:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org
Subject: Re: phc2sys - does it work?
Message-ID: <20200726195321.hwf22sqy7tada47k@skbuf>
References: <20200725124927.GE1551@shell.armlinux.org.uk>
 <20200725132916.7ibhnre2be3hfsrt@skbuf>
 <20200726110104.GV1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726110104.GV1605@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 12:01:05PM +0100, Russell King - ARM Linux admin wrote:
> 
> Another solution would be to avoid running NTP on any machine intending
> to be the source of PTP time on a network, but that then brings up the
> problem that you can't synchronise the PTP time source to a reference
> time, which rather makes PTP pointless unless all that you're after is
> "all my local machines say the same wrong time."
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

TL;DR: if your PHC supports external timestamping (extts), use that,
plus a GPS module. Then synchonize CLOCK_REALTIME to the PHC and not the
other way around.

I guess there is some truth to the saying that "a man with one clock
knows what time it is; a man with two clocks is never sure".

In my corner of the universe, you would never want a 1588 GM to be
disciplined to a Stratum >= 2 NTP server, and possibly never over NTP at
large. That is, _if_ you want your 1588 timing domain to be traceable to
TAI at all (and if the use case doesn't require that, you're 100% better
off leaving the 1588 GM free-running).  Jitter propagates transitively,
and there are few worse things you can do to a synchronization network
than serve a time that is jittery in the first place.

The biggest source of jitter is so-called 'software synchronization'
(aka without hardware assist). phc2sys is a prime example of that, but
also NTP in the configuration most people use it in. There are ways to
improve that (the various species of SYSOFF), and while they do work
fine, the brick wall between hardware and software synchronization still
exists. The one place where it is fine is at the leaves of the clock
distribution tree, aka syncing the system time to the PHC. There, even
if you want to do some periodic tasks based on the PTP schedule, the
scheduling jitter is probably large enough anyway that software
synchronization is not your biggest concern.

-Vladimir
