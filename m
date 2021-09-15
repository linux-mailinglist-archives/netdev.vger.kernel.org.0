Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7709A40C1C3
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 10:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbhIOIb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 04:31:59 -0400
Received: from mail-ua1-f46.google.com ([209.85.222.46]:41857 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236942AbhIOIbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 04:31:51 -0400
Received: by mail-ua1-f46.google.com with SMTP id f24so1185731uav.8;
        Wed, 15 Sep 2021 01:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Ztxy/s7U9agvYZxsUEFpUVoJBTuSA4ry4mqrv1u2YM=;
        b=DjZH+GOglQEJD2YHyLVxbRhbPQ9EfW+3LUweyTIpLdhjNQsFtLVpPQ2pmdcDOWyxA6
         58APQzQD863omUhnraCsU/Tv41l+O3rfzVnXfge7ktbenTjKRbMRNhP37yzbyZXUX6TN
         vm11SgMqq49lIL8QumDFRmLg/cep5/a0WENmIi7pyMQDSUK5YZRgIeytyso4FKVpinDh
         WvsAx1HEzKnrbQMILUrg7MHa1lIE+tVPvzLtdb1klLoQt0kcv4cPsSNoYDUpOT9piYqD
         XpHgGKqVZTP4jbB8eSDLCyggZYosB0ygEpIScOO+4SJ7/VfSmYa80cBV1e8ty889JDEw
         fMig==
X-Gm-Message-State: AOAM533saVJ3FWcw2Alf7DGIfTUO1EHpoOTL6OZmDbYEUXXnN26uZfM7
        vsCcfPRMXGDb0F0Y04RoxAoExybRQIzo7yoU8n0=
X-Google-Smtp-Source: ABdhPJxTKVXVnulWMi3+R5IFXquG8Cu12tPtEoMHnocvOQKYopDuzTbzcrN8H8LdkiMckdeQd7OCVQBBLd6sITBzb8g=
X-Received: by 2002:ab0:6dc7:: with SMTP id r7mr7221857uaf.14.1631694628565;
 Wed, 15 Sep 2021 01:30:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210915081139.480263-1-saravanak@google.com> <20210915081139.480263-3-saravanak@google.com>
In-Reply-To: <20210915081139.480263-3-saravanak@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Sep 2021 10:30:17 +0200
Message-ID: <CAMuHMdVb7KD2LdRaQWU0LtBr-YewTp_5Uzt5tcoy6SdJSPjzDA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] driver core: Set deferred probe reason when
 deferred by driver core
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 10:11 AM Saravana Kannan <saravanak@google.com> wrote:
> When the driver core defers the probe of a device, set the deferred
> probe reason so that it's easier to debug. The deferred probe reason is
> available in debugfs under devices_deferred.
>
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
