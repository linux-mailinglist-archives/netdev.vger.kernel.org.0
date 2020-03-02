Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3ADA17592F
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 12:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgCBLIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 06:08:14 -0500
Received: from mout.gmx.net ([212.227.17.20]:47023 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgCBLIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 06:08:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1583147285;
        bh=WsyWkH2ZPYlfH4IVEhq7y8PwsweJYWJZCrIhLPKsuZo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ehRNHHHCe+XWuW4McXot2xC4BvJQ6AVvRQmUhKmdrOOnDOLepMOJXjhkTI+72fwSv
         Ry5CISDHm7uPK8ja6YvMY29u0KMCmZpWbug5NA8NR+YxpjdAXHAiGiMTw8HRWWQh9H
         ubReMFQ/uoFSGWGmRJaeInE0nFk621H6mCRLkhlo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.2.2.136] ([85.220.165.66]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N6sit-1jS1P82A3j-018O1h; Mon, 02
 Mar 2020 12:08:05 +0100
Subject: Re: [PATCH 2/2] ag71xx: Configure Ethernet interface
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com, jcliburn@gmail.com
References: <20200302001830.14278-1-hauke@hauke-m.de>
 <20200302001830.14278-2-hauke@hauke-m.de>
From:   Oleksij Rempel <linux@rempel-privat.de>
Autocrypt: addr=linux@rempel-privat.de; prefer-encrypt=mutual; keydata=
 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
 Rmpernzn0GXR0xYSTiUvuvpLsoo=
Message-ID: <fd921f50-075d-c39e-b22a-7de296e59038@rempel-privat.de>
Date:   Mon, 2 Mar 2020 12:07:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302001830.14278-2-hauke@hauke-m.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cdbXUjIwFX0fPZ90m0YdcOzwMPYsJSt7q"
X-Provags-ID: V03:K1:LJgsWkOpPWEoc52/h4CklLnda0IzY96LzGuhNEyOueU3S/ShSQD
 Hw/bak61PUncFKUGPrKWgwr+24Wm5ll6P5Dd3HsfYhDo3URhTEO8mIK0v9zAsFP5eATpDwu
 BzF7imbff5xnkpWc7LK908Kb92OOGX8w4HzWuYQqs74tKj8SN8w7Jc2Jpc2k/tFMeracKp/
 tWVf/Uf4GxPJ7xinDcrhA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6dB2PdCFW/U=:9QuO0hWJsg7U7OjEbKT0pg
 QnjmIeOxE1KtrIGniIb/+7qAOda+I/fgj0I89WMk4r1aSXrQUfhFCutMJAiOwcjakrjJ2glvO
 lxIvOTJ+le4XOsJuaEpWphuiBpJ6z4ybM290iLOPNxceh8MIKq2xbx9JfDoUMvTo2/ALou5dn
 j/JGufZ2f6Lo051HXXmJ0/BaKHzb7wa754kZnJvtDE36tw4exS6I/n9w3WBKYlhpDtnIuLVpR
 yQeQIdAXl/DPQ1UzNmf3+yEDTkvg2BbfPkxaUTV8oTte37fsXal5JeRZ0TRjQBjp2XTS+QJ3l
 sxD7V/mKli8owc+1vGhJVgOEAkdcNb2wD6uDd9oxaGo7peBZ/Znip0HGqvWelshAEelaTk0ui
 f7idUVYNK88VbyEvXSaKjuDq3UnVSt8UKqOKKkD7ppfaLYn9RMPnBkqk4M87w/hfFxCvoQAmz
 WBCjUegr4ujdwh+dEtjz+Nss2pEzYE21H51DsyYTjkg7BGFLbN0MifRAYEi4EQPlGDU//0VWF
 rJ7BNFKYALJeK9BY9zgdE38zZX0Nc+gjhCpRODA11vPR2GHxgpZsrpmStKCxJoMc+nKuGAKwC
 8glUD7FNOuEWY6NolAFLCK8NnpXlcgrPnpdy4kX6d9gHrs3VOmh70k1O8SFT5b8KLjFx077HH
 x9ibaRHxcwe2RFeKtdm7MmTj49QftyNs8o0BOBpdpKe159C9nqs9/oRoNZkhdUsiijb+kGaLf
 KCcyf/02K0vlQxk1cWtCOHnMbESPdsO3Y0iYUgPiI+5Ua8JPLK9dakrnmqh8qJlqY3f0TuW4n
 2CEn44vGvhTEAx+aDFFdSZyv4wC4ypmEtB0d5Qv7jtLANx9NcVcPgkqGNVF/mob0XZgPANb5A
 ZQzD7kKSIam/0rtfI2QTA4j60U2a8VLeNcUcUSjdLE/rW/J6q/pPBnYI3QBbbqDuLZfCjV7Fe
 Zx9C0qsiRiom9s7t7Jck3mWQXunQuEz1ffcdY42qBD25bjh9WYfbwbzS7YV8lUMjoziSHTf7O
 RCS9Dx01CewwiIUkYzd5jzz8SGs40GETBJCvQmB7jywxRZC/AZhCo/CV3fGtJRvW1IO7P9BLN
 z5YLg9R4NUU+WQ+mdcuX7X7UaIAVu2qInS1ojRjS8XM+QwvTXeReX/dtt5wMyPGW5WdOcCJid
 ODBReBdJlbhNDxryPKyhFsnQEK2wpR8KmnHSB6JVYXGQugo5XuEpCZkX7tMSqlcMpRqm8on7D
 pfbAo1eZbwpHLiHrG
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cdbXUjIwFX0fPZ90m0YdcOzwMPYsJSt7q
Content-Type: multipart/mixed; boundary="ix2iAHvJj1KeVQjOdDjYvdintCIrMOjEy"

--ix2iAHvJj1KeVQjOdDjYvdintCIrMOjEy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 02.03.20 um 01:18 schrieb Hauke Mehrtens:
> Configure the Ethernet interface when the register range is provided.
>=20
> The GMAC0 of the AR9330=20

I was not able to find any ar9330 documentation or chip. Are there any th=
e wild? The AR9331 do not
have support for external PHYs. RGMII on GMAC0 seems to be not supported =
or not working. At least,
currently I was not able to get it in working state.

> and AR9340 can be operated in different modes,
> like MII, RMII, GMII and RGMII. This allows to configure this mode in
> the interface register block.
>=20
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/ethernet/atheros/ag71xx.c | 76 +++++++++++++++++++++++++++=

>  1 file changed, 76 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethern=
et/atheros/ag71xx.c
> index 69125f870363..7ef16fdd6617 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -64,6 +64,14 @@
>  #define AG71XX_MDIO_DELAY	5
>  #define AG71XX_MDIO_MAX_CLK	5000000
> =20
> +/* GMAC Interface Registers */
> +#define AG71XX_GMAC_REG_ETH_CFG	0x00
> +#define ETH_CFG_RGMII_GE0	BIT(0)
> +#define ETH_CFG_MII_GE0		BIT(1)
> +#define ETH_CFG_GMII_GE0	BIT(2)
> +#define ETH_CFG_RMII_GE0_AR933X	BIT(9)
> +#define ETH_CFG_RMII_GE0_AR934X	BIT(10)

According to the ar9344 doc this bit is MII_CNTL_SPEED, not RMII.

> +
>  /* Register offsets */
>  #define AG71XX_REG_MAC_CFG1	0x0000
>  #define MAC_CFG1_TXE		BIT(0)	/* Tx Enable */
> @@ -311,6 +319,8 @@ struct ag71xx {
>  	/* From this point onwards we're not looking at per-packet fields. */=

>  	void __iomem *mac_base;
> =20
> +	void __iomem *inf_base;

please use regmap instead.

> +
>  	struct ag71xx_desc *stop_desc;
>  	dma_addr_t stop_desc_dma;
> =20
> @@ -364,6 +374,18 @@ static u32 ag71xx_rr(struct ag71xx *ag, unsigned i=
nt reg)
>  	return ioread32(ag->mac_base + reg);
>  }
> =20
> +static void ag71xx_inf_wr(struct ag71xx *ag, unsigned int reg, u32 val=
ue)
> +{
> +	iowrite32(value, ag->inf_base + reg);
> +	/* flush write */
> +	(void)ioread32(ag->inf_base + reg);
> +}
> +
> +static u32 ag71xx_inf_rr(struct ag71xx *ag, unsigned int reg)
> +{
> +	return ioread32(ag->inf_base + reg);
> +}
> +
>  static void ag71xx_sb(struct ag71xx *ag, unsigned int reg, u32 mask)
>  {
>  	void __iomem *r;
> @@ -848,6 +870,52 @@ static void ag71xx_hw_start(struct ag71xx *ag)
>  	netif_wake_queue(ag->ndev);
>  }
> =20
> +static void ag71xx_mac_config_inf(struct ag71xx *ag,
> +				  const struct phylink_link_state *state)
> +{
> +	u32 val;
> +
> +	if (!ag71xx_is(ag, AR9330) && !ag71xx_is(ag, AR9340))
> +		return;

We should do complete validate (port, chip and so on) here again, or do p=
roper validation in
ag71xx_mac_validate() and trust provided results here.

I would prefer to do proper validation only one time.

> +
> +	val =3D ag71xx_inf_rr(ag, AG71XX_GMAC_REG_ETH_CFG);
> +
> +	val &=3D ~ETH_CFG_MII_GE0;
> +	val &=3D ~ETH_CFG_GMII_GE0;
> +	val &=3D ~ETH_CFG_RGMII_GE0;

Better val &=3D ~(ETH_CFG_MII_GE0 | ETH_CFG_GMII_GE0 ...)

> +	if (ag71xx_is(ag, AR9330))
> +		val &=3D ~ETH_CFG_RMII_GE0_AR933X;
> +	else
> +		val &=3D ~ETH_CFG_RMII_GE0_AR934X;
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_MII:
> +		val |=3D ETH_CFG_MII_GE0;
> +		break;
> +	case PHY_INTERFACE_MODE_RMII:
> +		if (ag71xx_is(ag, AR9330))
> +			val |=3D ETH_CFG_RMII_GE0_AR933X;
> +		else
> +			val |=3D ETH_CFG_RMII_GE0_AR934X;
> +		break;
> +	case PHY_INTERFACE_MODE_GMII:
> +		val |=3D ETH_CFG_GMII_GE0;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		val |=3D ETH_CFG_RGMII_GE0;
> +		break;
> +	default:
> +		netif_err(ag, link, ag->ndev,
> +			  "Unsupported interface: %d\n",
> +			  state->interface);
> +		return;
> +	}
> +	ag71xx_inf_wr(ag, AG71XX_GMAC_REG_ETH_CFG, val);
> +}
> +
>  static void ag71xx_mac_config(struct phylink_config *config, unsigned =
int mode,
>  			      const struct phylink_link_state *state)
>  {
> @@ -859,6 +927,9 @@ static void ag71xx_mac_config(struct phylink_config=
 *config, unsigned int mode,
>  	if (!ag71xx_is(ag, AR7100) && !ag71xx_is(ag, AR9130))
>  		ag71xx_fast_reset(ag);
> =20
> +	if (ag->inf_base)
> +		ag71xx_mac_config_inf(ag, state);
> +
>  	if (ag->tx_ring.desc_split) {
>  		ag->fifodata[2] &=3D 0xffff;
>  		ag->fifodata[2] |=3D ((2048 - ag->tx_ring.desc_split) / 4) << 16;
> @@ -1703,6 +1774,11 @@ static int ag71xx_probe(struct platform_device *=
pdev)
>  		return -EINVAL;
>  	}
> =20
> +	/* The interface resource is optional */
> +	ag->inf_base =3D devm_platform_ioremap_resource_byname(pdev, "interfa=
ce");
> +	if (IS_ERR(ag->inf_base) && PTR_ERR(ag->inf_base) !=3D -ENOENT)
> +		return PTR_ERR(ag->inf_base);

Please use regmap, this register should be shared with switch driver at l=
east on ar9331. You will
need to define separate devicetree node for ETH_CFG register and link it =
to the eth0 node.

>  	ag->clk_eth =3D devm_clk_get(&pdev->dev, "eth");
>  	if (IS_ERR(ag->clk_eth)) {
>  		netif_err(ag, probe, ndev, "Failed to get eth clk.\n");
>=20


--=20
Regards,
Oleksij


--ix2iAHvJj1KeVQjOdDjYvdintCIrMOjEy--

--cdbXUjIwFX0fPZ90m0YdcOzwMPYsJSt7q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEpENFL0P3hvQ7p0DDdQOiSHVI77QFAl5c6RQACgkQdQOiSHVI
77T8+ggAuENuSWJWo61jrSIBp934N5VvFpobbRt0Vb2uueAeVaWN6a2KDVKXrnB+
mPSrMNdMc5Fp6HjVY6d9iPp3EzfLTBhoWtQ3OLRN7lLDSAVIVstJAFuVjX8emzf0
dB2WHum9rU4DM/4na66+l11vteoQWVL+mFjGbFMG+BZVYjSLkG5x5EjgM3NLVxok
eZQhweWrjaCH4BDwrotIMYdLz4+wUm1FjVVFoxstW8ZK57ky9xK1ShbouAgTFK72
Y9FSoIkrlfPR32GtvQkOvPyiR+E96dWUjtiHtU5FbC4k0mm5TzIhdvKyxgGhpg4/
957tgr8hPAlvB1ISD7zZQg3qOslQlQ==
=Ftbb
-----END PGP SIGNATURE-----

--cdbXUjIwFX0fPZ90m0YdcOzwMPYsJSt7q--
