Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8137A60102E
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 15:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJQN1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 09:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJQN13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 09:27:29 -0400
Received: from www381.your-server.de (www381.your-server.de [78.46.137.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D545E56D;
        Mon, 17 Oct 2022 06:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
        s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=MdtINtRvkg7xkh9fmGLAQq8wLHecOzt4ylQEzbIqL8g=; b=R1QoctUeuHEaXEmVIdYlEBm6bg
        bLePYFMZGzPcEQYYXJFotrqM6WD80+HJdFE6f1/1QMlYS2arHCSlIXh+uAfuNonHVLgmOi3vhUZuB
        jrlfnMU/QtqIqy7HBWoP8fH6fMDsfb8EpSXkH4nhIK451MoqO4/TurP9a29D0WxBXr/6t3B3gjChk
        jew0guT50o7cNZ621x5hWL/vc+lzDEYlVN8iTg3Zx1ZrQOokl03ZJ73Mw4rFNcb2nb1c/QOEF7Yv7
        qroKUdpzHXgcV7CVxslcgKMQB4foKS4dyJ1hjK+phq+AqsO5AjArziYHNVQVkjYJJbxDQwnAtuK6m
        WqfT5wJQ==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www381.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lars@metafoo.de>)
        id 1okPnk-0007DL-6P; Mon, 17 Oct 2022 15:05:04 +0200
Received: from [2001:a61:2a91:5601:9e5c:8eff:fe01:8578]
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1okPnf-000O4x-89; Mon, 17 Oct 2022 15:04:59 +0200
Message-ID: <12fe1b84-1981-bf56-9323-b7f5b698c196@metafoo.de>
Date:   Mon, 17 Oct 2022 15:04:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 03/10] net: Replace spi->chip_select references to
 spi->chip_select[0]
Content-Language: en-US
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
        broonie@kernel.org, sanju.mehta@amd.com,
        chin-ting_kuo@aspeedtech.com, clg@kaod.org, kdasu.kdev@gmail.com,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        eajames@linux.ibm.com, olteanv@gmail.com, han.xu@nxp.com,
        john.garry@huawei.com, shawnguo@kernel.org, s.hauer@pengutronix.de,
        narmstrong@baylibre.com, khilman@baylibre.com,
        matthias.bgg@gmail.com, haibo.chen@nxp.com,
        linus.walleij@linaro.org, daniel@zonque.org,
        haojian.zhuang@gmail.com, robert.jarzmik@free.fr,
        agross@kernel.org, bjorn.andersson@linaro.org, heiko@sntech.de,
        krzysztof.kozlowski@linaro.org, andi@etezian.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        wens@csie.org, jernej.skrabec@gmail.com, samuel@sholland.org,
        masahisa.kojima@linaro.org, jaswinder.singh@linaro.org,
        rostedt@goodmis.org, mingo@redhat.com, l.stelmach@samsung.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.aring@gmail.com, stefan@datenfreihafen.org,
        kvalo@kernel.org, miquel.raynal@bootlin.com, richard@nod.at,
        vigneshr@ti.com, jic23@kernel.org, tudor.ambarus@microchip.com,
        pratyush@kernel.org
Cc:     git@amd.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au, andrew@aj.id.au,
        radu_nicolae.pirea@upb.ro, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        bcm-kernel-feedback-list@broadcom.com, fancer.lancer@gmail.com,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        avifishman70@gmail.com, tmaimon77@gmail.com, tali.perry1@gmail.com,
        venture@google.com, yuenn@google.com, benjaminfair@google.com,
        yogeshgaur.83@gmail.com, konrad.dybcio@somainline.org,
        alim.akhtar@samsung.com, ldewangan@nvidia.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        michal.simek@amd.com, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-mtd@lists.infradead.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, michael@walle.cc, akumarma@amd.com,
        amitrkcian2002@gmail.com
References: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
 <20221017121249.19061-4-amit.kumar-mahapatra@amd.com>
From:   Lars-Peter Clausen <lars@metafoo.de>
In-Reply-To: <20221017121249.19061-4-amit.kumar-mahapatra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.103.7/26692/Mon Oct 17 09:58:17 2022)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/17/22 14:12, Amit Kumar Mahapatra wrote:
> For adding multi CS support & to prevent any existing driver from
> breaking, replaced all spi->chip_select references to spi->chip_select[0].

But the tree is broken, isn't it? You introduce make chipselect an array 
in one of the earlier patches and then change drivers one by one in 
separate patches.

How about adding a inline helper function spi_chipselect(struct 
spi_device *spi, unsigned int idx). Update all drivers to use that 
function and then once there are no drivers left that directly reference 
the chipselect field you can introduce multi-chipselect support and 
update the helper function.

>
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
> ---
>   drivers/net/ethernet/asix/ax88796c_main.c      | 2 +-
>   drivers/net/ethernet/davicom/dm9051.c          | 2 +-
>   drivers/net/ieee802154/ca8210.c                | 2 +-
>   drivers/net/wan/slic_ds26522.c                 | 2 +-
>   drivers/net/wireless/marvell/libertas/if_spi.c | 2 +-
>   5 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
> index 6ba5b024a7be..65586ff24dfb 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -1006,7 +1006,7 @@ static int ax88796c_probe(struct spi_device *spi)
>   	ax_local->mdiobus->parent = &spi->dev;
>   
>   	snprintf(ax_local->mdiobus->id, MII_BUS_ID_SIZE,
> -		 "ax88796c-%s.%u", dev_name(&spi->dev), spi->chip_select);
> +		 "ax88796c-%s.%u", dev_name(&spi->dev), spi->chip_select[0]);
>   
>   	ret = devm_mdiobus_register(&spi->dev, ax_local->mdiobus);
>   	if (ret < 0) {
> diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
> index a523ddda7609..835674ad6ceb 100644
> --- a/drivers/net/ethernet/davicom/dm9051.c
> +++ b/drivers/net/ethernet/davicom/dm9051.c
> @@ -1121,7 +1121,7 @@ static int dm9051_mdio_register(struct board_info *db)
>   	db->mdiobus->phy_mask = (u32)~BIT(1);
>   	db->mdiobus->parent = &spi->dev;
>   	snprintf(db->mdiobus->id, MII_BUS_ID_SIZE,
> -		 "dm9051-%s.%u", dev_name(&spi->dev), spi->chip_select);
> +		 "dm9051-%s.%u", dev_name(&spi->dev), spi->chip_select[0]);
>   
>   	ret = devm_mdiobus_register(&spi->dev, db->mdiobus);
>   	if (ret)
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index 42c0b451088d..f0ccf1cd79f4 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2967,7 +2967,7 @@ static int ca8210_test_interface_init(struct ca8210_priv *priv)
>   		sizeof(node_name),
>   		"ca8210@%d_%d",
>   		priv->spi->master->bus_num,
> -		priv->spi->chip_select
> +		priv->spi->chip_select[0]
>   	);
>   
>   	test->ca8210_dfs_spi_int = debugfs_create_file(
> diff --git a/drivers/net/wan/slic_ds26522.c b/drivers/net/wan/slic_ds26522.c
> index 6063552cea9b..eb053a76fe52 100644
> --- a/drivers/net/wan/slic_ds26522.c
> +++ b/drivers/net/wan/slic_ds26522.c
> @@ -211,7 +211,7 @@ static int slic_ds26522_probe(struct spi_device *spi)
>   
>   	ret = slic_ds26522_init_configure(spi);
>   	if (ret == 0)
> -		pr_info("DS26522 cs%d configured\n", spi->chip_select);
> +		pr_info("DS26522 cs%d configured\n", spi->chip_select[0]);
>   
>   	return ret;
>   }
> diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c b/drivers/net/wireless/marvell/libertas/if_spi.c
> index ff1c7ec8c450..074d6c1f0c2c 100644
> --- a/drivers/net/wireless/marvell/libertas/if_spi.c
> +++ b/drivers/net/wireless/marvell/libertas/if_spi.c
> @@ -1051,7 +1051,7 @@ static int if_spi_init_card(struct if_spi_card *card)
>   				"spi->max_speed_hz=%d\n",
>   				card->card_id, card->card_rev,
>   				card->spi->master->bus_num,
> -				card->spi->chip_select,
> +				card->spi->chip_select[0],
>   				card->spi->max_speed_hz);
>   		err = if_spi_prog_helper_firmware(card, helper);
>   		if (err)


