Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6221723B5ED
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 09:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgHDHoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 03:44:18 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51919 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729874AbgHDHoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 03:44:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CAAA55C0003;
        Tue,  4 Aug 2020 03:44:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 04 Aug 2020 03:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+TPlxB
        1NA9qErTj3O+ohR/v9W1SPgOB1oHZ14rLsSzA=; b=cPJCTGbIAE7E5r29si/g+C
        2QpKAm2zHa4njNQLFNSYFmag8lg++vAekgiNacO1cgXCA5d62GUB8K76myJ7sGaB
        iWE4A6n/HjHh30ooGPSFBKQNJYXMqg1AeFXJaXPh9c6+wtUbcZQJTw9E7LUuBBxB
        iXzWfFwAyD9fKYFyouTp0NHa2Xqh3OfS+wZaJEpMm3P4rb65HCnyaXd9Em6e2xzd
        7bX/Zz0OgJKtSA59c9oxGgWbFvrcw1iygMbO2bmuuquPCQf8ZjSR8MIgrqoF0vLk
        nRRr/8Ki7fiDg58x06HqvUQU1a0bwyTWMfPgKNBpD4FhO9i47mAJmRiTqBKgw01g
        ==
X-ME-Sender: <xms:0BEpXzAG8HWw8Np3NsUL53PooIm-wx0e0FVLGIrqzyv4Hb_iTAvfNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeehgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepjeelrddukedurdeirddvudelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:0BEpX5je93gY053f01bV3XjyO4NzjKpmm_54SwjuS1IWyn0eQAF1qA>
    <xmx:0BEpX-muBi8DVqBIgohiHWxhPYT11qBnFRUR5_p2svjIF5auU3S_xg>
    <xmx:0BEpX1w7rZg270z-hSpc0T5j75KCnXzJhEZuGZUzu0knsJldMCAUsQ>
    <xmx:0BEpX9KNGg9vb3ogD7xYbehWYqqafIwFyKnee2hnyopTUwFkjYPkAw>
Received: from localhost (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02413328005E;
        Tue,  4 Aug 2020 03:44:15 -0400 (EDT)
Date:   Tue, 4 Aug 2020 10:44:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com,
        andrew@lunn.ch
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
Message-ID: <20200804074413.GA2534462@shredder>
References: <20200731084725.7804-1-popadrian1996@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731084725.7804-1-popadrian1996@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adrian, thanks again for submitting this patch. I got two comments
off-list. Sharing them here.

On Fri, Jul 31, 2020 at 11:47:25AM +0300, Adrian Pop wrote:
> +/**
> + * Print the cable assembly length, for both passive copper and active
> + * optical or electrical cables. The base length (bits 5-0) must be
> + * multiplied with the SMF length multiplier (bits 7-6) to obtain the
> + * correct value. Relevant documents:
> + * [1] CMIS Rev. 3, pag. 59, section 1.7.3.10, Table 31
> + * [2] CMIS Rev. 4, pag. 94, section 8.3.10, Table 8-19
> + */
> +static void qsfp_dd_show_cbl_asm_len(const __u8 *id)
> +{
> +	static const char *fn = "Cable assembly length";
> +	float mul = 1.0f;
> +	float val = 0.0f;
> +
> +	/* Check if max length */
> +	if (id[QSFP_DD_CBL_ASM_LEN_OFFSET] == QSFP_DD_6300M_MAX_LEN) {
> +		printf("\t%-41s : > 6.3km\n", fn);
> +		return;
> +	}
> +
> +	/* Get the multiplier from the first two bits */
> +	switch (id[QSFP_DD_CBL_ASM_LEN_OFFSET] & QSFP_DD_LEN_MUL_MASK) {
> +	case QSFP_DD_MULTIPLIER_00:
> +		mul = 0.1f;
> +		break;
> +	case QSFP_DD_MULTIPLIER_01:
> +		mul = 1.0f;
> +		break;
> +	case QSFP_DD_MULTIPLIER_10:
> +		mul = 10.0f;
> +		break;
> +	case QSFP_DD_MULTIPLIER_11:
> +		mul = 100.0f;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	/* Get base value from first 6 bits and multiply by mul */
> +	val = (id[QSFP_DD_CBL_ASM_LEN_OFFSET] & QSFP_DD_LEN_VAL_MASK);
> +	val = (float)val * mul;
> +	printf("\t%-41s : %0.2fkm\n", fn, val);

Should be:

printf("\t%-41s : %0.2fm\n", fn, val);

Since the specification says "Link length base value in meters".

Before:

        Cable assembly length                     : 0.50km

After:

        Cable assembly length                     : 0.50m

> +}

...

> diff --git a/qsfp-dd.h b/qsfp-dd.h
> new file mode 100644
> index 0000000..a7a7051
> --- /dev/null
> +++ b/qsfp-dd.h
> @@ -0,0 +1,236 @@
> +#ifndef QSFP_DD_H__
> +#define QSFP_DD_H__
> +
> +#define QSFP_DD_PAG_SIZE			0x80
> +#define QSFP_DD_EEPROM_5PAG			(0x80 * 6)
> +#define QSFP_DD_MAX_CHANNELS			0x08
> +#define QSFP_DD_MAX_DESC_SIZE			0x2A
> +#define QSFP_DD_READ_TX				0x00
> +#define QSFP_DD_READ_RX				0x01
> +
> +/* Struct for the current/power of a channel */
> +struct qsfp_dd_channel_diags {
> +	__u16 bias_cur;
> +	__u16 rx_power;
> +	__u16 tx_power;
> +};
> +
> +struct qsfp_dd_diags {
> +	/* Voltage in 0.1mV units; the first 4 elements represent
> +	 * the high/low alarm, high/low warning and the last one
> +	 * represent the current voltage of the module.
> +	 */
> +	__u16 sfp_voltage[4];
> +
> +	/**
> +	 * Temperature in 16-bit signed 1/256 Celsius; the first 4
> +	 * elements represent the high/low alarm, high/low warning
> +	 * and the last one represent the current temp of the module.
> +	 */
> +	__s16 sfp_temp[4];
> +
> +	/* Tx bias current in 2uA units */
> +	__u16 bias_cur[4];
> +
> +	/* Measured TX Power */
> +	__u16 tx_power[4];
> +
> +	/* Measured RX Power */
> +	__u16 rx_power[4];
> +
> +	/* Rx alarms and warnings */
> +	bool rxaw[QSFP_DD_MAX_CHANNELS][4];
> +
> +	/* Tx alarms and warnings */
> +	bool txaw[QSFP_DD_MAX_CHANNELS][4];
> +
> +	struct qsfp_dd_channel_diags scd[QSFP_DD_MAX_CHANNELS];
> +};
> +
> +#define HA					0
> +#define LA					1
> +#define HW					2
> +#define LW					3
> +
> +/* Identifier and revision compliance (Page 0) */
> +#define	QSFP_DD_ID_OFFSET			0x00
> +#define QSFP_DD_REV_COMPLIANCE_OFFSET		0x01
> +
> +#define QSFP_DD_MODULE_TYPE_OFFSET		0x55
> +#define QSFP_DD_MT_MMF				0x01
> +#define QSFP_DD_MT_SMF				0x02
> +
> +/* Module-Level Monitors (Page 0) */
> +#define QSFP_DD_CURR_TEMP_OFFSET		0x0E
> +#define QSFP_DD_CURR_CURR_OFFSET		0x10
> +
> +#define QSFP_DD_CTOR_OFFSET			0xCB
> +
> +/* Vendor related information (Page 0) */
> +#define QSFP_DD_VENDOR_NAME_START_OFFSET	0x81
> +#define QSFP_DD_VENDOR_NAME_END_OFFSET		0x90
> +
> +#define QSFP_DD_VENDOR_OUI_OFFSET		0x91
> +
> +#define QSFP_DD_VENDOR_PN_START_OFFSET		0x94
> +#define QSFP_DD_VENDOR_PN_END_OFFSET		0xA3
> +
> +#define QSFP_DD_VENDOR_REV_START_OFFSET		0xA4
> +#define QSFP_DD_VENDOR_REV_END_OFFSET		0xA5
> +
> +#define QSFP_DD_VENDOR_SN_START_OFFSET		0xA6
> +#define QSFP_DD_VENDOR_SN_END_OFFSET		0xB5
> +
> +#define QSFP_DD_DATE_YEAR_OFFSET		0xB6
> +#define QSFP_DD_DATE_VENDOR_LOT_OFFSET		0xBD

According to the specification (section 8.3.7), the offset is 188, so
should be 0xBC.

Before:

        Date code                                 : 200507  _

After:

        Date code                                 : 200507
