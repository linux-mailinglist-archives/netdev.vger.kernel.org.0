Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC7628D52F
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 22:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgJMUFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 16:05:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56117 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgJMUFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 16:05:12 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201013200459euoutp0129cd7c411a466ddbf45ea273d56282d2~9pfGHF5jL2039320393euoutp01M;
        Tue, 13 Oct 2020 20:04:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201013200459euoutp0129cd7c411a466ddbf45ea273d56282d2~9pfGHF5jL2039320393euoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1602619499;
        bh=X/XhPZiv+RF/G794IzPX4gH5N2uLg6VMkdLk0nu6C+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dW2pHOmgE0yj1dDP3HFu7VhQHbtbq44kj5sBKeXimK/pwYCqUOg5Rvg9h90W/bBVE
         nTW1v+8LNhOFoaUKXeyzv58bSgO9J6SpnzV3xwtpCyKEJX/MgOc1GGdDTMnwcSpoga
         Ieo/5m+wFrx4sMkCjNk9tDLD/DWV0mhKV6Hn+y24=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201013200453eucas1p29b2127ed259148b8958a1d6656566b75~9pfA6fp452242422424eucas1p2-;
        Tue, 13 Oct 2020 20:04:53 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id F1.A4.05997.568068F5; Tue, 13
        Oct 2020 21:04:53 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201013200453eucas1p1b77c93275b518422429ff1481f88a4be~9pfAkJygN0735107351eucas1p1D;
        Tue, 13 Oct 2020 20:04:53 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201013200453eusmtrp2395d6e1c9c00fb8161dea5b2f019fe82~9pfAjWY8X0911709117eusmtrp2U;
        Tue, 13 Oct 2020 20:04:53 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-6e-5f8608658d36
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 5F.F9.06314.568068F5; Tue, 13
        Oct 2020 21:04:53 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201013200453eusmtip188860f7bc3c9b73447fb4e413f9a589f~9pfAYzN8-0753307533eusmtip1Y;
        Tue, 13 Oct 2020 20:04:53 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewi?= =?utf-8?Q?cz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 2/4] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Tue, 13 Oct 2020 22:04:52 +0200
In-Reply-To: <20201002203641.GI3996795@lunn.ch> (Andrew Lunn's message of
        "Fri, 2 Oct 2020 22:36:41 +0200")
Message-ID: <dleftjd01l99jv.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUgUYRjHeXdmdsbFrXGtfDK7Fgus1O5G0w4pGihK/NCduumgkrvGjtoF
        JZaW5hEepJtkRefampl54Vpumxai4+bRgWJo1OYmRVpoqeU6Cn77Pc/z/z/Hy0thiiHClYrS
        xHJajSpaKZXh5fXDgidHJYesNFnnM0KXCWMe5z0imALhAs4UmpsJpqO/k2Aye20YIwglJNNS
        nkEwpb0dBNNaXSBl8oRaCWPKNSLGYO4imfobc5gko5ncMpNt7bBgbNmD9xK2StdFsqX6FCn7
        5PY5tqpyQMJmlOkRO1C6IJA6KPML56Kj4jmt96ZQWeTfl/3k8Z9xJzMaLUQCSgpORQ4U0Guh
        3vYDS0UySkHfR/AqvWgyGERQ+eMXKQYDCH49+4hNWXpT7knEwj0ErRbjpOULggZzBZ6KKEpK
        e4HBsN9umEUvgpzXI4Rdg9EPcbANGyT2gjO9FywX3010xeklkPK0G9nZgVbDNeH2BMvpDXC9
        bVRq59m0D5RZu0kx7wSv8z/hdsbG9fnCN2QfAHQ+BfnPf0vEVbdB++cWUmRn6Gsom2Q3+FdV
        KLEvCvQ5yM5aL3rTEJQXDOGiZiN0Nv+RirwVct9YcVE/A971O4lzZ0BW+VVMTMvhUrJCVLtD
        cWbNZBdXSO+7j0QJC9bkleJTJSK4+zOXuIIW6aZdo5t2jW7cgtEe8KjaW0wvh7s3bZjI/lBc
        /B2/gQg9cuHieHUEx6/WcCe8eJWaj9NEeIXFqEvR+B9sHGsYrETVI0dNiKaQ0lF+qSQpREGo
        4vlTahNyH+/UU1LUglxxTYyGU86SBzQ1Bivk4apTpzltTIg2LprjTWgehStd5GtufT2ioCNU
        sdwxjjvOaaeqEsrBNQEt9Q87H7zXt8ZZNtD2VO9myKnaNXonu+TDgZuO8nVBY+eXvK3ZiYyp
        +85uh9U73StWhC1s+7w5QN+Udmh3+7WWHn5He2TA5S6PoELfxJ7MM7V11syiTSMuPvWBfo4h
        euOok7O7JVDqWTk3dPeezhf+XmeDHnuo7iw+XOctmElbfIJSifORqlXLMC2v+g/ctCVXiwMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t/xu7qpHG3xBqe3clmcv3uI2WLjjPWs
        FnPOt7BYzD9yjtXi2ts7rBb9j18zW5w/v4Hd4sK2PlaLTY+vsVpc3jWHzWLG+X1MFoem7mW0
        WHvkLrvFsQViFq17j7A78HtcvnaR2WPLyptMHjtn3WX32LSqk81j85J6j507PjN59G1Zxejx
        eZNcAEeUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2C
        Xsbvo2/ZCz6VVvSdvsjawNga18XIySEhYCLxuHM5UxcjF4eQwFJGiZtLzjN3MXIAJaQkVs5N
        h6gRlvhzrYsNouYpo8Tz3uNMIDVsAnoSa9dGgNSICChITDn5hxXEZhZYzyKxehIniC0sECKx
        sO8UE4gtBFT+aEkbC4jNIqAq0bn1PiOIzSmQKzH7/BIwm1fAXGLelb9sILaogKXElhf32SHi
        ghInZz5hgZifLfF19XPmCYwCs5CkZiFJzQK6jllAU2L9Ln2IsLbEsoWvmSFsW4l1696zLGBk
        XcUoklpanJueW2yoV5yYW1yal66XnJ+7iREYwduO/dy8g/HSxuBDjAIcjEo8vB0bWuOFWBPL
        iitzDzGqAI15tGH1BUYplrz8vFQlEV6ns6fjhHhTEiurUovy44tKc1KLDzGaAv05kVlKNDkf
        mHTySuINTQ3NLSwNzY3Njc0slMR5OwQOxggJpCeWpGanphakFsH0MXFwSjUwet6blciwemb8
        HNMYQeOaewrnGNjLPQJNDh3j/vZ9ovN69kM2Os8nKef0r2xW/KtQM0nae1Pj7EQZMcEXAh98
        sp+e4JQxOv/5WFFa3J9zyjnKfvdXhNx1Vu5Y+tLnpn5t6jvX3QcXfuDifHCtKUClb+OUWSWP
        nc9e1yr5Ll/DKLE22HHunxWpSizFGYmGWsxFxYkAWjTxCAIDAAA=
X-CMS-MailID: 20201013200453eucas1p1b77c93275b518422429ff1481f88a4be
X-Msg-Generator: CA
X-RootMTR: 20201013200453eucas1p1b77c93275b518422429ff1481f88a4be
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201013200453eucas1p1b77c93275b518422429ff1481f88a4be
References: <20201002203641.GI3996795@lunn.ch>
        <CGME20201013200453eucas1p1b77c93275b518422429ff1481f88a4be@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-02 pi=C4=85 22:36>, when Andrew Lunn wrote:
>> +static u32 ax88796c_get_link(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	phy_read_status(ndev->phydev);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>
> Why do you take this mutux before calling phy_read_status()? The
> phylib core will not be taking this mutex when it calls into the PHY
> driver. This applies to all the calls you have with phy_
>

I need to review the use of this mutex. Thanks for spotting.

> There should not be any need to call phy_read_status(). phylib will do
> this once per second, or after any interrupt from the PHY. so just use
>
>      phydev->link
>

Using ethtool_op_get_link()

>> +static void
>> +ax88796c_get_regs(struct net_device *ndev, struct ethtool_regs *regs, v=
oid *_p)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u16 *p =3D _p;
>> +	int offset, i;
>> +
>> +	memset(p, 0, AX88796C_REGDUMP_LEN);
>> +
>> +	for (offset =3D 0; offset < AX88796C_REGDUMP_LEN; offset +=3D 2) {
>> +		if (!test_bit(offset / 2, ax88796c_no_regs_mask))
>> +			*p =3D AX_READ(&ax_local->ax_spi, offset);
>> +		p++;
>> +	}
>> +
>> +	for (i =3D 0; i < AX88796C_PHY_REGDUMP_LEN / 2; i++) {
>> +		*p =3D phy_read(ax_local->phydev, i);
>> +		p++;
>
> Depending on the PHY, that can be dangerous.

This is a built-in generic PHY. The chip has no lines to attach any
other external one.

> phylib could be busy doing things with the PHY. It could be looking at

How does phylib prevent concurrent access to a PHY?=20

> a different page for example.

Different page?=20

> miitool(1) can give you the same functionally without the MAC driver
> doing anything, other than forwarding the IOCTL call on.

No, I am afraid mii-tool is not able to dump registers. I am not insisting
on dumping PHY registeres but I think it is nice to have them. Intel
drivers do it.

>> +int ax88796c_mdio_read(struct mii_bus *mdiobus, int phy_id, int loc)
>> +{
>> +	struct ax88796c_device *ax_local =3D mdiobus->priv;
>> +	int ret;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, MDIOCR_RADDR(loc)
>> +			| MDIOCR_FADDR(phy_id) | MDIOCR_READ, P2_MDIOCR);
>> +
>> +	ret =3D read_poll_timeout(AX_READ, ret,
>> +				(ret !=3D 0),
>> +				0, jiffies_to_usecs(HZ / 100), false,
>> +				&ax_local->ax_spi, P2_MDIOCR);
>> +	if (ret)
>> +		return -EBUSY;
>
> Return whatever read_poll_timeout() returned. It is probably
> -ETIMEDOUT, but it could also be -EIO for example.

Indeed it is -ETIMEDOUT. Returning ret.

>> +ax88796c_mdio_write(struct mii_bus *mdiobus, int phy_id, int loc, u16 v=
al)
>> +{
>> +	struct ax88796c_device *ax_local =3D mdiobus->priv;
>> +	int ret;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, val, P2_MDIODR);
>> +
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		 MDIOCR_RADDR(loc) | MDIOCR_FADDR(phy_id)
>> +		 | MDIOCR_WRITE, P2_MDIOCR);
>> +
>> +	ret =3D read_poll_timeout(AX_READ, ret,
>> +				((ret & MDIOCR_VALID) !=3D 0), 0,
>> +				jiffies_to_usecs(HZ / 100), false,
>> +				&ax_local->ax_spi, P2_MDIOCR);
>> +	if (ret)
>> +		return -EIO;
>> +
>> +	if (loc =3D=3D MII_ADVERTISE) {
>> +		AX_WRITE(&ax_local->ax_spi, (BMCR_FULLDPLX | BMCR_ANRESTART |
>> +			  BMCR_ANENABLE | BMCR_SPEED100), P2_MDIODR);
>> +		AX_WRITE(&ax_local->ax_spi, (MDIOCR_RADDR(MII_BMCR) |
>> +			  MDIOCR_FADDR(phy_id) | MDIOCR_WRITE),
>> +			  P2_MDIOCR);
>>
>
> What is this doing?
>

Well=E2=80=A6 it turns autonegotiation when changing advertised link modes.=
 But
this is obvious. As to why this code is here, I will honestly say =E2=80=94=
 I am
not sure (Reminder: this is a vendor driver I am porting, I am more than
happy to receive any comments, thank you). Apparently it is not required
and I am willing to remove it.  It could be of some use when the driver
didn't use phylib.

>> +		ret =3D read_poll_timeout(AX_READ, ret,
>> +					((ret & MDIOCR_VALID) !=3D 0), 0,
>> +					jiffies_to_usecs(HZ / 100), false,
>> +					&ax_local->ax_spi, P2_MDIOCR);
>> +		if (ret)
>> +			return -EIO;
>> +	}
>> +
>> +	return 0;
>> +}
>
>> +static char *no_regs_list =3D "80018001,e1918001,8001a001,fc0d0000";
>> +unsigned long ax88796c_no_regs_mask[AX88796C_REGDUMP_LEN / (sizeof(unsi=
gned long) * 8)];
>> +
>> +module_param(comp, int, 0444);
>> +MODULE_PARM_DESC(comp, "0=3DNon-Compression Mode, 1=3DCompression Mode"=
);
>> +
>> +module_param(msg_enable, int, 0444);
>> +MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for b=
itmap)");
>
> No module parameters allowed, not in netdev.
>
>> +static int ax88796c_reload_eeprom(struct ax88796c_device *ax_local)
>> +{
>> +	int ret;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, EECR_RELOAD, P3_EECR);
>> +
>> +	ret =3D read_poll_timeout(AX_READ, ret,
>> +				(ret & PSR_DEV_READY),
>> +				0, jiffies_to_usecs(2 * HZ / 1000), false,
>> +				&ax_local->ax_spi, P0_PSR);
>> +	if (ret) {
>> +		dev_err(&ax_local->spi->dev,
>> +			"timeout waiting for reload eeprom\n");
>> +		return -1;
>
> return ret not EINVAL which is -1
>

Done.

>> +static int ax88796c_set_mac_address(struct net_device *ndev, void *p)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	struct sockaddr *addr =3D p;
>> +
>> +	if (!is_valid_ether_addr(addr->sa_data))
>> +		return -EADDRNOTAVAIL;
>
> It would be better to just use eth_mac_addr().
>

Done.

>> +static int
>> +ax88796c_check_free_pages(struct ax88796c_device *ax_local, u8 need_pag=
es)
>> +{
>> +	u8 free_pages;
>> +	u16 tmp;
>> +
>> +	free_pages =3D AX_READ(&ax_local->ax_spi, P0_TFBFCR) & TX_FREEBUF_MASK;
>> +	if (free_pages < need_pages) {
>> +		/* schedule free page interrupt */
>> +		tmp =3D AX_READ(&ax_local->ax_spi, P0_TFBFCR)
>> +				& TFBFCR_SCHE_FREE_PAGE;
>> +		AX_WRITE(&ax_local->ax_spi, tmp | TFBFCR_TX_PAGE_SET |
>> +				TFBFCR_SET_FREE_PAGE(need_pages),
>> +				P0_TFBFCR);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static struct sk_buff *
>> +ax88796c_tx_fixup(struct net_device *ndev, struct sk_buff_head *q)
>> +{
>> +	if (netif_msg_pktdata(ax_local)) {
>> +		char pfx[IFNAMSIZ + 7];
>> +
>> +		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
>> +
>> +		netdev_info(ndev, "TX packet len %d, total len %d, seq %d\n",
>> +			    pkt_len, tx_skb->len, seq_num);
>> +
>> +		netdev_info(ndev, "  SPI Header:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       tx_skb->data, 4, 0);
>> +
>> +		netdev_info(ndev, "  TX SOP:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       tx_skb->data + 4, TX_OVERHEAD, 0);
>> +
>> +		netdev_info(ndev, "  TX packet:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       tx_skb->data + 4 + TX_OVERHEAD,
>> +			       tx_skb->len - TX_EOP_SIZE - 4 - TX_OVERHEAD, 0);
>> +
>> +		netdev_info(ndev, "  TX EOP:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       tx_skb->data + tx_skb->len - 4, 4, 0);
>> +	}
>
> I expect others are going to ask you to remove this.
>

You mean dumping packets? I will if they do. What is pktdata flag for then?

>> +static void ax88796c_handle_link_change(struct net_device *ndev)
>> +{
>> +	if (net_ratelimit())
>> +		phy_print_status(ndev->phydev);
>> +}
>> +
>> +void ax88796c_phy_init(struct ax88796c_device *ax_local)
>> +{
>> +	/* Enable PHY auto-polling */
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		 PCR_PHYID(0x10) | PCR_POLL_EN |
>> +		 PCR_POLL_FLOWCTRL | PCR_POLL_BMCR, P2_PCR);
>
> Auto-polling of the PHY is generally a bad idea. The hardware is not
> going to respect the phydev->lock mutex, for example. Disable this,
> and add a proper ax88796c_handle_link_change().
>

Done.

>> +static int
>> +ax88796c_open(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +	unsigned long irq_flag =3D IRQF_SHARED;
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	ret =3D ax88796c_soft_reset(ax_local);
>> +	if (ret < 0)
>> +		return -ENODEV;
>> +
>> +	ret =3D request_irq(ndev->irq, ax88796c_interrupt,
>> +			  irq_flag, ndev->name, ndev);
>
> Maybe look at using request_threaded_irq(). You can then remove your
> work queue, and do the work in the thread_fn.
>

There is other work beeing done in the work queue too.

>> +	if (ret) {
>> +		netdev_err(ndev, "unable to get IRQ %d (errno=3D%d).\n",
>> +			   ndev->irq, ret);
>> +		return -ENXIO;
>
> return ret;
>
> In general, never change a return code unless you have a really good
> reason why. And if you do have a reason, document it.
>

OK, Done.

>> +static int
>> +ax88796c_close(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	netif_stop_queue(ndev);
>> +
>> +	free_irq(ndev->irq, ndev);
>> +
>> +	phy_stop(ndev->phydev);
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
>> +	ax88796c_free_skb_queue(&ax_local->tx_wait_q);
>> +
>> +	ax88796c_soft_reset(ax_local);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +	netif_carrier_off(ndev);
>
> phy_stop() will do that for you.
>

Removed.

>> +static int ax88796c_probe(struct spi_device *spi)
>> +{
>
>> +	ax_local->mdiobus->priv =3D ax_local;
>> +	ax_local->mdiobus->read =3D ax88796c_mdio_read;
>> +	ax_local->mdiobus->write =3D ax88796c_mdio_write;
>> +	ax_local->mdiobus->name =3D "ax88976c-mdiobus";
>> +	ax_local->mdiobus->phy_mask =3D ~(1 << 0x10);
>
> BIT(0x10);
>

Done.

>> +
>> +	ret =3D devm_register_netdev(&spi->dev, ndev);
>> +	if (ret) {
>> +		dev_err(&spi->dev, "failed to register a network device\n");
>> +		destroy_workqueue(ax_local->ax_work_queue);
>> +		goto err;
>> +	}
>
> The device is not live. If this is being used for NFS root, the kernel
> will start using it. So what sort of mess will it get into, if there
> is no PHY yet? Nothing important should happen after register_netdev().
>

But, with an unregistered network device ndev_owner in
phy_attach_direct() is NULL. Thus, phy_connect_direct() below fails.

=2D-8<---------------cut here---------------start------------->8---
   1332         if (dev)
   1333                 ndev_owner =3D dev->dev.parent->driver->owner;
   1334         if (ndev_owner !=3D bus->owner &&  !try_module_get(bus->own=
er)) {
   1335                 phydev_err(phydev, "failed to get the bus  module\n=
");
   1336                 return -EIO;
   1337         }
=2D-8<---------------cut here---------------end--------------->8---


>> +
>> +	ax_local->phydev =3D phy_find_first(ax_local->mdiobus);
>> +	if (!ax_local->phydev) {
>> +		dev_err(&spi->dev, "no PHY found\n");
>> +		ret =3D -ENODEV;
>> +		goto err;
>> +	}
>> +
>> +	ax_local->phydev->irq =3D PHY_IGNORE_INTERRUPT;
>> +	phy_connect_direct(ax_local->ndev, ax_local->phydev,
>> +			   ax88796c_handle_link_change,
>> +			   PHY_INTERFACE_MODE_MII);
>> +
>> +	netif_info(ax_local, probe, ndev, "%s %s registered\n",
>> +		   dev_driver_string(&spi->dev),
>> +		   dev_name(&spi->dev));
>> +	phy_attached_info(ax_local->phydev);
>> +
>> +	ret =3D 0;
>> +err:
>> +	return ret;
>> +}
>> +
>> +static int ax88796c_remove(struct spi_device *spi)
>> +{
>> +	struct ax88796c_device *ax_local =3D dev_get_drvdata(&spi->dev);
>> +	struct net_device *ndev =3D ax_local->ndev;
>
> You might want to disconnect the PHY.
>

I do (-; Done.

>> +
>> +	netif_info(ax_local, probe, ndev, "removing network device %s %s\n",
>> +		   dev_driver_string(&spi->dev),
>> +		   dev_name(&spi->dev));
>> +
>> +	destroy_workqueue(ax_local->ax_work_queue);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id ax88796c_dt_ids[] =3D {
>> +	{ .compatible =3D "asix,ax88796c" },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, ax88796c_dt_ids);
>> +
>> +static const struct spi_device_id asix_id[] =3D {
>> +	{ "ax88796c", 0 },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(spi, asix_id);
>> +
>> +static struct spi_driver ax88796c_spi_driver =3D {
>> +	.driver =3D {
>> +		.name =3D DRV_NAME,
>> +#ifdef CONFIG_USE_OF
>> +		.of_match_table =3D of_match_ptr(ax88796c_dt_ids),
>> +#endif
>
> I don't think you need the #ifdef.
>

Indeed, it appears to be an uncommon practice to use it in this
context. Done.

>> +#ifndef _AX88796C_MAIN_H
>> +#define _AX88796C_MAIN_H
>> +
>> +#include <linux/netdevice.h>
>> +#include <linux/mii.h>
>> +
>> +#include "ax88796c_spi.h"
>> +
>> +/* These identify the driver base version and may not be removed. */
>> +#define DRV_NAME	"ax88796c"
>> +#define ADP_NAME	"ASIX AX88796C SPI Ethernet Adapter"
>> +#define DRV_VERSION	"1.2.0"
>
> DRV_VERSION are pretty pointless. Not sure you use it anyway. Please
> remove.
>

Done.

>> +	unsigned long		capabilities;
>> +		#define AX_CAP_DMA		1
>> +		#define AX_CAP_COMP		2
>> +		#define AX_CAP_BIDIR		4
>
> BIT(0), BIT(1), BIT(2)...
>

No problem. Do you have any recommendation how to express this

 #define PSR_RESET  (0 << 15)

I know it equals 0, but shows explicitly the bit number.

>> +struct skb_data;
>> +
>> +struct skb_data {
>> +	enum skb_state state;
>> +	struct net_device *ndev;
>> +	struct sk_buff *skb;
>> +	size_t len;
>> +	dma_addr_t phy_addr;
>> +};
>
> A forward definition, followed by the real definition?
>

There must have been something in between. Done.

>> +	#define FER_IPALM		(1 << 0)
>> +	#define FER_DCRC		(1 << 1)
>> +	#define FER_RH3M		(1 << 2)
>> +	#define FER_HEADERSWAP		(1 << 7)
>> +	#define FER_WSWAP		(1 << 8)
>> +	#define FER_BSWAP		(1 << 9)
>> +	#define FER_INTHI		(1 << 10)
>> +	#define FER_INTLO		(0 << 10)
>> +	#define FER_IRQ_PULL		(1 << 11)
>> +	#define FER_RXEN		(1 << 14)
>> +	#define FER_TXEN		(1 << 15)
>
> Isn't checkpatch giving warnings and suggesting BIT?

Not exactly. It gives green CHECK messages, which I decided to
ignore. Apparently a wrong move.

Thanks for the feedback.
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+GCGQACgkQsK4enJil
gBDiVQf/RFyDFHSaNmSqW1FxYiUDYphDCgzhzDPzQEHJhI1YqFWh3aC3uYG1Vs5a
yviPHAVt6EGodQN2T83aQHr/ywBkEMIBGvTU6QQJbGs0dp1Fx/QCH5jhT+uOa+0C
t5eWOvXHOfcg65klahb5lViSTYnEJKoEazyVlkKAwNLQSqg61o2AvpRMWnYrBj3a
5oX3j4tS06qWjwIvoK1rjKxKflqOHXk0azu+J8dx8Vvtg5fvGOWz515EszM/TeKK
OjKzc69zxhmhquBkjW36UosZxVzo1nfVi2048AX81WWwrdasd7pWz2hiWeDWWzFt
wnPGfnC1jNFVa1+7eLN7fBCDZ+c3DQ==
=cNrL
-----END PGP SIGNATURE-----
--=-=-=--
