Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F3D6192BF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 09:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiKDIao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 04:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKDIam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 04:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3102C275E2;
        Fri,  4 Nov 2022 01:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77ADB620E5;
        Fri,  4 Nov 2022 08:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAB3C433D6;
        Fri,  4 Nov 2022 08:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667550639;
        bh=WIUTKBxwy/bzKaF26xR92fZ5f2WaPf18vEmhzh/HNwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q9QLBS1BDlwzJjibwmEleUhyv//E8vdFqEwgmHEBt/qR607nFIbmjT0p6XmNj31fY
         t45XFoJbRYUsO1prb+4UPkl8+ej0d1mN2RVb7334o4cw0S80zxPTsLC4Gs993CY5kg
         itS5HkS6RHDzkF2EXu8w7spxZkVN3hUBMOugZb3+GBV5kMMoM9DQlfqczLT2TKwrof
         LXHhvR9/IXfQfQKb4udvWQyi2ZNM83FlhrcAvb5sX9r5qunj0tbqTI8FzgsjhDjPBw
         eN6SXq0Y3keBRVwT/CXhJ6OIXhCuwcfUdRgizXg4a2NsKjyBwlugl8bdo10hnaA+sy
         IEPCFXg1bZM6g==
Date:   Fri, 4 Nov 2022 09:30:36 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Subject: Re: [PATCH v3 net-next 3/8] net: ethernet: mtk_wed: introduce wed
 mcu support
Message-ID: <Y2TNrF610zJUt4vr@lore-desk>
References: <cover.1667466887.git.lorenzo@kernel.org>
 <01c82e3783373e04b609d60075ef7ecf71d0d24d.1667466887.git.lorenzo@kernel.org>
 <Y2R6A68BY6GuMt+f@makrotopia.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VKqrjdcuJRZc+ap5"
Content-Disposition: inline
In-Reply-To: <Y2R6A68BY6GuMt+f@makrotopia.org>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--VKqrjdcuJRZc+ap5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,

Hi Daniel,

>=20
> I found a potential typo in the print output during probe.
> See below.
>=20
> On Thu, Nov 03, 2022 at 10:28:02AM +0100, Lorenzo Bianconi wrote:
> > From: Sujuan Chen <sujuan.chen@mediatek.com>
> >=20
> > Introduce WED mcu support used to configure WED WO chip.
> > This is a preliminary patch in order to add RX Wireless
> > Ethernet Dispatch available on MT7986 SoC.
> >=20
> > Tested-by: Daniel Golle <daniel@makrotopia.org>
> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > ---
> >  drivers/net/ethernet/mediatek/Makefile       |   2 +-
> >  drivers/net/ethernet/mediatek/mtk_wed_mcu.c  | 364 +++++++++++++++++++
> >  drivers/net/ethernet/mediatek/mtk_wed_regs.h |   1 +
> >  drivers/net/ethernet/mediatek/mtk_wed_wo.h   | 152 ++++++++
> >  include/linux/soc/mediatek/mtk_wed.h         |  29 ++
> >  5 files changed, 547 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> >  create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.h
> >=20
> > diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ether=
net/mediatek/Makefile
> > index 45ba0970504a..d4bdefa77159 100644
> > --- a/drivers/net/ethernet/mediatek/Makefile
> > +++ b/drivers/net/ethernet/mediatek/Makefile
> > @@ -5,7 +5,7 @@
> > =20
> >  obj-$(CONFIG_NET_MEDIATEK_SOC) +=3D mtk_eth.o
> >  mtk_eth-y :=3D mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o mtk_ppe.o mtk_=
ppe_debugfs.o mtk_ppe_offload.o
> > -mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) +=3D mtk_wed.o
> > +mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) +=3D mtk_wed.o mtk_wed_mcu.o
> >  ifdef CONFIG_DEBUG_FS
> >  mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) +=3D mtk_wed_debugfs.o
> >  endif
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/=
ethernet/mediatek/mtk_wed_mcu.c
> > new file mode 100644
> > index 000000000000..20987eecfb52
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > @@ -0,0 +1,364 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (C) 2022 MediaTek Inc.
> > + *
> > + * Author: Lorenzo Bianconi <lorenzo@kernel.org>
> > + *	   Sujuan Chen <sujuan.chen@mediatek.com>
> > + */
> > +
> > +#include <linux/firmware.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_reserved_mem.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/soc/mediatek/mtk_wed.h>
> > +
> > +#include "mtk_wed_regs.h"
> > +#include "mtk_wed_wo.h"
> > +#include "mtk_wed.h"
> > +
> > +static u32 wo_r32(struct mtk_wed_wo *wo, u32 reg)
> > +{
> > +	u32 val;
> > +
> > +	if (regmap_read(wo->boot, reg, &val))
> > +		val =3D ~0;
> > +
> > +	return val;
> > +}
> > +
> > +static void wo_w32(struct mtk_wed_wo *wo, u32 reg, u32 val)
> > +{
> > +	regmap_write(wo->boot, reg, val);
> > +}
> > +
> > +static struct sk_buff *
> > +mtk_wed_mcu_msg_alloc(const void *data, int data_len)
> > +{
> > +	int length =3D sizeof(struct mtk_wed_mcu_hdr) + data_len;
> > +	struct sk_buff *skb;
> > +
> > +	skb =3D alloc_skb(length, GFP_KERNEL);
> > +	if (!skb)
> > +		return NULL;
> > +
> > +	memset(skb->head, 0, length);
> > +	skb_reserve(skb, sizeof(struct mtk_wed_mcu_hdr));
> > +	if (data && data_len)
> > +		skb_put_data(skb, data, data_len);
> > +
> > +	return skb;
> > +}
> > +
> > +static struct sk_buff *
> > +mtk_wed_mcu_get_response(struct mtk_wed_wo *wo, unsigned long expires)
> > +{
> > +	if (!time_is_after_jiffies(expires))
> > +		return NULL;
> > +
> > +	wait_event_timeout(wo->mcu.wait, !skb_queue_empty(&wo->mcu.res_q),
> > +			   expires - jiffies);
> > +	return skb_dequeue(&wo->mcu.res_q);
> > +}
> > +
> > +void mtk_wed_mcu_rx_event(struct mtk_wed_wo *wo, struct sk_buff *skb)
> > +{
> > +	skb_queue_tail(&wo->mcu.res_q, skb);
> > +	wake_up(&wo->mcu.wait);
> > +}
> > +
> > +void mtk_wed_mcu_rx_unsolicited_event(struct mtk_wed_wo *wo,
> > +				      struct sk_buff *skb)
> > +{
> > +	struct mtk_wed_mcu_hdr *hdr =3D (struct mtk_wed_mcu_hdr *)skb->data;
> > +
> > +	switch (hdr->cmd) {
> > +	case MTK_WED_WO_EVT_LOG_DUMP: {
> > +		const char *msg =3D (const char *)(skb->data + sizeof(*hdr));
> > +
> > +		dev_notice(wo->hw->dev, "%s\n", msg);
> > +		break;
> > +	}
> > +	case MTK_WED_WO_EVT_PROFILING: {
> > +		struct mtk_wed_wo_log_info *info;
> > +		u32 count =3D (skb->len - sizeof(*hdr)) / sizeof(*info);
> > +		int i;
> > +
> > +		info =3D (struct mtk_wed_wo_log_info *)(skb->data + sizeof(*hdr));
> > +		for (i =3D 0 ; i < count ; i++)
> > +			dev_notice(wo->hw->dev,
> > +				   "SN:%u latency: total=3D%u, rro:%u, mod:%u\n",
> > +				   le32_to_cpu(info[i].sn),
> > +				   le32_to_cpu(info[i].total),
> > +				   le32_to_cpu(info[i].rro),
> > +				   le32_to_cpu(info[i].mod));
> > +		break;
> > +	}
> > +	case MTK_WED_WO_EVT_RXCNT_INFO:
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	dev_kfree_skb(skb);
> > +}
> > +
> > +static int
> > +mtk_wed_mcu_skb_send_msg(struct mtk_wed_wo *wo, struct sk_buff *skb,
> > +			 int id, int cmd, u16 *wait_seq, bool wait_resp)
> > +{
> > +	struct mtk_wed_mcu_hdr *hdr;
> > +
> > +	/* TODO: make it dynamic based on cmd */
> > +	wo->mcu.timeout =3D 20 * HZ;
> > +
> > +	hdr =3D (struct mtk_wed_mcu_hdr *)skb_push(skb, sizeof(*hdr));
> > +	hdr->cmd =3D cmd;
> > +	hdr->length =3D cpu_to_le16(skb->len);
> > +
> > +	if (wait_resp && wait_seq) {
> > +		u16 seq =3D ++wo->mcu.seq;
> > +
> > +		if (!seq)
> > +			seq =3D ++wo->mcu.seq;
> > +		*wait_seq =3D seq;
> > +
> > +		hdr->flag |=3D cpu_to_le16(MTK_WED_WARP_CMD_FLAG_NEED_RSP);
> > +		hdr->seq =3D cpu_to_le16(seq);
> > +	}
> > +	if (id =3D=3D MTK_WED_MODULE_ID_WO)
> > +		hdr->flag |=3D cpu_to_le16(MTK_WED_WARP_CMD_FLAG_FROM_TO_WO);
> > +
> > +	dev_kfree_skb(skb);
> > +	return 0;
> > +}
> > +
> > +static int
> > +mtk_wed_mcu_parse_response(struct mtk_wed_wo *wo, struct sk_buff *skb,
> > +			   int cmd, int seq)
> > +{
> > +	struct mtk_wed_mcu_hdr *hdr;
> > +
> > +	if (!skb) {
> > +		dev_err(wo->hw->dev, "Message %08x (seq %d) timeout\n",
> > +			cmd, seq);
> > +		return -ETIMEDOUT;
> > +	}
> > +
> > +	hdr =3D (struct mtk_wed_mcu_hdr *)skb->data;
> > +	if (le16_to_cpu(hdr->seq) !=3D seq)
> > +		return -EAGAIN;
> > +
> > +	skb_pull(skb, sizeof(*hdr));
> > +	switch (cmd) {
> > +	case MTK_WED_WO_CMD_RXCNT_INFO:
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
> > +			 const void *data, int len, bool wait_resp)
> > +{
> > +	unsigned long expires;
> > +	struct sk_buff *skb;
> > +	u16 seq;
> > +	int ret;
> > +
> > +	skb =3D mtk_wed_mcu_msg_alloc(data, len);
> > +	if (!skb)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&wo->mcu.mutex);
> > +
> > +	ret =3D mtk_wed_mcu_skb_send_msg(wo, skb, id, cmd, &seq, wait_resp);
> > +	if (ret || !wait_resp)
> > +		goto unlock;
> > +
> > +	expires =3D jiffies + wo->mcu.timeout;
> > +	do {
> > +		skb =3D mtk_wed_mcu_get_response(wo, expires);
> > +		ret =3D mtk_wed_mcu_parse_response(wo, skb, cmd, seq);
> > +		dev_kfree_skb(skb);
> > +	} while (ret =3D=3D -EAGAIN);
> > +
> > +unlock:
> > +	mutex_unlock(&wo->mcu.mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int
> > +mtk_wed_get_memory_region(struct mtk_wed_wo *wo,
> > +			  struct mtk_wed_wo_memory_region *region)
> > +{
> > +	struct reserved_mem *rmem;
> > +	struct device_node *np;
> > +	int index;
> > +
> > +	index =3D of_property_match_string(wo->hw->node, "memory-region-names=
",
> > +					 region->name);
> > +	if (index < 0)
> > +		return index;
> > +
> > +	np =3D of_parse_phandle(wo->hw->node, "memory-region", index);
> > +	if (!np)
> > +		return -ENODEV;
> > +
> > +	rmem =3D of_reserved_mem_lookup(np);
> > +	of_node_put(np);
> > +
> > +	if (!rmem)
> > +		return -ENODEV;
> > +
> > +	region->phy_addr =3D rmem->base;
> > +	region->size =3D rmem->size;
> > +	region->addr =3D devm_ioremap(wo->hw->dev, region->phy_addr, region->=
size);
> > +	if (!region->addr)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +mtk_wed_mcu_run_firmware(struct mtk_wed_wo *wo, const struct firmware =
*fw,
> > +			 struct mtk_wed_wo_memory_region *region)
> > +{
> > +	const u8 *first_region_ptr, *region_ptr, *trailer_ptr, *ptr =3D fw->d=
ata;
> > +	const struct mtk_wed_fw_trailer *trailer;
> > +	const struct mtk_wed_fw_region *fw_region;
> > +
> > +	trailer_ptr =3D fw->data + fw->size - sizeof(*trailer);
> > +	trailer =3D (const struct mtk_wed_fw_trailer *)trailer_ptr;
> > +	region_ptr =3D trailer_ptr - trailer->num_region * sizeof(*fw_region);
> > +	first_region_ptr =3D region_ptr;
> > +
> > +	while (region_ptr < trailer_ptr) {
> > +		u32 length;
> > +
> > +		fw_region =3D (const struct mtk_wed_fw_region *)region_ptr;
> > +		length =3D le32_to_cpu(fw_region->len);
> > +
> > +		if (region->phy_addr !=3D le32_to_cpu(fw_region->addr))
> > +			goto next;
> > +
> > +		if (region->size < length)
> > +			goto next;
> > +
> > +		if (first_region_ptr < ptr + length)
> > +			goto next;
> > +
> > +		if (region->shared && region->consumed)
> > +			return 0;
> > +
> > +		if (!region->shared || !region->consumed) {
> > +			memcpy_toio(region->addr, ptr, length);
> > +			region->consumed =3D true;
> > +			return 0;
> > +		}
> > +next:
> > +		region_ptr +=3D sizeof(*fw_region);
> > +		ptr +=3D length;
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static int
> > +mtk_wed_mcu_load_firmware(struct mtk_wed_wo *wo)
> > +{
> > +	static struct mtk_wed_wo_memory_region mem_region[] =3D {
> > +		[MTK_WED_WO_REGION_EMI] =3D {
> > +			.name =3D "wo-emi",
> > +		},
> > +		[MTK_WED_WO_REGION_ILM] =3D {
> > +			.name =3D "wo-ilm",
> > +		},
> > +		[MTK_WED_WO_REGION_DATA] =3D {
> > +			.name =3D "wo-data",
> > +			.shared =3D true,
> > +		},
> > +	};
> > +	const struct mtk_wed_fw_trailer *trailer;
> > +	const struct firmware *fw;
> > +	const char *fw_name;
> > +	u32 val, boot_cr;
> > +	int ret, i;
> > +
> > +	/* load firmware region metadata */
> > +	for (i =3D 0; i < ARRAY_SIZE(mem_region); i++) {
> > +		ret =3D mtk_wed_get_memory_region(wo, &mem_region[i]);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	wo->boot =3D syscon_regmap_lookup_by_phandle(wo->hw->node,
> > +						   "mediatek,wo-boot");
> > +	if (IS_ERR_OR_NULL(wo->boot))
> > +		return PTR_ERR(wo->boot);
> > +
> > +	/* set dummy cr */
> > +	wed_w32(wo->hw->wed_dev, MTK_WED_SCR0 + 4 * MTK_WED_DUMMY_CR_FWDL,
> > +		wo->hw->index + 1);
> > +
> > +	/* load firmware */
> > +	fw_name =3D wo->hw->index ? MT7986_FIRMWARE_WO1 : MT7986_FIRMWARE_WO0;
> > +	ret =3D request_firmware(&fw, fw_name, wo->hw->dev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	trailer =3D (void *)(fw->data + fw->size -
> > +			   sizeof(struct mtk_wed_fw_trailer));
> > +	dev_info(wo->hw->dev,
> > +		 "MTK WED WO Firmware Version: %.10s, Build Time: %.15s\n",
> > +		 trailer->fw_ver, trailer->build_date);
> > +	dev_info(wo->hw->dev, "MTK WED WO Chid ID %02x Region %d\n",
>=20
> -Chid
> +Chip
> ?

ack, I will fix it.

Regards,
Lorenzo

>=20
>=20
> > +		 trailer->chip_id, trailer->num_region);
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(mem_region); i++) {
> > +		ret =3D mtk_wed_mcu_run_firmware(wo, fw, &mem_region[i]);
> > +		if (ret)
> > +			goto out;
> > +	}
> > +
> > +	/* set the start address */
> > +	boot_cr =3D wo->hw->index ? MTK_WO_MCU_CFG_LS_WA_BOOT_ADDR_ADDR
> > +				: MTK_WO_MCU_CFG_LS_WM_BOOT_ADDR_ADDR;
> > +	wo_w32(wo, boot_cr, mem_region[MTK_WED_WO_REGION_EMI].phy_addr >> 16);
> > +	/* wo firmware reset */
> > +	wo_w32(wo, MTK_WO_MCU_CFG_LS_WF_MCCR_CLR_ADDR, 0xc00);
> > +
> > +	val =3D wo_r32(wo, MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR);
> > +	val |=3D wo->hw->index ? MTK_WO_MCU_CFG_LS_WF_WM_WA_WA_CPU_RSTB_MASK
> > +			     : MTK_WO_MCU_CFG_LS_WF_WM_WA_WM_CPU_RSTB_MASK;
> > +	wo_w32(wo, MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR, val);
> > +out:
> > +	release_firmware(fw);
> > +
> > +	return ret;
> > +}
> > +
> > +int mtk_wed_mcu_init(struct mtk_wed_wo *wo)
> > +{
> > +	u32 val;
> > +	int ret;
> > +
> > +	skb_queue_head_init(&wo->mcu.res_q);
> > +	init_waitqueue_head(&wo->mcu.wait);
> > +	mutex_init(&wo->mcu.mutex);
> > +
> > +	ret =3D mtk_wed_mcu_load_firmware(wo);
> > +	if (ret)
> > +		return ret;
> > +
> > +	do {
> > +		/* get dummy cr */
> > +		val =3D wed_r32(wo->hw->wed_dev,
> > +			      MTK_WED_SCR0 + 4 * MTK_WED_DUMMY_CR_FWDL);
> > +	} while (val && !time_after(jiffies, jiffies + MTK_FW_DL_TIMEOUT));
> > +
> > +	return val ? -EBUSY : 0;
> > +}
> > +
> > +MODULE_FIRMWARE(MT7986_FIRMWARE_WO0);
> > +MODULE_FIRMWARE(MT7986_FIRMWARE_WO1);
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net=
/ethernet/mediatek/mtk_wed_regs.h
> > index e270fb336143..c940b3bb215b 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
> > @@ -152,6 +152,7 @@ struct mtk_wdma_desc {
> > =20
> >  #define MTK_WED_RING_RX(_n)				(0x400 + (_n) * 0x10)
> > =20
> > +#define MTK_WED_SCR0					0x3c0
> >  #define MTK_WED_WPDMA_INT_TRIGGER			0x504
> >  #define MTK_WED_WPDMA_INT_TRIGGER_RX_DONE		BIT(1)
> >  #define MTK_WED_WPDMA_INT_TRIGGER_TX_DONE		GENMASK(5, 4)
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/e=
thernet/mediatek/mtk_wed_wo.h
> > new file mode 100644
> > index 000000000000..2ef3ccdec5bf
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
> > @@ -0,0 +1,152 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/* Copyright (C) 2022 Lorenzo Bianconi <lorenzo@kernel.org>  */
> > +
> > +#ifndef __MTK_WED_WO_H
> > +#define __MTK_WED_WO_H
> > +
> > +#include <linux/skbuff.h>
> > +#include <linux/netdevice.h>
> > +
> > +struct mtk_wed_hw;
> > +
> > +struct mtk_wed_mcu_hdr {
> > +	/* DW0 */
> > +	u8 version;
> > +	u8 cmd;
> > +	__le16 length;
> > +
> > +	/* DW1 */
> > +	__le16 seq;
> > +	__le16 flag;
> > +
> > +	/* DW2 */
> > +	__le32 status;
> > +
> > +	/* DW3 */
> > +	u8 rsv[20];
> > +};
> > +
> > +struct mtk_wed_wo_log_info {
> > +	__le32 sn;
> > +	__le32 total;
> > +	__le32 rro;
> > +	__le32 mod;
> > +};
> > +
> > +enum mtk_wed_wo_event {
> > +	MTK_WED_WO_EVT_LOG_DUMP		=3D 0x1,
> > +	MTK_WED_WO_EVT_PROFILING	=3D 0x2,
> > +	MTK_WED_WO_EVT_RXCNT_INFO	=3D 0x3,
> > +};
> > +
> > +#define MTK_WED_MODULE_ID_WO		1
> > +#define MTK_FW_DL_TIMEOUT		(4 * HZ)
> > +#define MTK_WOCPU_TIMEOUT		(2 * HZ)
> > +
> > +enum {
> > +	MTK_WED_WARP_CMD_FLAG_RSP		=3D BIT(0),
> > +	MTK_WED_WARP_CMD_FLAG_NEED_RSP		=3D BIT(1),
> > +	MTK_WED_WARP_CMD_FLAG_FROM_TO_WO	=3D BIT(2),
> > +};
> > +
> > +enum {
> > +	MTK_WED_WO_REGION_EMI,
> > +	MTK_WED_WO_REGION_ILM,
> > +	MTK_WED_WO_REGION_DATA,
> > +	__MTK_WED_WO_REGION_MAX,
> > +};
> > +
> > +enum mtk_wed_dummy_cr_idx {
> > +	MTK_WED_DUMMY_CR_FWDL,
> > +	MTK_WED_DUMMY_CR_WO_STATUS,
> > +};
> > +
> > +#define MT7986_FIRMWARE_WO0	"mediatek/mt7986_wo_0.bin"
> > +#define MT7986_FIRMWARE_WO1	"mediatek/mt7986_wo_1.bin"
> > +
> > +#define MTK_WO_MCU_CFG_LS_BASE				0 /* XXX: 0x15194000 */
> > +#define MTK_WO_MCU_CFG_LS_HW_VER_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x00=
0)
> > +#define MTK_WO_MCU_CFG_LS_FW_VER_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x00=
4)
> > +#define MTK_WO_MCU_CFG_LS_CFG_DBG1_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x=
00c)
> > +#define MTK_WO_MCU_CFG_LS_CFG_DBG2_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x=
010)
> > +#define MTK_WO_MCU_CFG_LS_WF_MCCR_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x0=
14)
> > +#define MTK_WO_MCU_CFG_LS_WF_MCCR_SET_ADDR		(MTK_WO_MCU_CFG_LS_BASE + =
0x018)
> > +#define MTK_WO_MCU_CFG_LS_WF_MCCR_CLR_ADDR		(MTK_WO_MCU_CFG_LS_BASE + =
0x01c)
> > +#define MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR		(MTK_WO_MCU_CFG_LS_BA=
SE + 0x050)
> > +#define MTK_WO_MCU_CFG_LS_WM_BOOT_ADDR_ADDR		(MTK_WO_MCU_CFG_LS_BASE +=
 0x060)
> > +#define MTK_WO_MCU_CFG_LS_WA_BOOT_ADDR_ADDR		(MTK_WO_MCU_CFG_LS_BASE +=
 0x064)
> > +
> > +#define MTK_WO_MCU_CFG_LS_WF_WM_WA_WM_CPU_RSTB_MASK	BIT(5)
> > +#define MTK_WO_MCU_CFG_LS_WF_WM_WA_WA_CPU_RSTB_MASK	BIT(0)
> > +
> > +struct mtk_wed_wo_memory_region {
> > +	const char *name;
> > +	void __iomem *addr;
> > +	phys_addr_t phy_addr;
> > +	u32 size;
> > +	bool shared:1;
> > +	bool consumed:1;
> > +};
> > +
> > +struct mtk_wed_fw_region {
> > +	__le32 decomp_crc;
> > +	__le32 decomp_len;
> > +	__le32 decomp_blk_sz;
> > +	u8 rsv0[4];
> > +	__le32 addr;
> > +	__le32 len;
> > +	u8 feature_set;
> > +	u8 rsv1[15];
> > +} __packed;
> > +
> > +struct mtk_wed_fw_trailer {
> > +	u8 chip_id;
> > +	u8 eco_code;
> > +	u8 num_region;
> > +	u8 format_ver;
> > +	u8 format_flag;
> > +	u8 rsv[2];
> > +	char fw_ver[10];
> > +	char build_date[15];
> > +	u32 crc;
> > +};
> > +
> > +struct mtk_wed_wo {
> > +	struct mtk_wed_hw *hw;
> > +	struct regmap *boot;
> > +
> > +	struct {
> > +		struct mutex mutex;
> > +		int timeout;
> > +		u16 seq;
> > +
> > +		struct sk_buff_head res_q;
> > +		wait_queue_head_t wait;
> > +	} mcu;
> > +};
> > +
> > +static inline int
> > +mtk_wed_mcu_check_msg(struct mtk_wed_wo *wo, struct sk_buff *skb)
> > +{
> > +	struct mtk_wed_mcu_hdr *hdr =3D (struct mtk_wed_mcu_hdr *)skb->data;
> > +
> > +	if (hdr->version)
> > +		return -EINVAL;
> > +
> > +	if (skb->len < sizeof(*hdr))
> > +		return -EINVAL;
> > +
> > +	if (skb->len !=3D le16_to_cpu(hdr->length))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +void mtk_wed_mcu_rx_event(struct mtk_wed_wo *wo, struct sk_buff *skb);
> > +void mtk_wed_mcu_rx_unsolicited_event(struct mtk_wed_wo *wo,
> > +				      struct sk_buff *skb);
> > +int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
> > +			 const void *data, int len, bool wait_resp);
> > +int mtk_wed_mcu_init(struct mtk_wed_wo *wo);
> > +
> > +#endif /* __MTK_WED_WO_H */
> > diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/m=
ediatek/mtk_wed.h
> > index 4450c8b7a1cb..2cc2f1e43ba9 100644
> > --- a/include/linux/soc/mediatek/mtk_wed.h
> > +++ b/include/linux/soc/mediatek/mtk_wed.h
> > @@ -11,6 +11,35 @@
> >  struct mtk_wed_hw;
> >  struct mtk_wdma_desc;
> > =20
> > +enum mtk_wed_wo_cmd {
> > +	MTK_WED_WO_CMD_WED_CFG,
> > +	MTK_WED_WO_CMD_WED_RX_STAT,
> > +	MTK_WED_WO_CMD_RRO_SER,
> > +	MTK_WED_WO_CMD_DBG_INFO,
> > +	MTK_WED_WO_CMD_DEV_INFO,
> > +	MTK_WED_WO_CMD_BSS_INFO,
> > +	MTK_WED_WO_CMD_STA_REC,
> > +	MTK_WED_WO_CMD_DEV_INFO_DUMP,
> > +	MTK_WED_WO_CMD_BSS_INFO_DUMP,
> > +	MTK_WED_WO_CMD_STA_REC_DUMP,
> > +	MTK_WED_WO_CMD_BA_INFO_DUMP,
> > +	MTK_WED_WO_CMD_FBCMD_Q_DUMP,
> > +	MTK_WED_WO_CMD_FW_LOG_CTRL,
> > +	MTK_WED_WO_CMD_LOG_FLUSH,
> > +	MTK_WED_WO_CMD_CHANGE_STATE,
> > +	MTK_WED_WO_CMD_CPU_STATS_ENABLE,
> > +	MTK_WED_WO_CMD_CPU_STATS_DUMP,
> > +	MTK_WED_WO_CMD_EXCEPTION_INIT,
> > +	MTK_WED_WO_CMD_PROF_CTRL,
> > +	MTK_WED_WO_CMD_STA_BA_DUMP,
> > +	MTK_WED_WO_CMD_BA_CTRL_DUMP,
> > +	MTK_WED_WO_CMD_RXCNT_CTRL,
> > +	MTK_WED_WO_CMD_RXCNT_INFO,
> > +	MTK_WED_WO_CMD_SET_CAP,
> > +	MTK_WED_WO_CMD_CCIF_RING_DUMP,
> > +	MTK_WED_WO_CMD_WED_END
> > +};
> > +
> >  enum mtk_wed_bus_tye {
> >  	MTK_WED_BUS_PCIE,
> >  	MTK_WED_BUS_AXI,
> > --=20
> > 2.38.1
> >=20
> >=20

--VKqrjdcuJRZc+ap5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY2TNrAAKCRA6cBh0uS2t
rBmzAP0Rwq2n8F4Bnoh5jOaoXhZGRo9bD9JsepZRBpC+wyefzQD+JM71oiwGJ3Ne
+IoIUY21ljdFS7bzKvt8kLxL/crihwU=
=bEN6
-----END PGP SIGNATURE-----

--VKqrjdcuJRZc+ap5--
