Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA3E17A066
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgCEHJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:09:29 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:17365 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCEHJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:09:28 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: wEXL+dIDuMVObvrimLl4TzKNRkFt46yiD+yKBoA32XQ5mmtYOerMBstmO6jwIHrQTxBO+AbSGm
 WOLm3bEmSc/c1x20b9x/HurJLOibl6VBm0a1Hm7i++dIVW/DQ34qstUYW3j2s7zMoJJXU8Jctt
 PWzGCs80bL6mCVNe5yFZgf1UcW1ygvNgFrq3z1UbgdCjFQYT55PXQgfqZhJLYuHz9BkkPblDBw
 Qbok8tK0g7gwZkwbLIIetByV3sKI36jPgoHWjXOoLxeRBFoumwIra6CezDZwqkzJTjp6UCY9/p
 GZw=
X-IronPort-AV: E=Sophos;i="5.70,517,1574146800"; 
   d="scan'208";a="66192661"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Mar 2020 00:09:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Mar 2020 00:09:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 5 Mar 2020 00:09:27 -0700
Date:   Thu, 5 Mar 2020 08:09:26 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <claudiu.manoil@nxp.com>,
        <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <alexandru.marginean@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <yangbo.lu@nxp.com>, <po.liu@nxp.com>, <jiri@mellanox.com>,
        <idosch@idosch.org>, <kuba@kernel.org>
Subject: Re: [PATCH v2 net-next 05/10] net: mscc: ocelot: spell out full
 "ocelot" name instead of "oc"
Message-ID: <20200305070926.ztwgwsilejsqglet@lx-anielsen.microsemi.net>
References: <20200229143114.10656-1-olteanv@gmail.com>
 <20200229143114.10656-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200229143114.10656-6-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.02.2020 16:31, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>This is a cosmetic patch that makes the name of the driver private
>variable be used uniformly in ocelot_ace.c as in the rest of the driver.
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
>Changes in v2:
>Patch is new.
>
> drivers/net/ethernet/mscc/ocelot_ace.c | 45 ++++++++++++++------------
> 1 file changed, 24 insertions(+), 21 deletions(-)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
>index 375c7c6aa7d5..ec86d29d8be4 100644
>--- a/drivers/net/ethernet/mscc/ocelot_ace.c
>+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
>@@ -93,12 +93,12 @@ struct vcap_data {
>        u32 tg_mask; /* Current type-group mask */
> };
>
>-static u32 vcap_s2_read_update_ctrl(struct ocelot *oc)
>+static u32 vcap_s2_read_update_ctrl(struct ocelot *ocelot)
> {
>-       return ocelot_read(oc, S2_CORE_UPDATE_CTRL);
>+       return ocelot_read(ocelot, S2_CORE_UPDATE_CTRL);
> }
>
>-static void vcap_cmd(struct ocelot *oc, u16 ix, int cmd, int sel)
>+static void vcap_cmd(struct ocelot *ocelot, u16 ix, int cmd, int sel)
> {
>        u32 value = (S2_CORE_UPDATE_CTRL_UPDATE_CMD(cmd) |
>                     S2_CORE_UPDATE_CTRL_UPDATE_ADDR(ix) |
>@@ -116,42 +116,42 @@ static void vcap_cmd(struct ocelot *oc, u16 ix, int cmd, int sel)
>        if (!(sel & VCAP_SEL_COUNTER))
>                value |= S2_CORE_UPDATE_CTRL_UPDATE_CNT_DIS;
>
>-       ocelot_write(oc, value, S2_CORE_UPDATE_CTRL);
>-       readx_poll_timeout(vcap_s2_read_update_ctrl, oc, value,
>+       ocelot_write(ocelot, value, S2_CORE_UPDATE_CTRL);
>+       readx_poll_timeout(vcap_s2_read_update_ctrl, ocelot, value,
>                                (value & S2_CORE_UPDATE_CTRL_UPDATE_SHOT) == 0,
>                                10, 100000);
> }
>
> /* Convert from 0-based row to VCAP entry row and run command */
>-static void vcap_row_cmd(struct ocelot *oc, u32 row, int cmd, int sel)
>+static void vcap_row_cmd(struct ocelot *ocelot, u32 row, int cmd, int sel)
> {
>-       vcap_cmd(oc, vcap_is2.entry_count - row - 1, cmd, sel);
>+       vcap_cmd(ocelot, vcap_is2.entry_count - row - 1, cmd, sel);
> }
>
>-static void vcap_entry2cache(struct ocelot *oc, struct vcap_data *data)
>+static void vcap_entry2cache(struct ocelot *ocelot, struct vcap_data *data)
> {
>        u32 i;
>
>        for (i = 0; i < vcap_is2.entry_words; i++) {
>-               ocelot_write_rix(oc, data->entry[i], S2_CACHE_ENTRY_DAT, i);
>-               ocelot_write_rix(oc, ~data->mask[i], S2_CACHE_MASK_DAT, i);
>+               ocelot_write_rix(ocelot, data->entry[i], S2_CACHE_ENTRY_DAT, i);
>+               ocelot_write_rix(ocelot, ~data->mask[i], S2_CACHE_MASK_DAT, i);
>        }
>-       ocelot_write(oc, data->tg, S2_CACHE_TG_DAT);
>+       ocelot_write(ocelot, data->tg, S2_CACHE_TG_DAT);
> }
>
>-static void vcap_cache2entry(struct ocelot *oc, struct vcap_data *data)
>+static void vcap_cache2entry(struct ocelot *ocelot, struct vcap_data *data)
> {
>        u32 i;
>
>        for (i = 0; i < vcap_is2.entry_words; i++) {
>-               data->entry[i] = ocelot_read_rix(oc, S2_CACHE_ENTRY_DAT, i);
>+               data->entry[i] = ocelot_read_rix(ocelot, S2_CACHE_ENTRY_DAT, i);
>                // Invert mask
>-               data->mask[i] = ~ocelot_read_rix(oc, S2_CACHE_MASK_DAT, i);
>+               data->mask[i] = ~ocelot_read_rix(ocelot, S2_CACHE_MASK_DAT, i);
>        }
>-       data->tg = ocelot_read(oc, S2_CACHE_TG_DAT);
>+       data->tg = ocelot_read(ocelot, S2_CACHE_TG_DAT);
> }
>
>-static void vcap_action2cache(struct ocelot *oc, struct vcap_data *data)
>+static void vcap_action2cache(struct ocelot *ocelot, struct vcap_data *data)
> {
>        u32 i, width, mask;
>
>@@ -163,21 +163,24 @@ static void vcap_action2cache(struct ocelot *oc, struct vcap_data *data)
>        }
>
>        for (i = 0; i < vcap_is2.action_words; i++)
>-               ocelot_write_rix(oc, data->action[i], S2_CACHE_ACTION_DAT, i);
>+               ocelot_write_rix(ocelot, data->action[i],
>+                                S2_CACHE_ACTION_DAT, i);
>
>        for (i = 0; i < vcap_is2.counter_words; i++)
>-               ocelot_write_rix(oc, data->counter[i], S2_CACHE_CNT_DAT, i);
>+               ocelot_write_rix(ocelot, data->counter[i],
>+                                S2_CACHE_CNT_DAT, i);
> }
>
>-static void vcap_cache2action(struct ocelot *oc, struct vcap_data *data)
>+static void vcap_cache2action(struct ocelot *ocelot, struct vcap_data *data)
> {
>        u32 i, width;
>
>        for (i = 0; i < vcap_is2.action_words; i++)
>-               data->action[i] = ocelot_read_rix(oc, S2_CACHE_ACTION_DAT, i);
>+               data->action[i] = ocelot_read_rix(ocelot, S2_CACHE_ACTION_DAT,
>+                                                 i);
>
>        for (i = 0; i < vcap_is2.counter_words; i++)
>-               data->counter[i] = ocelot_read_rix(oc, S2_CACHE_CNT_DAT, i);
>+               data->counter[i] = ocelot_read_rix(ocelot, S2_CACHE_CNT_DAT, i);
>
>        /* Extract action type */
>        width = vcap_is2.action_type_width;
>--
>2.17.1


Reviewed-by: Allan W. Nielsen <allan.nielsen@microchip.com>
