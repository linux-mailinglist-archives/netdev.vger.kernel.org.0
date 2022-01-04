Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AD6484365
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiADOaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiADOav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:30:51 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFEFC061761;
        Tue,  4 Jan 2022 06:30:51 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id n30so37092207eda.13;
        Tue, 04 Jan 2022 06:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ipzSJZpP+W6o704GM9POWbumVjv2ztu0YINjQPeKhVg=;
        b=GJiecoxlhc01vvlK70zqTzHh7XslNL7CTE3tOAPG2IocD3XwPd01tP94oBYP0qOBN2
         Mc/y3FprG8xdj9IfVqkLnDzYlHR2Lmlhtrd4mOyxRATgqFHoRyh4zfu2kIN5pTqpDY0k
         Ot8ZVRmjK3eg0fJLwMBeuYdbAr5qNqA8MJAZ/e4NQOuxXMHMGmswoCEWwxl3irnaWm3J
         wOqGckcGX1u8XWZ8JDABGRdY3zP+mbQGNzWP5TAQ2f+e6UxbKwUVyaEXrXqd6xI9f2fe
         733NBaDnRTwDw6AHnTcubldpDxVARJuz2WIE5yX436BqONLtGjJrwqiqu/xuPKOu5yOS
         ooLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ipzSJZpP+W6o704GM9POWbumVjv2ztu0YINjQPeKhVg=;
        b=k4WSnzxeJqpQj5lmTHEaWwrXyzND10DFAdSkUHukzecV/WG4RMOIiY/9MOE5GBsuN0
         pRzYQykTZKHNPh1UjZiy1tZsZqrHRi6s4c9jC2wQWVEkbjsvVluPCQA38DgSl8gen3Tj
         Qm9JbywCvWrsQXO30n4TrTWA4daZGPh13uNNKPS4w1ROL6ydu0RynPXG9p6n05JJt8dB
         l8RRNDdt5edQ3K2+Oul+TDmpp1l9oUQTDHQPBY4VG/wGCYdjCKn9IspGTuPSgE7A0iUQ
         bbJTb/dF5XZKL9eAuQOMfWSUPAcpfWuhH2RBze36/s85tLbMD/dP/a9+nxZJog4JFRhH
         Km0w==
X-Gm-Message-State: AOAM530xIckEFfwE30b/UtHQqnYlOkV88cPBQckpo2alq/EP99ZZXhww
        ETtpZsNthPIefWDik7wy/BVJQ52t8jNV6Vf8kOQ=
X-Google-Smtp-Source: ABdhPJxvMHAKUDKUaYOLQC9uJERFiKIEfT8jSuKAKEXO7h9Qyff1qhwD2N1DIrZxDaTa515DKmPkBFm3AbH2mY7xZYo=
X-Received: by 2002:a05:6402:12c4:: with SMTP id k4mr47490896edx.218.1641306649506;
 Tue, 04 Jan 2022 06:30:49 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st>
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 4 Jan 2022 16:28:58 +0200
Message-ID: <CAHp75VdnSCV0HczotPoZRZane90Mt-uQ4MauvFKNR-uJ11sx3Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/35] brcmfmac: Support Apple T2 and M1 platforms
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 9:27 AM Hector Martin <marcan@marcan.st> wrote:
>
> Hi everyone,
>
> Happy new year! This 35-patch series adds proper support for the
> Broadcom FullMAC chips used on Apple T2 and M1 platforms:
>
> - BCM4355C1
> - BCM4364B2/B3
> - BCM4377B3
> - BCM4378B1
> - BCM4387C2
>
> As usual for Apple, things are ever so slightly different on these
> machines from every other Broadcom platform. In particular, besides
> the normal device/firmware support changes, a large fraction of this
> series deals with selecting and loading the correct firmware. These
> platforms use multiple dimensions for firmware selection, and the values
> for these dimensions are variously sourced from DT or OTP (see the
> commit message for #9 for the gory details).
>
> This is what is included:
>
> # 01: DT bindings (M1 platforms)
>
> On M1 platforms, we use the device tree to provide properties for PCIe
> devices like these cards. This patch re-uses the existing SDIO binding
> and adds the compatibles for these PCIe chips, plus the properties we
> need to correctly instantiate them:
>
> - brcm,board-type: Overrides the board-type which is used for firmware
>   selection on all platforms, which normally comes from the DMI device
>   name or the root node compatible. Apple have their own
>   mapping/identifier here ("island" name), so we prefix it with "apple,"
>   and use it as the board-type override.
>
> - apple,antenna-sku: Specifies the specific antenna configuration in a
>   produt. This would normally be filled in by the bootloader from
>   device-specific configuration data. On ACPI platforms, this is
>   provided via ACPI instead. This is used to build the funky Apple
>   firmware filenames. Note: it seems the antenna doesn't actually matter
>   for any of the above platforms (they are all aliases to the same files
>   and our firmware copier collapses down this dimension), but since
>   Apple do support having different firmware or NVRAM depending on
>   antenna SKU, we ough to support it in case it starts mattering on a
>   future platform.
>
> - brcm,cal-blob: A calibration blob for the Wi-Fi module, specific to a
>   given unit. On most platforms, this is stored in SROM on the module,
>   and does not need to be provided externally, but Apple instead stores
>   this in platform configuration for M1 machines and the driver needs to
>   upload it to the device after initializing the firmware. This has a
>   generic brcm name, since a priori this mechanism shouldn't be
>   Apple-specific, although chances are only Apple do it like this so far.
>
> # 02~09: Apple firmware selection (M1 platforms)
>
> These patches add support for choosing firmwares (binaries, CLM blobs,
> and NVRAM configs alike) using all the dimensions that Apple uses. The
> firmware files are renamed to conform to the existing brcmfmac
> convention. See the commit message for #9 for the gory details as to how
> these filenames are constructed. The data to make the firmware selection
> comes from the above DT properties and from an OTP ROM on the chips on
> M1 platforms.
>
> # 10~14: BCM4378 support (M1 T8103 platforms)
>
> These patches make changes required to support the BCM4378 chip present
> in Apple M1 (T8103) platforms. This includes adding support for passing
> in the MAC address via the DT (this is standard on DT platforms) since
> the chip does not have a burned-in MAC; adding support for PCIe core
> revs >64 (which moved around some registers); tweaking ring buffer
> sizes; and fixing a bug.
>
> # 15~20: BCM4355/4364/4377 support (T2 platforms)
>
> These patches add support for the chips found across T2 Mac platforms.
> This includes ACPI support for fetching properties instead of using DT,
> providing a buffer of entropy to the devices (required for some of the
> firmwares), and adding the required IDs. This also fixes the BCM4364
> firmware naming; it was added without consideration that there are two
> incompatible chip revisions. To avoid this ambiguity in the future, all
> the chips added by this series use firmware names ending in the revision
> (apple/brcm style, that is letter+number), so that future revisions can
> be added without creating confusion.
>
> # 21~27: BCM4387 support (M1 Pro/Max T600x platforms)
>
> These patches add support for the newer BCM4387 present in the recently
> launched M1 Pro/Max platforms. This chip requires a few changes to D11
> reset behavior and TCM size calculation to work properly, and it uses
> newer firmware which needs support for newer firmware interfaces
> in the cfg80211 support. Backwards compatibility is maintained via
> feature flags discovered at runtime from information provided by the
> firmware.
>
> A note on #26: it seems this chip broke the old hack of passing the PMK
> in hexdump form as a PSK, but it seems brcmfmac chips supported passing
> it in binary all along. I'm not sure why it was done this way in the
> Linux driver, but it seems OpenBSD always did it in binary and works
> with older chips, so this should be reasonably well tested. Any further
> insight as to why this was done this way would be appreciated.
>
> # 28~32: Fixes
>
> These are just random things I came across while developing this series.
> #31 is required to avoid a compile warning in subsequent patches. None
> of these are strictly required to support these chips/platforms.
>
> # 33-35: TxCap and calibration blobs
>
> These patches add support for uploading TxCap blobs, which are another
> kind of firmware blob that Apple platforms use (T2 and M1), as well as
> providing Wi-Fi calibration data from the device tree (M1).
>
> I'm not sure what the TxCap blobs do. Given the stray function
> prototype at [5], it would seem the Broadcom folks in charge of Linux
> drivers also know all about Apple's fancy OTP for firmware selection
> and the existence of TxCap blobs, so it would be great if you could
> share any insight here ;-)
>
> These patches are not required for the chips to function, but presumably
> having proper per-device calibration data available matters, and I
> assume the TxCap blobs aren't just for show either.
>
> # On firmware
>
> As you might expect, the firmware for these machines is not available
> under a redistributable license; however, every owner of one of these
> machines *is* implicitly licensed to posess the firmware, and the OS
> packages containing it are available under well-known URLs on Apple's
> CDN with no authentication.
>
> Our plan to support this is to propose a platform firmware mechanism,
> where platforms can provide a firmware package in the EFI system
> partition along with a manifest, and distros will extract it to
> /lib/firmware on boot or otherwise make it available to the kernel.
>
> Then, on M1 platforms, our install script, which performs all the
> bootloader installation steps required to run Linux on these machines in
> the first place, will also take care of copying the firmware from the
> base macOS image to the EFI partition. On T2 platforms, we'll provide an
> analogous script that users can manually run prior to a normal EFI Linux
> installation to just grab the firmware from /usr/share/firmware/wifi in
> the running macOS.
>
> There is an example firmware manifest at [1] which details the files
> copied by our firmware rename script [2], as of macOS 12.0.1.
>
> To test this series on a supported Mac today (T2 or M1), boot into macOS
> and run:
>
> $ git clone https://github.com/AsahiLinux/asahi-installer
> $ cd asahi-installer/src
> $ python -m firmware.wifi /usr/share/firmware/wifi firmware.tar
>
> Then copy firmware.tar to Linux and extract it into /lib/firmware.

I looked into the ~half of the series and basically common mistakes
you have are (but not limited to):
 - missed checks for error from allocator calls
 - NIH devm_kasprintf()
 - quite possible reinveting a wheel of many functions we have already
implemented in the kernel.

Suggestion for the last one is to use `git grep ...`, which is very
powerful instrument, and just always questioning yourself "I'm doing
XYZ and my gut feeling is that XYZ is (so) generic I can't believe
there is no implementation of it already exists in the kernel". This
is how I come up with a lot of cleanups done in the past.

-- 
With Best Regards,
Andy Shevchenko
