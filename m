Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE250395D27
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 15:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhEaNl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 09:41:56 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:2032 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhEaNjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 09:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622468289; x=1654004289;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4NvKEFLcTaZsrZt676mG2JeyIZzYHRMP6td1iN925rU=;
  b=2sjRjn3+NCcsT91iXAlGVv9S2qDeFbbBboZXLAPb7ZGC3VF7jmwtqFb3
   avpH8oQN3u9cbIb49Va7tLisCga2/lJWmgvuigNkh2qFkkifx+lnWUesq
   TzIfyyQvzLSc3MIE+acsyiKf5bbBt13Sb2icDWgdBDDakPgYWcseM1k2y
   KSmbhmGUUQOdLsrjciJsF43xuxLgD4ZkbveT3ixUa9Mb23BX7DlEqqo3t
   JkbEEvdzF6MvnQ/r/qeoUS2HO993sK+N6Z6TkNPvEPBmIv28WxEGJS0O2
   IKngPcwv0HWOi6IefYwzFloUzQcBo8mW4+09smNpSY9sRmPGIJnrHr8YF
   g==;
IronPort-SDR: cFUxJFz0Vu3et/lEzifPl84BnJAtp/n7Ga/CKr9m2OkfAsa1b48kNahRwzw8yuGRatPZEXvKQq
 Bz33HXEeJ985Y0WniUvRCZ0lsNhvoORhbr1y3rQpz5lJLRXoHvkg2sFs9A93wO0i2uYXM0H2NH
 zV1tWg1cJkhBcx7xFTRd1s9fn/W+R7ZNbZczhJBmCMf7m9+QTc6aLHIdbF9fDgfKgeAU63qNFg
 DodZXJwoW8cUWJ21LWc6Sy2+iTM10ouT4zNQDwibBt/AQ2fjt1O5jknFnSJo7nsnnOvfD0AUHr
 MGw=
X-IronPort-AV: E=Sophos;i="5.83,237,1616482800"; 
   d="scan'208";a="57375529"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 May 2021 06:38:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 06:38:08 -0700
Received: from [10.205.21.35] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 31 May 2021 06:38:04 -0700
Message-ID: <975ebaaf4f7457b7c34d0d31ed5185a44ba05d17.camel@microchip.com>
Subject: Re: [PATCH net-next v2 02/10] net: sparx5: add the basic sparx5
 driver
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Mon, 31 May 2021 15:38:04 +0200
In-Reply-To: <20210530135919.3f64cf33@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210528123419.1142290-1-steen.hegelund@microchip.com>
         <20210528123419.1142290-3-steen.hegelund@microchip.com>
         <20210530135919.3f64cf33@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

Thanks for your comments.

On Sun, 2021-05-30 at 13:59 -0700, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 28 May 2021 14:34:11 +0200 Steen Hegelund wrote:
> > This adds the Sparx5 basic SwitchDev driver framework with IO range
> > mapping, switch device detection and core clock configuration.
> > 
> > Support for ports, phylink, netdev, mactable etc. are in the following
> > patches.
> 
> > +     for (idx = 0; idx < 3; idx++) {
> > +             spx5_rmw(GCB_SIO_CLOCK_SYS_CLK_PERIOD_SET(clk_period / 100),
> > +                      GCB_SIO_CLOCK_SYS_CLK_PERIOD,
> > +                      sparx5,
> > +                      GCB_SIO_CLOCK(idx));
> > +     }
> 
> braces unnecessary, please fix everywhere.

Will do that.

> 
> > +
> > +     spx5_rmw(HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY_SET
> > +              ((256 * 1000) / clk_period),
> > +              HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY,
> > +              sparx5,
> > +              HSCH_TAS_STATEMACHINE_CFG);
> > +
> > +     spx5_rmw(ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT_SET(pol_upd_int),
> > +              ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT,
> > +              sparx5,
> > +              ANA_AC_POL_POL_UPD_INT_CFG);
> > +
> > +     return 0;
> > +}
> 
> > +     /* Default values, some from DT */
> > +     sparx5->coreclock = SPX5_CORE_CLOCK_DEFAULT;
> > +
> > +     ports = of_get_child_by_name(np, "ethernet-ports");
> 
> Don't you need to release the reference you got on @ports?

Yes that is missing.  I will update.

> 
> > +     if (!ports) {
> > +             dev_err(sparx5->dev, "no ethernet-ports child node found\n");
> > +             return -ENODEV;
> > +     }
> > +     sparx5->port_count = of_get_child_count(ports);
> > +
> > +     configs = kcalloc(sparx5->port_count,
> > +                       sizeof(struct initial_port_config), GFP_KERNEL);
> > +     if (!configs)
> > +             return -ENOMEM;
> > +
> > +     for_each_available_child_of_node(ports, portnp) {
> > +             struct sparx5_port_config *conf;
> > +             struct phy *serdes;
> > +             u32 portno;
> > +
> > +             err = of_property_read_u32(portnp, "reg", &portno);
> > +             if (err) {
> > +                     dev_err(sparx5->dev, "port reg property error\n");
> > +                     continue;
> > +             }
> > +             config = &configs[idx];
> > +             conf = &config->conf;
> > +             err = of_get_phy_mode(portnp, &conf->phy_mode);
> > +             if (err) {
> > +                     dev_err(sparx5->dev, "port %u: missing phy-mode\n",
> > +                             portno);
> > +                     continue;
> > +             }
> > +             err = of_property_read_u32(portnp, "microchip,bandwidth",
> > +                                        &conf->bandwidth);
> > +             if (err) {
> > +                     dev_err(sparx5->dev, "port %u: missing bandwidth\n",
> > +                             portno);
> > +                     continue;
> > +             }
> > +             err = of_property_read_u32(portnp, "microchip,sd-sgpio", &conf->sd_sgpio);
> > +             if (err)
> > +                     conf->sd_sgpio = ~0;
> > +             else
> > +                     sparx5->sd_sgpio_remapping = true;
> > +             serdes = devm_of_phy_get(sparx5->dev, portnp, NULL);
> > +             if (IS_ERR(serdes)) {
> > +                     err = PTR_ERR(serdes);
> > +                     if (err != -EPROBE_DEFER)
> > +                             dev_err(sparx5->dev,
> > +                                     "port %u: missing serdes\n",
> > +                                     portno);
> 
> dev_err_probe()

OK - did not know that one.

> 
> > +                     goto cleanup_config;
> > +             }
> > +             config->portno = portno;
> > +             config->node = portnp;
> > +             config->serdes = serdes;
> > +
> > +             conf->media = PHY_MEDIA_DAC;
> > +             conf->serdes_reset = true;
> > +             conf->portmode = conf->phy_mode;
> > +             if (of_find_property(portnp, "sfp", NULL)) {
> > +                     conf->has_sfp = true;
> > +                     conf->power_down = true;
> > +             }
> > +             idx++;
> > +     }
> > +
> > +     err = sparx5_create_targets(sparx5);
> > +     if (err)
> > +             goto cleanup_config;
> > +
> > +     if (of_get_mac_address(np, mac_addr)) {
> > +             dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
> > +             eth_random_addr(sparx5->base_mac);
> > +             sparx5->base_mac[5] = 0;
> > +     } else {
> > +             ether_addr_copy(sparx5->base_mac, mac_addr);
> > +     }
> > +
> > +     /* Inj/Xtr IRQ support to be added in later patches */
> > +     /* Read chip ID to check CPU interface */
> > +     sparx5->chip_id = spx5_rd(sparx5, GCB_CHIP_ID);
> > +
> > +     sparx5->target_ct = (enum spx5_target_chiptype)
> > +             GCB_CHIP_ID_PART_ID_GET(sparx5->chip_id);
> > +
> > +     /* Initialize Switchcore and internal RAMs */
> > +     if (sparx5_init_switchcore(sparx5)) {
> > +             dev_err(sparx5->dev, "Switchcore initialization error\n");
> > +             goto cleanup_config;
> 
> Should @err be set?

Yes it should.  I will update here and below.

> 
> > +     }
> > +
> > +     /* Initialize the LC-PLL (core clock) and set affected registers */
> > +     if (sparx5_init_coreclock(sparx5)) {
> > +             dev_err(sparx5->dev, "LC-PLL initialization error\n");
> > +             goto cleanup_config;
> 
> ditto

Yes.

> 
> > +     }
> > +
> > +     for (idx = 0; idx < sparx5->port_count; ++idx) {
> > +             config = &configs[idx];
> > +             if (!config->node)
> > +                     continue;
> > +
> > +             err = sparx5_create_port(sparx5, config);
> > +             if (err) {
> > +                     dev_err(sparx5->dev, "port create error\n");
> > +                     goto cleanup_ports;
> > +             }
> > +     }
> > +
> > +     if (sparx5_start(sparx5)) {
> > +             dev_err(sparx5->dev, "Start failed\n");
> > +             goto cleanup_ports;
> 
> and here

Yes.

> 
> > +     }
> > +
> > +     kfree(configs);
> > +     return err;
> > +
> > +cleanup_ports:
> > +     /* Port cleanup to be added in later patches */
> > +cleanup_config:
> > +     kfree(configs);
> > +     return err;
> > +}
> 
> > +struct sparx5_port_config      {
> 
> Spurious tab before {?

Spurious spaces - but they will be removed.

> 
> > +     phy_interface_t portmode;
> > +     bool has_sfp;
> > +     u32 bandwidth;
> > +     int speed;
> > +     int duplex;
> > +     enum phy_media media;
> > +     bool power_down;
> > +     bool autoneg;
> > +     u32 pause;
> > +     bool serdes_reset;
> 
> Group all 4 bools together for better packing?

Yes that saves some bytes.  Would bitfields be preferable or are bools sufficient?

> 
> > +     phy_interface_t phy_mode;
> > +     u32 sd_sgpio;
> > +};
> 
> > +static inline void spx5_rmw(u32 val, u32 mask, struct sparx5 *sparx5,
> > +                         int id, int tinst, int tcnt,
> > +                         int gbase, int ginst, int gcnt, int gwidth,
> > +                         int raddr, int rinst, int rcnt, int rwidth)
> > +{
> > +     u32 nval;
> > +     void __iomem *addr =
> > +             spx5_addr(sparx5->regs, id, tinst, tcnt,
> 
> Why try to initialize inline when it results in weird looking code and
> no saved lines?

Hmm, I had not really noticed that... I will just use the spx5_addr call in both places.

> 
> > +                       gbase, ginst, gcnt, gwidth,
> > +                       raddr, rinst, rcnt, rwidth);
> 
> Not to mention that you end up with no new line after variable
> declaration.

Yes.  I will add an empty line.

> 
> > +     nval = readl(addr);
> > +     nval = (nval & ~mask) | (val & mask);
> > +     writel(nval, addr);
> > +}


Thanks!

-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com


