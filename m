Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE841D6CE0
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 22:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgEQUZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 16:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQUZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 16:25:38 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F634C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 13:25:38 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e18so8433333iog.9
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 13:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ghQ9S1pot/ETxKnVf8aKdR+3bLiJHwqBt3VES+27luo=;
        b=GxomQTnXnKUweaOK6BrkkhYxcM8cbHEX/7mQ9ADU7JKOKSR3LIbjzWKUtdnUCbHCmB
         yyHsta8SDO48jdmFF29BtW21Kv/kHzjh5SZiOu75vViX2y5bNCpiY38Yrml5Vnf3WJft
         RT2ygF6ED7yFv4wTdGiVla6fev9XhsYNeVNaF0uB4KXjBYysvz4OJxyOOxNhamN1xdIl
         i9aPc41ifkR6UqfIwnvdUvqjZo7W9I9fPUOpHRHEoQHDwp4KFAToo9yE94ZKmibIB2Ur
         cV5kPL3WOlN9SATJ61UBeycUgf4n9c7aFwLrUeKEmOkTAcWStA0nKF4hR+tfFvvuM3Tm
         0Ehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ghQ9S1pot/ETxKnVf8aKdR+3bLiJHwqBt3VES+27luo=;
        b=RlzhoC4SlfdqHvuMZrg19stXXQPHQKKsCFYqQm9lJo2RH+h8sUv4EFJuRXMIZOwp+z
         muFle9QZW1ueH3J+mjDw4W4Mj1eW98XMfS/QXSsRAPR8muTAPqcn2BDKD2UpHaa/LTmJ
         /RS+0uj/IbB2LVZkDHw4pfGuZAeUsIDdHwbiaiVG3BKRLpUOTJQMnEhdD4I/RrhOWyvM
         p2CPduiGjCH2/02uzmPnW0D+0YOcA9Rlf/GNNhBi9a3w67MWf6oNZDeBZJPgnCbVLvSF
         RhLIZ07fqC1ZMVBG6G4T41hgL+7Owdv5YnvrI30A0k7RMQwiym01Mk/lS/3YVtizXray
         IhJA==
X-Gm-Message-State: AOAM533qcCPDciknlGvmPkwMneTzvvtOunqXzqZHlpPeBlj/b+8qOXlH
        UVgQHg2bRwyrNWldZogCDioOCqJ205QbGJsyPXA=
X-Google-Smtp-Source: ABdhPJzJN+ttDxXtnrr32xy98xMbV+UjUov6IMA7hEXBiD5G5/q06zJ3dCBj43CoKRMtsVMT8D8qEDf7JmJpCxyl10A=
X-Received: by 2002:a6b:e509:: with SMTP id y9mr11723301ioc.67.1589747137522;
 Sun, 17 May 2020 13:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195851.610435-1-andrew@lunn.ch> <20200517195851.610435-5-andrew@lunn.ch>
In-Reply-To: <20200517195851.610435-5-andrew@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 17 May 2020 13:25:23 -0700
Message-ID: <CAFXsbZohCG5OScjAszD5vpMacfUEUYK_74FU1tjz4Sm8nbegsg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: phy: marvell: Add support for amplitude graph
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 12:59 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> The Marvell PHYs can measure the amplitude of the returned signal for
> a given distance. Implement this option of the cable test
> infrastructure.
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/marvell.c | 227 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 226 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 4bc7febf9248..e7994f5b506e 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -42,6 +42,7 @@
>  #define MII_MARVELL_FIBER_PAGE         0x01
>  #define MII_MARVELL_MSCR_PAGE          0x02
>  #define MII_MARVELL_LED_PAGE           0x03
> +#define MII_MARVELL_VCT5_PAGE          0x05
>  #define MII_MARVELL_MISC_TEST_PAGE     0x06
>  #define MII_MARVELL_VCT7_PAGE          0x07
>  #define MII_MARVELL_WOL_PAGE           0x11
> @@ -164,6 +165,54 @@
>  #define MII_88E1510_GEN_CTRL_REG_1_MODE_SGMII  0x1     /* SGMII to copper */
>  #define MII_88E1510_GEN_CTRL_REG_1_RESET       0x8000  /* Soft reset */
>
> +#define MII_VCT5_TX_RX_MDI0_COUPLING   0x10
> +#define MII_VCT5_TX_RX_MDI1_COUPLING   0x11
> +#define MII_VCT5_TX_RX_MDI2_COUPLING   0x12
> +#define MII_VCT5_TX_RX_MDI3_COUPLING   0x13
> +#define MII_VCT5_TX_RX_AMPLITUDE_MASK  0x7f00
> +#define MII_VCT5_TX_RX_AMPLITUDE_SHIFT 8
> +#define MII_VCT5_TX_RX_COUPLING_POSITIVE_REFLECTION    BIT(15)
> +
> +#define MII_VCT5_CTRL                          0x17
> +#define MII_VCT5_CTRL_ENABLE                           BIT(15)
> +#define MII_VCT5_CTRL_COMPLETE                         BIT(14)
> +#define MII_VCT5_CTRL_TX_SAME_CHANNEL                  (0x0 << 11)
> +#define MII_VCT5_CTRL_TX0_CHANNEL                      (0x4 << 11)
> +#define MII_VCT5_CTRL_TX1_CHANNEL                      (0x5 << 11)
> +#define MII_VCT5_CTRL_TX2_CHANNEL                      (0x6 << 11)
> +#define MII_VCT5_CTRL_TX3_CHANNEL                      (0x7 << 11)
> +#define MII_VCT5_CTRL_SAMPLES_2                                (0x0 << 8)
> +#define MII_VCT5_CTRL_SAMPLES_4                                (0x1 << 8)
> +#define MII_VCT5_CTRL_SAMPLES_8                                (0x2 << 8)
> +#define MII_VCT5_CTRL_SAMPLES_16                       (0x3 << 8)
> +#define MII_VCT5_CTRL_SAMPLES_32                       (0x4 << 8)
> +#define MII_VCT5_CTRL_SAMPLES_64                       (0x5 << 8)
> +#define MII_VCT5_CTRL_SAMPLES_128                      (0x6 << 8)
> +#define MII_VCT5_CTRL_SAMPLES_DEFAULT                  (0x6 << 8)
> +#define MII_VCT5_CTRL_SAMPLES_256                      (0x7 << 8)
> +#define MII_VCT5_CTRL_SAMPLES_SHIFT                    8
> +#define MII_VCT5_CTRL_MODE_MAXIMUM_PEEK                        (0x0 << 6)
> +#define MII_VCT5_CTRL_MODE_FIRST_LAST_PEEK             (0x1 << 6)
> +#define MII_VCT5_CTRL_MODE_OFFSET                      (0x2 << 6)
> +#define MII_VCT5_CTRL_SAMPLE_POINT                     (0x3 << 6)
> +#define MII_VCT5_CTRL_PEEK_HYST_DEFAULT                        3
> +
> +#define MII_VCT5_SAMPLE_POINT_DISTANCE         0x18
> +#define MII_VCT5_TX_PULSE_CTRL                 0x1c
> +#define MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN     BIT(12)
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_128nS       (0x0 << 10)
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_96nS                (0x1 << 10)
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_64nS                (0x2 << 10)
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS                (0x3 << 10)
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_SHIFT       10
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_1000mV  (0x0 << 8)
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_750mV   (0x1 << 8)
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_500mV   (0x2 << 8)
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_250mV   (0x3 << 8)
> +#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_SHIFT   8
> +#define MII_VCT5_TX_PULSE_CTRL_MAX_AMP                 BIT(7)
> +#define MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV         (0x6 << 0)
> +
>  #define MII_VCT7_PAIR_0_DISTANCE       0x10
>  #define MII_VCT7_PAIR_1_DISTANCE       0x11
>  #define MII_VCT7_PAIR_2_DISTANCE       0x12
> @@ -220,6 +269,7 @@ struct marvell_priv {
>         u64 stats[ARRAY_SIZE(marvell_hw_stats)];
>         char *hwmon_name;
>         struct device *hwmon_dev;
> +       bool cable_test_tdr;
>  };
>
>  static int marvell_read_page(struct phy_device *phydev)
> @@ -1690,7 +1740,117 @@ static void marvell_get_stats(struct phy_device *phydev,
>                 data[i] = marvell_get_stat(phydev, i);
>  }
>
> -static int marvell_vct7_cable_test_start(struct phy_device *phydev)
> +static int marvell_vct5_wait_complete(struct phy_device *phydev)
> +{
> +       int i;
> +       int val;
> +
> +       for (i = 0; i < 32; i++) {
> +               val = phy_read_paged(phydev, MII_MARVELL_VCT5_PAGE,
> +                                    MII_VCT5_CTRL);
> +               if (val < 0)
> +                       return val;
> +
> +               if (val & MII_VCT5_CTRL_COMPLETE)
> +                       return 0;
> +
> +               usleep_range(1000, 2000);
> +       }
> +
> +       phydev_err(phydev, "Timeout while waiting for cable test to finish\n");
> +       return -ETIMEDOUT;
> +}
> +
> +static int marvell_vct5_amplitude(struct phy_device *phydev, int pair)
> +{
> +       int amplitude;
> +       int val;
> +       int reg;
> +
> +       reg = MII_VCT5_TX_RX_MDI0_COUPLING + pair;
> +       val = phy_read_paged(phydev, MII_MARVELL_VCT5_PAGE, reg);
> +
> +       if (val < 0)
> +               return 0;
> +
> +       amplitude = (val & MII_VCT5_TX_RX_AMPLITUDE_MASK) >>
> +               MII_VCT5_TX_RX_AMPLITUDE_SHIFT;
> +
> +       if (!(val & MII_VCT5_TX_RX_COUPLING_POSITIVE_REFLECTION))
> +               amplitude = -amplitude;
> +
> +       return 1000 * amplitude / 128;
> +}
> +
> +static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
> +                                          int meters)
> +{
> +       int mV_pair0, mV_pair1, mV_pair2, mV_pair3;
> +       int distance;
> +       u16 reg;
> +       int err;
> +
> +       distance = meters * 1000 / 805;

With this integer based meters representation, it seems to me that we
are artificially reducing the resolution of the distance sampling.
For a 100 meter cable, the Marvell implementation looks to support 124
sample points.  This could result in incorrect data reporting as two
adjacent meter numbers would resolve to the same disatance value
entered into the register.  (eg - 2 meters = 2 distance  3 meters = 2
distance)

Is there a better way of doing this which would allow for userspace to
use the full resolution of the hardware?

> +
> +       err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
> +                             MII_VCT5_SAMPLE_POINT_DISTANCE,
> +                             distance);
> +       if (err)
> +               return err;
> +
> +       reg = MII_VCT5_CTRL_ENABLE |
> +               MII_VCT5_CTRL_TX_SAME_CHANNEL |
> +               MII_VCT5_CTRL_SAMPLES_DEFAULT |
> +               MII_VCT5_CTRL_SAMPLE_POINT |
> +               MII_VCT5_CTRL_PEEK_HYST_DEFAULT;
> +       err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
> +                             MII_VCT5_CTRL, reg);
> +       if (err)
> +               return err;
> +
> +       err = marvell_vct5_wait_complete(phydev);
> +       if (err)
> +               return err;
> +
> +       mV_pair0 = marvell_vct5_amplitude(phydev, 0);
> +       mV_pair1 = marvell_vct5_amplitude(phydev, 1);
> +       mV_pair2 = marvell_vct5_amplitude(phydev, 2);
> +       mV_pair3 = marvell_vct5_amplitude(phydev, 3);
> +
> +       ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_A, mV_pair0);
> +       ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_B, mV_pair1);
> +       ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_C, mV_pair2);
> +       ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_D, mV_pair3);
> +
> +       return 0;
> +}
> +
> +static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
> +{
> +       int meters;
> +       int err;
> +       u16 reg;
> +
> +       reg = MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV |
> +               MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN |
> +               MII_VCT5_TX_PULSE_CTRL_MAX_AMP |
> +               MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS;
> +
> +       err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
> +                             MII_VCT5_TX_PULSE_CTRL, reg);
> +       if (err)
> +               return err;
> +
> +       for (meters = 0; meters <= 100; meters++) {
> +               err = marvell_vct5_amplitude_distance(phydev, meters);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static int marvell_cable_test_start_common(struct phy_device *phydev)
>  {
>         int bmcr, bmsr, ret;
>
> @@ -1719,12 +1879,66 @@ static int marvell_vct7_cable_test_start(struct phy_device *phydev)
>         if (bmsr & BMSR_LSTATUS)
>                 msleep(1500);
>
> +       return 0;
> +}
> +
> +static int marvell_vct7_cable_test_start(struct phy_device *phydev)
> +{
> +       struct marvell_priv *priv = phydev->priv;
> +       int ret;
> +
> +       ret = marvell_cable_test_start_common(phydev);
> +       if (ret)
> +               return ret;
> +
> +       priv->cable_test_tdr = false;
> +
> +       /* Reset the VCT5 API control to defaults, otherwise
> +        * VCT7 does not work correctly.
> +        */
> +       ret = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
> +                             MII_VCT5_CTRL,
> +                             MII_VCT5_CTRL_TX_SAME_CHANNEL |
> +                             MII_VCT5_CTRL_SAMPLES_DEFAULT |
> +                             MII_VCT5_CTRL_MODE_MAXIMUM_PEEK |
> +                             MII_VCT5_CTRL_PEEK_HYST_DEFAULT);
> +       if (ret)
> +               return ret;
> +
> +       ret = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
> +                             MII_VCT5_SAMPLE_POINT_DISTANCE, 0);
> +       if (ret)
> +               return ret;
> +
>         return phy_write_paged(phydev, MII_MARVELL_VCT7_PAGE,
>                                MII_VCT7_CTRL,
>                                MII_VCT7_CTRL_RUN_NOW |
>                                MII_VCT7_CTRL_CENTIMETERS);
>  }
>
> +static int marvell_vct5_cable_test_tdr_start(struct phy_device *phydev)
> +{
> +       struct marvell_priv *priv = phydev->priv;
> +       int ret;
> +
> +       /* Disable  VCT7 */
> +       ret = phy_write_paged(phydev, MII_MARVELL_VCT7_PAGE,
> +                             MII_VCT7_CTRL, 0);
> +       if (ret)
> +               return ret;
> +
> +       ret = marvell_cable_test_start_common(phydev);
> +       if (ret)
> +               return ret;
> +
> +       priv->cable_test_tdr = true;
> +       ret = ethnl_cable_test_pulse(phydev, 1000);
> +       if (ret)
> +               return ret;
> +
> +       return ethnl_cable_test_step(phydev, 0, 100, 1);
> +}
> +
>  static int marvell_vct7_distance_to_length(int distance, bool meter)
>  {
>         if (meter)
> @@ -1828,8 +2042,15 @@ static int marvell_vct7_cable_test_report(struct phy_device *phydev)
>  static int marvell_vct7_cable_test_get_status(struct phy_device *phydev,
>                                               bool *finished)
>  {
> +       struct marvell_priv *priv = phydev->priv;
>         int ret;
>
> +       if (priv->cable_test_tdr) {
> +               ret = marvell_vct5_amplitude_graph(phydev);
> +               *finished = true;
> +               return ret;
> +       }
> +
>         *finished = false;
>
>         ret = phy_read_paged(phydev, MII_MARVELL_VCT7_PAGE,
> @@ -2563,6 +2784,7 @@ static struct phy_driver marvell_drivers[] = {
>                 .get_tunable = m88e1011_get_tunable,
>                 .set_tunable = m88e1011_set_tunable,
>                 .cable_test_start = marvell_vct7_cable_test_start,
> +               .cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
>                 .cable_test_get_status = marvell_vct7_cable_test_get_status,
>         },
>         {
> @@ -2588,6 +2810,7 @@ static struct phy_driver marvell_drivers[] = {
>                 .get_tunable = m88e1540_get_tunable,
>                 .set_tunable = m88e1540_set_tunable,
>                 .cable_test_start = marvell_vct7_cable_test_start,
> +               .cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
>                 .cable_test_get_status = marvell_vct7_cable_test_get_status,
>         },
>         {
> @@ -2613,6 +2836,7 @@ static struct phy_driver marvell_drivers[] = {
>                 .get_tunable = m88e1540_get_tunable,
>                 .set_tunable = m88e1540_set_tunable,
>                 .cable_test_start = marvell_vct7_cable_test_start,
> +               .cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
>                 .cable_test_get_status = marvell_vct7_cable_test_get_status,
>         },
>         {
> @@ -2658,6 +2882,7 @@ static struct phy_driver marvell_drivers[] = {
>                 .get_tunable = m88e1540_get_tunable,
>                 .set_tunable = m88e1540_set_tunable,
>                 .cable_test_start = marvell_vct7_cable_test_start,
> +               .cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
>                 .cable_test_get_status = marvell_vct7_cable_test_get_status,
>         },
>  };
> --
> 2.26.2
>
