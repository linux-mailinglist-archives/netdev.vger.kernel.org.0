Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67E268F5D2
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjBHRmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjBHRmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:42:01 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC2759B75;
        Wed,  8 Feb 2023 09:39:19 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id d2so15439052pjd.5;
        Wed, 08 Feb 2023 09:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mt7da7JBKGvR4LSntTeuJe6DMplLDoGUOKCQPGZdlGg=;
        b=ivdvtHb/cAwTm1L/FgLXx31CWf0xFJ8TSbJCP6hEHaSY3PjajLWgjyGvUvqydYG87I
         uiAykkLixoQSL0btEYuBNv5LVDPcZZuo8s8WjrANmOaJfzP9Casw/5XHzI0QXhwIOWaT
         YZe+y7KUjSWrebTtgqDmnYxvALJem912BzVQTGICxSARJHNVN6DBCPFP2hZbU5QmwsXE
         W7osOlWBmJOiRDOxcirc86oHMQWX2DI96wwAl2X8CarvYY+ilKPSO6v8C/X+/W6wfvED
         petQisdbG9nV7A214s11jEOem+CgCxsx9v/LqSJDJEFvqFJaD542en1JzLCN9QUQxlhz
         GqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mt7da7JBKGvR4LSntTeuJe6DMplLDoGUOKCQPGZdlGg=;
        b=0t4bJY24zd8EcjC3XBrKpEt4W1OWYrR+FST/viXe+0BaHB6gkMnDA75i23lk6Fynv0
         e7M6vlUCnemABN1cyZEwgTkT6Qb6KpJQlU28/sc9gPeNyI8r9ckiorIMH/ZdgwF6ftOL
         FfqaK9NGwVxfTxGski7521IKaBBGmLynJDy9VDHPb3WgOy2ChbClbmW7as/neytp2OSg
         0l5Rj+DhAY3roeOQzj0Qh0+I/9k8PpslMQtWY2h7JfRI31aL/Rov+GgA2n1C3kP2l1Qx
         zTWSRJ4nO4WzUh4ymSEhuviB6cNtq7SqNqkBxK0xNq1U613w7Yio/crMxDHWXDOcyQKB
         YhCA==
X-Gm-Message-State: AO0yUKX4mRnpvnMcOoLIFzE9MgZAXY8gP5NSJcA0ED6Bj8aZvgbLqGP5
        IMEqdFUgk48fJMmr1hhPze8=
X-Google-Smtp-Source: AK7set+bsYHVWRwGHITeXLzq8iF5eFdCVYOwHB1HTun46VRr36bFwoSzBx51bhOxUjuh2JXncO2vPg==
X-Received: by 2002:a17:90b:3b8a:b0:230:86d2:5832 with SMTP id pc10-20020a17090b3b8a00b0023086d25832mr9361510pjb.2.1675877888192;
        Wed, 08 Feb 2023 09:38:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id em14-20020a17090b014e00b0023087e8adf8sm1873883pjb.21.2023.02.08.09.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 09:38:07 -0800 (PST)
Message-ID: <317ec9fc-87de-2683-dfd4-30fe94e2efd7@gmail.com>
Date:   Wed, 8 Feb 2023 09:38:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v3 3/3] net: dsa: rzn1-a5psw: add vlan support
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230208161749.331965-1-clement.leger@bootlin.com>
 <20230208161749.331965-4-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230208161749.331965-4-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 08:17, Clément Léger wrote:
> Add support for vlan operation (add, del, filtering) on the RZN1
> driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> tagged/untagged VLANs and PVID for each ports.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

This looks good to me, just a few nits/suggestions below.

> ---
>   drivers/net/dsa/rzn1_a5psw.c | 167 +++++++++++++++++++++++++++++++++++
>   drivers/net/dsa/rzn1_a5psw.h |   8 +-
>   2 files changed, 172 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 0ce3948952db..de6b18ec647d 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -583,6 +583,147 @@ static int a5psw_port_fdb_dump(struct dsa_switch *ds, int port,
>   	return ret;
>   }
>   
> +static int a5psw_port_vlan_filtering(struct dsa_switch *ds, int port,
> +				     bool vlan_filtering,
> +				     struct netlink_ext_ack *extack)
> +{
> +	u32 mask = BIT(port + A5PSW_VLAN_VERI_SHIFT) |
> +		   BIT(port + A5PSW_VLAN_DISC_SHIFT);
> +	struct a5psw *a5psw = ds->priv;
> +	u32 val = 0;
> +
> +	if (vlan_filtering)
> +		val = BIT(port + A5PSW_VLAN_VERI_SHIFT) |
> +		      BIT(port + A5PSW_VLAN_DISC_SHIFT);
> +
> +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_VERIFY, mask, val);
> +
> +	return 0;
> +}
> +
> +static int a5psw_find_vlan_entry(struct a5psw *a5psw, u16 vid)
> +{
> +	u32 vlan_res;
> +	int i;
> +
> +	/* Find vlan for this port */
> +	for (i = 0; i < A5PSW_VLAN_COUNT; i++) {
> +		vlan_res = a5psw_reg_readl(a5psw, A5PSW_VLAN_RES(i));
> +		if (FIELD_GET(A5PSW_VLAN_RES_VLANID, vlan_res) == vid)
> +			return i;
> +	}
> +
> +	return -1;
> +}
> +
> +static int a5psw_get_vlan_res_entry(struct a5psw *a5psw, u16 newvid)

The name seems a bit misleading with respect to what it does, maybe 
a5psw_new_vlan_res_entry()?

> +{
> +	u32 vlan_res;
> +	int i;
> +
> +	/* Find a free VLAN entry */
> +	for (i = 0; i < A5PSW_VLAN_COUNT; i++) {
> +		vlan_res = a5psw_reg_readl(a5psw, A5PSW_VLAN_RES(i));
> +		if (!(FIELD_GET(A5PSW_VLAN_RES_PORTMASK, vlan_res))) {
> +			vlan_res = FIELD_PREP(A5PSW_VLAN_RES_VLANID, newvid);
> +			a5psw_reg_writel(a5psw, A5PSW_VLAN_RES(i), vlan_res);
> +			return i;
> +		}
> +	}
> +
> +	return -1;
> +}
> +
> +static void a5psw_port_vlan_tagged_cfg(struct a5psw *a5psw, int vlan_res_id,

unsigned int vlan_res_id

> +				       int port, bool set)
> +{
> +	u32 mask = A5PSW_VLAN_RES_WR_PORTMASK | A5PSW_VLAN_RES_RD_TAGMASK |
> +		   BIT(port);
> +	u32 vlan_res_off = A5PSW_VLAN_RES(vlan_res_id);
> +	u32 val = A5PSW_VLAN_RES_WR_TAGMASK, reg;
> +
> +	if (set)
> +		val |= BIT(port);
> +
> +	/* Toggle tag mask read */
> +	a5psw_reg_writel(a5psw, vlan_res_off, A5PSW_VLAN_RES_RD_TAGMASK);
> +	reg = a5psw_reg_readl(a5psw, vlan_res_off);
> +	a5psw_reg_writel(a5psw, vlan_res_off, A5PSW_VLAN_RES_RD_TAGMASK);
> +
> +	reg &= ~mask;
> +	reg |= val;
> +	a5psw_reg_writel(a5psw, vlan_res_off, reg);
> +}
> +
> +static void a5psw_port_vlan_cfg(struct a5psw *a5psw, int vlan_res_id, int port,

Likewise

> +				bool set)
> +{
> +	u32 mask = A5PSW_VLAN_RES_WR_TAGMASK | BIT(port);
> +	u32 reg = A5PSW_VLAN_RES_WR_PORTMASK;
> +
> +	if (set)
> +		reg |= BIT(port);
> +
> +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_RES(vlan_res_id), mask, reg);
> +}
> +
> +static int a5psw_port_vlan_add(struct dsa_switch *ds, int port,
> +			       const struct switchdev_obj_port_vlan *vlan,
> +			       struct netlink_ext_ack *extack)
> +{
> +	bool tagged = !(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
> +	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> +	struct a5psw *a5psw = ds->priv;
> +	u16 vid = vlan->vid;
> +	int vlan_res_id;
> +
> +	dev_dbg(a5psw->dev, "Add VLAN %d on port %d, %s, %s\n",
> +		vid, port, tagged ? "tagged" : "untagged",
> +		pvid ? "PVID" : "no PVID");
> +
> +	vlan_res_id = a5psw_find_vlan_entry(a5psw, vid);
> +	if (vlan_res_id < 0) {
> +		vlan_res_id = a5psw_get_vlan_res_entry(a5psw, vid);
> +		if (vlan_res_id < 0)
> +			return -EINVAL;

return -ENOSPC?

> +	}
> +
> +	a5psw_port_vlan_cfg(a5psw, vlan_res_id, port, true);
> +	if (tagged)
> +		a5psw_port_vlan_tagged_cfg(a5psw, vlan_res_id, port, true);
> +
> +	if (pvid) {
> +		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port),
> +			      BIT(port));
> +		a5psw_reg_writel(a5psw, A5PSW_SYSTEM_TAGINFO(port), vid);
> +	}
> +
> +	return 0;
> +}
> +
> +static int a5psw_port_vlan_del(struct dsa_switch *ds, int port,
> +			       const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	u16 vid = vlan->vid;
> +	int vlan_res_id;
> +
> +	dev_dbg(a5psw->dev, "Removing VLAN %d on port %d\n", vid, port);
> +
> +	vlan_res_id = a5psw_find_vlan_entry(a5psw, vid);
> +	if (vlan_res_id < 0)
> +		return -EINVAL;

-EINVAL looks legit here

> +
> +	a5psw_port_vlan_cfg(a5psw, vlan_res_id, port, false);
> +	a5psw_port_vlan_tagged_cfg(a5psw, vlan_res_id, port, false);
> +
> +	/* Disable PVID if the vid is matching the port one */
> +	if (vid == a5psw_reg_readl(a5psw, A5PSW_SYSTEM_TAGINFO(port)))
> +		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port), 0);
> +
> +	return 0;
> +}
> +
>   static u64 a5psw_read_stat(struct a5psw *a5psw, u32 offset, int port)
>   {
>   	u32 reg_lo, reg_hi;
> @@ -700,6 +841,27 @@ static void a5psw_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
>   	ctrl_stats->MACControlFramesReceived = stat;
>   }
>   
> +static void a5psw_vlan_setup(struct a5psw *a5psw, int port)
> +{
> +	u32 reg;
> +
> +	/* Enable TAG always mode for the port, this is actually controlled
> +	 * by VLAN_IN_MODE_ENA field which will be used for PVID insertion
> +	 */
> +	reg = A5PSW_VLAN_IN_MODE_TAG_ALWAYS;
> +	reg <<= A5PSW_VLAN_IN_MODE_PORT_SHIFT(port);
> +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE, A5PSW_VLAN_IN_MODE_PORT(port),
> +		      reg);

If we always enable VLAN mode, which VLAN ID do switch ports not part of 
a VLAN aware bridge get classified into?

> +
> +	/* Set transparent mode for output frame manipulation, this will depend
> +	 * on the VLAN_RES configuration mode
> +	 */
> +	reg = A5PSW_VLAN_OUT_MODE_TRANSPARENT;
> +	reg <<= A5PSW_VLAN_OUT_MODE_PORT_SHIFT(port);
> +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_OUT_MODE,
> +		      A5PSW_VLAN_OUT_MODE_PORT(port), reg);

Sort of a follow-on to the previous question, what does transparent 
mean? Does that mean the frames ingressing with a certain VLAN tag will 
egress with the same VLAN tag in the absence of a VLAN configuration 
rewriting the tag?

> +}
> +
>   static int a5psw_setup(struct dsa_switch *ds)
>   {
>   	struct a5psw *a5psw = ds->priv;
> @@ -772,6 +934,8 @@ static int a5psw_setup(struct dsa_switch *ds)
>   		/* Enable management forward only for user ports */
>   		if (dsa_port_is_user(dp))
>   			a5psw_port_mgmtfwd_set(a5psw, port, true);
> +
> +		a5psw_vlan_setup(a5psw, port);
>   	}
>   
>   	return 0;
> @@ -801,6 +965,9 @@ static const struct dsa_switch_ops a5psw_switch_ops = {
>   	.port_bridge_flags = a5psw_port_bridge_flags,
>   	.port_stp_state_set = a5psw_port_stp_state_set,
>   	.port_fast_age = a5psw_port_fast_age,
> +	.port_vlan_filtering = a5psw_port_vlan_filtering,
> +	.port_vlan_add = a5psw_port_vlan_add,
> +	.port_vlan_del = a5psw_port_vlan_del,
>   	.port_fdb_add = a5psw_port_fdb_add,
>   	.port_fdb_del = a5psw_port_fdb_del,
>   	.port_fdb_dump = a5psw_port_fdb_dump,
> diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
> index c67abd49c013..2bad2e3edc2a 100644
> --- a/drivers/net/dsa/rzn1_a5psw.h
> +++ b/drivers/net/dsa/rzn1_a5psw.h
> @@ -50,7 +50,9 @@
>   #define A5PSW_VLAN_IN_MODE_TAG_ALWAYS		0x2
>   
>   #define A5PSW_VLAN_OUT_MODE		0x2C
> -#define A5PSW_VLAN_OUT_MODE_PORT(port)	(GENMASK(1, 0) << ((port) * 2))
> +#define A5PSW_VLAN_OUT_MODE_PORT_SHIFT(port)	((port) * 2)
> +#define A5PSW_VLAN_OUT_MODE_PORT(port)	(GENMASK(1, 0) << \
> +					A5PSW_VLAN_OUT_MODE_PORT_SHIFT(port))
>   #define A5PSW_VLAN_OUT_MODE_DIS		0x0
>   #define A5PSW_VLAN_OUT_MODE_STRIP	0x1
>   #define A5PSW_VLAN_OUT_MODE_TAG_THROUGH	0x2
> @@ -59,7 +61,7 @@
>   #define A5PSW_VLAN_IN_MODE_ENA		0x30
>   #define A5PSW_VLAN_TAG_ID		0x34
>   
> -#define A5PSW_SYSTEM_TAGINFO(port)	(0x200 + A5PSW_PORT_OFFSET(port))
> +#define A5PSW_SYSTEM_TAGINFO(port)	(0x200 + 4 * (port))
>   
>   #define A5PSW_AUTH_PORT(port)		(0x240 + 4 * (port))
>   #define A5PSW_AUTH_PORT_AUTHORIZED	BIT(0)
> @@ -68,7 +70,7 @@
>   #define A5PSW_VLAN_RES_WR_PORTMASK	BIT(30)
>   #define A5PSW_VLAN_RES_WR_TAGMASK	BIT(29)
>   #define A5PSW_VLAN_RES_RD_TAGMASK	BIT(28)
> -#define A5PSW_VLAN_RES_ID		GENMASK(16, 5)
> +#define A5PSW_VLAN_RES_VLANID		GENMASK(16, 5)
>   #define A5PSW_VLAN_RES_PORTMASK		GENMASK(4, 0)
>   
>   #define A5PSW_RXMATCH_CONFIG(port)	(0x3e80 + 4 * (port))

-- 
Florian

