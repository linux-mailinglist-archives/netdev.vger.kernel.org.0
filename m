Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61434A6683
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiBAUzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiBAUyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:54:54 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E98BC06173E
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:54:54 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h12so18259002pjq.3
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GIsDKDJJ906n8rDktoO+wzfQ/bQlOPoH/WhlGNdvSuQ=;
        b=C1rgX19uCzxC26eMC121f6fLG7IdfYgVgd8fIENIEreQseymkVryt/S0SPPJWuMpz9
         Nir5/NsGwF9yH+73oYdsaH/3/MJBuVDELgZ4AEteh+/dLWJNIoxCjDW8D32ej5NqJNbO
         Stvj1+NZmfubXFxuq7ofodQdbNbVAJzEOc3LaLGUC0hXv/OYD2tA8tddEiB4y6O5Blva
         NXsIzj5paRcLX+ppnCftBWUJbRGN5XtAHdAxPVRn+E3hPl2AxZfNHYrXAscDlvZK74vv
         Ui9akpOcaPeeo6+NOo8fzCUh+jLx6vJhBjV3Fy87FAiIQwfDgl88G/z4R5Vd87KTZcIB
         UXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GIsDKDJJ906n8rDktoO+wzfQ/bQlOPoH/WhlGNdvSuQ=;
        b=oE8zf8qGpa/yZhESxvDFWLziFxW+kVg9udJ3G8PtV9N5bTk/C0eK9t0sh5Lx4oFqNa
         Qf5NzH/g/NH5scEtiOuSq6D3YZROHsICGOoRjk+KzPI/zRiukmel7akoB/8BOASqtRG1
         FQ5K/W26UK8P3OMtZrBDRttdIbsBUKaAQE2JkNXYCMU+MdSjPVxCp68XS48S3nyK16sm
         nc4cYShw8RvY5AjPuChffSoY1gWTWa1RCK5ktpabKt5vlkS9PtwUwMqxuzzIHaR8Wodb
         D2vC3/Q1g20D74uGlHpzYFff1XyGnEOhlgjX+1Yso78ZcKXeobWKp4qLmAoe5EMUXVck
         GtEQ==
X-Gm-Message-State: AOAM531u7AHMIq6Ahg8EN9+si87DrN1qOHDzpf4Xce97QW2nAd9e0eGP
        m1UDqfqYcTjTMN184e66xDnPp2OYfUvg8l4ORDO9ig==
X-Google-Smtp-Source: ABdhPJx2NTejkgNqXQMmFipMRsSvcla9sPcdEThKkmQFcOnG0Ds22smuJafHrYqLtk3n5gJx4vASYs1J/guDJ4lt5nM=
X-Received: by 2002:a17:90b:4a82:: with SMTP id lp2mr4426203pjb.179.1643748893933;
 Tue, 01 Feb 2022 12:54:53 -0800 (PST)
MIME-Version: 1.0
References: <20210421055047.22858-1-ms@dev.tdt.de>
In-Reply-To: <20210421055047.22858-1-ms@dev.tdt.de>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 1 Feb 2022 12:54:42 -0800
Message-ID: <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led functions
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 10:51 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> The Intel xway phys offer the possibility to deactivate the integrated
> LED function and to control the LEDs manually.
> If this was set by the bootloader, it must be ensured that the
> integrated LED function is enabled for all LEDs when loading the driver.
>
> Before commit 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> the LEDs were enabled by a soft-reset of the PHY (using
> genphy_soft_reset). Initialize the XWAY_MDIO_LED with it's default
> value (which is applied during a soft reset) instead of adding back
> the soft reset. This brings back the default LED configuration while
> still preventing an excessive amount of soft resets.
>
> Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> ---
>
> Changes to v2:
> o Fixed commit message
> o Fixed email recipients once again.
>
> Changes to v1:
> Added additional email recipients.
>
> ---
>  drivers/net/phy/intel-xway.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
> index 6eac50d4b42f..d453ec016168 100644
> --- a/drivers/net/phy/intel-xway.c
> +++ b/drivers/net/phy/intel-xway.c
> @@ -11,6 +11,18 @@
>
>  #define XWAY_MDIO_IMASK                        0x19    /* interrupt mask */
>  #define XWAY_MDIO_ISTAT                        0x1A    /* interrupt status */
> +#define XWAY_MDIO_LED                  0x1B    /* led control */
> +
> +/* bit 15:12 are reserved */
> +#define XWAY_MDIO_LED_LED3_EN          BIT(11) /* Enable the integrated function of LED3 */
> +#define XWAY_MDIO_LED_LED2_EN          BIT(10) /* Enable the integrated function of LED2 */
> +#define XWAY_MDIO_LED_LED1_EN          BIT(9)  /* Enable the integrated function of LED1 */
> +#define XWAY_MDIO_LED_LED0_EN          BIT(8)  /* Enable the integrated function of LED0 */
> +/* bit 7:4 are reserved */
> +#define XWAY_MDIO_LED_LED3_DA          BIT(3)  /* Direct Access to LED3 */
> +#define XWAY_MDIO_LED_LED2_DA          BIT(2)  /* Direct Access to LED2 */
> +#define XWAY_MDIO_LED_LED1_DA          BIT(1)  /* Direct Access to LED1 */
> +#define XWAY_MDIO_LED_LED0_DA          BIT(0)  /* Direct Access to LED0 */
>
>  #define XWAY_MDIO_INIT_WOL             BIT(15) /* Wake-On-LAN */
>  #define XWAY_MDIO_INIT_MSRE            BIT(14)
> @@ -159,6 +171,15 @@ static int xway_gphy_config_init(struct phy_device *phydev)
>         /* Clear all pending interrupts */
>         phy_read(phydev, XWAY_MDIO_ISTAT);
>
> +       /* Ensure that integrated led function is enabled for all leds */
> +       err = phy_write(phydev, XWAY_MDIO_LED,
> +                       XWAY_MDIO_LED_LED0_EN |
> +                       XWAY_MDIO_LED_LED1_EN |
> +                       XWAY_MDIO_LED_LED2_EN |
> +                       XWAY_MDIO_LED_LED3_EN);
> +       if (err)
> +               return err;
> +
>         phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LEDCH,
>                       XWAY_MMD_LEDCH_NACS_NONE |
>                       XWAY_MMD_LEDCH_SBF_F02HZ |
> --
> 2.20.1
>

Hi Martin,

Similar to my response in another thread to how be393dd685d2 ("net:
phy: intel-xway: Add RGMII internal delay configuration") which
changes the tx/rx interna delays to default values of 2ns if the
common delay properties are not found in the dt and thus may override
what boot firmware configured, I do not like the fact that this patch
just overrides LED configuration that boot firmware may have setup.

I am aware that there is not much consistency in PHY's for LED
configuration which makes coming up with common dt bindings impossible
but I feel that if PHY drivers add LED configuration they should only
apply it if new bindings are found instructing it to. Perhaps it makes
sense to at least create a common binding that allows configuration of
LED's here?

As a person responsible for boot firmware through kernel for a set of
boards I continue to do the following to keep Linux from mucking with
various PHY configurations:
- remove PHY reset pins from Linux DT's to keep Linux from hard resetting PHY's
- disabling PHY drivers

What are your thoughts about this?

Best regards,

Tim
