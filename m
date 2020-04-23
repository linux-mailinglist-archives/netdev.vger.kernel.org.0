Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FF1B5737
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 10:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDWI3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 04:29:53 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:10433 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgDWI3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 04:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587630590; x=1619166590;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BPuBQ6t76Cc6m+gxBX8zXtkt5tpsxeKV7Wd3w4H7MzU=;
  b=xNuUGjyTArXXtSF9ZWSx/WR72Gutf/gy2r1r9VuaJqr6zIZD0D/51vmL
   HPwZPfspgzD3AcLF+cZMOBXZskV2fwysAneivPEgt83WAiY8n5ewQA60A
   vBwXLw5xcDUlO9n3StTFVRyVDu/2JbG1pmD+3EM9Lo154eNrocq6AXuyo
   SWZ43zJfygpetmeYw/Zr9InZPIEIEX2FSVJMUJ9U2N8cYFCqvPaUAoJno
   DUYbD7WYlTmmI1FnGTg4xryssKJrtSTdV+nKZljEkXWYIwsMwMkmknEDb
   Xn8WRSGnsxOL56b3XST8lUdHEZf4Q3sthZUbH3c2JvZ9g3G25Gbh1BwqG
   Q==;
IronPort-SDR: 6qfP+pmYwVJ2Hc45FxhCT59nYhW3cq2uI+3Mtkkt8L8uXb22sC1xwIyOd8ovmmEAKC9qkOBbdC
 rv1zqMDWtyIGRMK6LGo+x5VFAldnGEiUbMn27JuCpcimoUWVcQ2VRv5cKzi/kConStkiXwrCV1
 gY6ZiUPzjQhJiCqrW1KzmMHvtjiHnfS0Qga1TAB9g7lFoYVk3NJFSKOId7iAZYXQ013wAffxHH
 QS6ouPzohDAVZJDl8M+HmaloyhwS1AiEKxQ2bOqcu3p2MG/06DS9WL+NiLUSzweX4UqJxB9yqH
 DGU=
X-IronPort-AV: E=Sophos;i="5.73,306,1583218800"; 
   d="scan'208";a="10144008"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Apr 2020 01:29:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 Apr 2020 01:29:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 23 Apr 2020 01:29:15 -0700
Date:   Thu, 23 Apr 2020 10:29:48 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        "James Hogan" <jhogan@kernel.org>, <linux-mips@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        <hongbo.wang@nxp.com>
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
Message-ID: <20200423082948.t7sgq4ikrbm4cbnt@soft-dev3.microsemi.net>
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com>
 <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
 <CA+h21hprXnOYWExg7NxVZEX9Vjd=Y7o52ifKuAJqLwFuvDjaiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hprXnOYWExg7NxVZEX9Vjd=Y7o52ifKuAJqLwFuvDjaiw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/23/2020 00:26, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi Horatiu,
> 
> On Fri, 31 May 2019 at 10:18, Horatiu Vultur
> <horatiu.vultur@microchip.com> wrote:
> >
> > Add ACL support using the TCAM. Using ACL it is possible to create rules
> > in hardware to filter/redirect frames.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  arch/mips/boot/dts/mscc/ocelot.dtsi      |   5 +-
> >  drivers/net/ethernet/mscc/Makefile       |   2 +-
> >  drivers/net/ethernet/mscc/ocelot.c       |  13 +
> >  drivers/net/ethernet/mscc/ocelot.h       |   8 +
> >  drivers/net/ethernet/mscc/ocelot_ace.c   | 777 +++++++++++++++++++++++++++++++
> >  drivers/net/ethernet/mscc/ocelot_ace.h   | 227 +++++++++
> >  drivers/net/ethernet/mscc/ocelot_board.c |   1 +
> >  drivers/net/ethernet/mscc/ocelot_regs.c  |  11 +
> >  drivers/net/ethernet/mscc/ocelot_s2.h    |  64 +++
> >  drivers/net/ethernet/mscc/ocelot_vcap.h  | 403 ++++++++++++++++
> >  10 files changed, 1508 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_ace.c
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_ace.h
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_vcap.h
> >
> > diff --git a/arch/mips/boot/dts/mscc/ocelot.dtsi b/arch/mips/boot/dts/mscc/ocelot.dtsi
> > index 90c60d4..33ae74a 100644
> > --- a/arch/mips/boot/dts/mscc/ocelot.dtsi
> > +++ b/arch/mips/boot/dts/mscc/ocelot.dtsi
> > @@ -132,11 +132,12 @@
> >                               <0x1270000 0x100>,
> >                               <0x1280000 0x100>,
> >                               <0x1800000 0x80000>,
> > -                             <0x1880000 0x10000>;
> > +                             <0x1880000 0x10000>,
> > +                             <0x1060000 0x10000>;
> >                         reg-names = "sys", "rew", "qs", "port0", "port1",
> >                                     "port2", "port3", "port4", "port5", "port6",
> >                                     "port7", "port8", "port9", "port10", "qsys",
> > -                                   "ana";
> > +                                   "ana", "s2";
> >                         interrupts = <21 22>;
> >                         interrupt-names = "xtr", "inj";
> >
> > diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
> > index 5e694dc..bf4a710 100644
> > --- a/drivers/net/ethernet/mscc/Makefile
> > +++ b/drivers/net/ethernet/mscc/Makefile
> > @@ -1,5 +1,5 @@
> >  # SPDX-License-Identifier: (GPL-2.0 OR MIT)
> >  obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
> >  mscc_ocelot_common-y := ocelot.o ocelot_io.o
> > -mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o
> > +mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o
> >  obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_board.o
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index ab7d9eb..0e5a387 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -22,6 +22,7 @@
> >  #include <net/switchdev.h>
> >
> >  #include "ocelot.h"
> > +#include "ocelot_ace.h"
> >
> >  #define TABLE_UPDATE_SLEEP_US 10
> >  #define TABLE_UPDATE_TIMEOUT_US 100000
> > @@ -130,6 +131,13 @@ static void ocelot_mact_init(struct ocelot *ocelot)
> >         ocelot_write(ocelot, MACACCESS_CMD_INIT, ANA_TABLES_MACACCESS);
> >  }
> >
> > +static void ocelot_vcap_enable(struct ocelot *ocelot, struct ocelot_port *port)
> > +{
> > +       ocelot_write_gix(ocelot, ANA_PORT_VCAP_S2_CFG_S2_ENA |
> > +                        ANA_PORT_VCAP_S2_CFG_S2_IP6_CFG(0xa),
> > +                        ANA_PORT_VCAP_S2_CFG, port->chip_port);
> > +}
> > +
> >  static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
> >  {
> >         return ocelot_read(ocelot, ANA_TABLES_VLANACCESS);
> > @@ -1689,6 +1697,9 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
> >         /* Basic L2 initialization */
> >         ocelot_vlan_port_apply(ocelot, ocelot_port);
> >
> > +       /* Enable vcap lookups */
> > +       ocelot_vcap_enable(ocelot, ocelot_port);
> > +
> >         return 0;
> >
> >  err_register_netdev:
> > @@ -1723,6 +1734,7 @@ int ocelot_init(struct ocelot *ocelot)
> >
> >         ocelot_mact_init(ocelot);
> >         ocelot_vlan_init(ocelot);
> > +       ocelot_ace_init(ocelot);
> >
> >         for (port = 0; port < ocelot->num_phys_ports; port++) {
> >                 /* Clear all counters (5 groups) */
> > @@ -1835,6 +1847,7 @@ void ocelot_deinit(struct ocelot *ocelot)
> >  {
> >         destroy_workqueue(ocelot->stats_queue);
> >         mutex_destroy(&ocelot->stats_lock);
> > +       ocelot_ace_deinit();
> >  }
> >  EXPORT_SYMBOL(ocelot_deinit);
> >
> > diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> > index 9514979..3430174 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.h
> > +++ b/drivers/net/ethernet/mscc/ocelot.h
> > @@ -69,6 +69,7 @@ enum ocelot_target {
> >         QSYS,
> >         REW,
> >         SYS,
> > +       S2,
> >         HSIO,
> >         TARGET_MAX,
> >  };
> > @@ -335,6 +336,13 @@ enum ocelot_reg {
> >         SYS_CM_DATA_RD,
> >         SYS_CM_OP,
> >         SYS_CM_DATA,
> > +       S2_CORE_UPDATE_CTRL = S2 << TARGET_OFFSET,
> > +       S2_CORE_MV_CFG,
> > +       S2_CACHE_ENTRY_DAT,
> > +       S2_CACHE_MASK_DAT,
> > +       S2_CACHE_ACTION_DAT,
> > +       S2_CACHE_CNT_DAT,
> > +       S2_CACHE_TG_DAT,
> >  };
> >
> >  enum ocelot_regfield {
> > diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
> > new file mode 100644
> > index 0000000..afbeb83
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mscc/ocelot_ace.c
> > @@ -0,0 +1,777 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/* Microsemi Ocelot Switch driver
> > + * Copyright (c) 2019 Microsemi Corporation
> > + */
> > +
> > +#include <linux/iopoll.h>
> > +#include <linux/proc_fs.h>
> > +
> > +#include "ocelot_ace.h"
> > +#include "ocelot_vcap.h"
> > +#include "ocelot_s2.h"
> > +
> > +#define OCELOT_POLICER_DISCARD 0x17f
> > +
> > +static struct ocelot_acl_block *acl_block;
> > +
> > +struct vcap_props {
> > +       const char *name; /* Symbolic name */
> > +       u16 tg_width; /* Type-group width (in bits) */
> > +       u16 sw_count; /* Sub word count */
> > +       u16 entry_count; /* Entry count */
> > +       u16 entry_words; /* Number of entry words */
> > +       u16 entry_width; /* Entry width (in bits) */
> > +       u16 action_count; /* Action count */
> > +       u16 action_words; /* Number of action words */
> > +       u16 action_width; /* Action width (in bits) */
> > +       u16 action_type_width; /* Action type width (in bits) */
> > +       struct {
> > +               u16 width; /* Action type width (in bits) */
> > +               u16 count; /* Action type sub word count */
> > +       } action_table[2];
> > +       u16 counter_words; /* Number of counter words */
> > +       u16 counter_width; /* Counter width (in bits) */
> > +};
> > +
> > +#define ENTRY_WIDTH 32
> > +#define BITS_TO_32BIT(x) (1 + (((x) - 1) / ENTRY_WIDTH))
> > +
> > +static const struct vcap_props vcap_is2 = {
> > +       .name = "IS2",
> > +       .tg_width = 2,
> > +       .sw_count = 4,
> > +       .entry_count = VCAP_IS2_CNT,
> > +       .entry_words = BITS_TO_32BIT(VCAP_IS2_ENTRY_WIDTH),
> > +       .entry_width = VCAP_IS2_ENTRY_WIDTH,
> > +       .action_count = (VCAP_IS2_CNT + VCAP_PORT_CNT + 2),
> > +       .action_words = BITS_TO_32BIT(VCAP_IS2_ACTION_WIDTH),
> > +       .action_width = (VCAP_IS2_ACTION_WIDTH),
> > +       .action_type_width = 1,
> > +       .action_table = {
> > +               {
> > +                       .width = (IS2_AO_ACL_ID + IS2_AL_ACL_ID),
> > +                       .count = 2
> > +               },
> > +               {
> > +                       .width = 6,
> > +                       .count = 4
> > +               },
> > +       },
> > +       .counter_words = BITS_TO_32BIT(4 * ENTRY_WIDTH),
> > +       .counter_width = ENTRY_WIDTH,
> > +};
> > +
> > +enum vcap_sel {
> > +       VCAP_SEL_ENTRY = 0x1,
> > +       VCAP_SEL_ACTION = 0x2,
> > +       VCAP_SEL_COUNTER = 0x4,
> > +       VCAP_SEL_ALL = 0x7,
> > +};
> > +
> > +enum vcap_cmd {
> > +       VCAP_CMD_WRITE = 0, /* Copy from Cache to TCAM */
> > +       VCAP_CMD_READ = 1, /* Copy from TCAM to Cache */
> > +       VCAP_CMD_MOVE_UP = 2, /* Move <count> up */
> > +       VCAP_CMD_MOVE_DOWN = 3, /* Move <count> down */
> > +       VCAP_CMD_INITIALIZE = 4, /* Write all (from cache) */
> > +};
> > +
> > +#define VCAP_ENTRY_WIDTH 12 /* Max entry width (32bit words) */
> > +#define VCAP_COUNTER_WIDTH 4 /* Max counter width (32bit words) */
> > +
> > +struct vcap_data {
> > +       u32 entry[VCAP_ENTRY_WIDTH]; /* ENTRY_DAT */
> > +       u32 mask[VCAP_ENTRY_WIDTH]; /* MASK_DAT */
> > +       u32 action[VCAP_ENTRY_WIDTH]; /* ACTION_DAT */
> > +       u32 counter[VCAP_COUNTER_WIDTH]; /* CNT_DAT */
> > +       u32 tg; /* TG_DAT */
> > +       u32 type; /* Action type */
> > +       u32 tg_sw; /* Current type-group */
> > +       u32 cnt; /* Current counter */
> > +       u32 key_offset; /* Current entry offset */
> > +       u32 action_offset; /* Current action offset */
> > +       u32 counter_offset; /* Current counter offset */
> > +       u32 tg_value; /* Current type-group value */
> > +       u32 tg_mask; /* Current type-group mask */
> > +} vcap_data_t;
> > +
> > +static u32 vcap_s2_read_update_ctrl(struct ocelot *oc)
> > +{
> > +       return ocelot_read(oc, S2_CORE_UPDATE_CTRL);
> > +}
> > +
> > +static void vcap_cmd(struct ocelot *oc, u16 ix, int cmd, int sel)
> > +{
> > +       u32 value = (S2_CORE_UPDATE_CTRL_UPDATE_CMD(cmd) |
> > +                    S2_CORE_UPDATE_CTRL_UPDATE_ADDR(ix) |
> > +                    S2_CORE_UPDATE_CTRL_UPDATE_SHOT);
> > +       int rc;
> > +
> > +       if ((sel & VCAP_SEL_ENTRY) && ix >= vcap_is2.entry_count)
> > +               return;
> > +
> > +       if (!(sel & VCAP_SEL_ENTRY))
> > +               value |= S2_CORE_UPDATE_CTRL_UPDATE_ENTRY_DIS;
> > +
> > +       if (!(sel & VCAP_SEL_ACTION))
> > +               value |= S2_CORE_UPDATE_CTRL_UPDATE_ACTION_DIS;
> > +
> > +       if (!(sel & VCAP_SEL_COUNTER))
> > +               value |= S2_CORE_UPDATE_CTRL_UPDATE_CNT_DIS;
> > +
> > +       ocelot_write(oc, value, S2_CORE_UPDATE_CTRL);
> > +       rc = readx_poll_timeout(vcap_s2_read_update_ctrl, oc, value,
> > +                               (value & S2_CORE_UPDATE_CTRL_UPDATE_SHOT) == 0,
> > +                               10, 100000);
> > +}
> > +
> > +/* Convert from 0-based row to VCAP entry row and run command */
> > +static void vcap_row_cmd(struct ocelot *oc, u32 row, int cmd, int sel)
> > +{
> > +       vcap_cmd(oc, vcap_is2.entry_count - row - 1, cmd, sel);
> > +}
> > +
> > +static void vcap_entry2cache(struct ocelot *oc, struct vcap_data *data)
> > +{
> > +       u32 i;
> > +
> > +       for (i = 0; i < vcap_is2.entry_words; i++) {
> > +               ocelot_write_rix(oc, data->entry[i], S2_CACHE_ENTRY_DAT, i);
> > +               ocelot_write_rix(oc, ~data->mask[i], S2_CACHE_MASK_DAT, i);
> > +       }
> > +       ocelot_write(oc, data->tg, S2_CACHE_TG_DAT);
> > +}
> > +
> > +static void vcap_cache2entry(struct ocelot *oc, struct vcap_data *data)
> > +{
> > +       u32 i;
> > +
> > +       for (i = 0; i < vcap_is2.entry_words; i++) {
> > +               data->entry[i] = ocelot_read_rix(oc, S2_CACHE_ENTRY_DAT, i);
> > +               // Invert mask
> > +               data->mask[i] = ~ocelot_read_rix(oc, S2_CACHE_MASK_DAT, i);
> > +       }
> > +       data->tg = ocelot_read(oc, S2_CACHE_TG_DAT);
> > +}
> > +
> > +static void vcap_action2cache(struct ocelot *oc, struct vcap_data *data)
> > +{
> > +       u32 i, width, mask;
> > +
> > +       /* Encode action type */
> > +       width = vcap_is2.action_type_width;
> > +       if (width) {
> > +               mask = GENMASK(width, 0);
> > +               data->action[0] = ((data->action[0] & ~mask) | data->type);
> > +       }
> > +
> > +       for (i = 0; i < vcap_is2.action_words; i++)
> > +               ocelot_write_rix(oc, data->action[i], S2_CACHE_ACTION_DAT, i);
> > +
> > +       for (i = 0; i < vcap_is2.counter_words; i++)
> > +               ocelot_write_rix(oc, data->counter[i], S2_CACHE_CNT_DAT, i);
> > +}
> > +
> > +static void vcap_cache2action(struct ocelot *oc, struct vcap_data *data)
> > +{
> > +       u32 i, width;
> > +
> > +       for (i = 0; i < vcap_is2.action_words; i++)
> > +               data->action[i] = ocelot_read_rix(oc, S2_CACHE_ACTION_DAT, i);
> > +
> > +       for (i = 0; i < vcap_is2.counter_words; i++)
> > +               data->counter[i] = ocelot_read_rix(oc, S2_CACHE_CNT_DAT, i);
> > +
> > +       /* Extract action type */
> > +       width = vcap_is2.action_type_width;
> > +       data->type = (width ? (data->action[0] & GENMASK(width, 0)) : 0);
> > +}
> > +
> > +/* Calculate offsets for entry */
> > +static void is2_data_get(struct vcap_data *data, int ix)
> > +{
> > +       u32 i, col, offset, count, cnt, base, width = vcap_is2.tg_width;
> > +
> > +       count = (data->tg_sw == VCAP_TG_HALF ? 2 : 4);
> > +       col = (ix % 2);
> > +       cnt = (vcap_is2.sw_count / count);
> > +       base = (vcap_is2.sw_count - col * cnt - cnt);
> > +       data->tg_value = 0;
> > +       data->tg_mask = 0;
> > +       for (i = 0; i < cnt; i++) {
> > +               offset = ((base + i) * width);
> > +               data->tg_value |= (data->tg_sw << offset);
> > +               data->tg_mask |= GENMASK(offset + width - 1, offset);
> > +       }
> > +
> > +       /* Calculate key/action/counter offsets */
> > +       col = (count - col - 1);
> > +       data->key_offset = (base * vcap_is2.entry_width) / vcap_is2.sw_count;
> > +       data->counter_offset = (cnt * col * vcap_is2.counter_width);
> > +       i = data->type;
> > +       width = vcap_is2.action_table[i].width;
> > +       cnt = vcap_is2.action_table[i].count;
> > +       data->action_offset =
> > +               (((cnt * col * width) / count) + vcap_is2.action_type_width);
> > +}
> > +
> > +static void vcap_data_set(u32 *data, u32 offset, u32 len, u32 value)
> > +{
> > +       u32 i, v, m;
> > +
> > +       for (i = 0; i < len; i++, offset++) {
> > +               v = data[offset / ENTRY_WIDTH];
> > +               m = (1 << (offset % ENTRY_WIDTH));
> > +               if (value & (1 << i))
> > +                       v |= m;
> > +               else
> > +                       v &= ~m;
> > +               data[offset / ENTRY_WIDTH] = v;
> > +       }
> > +}
> > +
> > +static u32 vcap_data_get(u32 *data, u32 offset, u32 len)
> > +{
> > +       u32 i, v, m, value = 0;
> > +
> > +       for (i = 0; i < len; i++, offset++) {
> > +               v = data[offset / ENTRY_WIDTH];
> > +               m = (1 << (offset % ENTRY_WIDTH));
> > +               if (v & m)
> > +                       value |= (1 << i);
> > +       }
> > +       return value;
> > +}
> > +
> > +static void vcap_key_set(struct vcap_data *data, u32 offset, u32 width,
> > +                        u32 value, u32 mask)
> > +{
> > +       vcap_data_set(data->entry, offset + data->key_offset, width, value);
> > +       vcap_data_set(data->mask, offset + data->key_offset, width, mask);
> > +}
> > +
> > +static void vcap_key_bytes_set(struct vcap_data *data, u32 offset, u8 *val,
> > +                              u8 *msk, u32 count)
> > +{
> > +       u32 i, j, n = 0, value = 0, mask = 0;
> > +
> > +       /* Data wider than 32 bits are split up in chunks of maximum 32 bits.
> > +        * The 32 LSB of the data are written to the 32 MSB of the TCAM.
> > +        */
> > +       offset += (count * 8);
> > +       for (i = 0; i < count; i++) {
> > +               j = (count - i - 1);
> > +               value += (val[j] << n);
> > +               mask += (msk[j] << n);
> > +               n += 8;
> > +               if (n == ENTRY_WIDTH || (i + 1) == count) {
> > +                       offset -= n;
> > +                       vcap_key_set(data, offset, n, value, mask);
> > +                       n = 0;
> > +                       value = 0;
> > +                       mask = 0;
> > +               }
> > +       }
> > +}
> > +
> > +static void vcap_key_l4_port_set(struct vcap_data *data, u32 offset,
> > +                                struct ocelot_vcap_udp_tcp *port)
> > +{
> > +       vcap_key_set(data, offset, 16, port->value, port->mask);
> > +}
> > +
> > +static void vcap_key_bit_set(struct vcap_data *data, u32 offset,
> > +                            enum ocelot_vcap_bit val)
> > +{
> > +       vcap_key_set(data, offset, 1, val == OCELOT_VCAP_BIT_1 ? 1 : 0,
> > +                    val == OCELOT_VCAP_BIT_ANY ? 0 : 1);
> > +}
> > +
> > +#define VCAP_KEY_SET(fld, val, msk) \
> > +       vcap_key_set(&data, IS2_HKO_##fld, IS2_HKL_##fld, val, msk)
> > +#define VCAP_KEY_ANY_SET(fld) \
> > +       vcap_key_set(&data, IS2_HKO_##fld, IS2_HKL_##fld, 0, 0)
> > +#define VCAP_KEY_BIT_SET(fld, val) vcap_key_bit_set(&data, IS2_HKO_##fld, val)
> > +#define VCAP_KEY_BYTES_SET(fld, val, msk) \
> > +       vcap_key_bytes_set(&data, IS2_HKO_##fld, val, msk, IS2_HKL_##fld / 8)
> > +
> > +static void vcap_action_set(struct vcap_data *data, u32 offset, u32 width,
> > +                           u32 value)
> > +{
> > +       vcap_data_set(data->action, offset + data->action_offset, width, value);
> > +}
> > +
> > +#define VCAP_ACT_SET(fld, val) \
> > +       vcap_action_set(data, IS2_AO_##fld, IS2_AL_##fld, val)
> > +
> > +static void is2_action_set(struct vcap_data *data,
> > +                          enum ocelot_ace_action action)
> > +{
> > +       switch (action) {
> > +       case OCELOT_ACL_ACTION_DROP:
> > +               VCAP_ACT_SET(PORT_MASK, 0x0);
> > +               VCAP_ACT_SET(MASK_MODE, 0x1);
> > +               VCAP_ACT_SET(POLICE_ENA, 0x1);
> > +               VCAP_ACT_SET(POLICE_IDX, OCELOT_POLICER_DISCARD);
> > +               VCAP_ACT_SET(CPU_QU_NUM, 0x0);
> > +               VCAP_ACT_SET(CPU_COPY_ENA, 0x0);
> > +               break;
> > +       case OCELOT_ACL_ACTION_TRAP:
> > +               VCAP_ACT_SET(PORT_MASK, 0x0);
> > +               VCAP_ACT_SET(MASK_MODE, 0x0);
> > +               VCAP_ACT_SET(POLICE_ENA, 0x0);
> > +               VCAP_ACT_SET(POLICE_IDX, 0x0);
> > +               VCAP_ACT_SET(CPU_QU_NUM, 0x0);
> > +               VCAP_ACT_SET(CPU_COPY_ENA, 0x1);
> > +               break;
> > +       }
> > +}
> > +
> > +static void is2_entry_set(struct ocelot *ocelot, int ix,
> > +                         struct ocelot_ace_rule *ace)
> > +{
> > +       u32 val, msk, type, type_mask = 0xf, i, count;
> > +       struct ocelot_ace_vlan *tag = &ace->vlan;
> > +       struct ocelot_vcap_u64 payload = { 0 };
> > +       struct vcap_data data = { 0 };
> > +       int row = (ix / 2);
> > +
> > +       /* Read row */
> > +       vcap_row_cmd(ocelot, row, VCAP_CMD_READ, VCAP_SEL_ALL);
> > +       vcap_cache2entry(ocelot, &data);
> > +       vcap_cache2action(ocelot, &data);
> > +
> > +       data.tg_sw = VCAP_TG_HALF;
> > +       is2_data_get(&data, ix);
> > +       data.tg = (data.tg & ~data.tg_mask);
> > +       if (ace->prio != 0)
> > +               data.tg |= data.tg_value;
> 

Hi Vladimir,

> This complicated piece of logic here populates the type-group for
> subwords > 0 unconditionally, and the type-group for subword 0 only if
> the ACE is enabled.
> 
> tc filter add dev swp0 ingress protocol ip flower skip_sw src_ip
> 192.168.1.1 action drop
> [   34.172068] is2_entry_set: ace->prio 49152 data tg 0xaa
> tc filter del dev swp0 ingress pref 49152
> [   44.266662] is2_entry_set: ace->prio 0 data tg 0xa0
> 
> What is the purpose of this? Why can't the entire data->tg be set to
> zero when deleting it?
I don't remember exactly but let me try:

In case you have only one entry per row, then you could set the tg to
have value 0. But in case you have 2 entries(use half keys), you need to
set the tg to 0 only to the half entry that you delete.

So for example if you have only 1 half entry at subword 1 then the tg
should be 0xa0. Then when you add a new entry on the same row but at
subword 0 then the tg should have the value 0xaa.
The value 0xaa, comes from the fact that the type group for half entry
is 0x2 and this needs to be set for each subword. And IS2 has 4 subwords
therefore 0b10101010 = 0xaa.

I hope this helps, if not I can look deeper in the code and see exactly.

> Is there any special meaning to a TCAM entry > with subword zero unused?
> 
> > +
> > +       data.type = IS2_ACTION_TYPE_NORMAL;
> > +
> > +       VCAP_KEY_ANY_SET(PAG);
> > +       VCAP_KEY_SET(IGR_PORT_MASK, 0, ~BIT(ace->chip_port));
> > +       VCAP_KEY_BIT_SET(FIRST, OCELOT_VCAP_BIT_1);
> > +       VCAP_KEY_BIT_SET(HOST_MATCH, OCELOT_VCAP_BIT_ANY);
> > +       VCAP_KEY_BIT_SET(L2_MC, ace->dmac_mc);
> > +       VCAP_KEY_BIT_SET(L2_BC, ace->dmac_bc);
> > +       VCAP_KEY_BIT_SET(VLAN_TAGGED, tag->tagged);
> > +       VCAP_KEY_SET(VID, tag->vid.value, tag->vid.mask);
> > +       VCAP_KEY_SET(PCP, tag->pcp.value[0], tag->pcp.mask[0]);
> > +       VCAP_KEY_BIT_SET(DEI, tag->dei);
> > +
> > +       switch (ace->type) {
> > +       case OCELOT_ACE_TYPE_ETYPE: {
> > +               struct ocelot_ace_frame_etype *etype = &ace->frame.etype;
> > +
> > +               type = IS2_TYPE_ETYPE;
> > +               VCAP_KEY_BYTES_SET(L2_DMAC, etype->dmac.value,
> > +                                  etype->dmac.mask);
> > +               VCAP_KEY_BYTES_SET(L2_SMAC, etype->smac.value,
> > +                                  etype->smac.mask);
> > +               VCAP_KEY_BYTES_SET(MAC_ETYPE_ETYPE, etype->etype.value,
> > +                                  etype->etype.mask);
> > +               VCAP_KEY_ANY_SET(MAC_ETYPE_L2_PAYLOAD); // Clear unused bits
> > +               vcap_key_bytes_set(&data, IS2_HKO_MAC_ETYPE_L2_PAYLOAD,
> > +                                  etype->data.value, etype->data.mask, 2);
> > +               break;
> > +       }
> > +       case OCELOT_ACE_TYPE_LLC: {
> > +               struct ocelot_ace_frame_llc *llc = &ace->frame.llc;
> > +
> > +               type = IS2_TYPE_LLC;
> > +               VCAP_KEY_BYTES_SET(L2_DMAC, llc->dmac.value, llc->dmac.mask);
> > +               VCAP_KEY_BYTES_SET(L2_SMAC, llc->smac.value, llc->smac.mask);
> > +               for (i = 0; i < 4; i++) {
> > +                       payload.value[i] = llc->llc.value[i];
> > +                       payload.mask[i] = llc->llc.mask[i];
> > +               }
> > +               VCAP_KEY_BYTES_SET(MAC_LLC_L2_LLC, payload.value, payload.mask);
> > +               break;
> > +       }
> > +       case OCELOT_ACE_TYPE_SNAP: {
> > +               struct ocelot_ace_frame_snap *snap = &ace->frame.snap;
> > +
> > +               type = IS2_TYPE_SNAP;
> > +               VCAP_KEY_BYTES_SET(L2_DMAC, snap->dmac.value, snap->dmac.mask);
> > +               VCAP_KEY_BYTES_SET(L2_SMAC, snap->smac.value, snap->smac.mask);
> > +               VCAP_KEY_BYTES_SET(MAC_SNAP_L2_SNAP,
> > +                                  ace->frame.snap.snap.value,
> > +                                  ace->frame.snap.snap.mask);
> > +               break;
> > +       }
> > +       case OCELOT_ACE_TYPE_ARP: {
> > +               struct ocelot_ace_frame_arp *arp = &ace->frame.arp;
> > +
> > +               type = IS2_TYPE_ARP;
> > +               VCAP_KEY_BYTES_SET(MAC_ARP_L2_SMAC, arp->smac.value,
> > +                                  arp->smac.mask);
> > +               VCAP_KEY_BIT_SET(MAC_ARP_ARP_ADDR_SPACE_OK, arp->ethernet);
> > +               VCAP_KEY_BIT_SET(MAC_ARP_ARP_PROTO_SPACE_OK, arp->ip);
> > +               VCAP_KEY_BIT_SET(MAC_ARP_ARP_LEN_OK, arp->length);
> > +               VCAP_KEY_BIT_SET(MAC_ARP_ARP_TGT_MATCH, arp->dmac_match);
> > +               VCAP_KEY_BIT_SET(MAC_ARP_ARP_SENDER_MATCH, arp->smac_match);
> > +               VCAP_KEY_BIT_SET(MAC_ARP_ARP_OPCODE_UNKNOWN, arp->unknown);
> > +
> > +               /* OPCODE is inverse, bit 0 is reply flag, bit 1 is RARP flag */
> > +               val = ((arp->req == OCELOT_VCAP_BIT_0 ? 1 : 0) |
> > +                      (arp->arp == OCELOT_VCAP_BIT_0 ? 2 : 0));
> > +               msk = ((arp->req == OCELOT_VCAP_BIT_ANY ? 0 : 1) |
> > +                      (arp->arp == OCELOT_VCAP_BIT_ANY ? 0 : 2));
> > +               VCAP_KEY_SET(MAC_ARP_ARP_OPCODE, val, msk);
> > +               vcap_key_bytes_set(&data, IS2_HKO_MAC_ARP_L3_IP4_DIP,
> > +                                  arp->dip.value.addr, arp->dip.mask.addr, 4);
> > +               vcap_key_bytes_set(&data, IS2_HKO_MAC_ARP_L3_IP4_SIP,
> > +                                  arp->sip.value.addr, arp->sip.mask.addr, 4);
> > +               VCAP_KEY_ANY_SET(MAC_ARP_DIP_EQ_SIP);
> > +               break;
> > +       }
> > +       case OCELOT_ACE_TYPE_IPV4:
> > +       case OCELOT_ACE_TYPE_IPV6: {
> > +               enum ocelot_vcap_bit sip_eq_dip, sport_eq_dport, seq_zero, tcp;
> > +               enum ocelot_vcap_bit ttl, fragment, options, tcp_ack, tcp_urg;
> > +               enum ocelot_vcap_bit tcp_fin, tcp_syn, tcp_rst, tcp_psh;
> > +               struct ocelot_ace_frame_ipv4 *ipv4 = NULL;
> > +               struct ocelot_ace_frame_ipv6 *ipv6 = NULL;
> > +               struct ocelot_vcap_udp_tcp *sport, *dport;
> > +               struct ocelot_vcap_ipv4 sip, dip;
> > +               struct ocelot_vcap_u8 proto, ds;
> > +               struct ocelot_vcap_u48 *ip_data;
> > +
> > +               if (ace->type == OCELOT_ACE_TYPE_IPV4) {
> > +                       ipv4 = &ace->frame.ipv4;
> > +                       ttl = ipv4->ttl;
> > +                       fragment = ipv4->fragment;
> > +                       options = ipv4->options;
> > +                       proto = ipv4->proto;
> > +                       ds = ipv4->ds;
> > +                       ip_data = &ipv4->data;
> > +                       sip = ipv4->sip;
> > +                       dip = ipv4->dip;
> > +                       sport = &ipv4->sport;
> > +                       dport = &ipv4->dport;
> > +                       tcp_fin = ipv4->tcp_fin;
> > +                       tcp_syn = ipv4->tcp_syn;
> > +                       tcp_rst = ipv4->tcp_rst;
> > +                       tcp_psh = ipv4->tcp_psh;
> > +                       tcp_ack = ipv4->tcp_ack;
> > +                       tcp_urg = ipv4->tcp_urg;
> > +                       sip_eq_dip = ipv4->sip_eq_dip;
> > +                       sport_eq_dport = ipv4->sport_eq_dport;
> > +                       seq_zero = ipv4->seq_zero;
> > +               } else {
> > +                       ipv6 = &ace->frame.ipv6;
> > +                       ttl = ipv6->ttl;
> > +                       fragment = OCELOT_VCAP_BIT_ANY;
> > +                       options = OCELOT_VCAP_BIT_ANY;
> > +                       proto = ipv6->proto;
> > +                       ds = ipv6->ds;
> > +                       ip_data = &ipv6->data;
> > +                       for (i = 0; i < 8; i++) {
> > +                               val = ipv6->sip.value[i + 8];
> > +                               msk = ipv6->sip.mask[i + 8];
> > +                               if (i < 4) {
> > +                                       dip.value.addr[i] = val;
> > +                                       dip.mask.addr[i] = msk;
> > +                               } else {
> > +                                       sip.value.addr[i - 4] = val;
> > +                                       sip.mask.addr[i - 4] = msk;
> > +                               }
> > +                       }
> > +                       sport = &ipv6->sport;
> > +                       dport = &ipv6->dport;
> > +                       tcp_fin = ipv6->tcp_fin;
> > +                       tcp_syn = ipv6->tcp_syn;
> > +                       tcp_rst = ipv6->tcp_rst;
> > +                       tcp_psh = ipv6->tcp_psh;
> > +                       tcp_ack = ipv6->tcp_ack;
> > +                       tcp_urg = ipv6->tcp_urg;
> > +                       sip_eq_dip = ipv6->sip_eq_dip;
> > +                       sport_eq_dport = ipv6->sport_eq_dport;
> > +                       seq_zero = ipv6->seq_zero;
> > +               }
> > +
> > +               VCAP_KEY_BIT_SET(IP4,
> > +                                ipv4 ? OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
> > +               VCAP_KEY_BIT_SET(L3_FRAGMENT, fragment);
> > +               VCAP_KEY_ANY_SET(L3_FRAG_OFS_GT0);
> > +               VCAP_KEY_BIT_SET(L3_OPTIONS, options);
> > +               VCAP_KEY_BIT_SET(L3_TTL_GT0, ttl);
> > +               VCAP_KEY_BYTES_SET(L3_TOS, ds.value, ds.mask);
> > +               vcap_key_bytes_set(&data, IS2_HKO_L3_IP4_DIP, dip.value.addr,
> > +                                  dip.mask.addr, 4);
> > +               vcap_key_bytes_set(&data, IS2_HKO_L3_IP4_SIP, sip.value.addr,
> > +                                  sip.mask.addr, 4);
> > +               VCAP_KEY_BIT_SET(DIP_EQ_SIP, sip_eq_dip);
> > +               val = proto.value[0];
> > +               msk = proto.mask[0];
> > +               type = IS2_TYPE_IP_UDP_TCP;
> > +               if (msk == 0xff && (val == 6 || val == 17)) {
> > +                       /* UDP/TCP protocol match */
> > +                       tcp = (val == 6 ?
> > +                              OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
> > +                       VCAP_KEY_BIT_SET(IP4_TCP_UDP_TCP, tcp);
> > +                       vcap_key_l4_port_set(&data,
> > +                                            IS2_HKO_IP4_TCP_UDP_L4_DPORT,
> > +                                            dport);
> > +                       vcap_key_l4_port_set(&data,
> > +                                            IS2_HKO_IP4_TCP_UDP_L4_SPORT,
> > +                                            sport);
> > +                       VCAP_KEY_ANY_SET(IP4_TCP_UDP_L4_RNG);
> > +                       VCAP_KEY_BIT_SET(IP4_TCP_UDP_SPORT_EQ_DPORT,
> > +                                        sport_eq_dport);
> > +                       VCAP_KEY_BIT_SET(IP4_TCP_UDP_SEQUENCE_EQ0, seq_zero);
> > +                       VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_FIN, tcp_fin);
> > +                       VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_SYN, tcp_syn);
> > +                       VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_RST, tcp_rst);
> > +                       VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_PSH, tcp_psh);
> > +                       VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_ACK, tcp_ack);
> > +                       VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_URG, tcp_urg);
> > +                       VCAP_KEY_ANY_SET(IP4_TCP_UDP_L4_1588_DOM);
> > +                       VCAP_KEY_ANY_SET(IP4_TCP_UDP_L4_1588_VER);
> > +               } else {
> > +                       if (msk == 0) {
> > +                               /* Any IP protocol match */
> > +                               type_mask = IS2_TYPE_MASK_IP_ANY;
> > +                       } else {
> > +                               /* Non-UDP/TCP protocol match */
> > +                               type = IS2_TYPE_IP_OTHER;
> > +                               for (i = 0; i < 6; i++) {
> > +                                       payload.value[i] = ip_data->value[i];
> > +                                       payload.mask[i] = ip_data->mask[i];
> > +                               }
> > +                       }
> > +                       VCAP_KEY_BYTES_SET(IP4_OTHER_L3_PROTO, proto.value,
> > +                                          proto.mask);
> > +                       VCAP_KEY_BYTES_SET(IP4_OTHER_L3_PAYLOAD, payload.value,
> > +                                          payload.mask);
> > +               }
> > +               break;
> > +       }
> > +       case OCELOT_ACE_TYPE_ANY:
> > +       default:
> > +               type = 0;
> > +               type_mask = 0;
> > +               count = (vcap_is2.entry_width / 2);
> > +               for (i = (IS2_HKO_PCP + IS2_HKL_PCP); i < count;
> > +                    i += ENTRY_WIDTH) {
> > +                       /* Clear entry data */
> > +                       vcap_key_set(&data, i, min(32u, count - i), 0, 0);
> > +               }
> > +               break;
> > +       }
> > +
> > +       VCAP_KEY_SET(TYPE, type, type_mask);
> > +       is2_action_set(&data, ace->action);
> > +       vcap_data_set(data.counter, data.counter_offset, vcap_is2.counter_width,
> > +                     ace->stats.pkts);
> > +
> > +       /* Write row */
> > +       vcap_entry2cache(ocelot, &data);
> > +       vcap_action2cache(ocelot, &data);
> > +       vcap_row_cmd(ocelot, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
> > +}
> > +
> > +static void is2_entry_get(struct ocelot_ace_rule *rule, int ix)
> > +{
> > +       struct ocelot *op = rule->port->ocelot;
> > +       struct vcap_data data;
> > +       int row = (ix / 2);
> > +       u32 cnt;
> > +
> > +       vcap_row_cmd(op, row, VCAP_CMD_READ, VCAP_SEL_COUNTER);
> > +       vcap_cache2action(op, &data);
> > +       data.tg_sw = VCAP_TG_HALF;
> > +       is2_data_get(&data, ix);
> > +       cnt = vcap_data_get(data.counter, data.counter_offset,
> > +                           vcap_is2.counter_width);
> > +
> > +       rule->stats.pkts = cnt;
> > +}
> > +
> > +static void ocelot_ace_rule_add(struct ocelot_acl_block *block,
> > +                               struct ocelot_ace_rule *rule)
> > +{
> > +       struct ocelot_ace_rule *tmp;
> > +       struct list_head *pos, *n;
> > +
> > +       block->count++;
> > +
> > +       if (list_empty(&block->rules)) {
> > +               list_add(&rule->list, &block->rules);
> > +               return;
> > +       }
> > +
> > +       list_for_each_safe(pos, n, &block->rules) {
> > +               tmp = list_entry(pos, struct ocelot_ace_rule, list);
> > +               if (rule->prio < tmp->prio)
> > +                       break;
> > +       }
> > +       list_add(&rule->list, pos->prev);
> > +}
> > +
> > +static int ocelot_ace_rule_get_index_id(struct ocelot_acl_block *block,
> > +                                       struct ocelot_ace_rule *rule)
> > +{
> > +       struct ocelot_ace_rule *tmp;
> > +       int index = -1;
> > +
> > +       list_for_each_entry(tmp, &block->rules, list) {
> > +               ++index;
> > +               if (rule->id == tmp->id)
> > +                       break;
> > +       }
> > +       return index;
> > +}
> > +
> > +static struct ocelot_ace_rule*
> > +ocelot_ace_rule_get_rule_index(struct ocelot_acl_block *block, int index)
> > +{
> > +       struct ocelot_ace_rule *tmp;
> > +       int i = 0;
> > +
> > +       list_for_each_entry(tmp, &block->rules, list) {
> > +               if (i == index)
> > +                       return tmp;
> > +               ++i;
> > +       }
> > +
> > +       return NULL;
> > +}
> > +
> > +int ocelot_ace_rule_offload_add(struct ocelot_ace_rule *rule)
> > +{
> > +       struct ocelot_ace_rule *ace;
> > +       int i, index;
> > +
> > +       /* Add rule to the linked list */
> > +       ocelot_ace_rule_add(acl_block, rule);
> > +
> > +       /* Get the index of the inserted rule */
> > +       index = ocelot_ace_rule_get_index_id(acl_block, rule);
> > +
> > +       /* Move down the rules to make place for the new rule */
> > +       for (i = acl_block->count - 1; i > index; i--) {
> > +               ace = ocelot_ace_rule_get_rule_index(acl_block, i);
> > +               is2_entry_set(rule->port->ocelot, i, ace);
> > +       }
> > +
> > +       /* Now insert the new rule */
> > +       is2_entry_set(rule->port->ocelot, index, rule);
> > +       return 0;
> > +}
> > +
> > +static void ocelot_ace_rule_del(struct ocelot_acl_block *block,
> > +                               struct ocelot_ace_rule *rule)
> > +{
> > +       struct ocelot_ace_rule *tmp;
> > +       struct list_head *pos, *q;
> > +
> > +       list_for_each_safe(pos, q, &block->rules) {
> > +               tmp = list_entry(pos, struct ocelot_ace_rule, list);
> > +               if (tmp->id == rule->id) {
> > +                       list_del(pos);
> > +                       kfree(tmp);
> > +               }
> > +       }
> > +
> > +       block->count--;
> > +}
> > +
> > +int ocelot_ace_rule_offload_del(struct ocelot_ace_rule *rule)
> > +{
> > +       struct ocelot_ace_rule del_ace = { 0 };
> > +       struct ocelot_ace_rule *ace;
> > +       int i, index;
> > +
> > +       /* Gets index of the rule */
> > +       index = ocelot_ace_rule_get_index_id(acl_block, rule);
> > +
> > +       /* Delete rule */
> > +       ocelot_ace_rule_del(acl_block, rule);
> > +
> > +       /* Move up all the blocks over the deleted rule */
> > +       for (i = index; i < acl_block->count; i++) {
> > +               ace = ocelot_ace_rule_get_rule_index(acl_block, i);
> > +               is2_entry_set(rule->port->ocelot, i, ace);
> > +       }
> > +
> > +       /* Now delete the last rule, because it is duplicated */
> > +       is2_entry_set(rule->port->ocelot, acl_block->count, &del_ace);
> > +
> > +       return 0;
> > +}
> > +
> > +int ocelot_ace_rule_stats_update(struct ocelot_ace_rule *rule)
> > +{
> > +       struct ocelot_ace_rule *tmp;
> > +       int index;
> > +
> > +       index = ocelot_ace_rule_get_index_id(acl_block, rule);
> > +       is2_entry_get(rule, index);
> > +
> > +       /* After we get the result we need to clear the counters */
> > +       tmp = ocelot_ace_rule_get_rule_index(acl_block, index);
> > +       tmp->stats.pkts = 0;
> > +       is2_entry_set(rule->port->ocelot, index, tmp);
> > +
> > +       return 0;
> > +}
> > +
> > +static struct ocelot_acl_block *ocelot_acl_block_create(struct ocelot *ocelot)
> > +{
> > +       struct ocelot_acl_block *block;
> > +
> > +       block = kzalloc(sizeof(*block), GFP_KERNEL);
> > +       if (!block)
> > +               return NULL;
> > +
> > +       INIT_LIST_HEAD(&block->rules);
> > +       block->count = 0;
> > +       block->ocelot = ocelot;
> > +
> > +       return block;
> > +}
> > +
> > +static void ocelot_acl_block_destroy(struct ocelot_acl_block *block)
> > +{
> > +       kfree(block);
> > +}
> > +
> > +int ocelot_ace_init(struct ocelot *ocelot)
> > +{
> > +       struct vcap_data data = { 0 };
> > +
> > +       vcap_entry2cache(ocelot, &data);
> > +       ocelot_write(ocelot, vcap_is2.entry_count, S2_CORE_MV_CFG);
> > +       vcap_cmd(ocelot, 0, VCAP_CMD_INITIALIZE, VCAP_SEL_ENTRY);
> > +
> > +       vcap_action2cache(ocelot, &data);
> > +       ocelot_write(ocelot, vcap_is2.action_count, S2_CORE_MV_CFG);
> > +       vcap_cmd(ocelot, 0, VCAP_CMD_INITIALIZE,
> > +                VCAP_SEL_ACTION | VCAP_SEL_COUNTER);
> > +
> > +       /* Create a policer that will drop the frames for the cpu.
> > +        * This policer will be used as action in the acl rules to drop
> > +        * frames.
> > +        */
> > +       ocelot_write_gix(ocelot, 0x299, ANA_POL_MODE_CFG,
> > +                        OCELOT_POLICER_DISCARD);
> > +       ocelot_write_gix(ocelot, 0x1, ANA_POL_PIR_CFG,
> > +                        OCELOT_POLICER_DISCARD);
> > +       ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_PIR_STATE,
> > +                        OCELOT_POLICER_DISCARD);
> > +       ocelot_write_gix(ocelot, 0x0, ANA_POL_CIR_CFG,
> > +                        OCELOT_POLICER_DISCARD);
> > +       ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_CIR_STATE,
> > +                        OCELOT_POLICER_DISCARD);
> > +
> > +       acl_block = ocelot_acl_block_create(ocelot);
> > +
> > +       return 0;
> > +}
> > +
> > +void ocelot_ace_deinit(void)
> > +{
> > +       ocelot_acl_block_destroy(acl_block);
> > +}
> > diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
> > new file mode 100644
> > index 0000000..c84e608
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mscc/ocelot_ace.h
> > @@ -0,0 +1,227 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> > +/* Microsemi Ocelot Switch driver
> > + * Copyright (c) 2019 Microsemi Corporation
> > + */
> > +
> > +#ifndef _MSCC_OCELOT_ACE_H_
> > +#define _MSCC_OCELOT_ACE_H_
> > +
> > +#include "ocelot.h"
> > +#include <net/sch_generic.h>
> > +#include <net/pkt_cls.h>
> > +
> > +struct ocelot_ipv4 {
> > +       u8 addr[4];
> > +};
> > +
> > +enum ocelot_vcap_bit {
> > +       OCELOT_VCAP_BIT_ANY,
> > +       OCELOT_VCAP_BIT_0,
> > +       OCELOT_VCAP_BIT_1
> > +};
> > +
> > +struct ocelot_vcap_u8 {
> > +       u8 value[1];
> > +       u8 mask[1];
> > +};
> > +
> > +struct ocelot_vcap_u16 {
> > +       u8 value[2];
> > +       u8 mask[2];
> > +};
> > +
> > +struct ocelot_vcap_u24 {
> > +       u8 value[3];
> > +       u8 mask[3];
> > +};
> > +
> > +struct ocelot_vcap_u32 {
> > +       u8 value[4];
> > +       u8 mask[4];
> > +};
> > +
> > +struct ocelot_vcap_u40 {
> > +       u8 value[5];
> > +       u8 mask[5];
> > +};
> > +
> > +struct ocelot_vcap_u48 {
> > +       u8 value[6];
> > +       u8 mask[6];
> > +};
> > +
> > +struct ocelot_vcap_u64 {
> > +       u8 value[8];
> > +       u8 mask[8];
> > +};
> > +
> > +struct ocelot_vcap_u128 {
> > +       u8 value[16];
> > +       u8 mask[16];
> > +};
> > +
> > +struct ocelot_vcap_vid {
> > +       u16 value;
> > +       u16 mask;
> > +};
> > +
> > +struct ocelot_vcap_ipv4 {
> > +       struct ocelot_ipv4 value;
> > +       struct ocelot_ipv4 mask;
> > +};
> > +
> > +struct ocelot_vcap_udp_tcp {
> > +       u16 value;
> > +       u16 mask;
> > +};
> > +
> > +enum ocelot_ace_type {
> > +       OCELOT_ACE_TYPE_ANY,
> > +       OCELOT_ACE_TYPE_ETYPE,
> > +       OCELOT_ACE_TYPE_LLC,
> > +       OCELOT_ACE_TYPE_SNAP,
> > +       OCELOT_ACE_TYPE_ARP,
> > +       OCELOT_ACE_TYPE_IPV4,
> > +       OCELOT_ACE_TYPE_IPV6
> > +};
> > +
> > +struct ocelot_ace_vlan {
> > +       struct ocelot_vcap_vid vid;    /* VLAN ID (12 bit) */
> > +       struct ocelot_vcap_u8  pcp;    /* PCP (3 bit) */
> > +       enum ocelot_vcap_bit dei;    /* DEI */
> > +       enum ocelot_vcap_bit tagged; /* Tagged/untagged frame */
> > +};
> > +
> > +struct ocelot_ace_frame_etype {
> > +       struct ocelot_vcap_u48 dmac;
> > +       struct ocelot_vcap_u48 smac;
> > +       struct ocelot_vcap_u16 etype;
> > +       struct ocelot_vcap_u16 data; /* MAC data */
> > +};
> > +
> > +struct ocelot_ace_frame_llc {
> > +       struct ocelot_vcap_u48 dmac;
> > +       struct ocelot_vcap_u48 smac;
> > +
> > +       /* LLC header: DSAP at byte 0, SSAP at byte 1, Control at byte 2 */
> > +       struct ocelot_vcap_u32 llc;
> > +};
> > +
> > +struct ocelot_ace_frame_snap {
> > +       struct ocelot_vcap_u48 dmac;
> > +       struct ocelot_vcap_u48 smac;
> > +
> > +       /* SNAP header: Organization Code at byte 0, Type at byte 3 */
> > +       struct ocelot_vcap_u40 snap;
> > +};
> > +
> > +struct ocelot_ace_frame_arp {
> > +       struct ocelot_vcap_u48 smac;
> > +       enum ocelot_vcap_bit arp;       /* Opcode ARP/RARP */
> > +       enum ocelot_vcap_bit req;       /* Opcode request/reply */
> > +       enum ocelot_vcap_bit unknown;    /* Opcode unknown */
> > +       enum ocelot_vcap_bit smac_match; /* Sender MAC matches SMAC */
> > +       enum ocelot_vcap_bit dmac_match; /* Target MAC matches DMAC */
> > +
> > +       /**< Protocol addr. length 4, hardware length 6 */
> > +       enum ocelot_vcap_bit length;
> > +
> > +       enum ocelot_vcap_bit ip;       /* Protocol address type IP */
> > +       enum  ocelot_vcap_bit ethernet; /* Hardware address type Ethernet */
> > +       struct ocelot_vcap_ipv4 sip;     /* Sender IP address */
> > +       struct ocelot_vcap_ipv4 dip;     /* Target IP address */
> > +};
> > +
> > +struct ocelot_ace_frame_ipv4 {
> > +       enum ocelot_vcap_bit ttl;      /* TTL zero */
> > +       enum ocelot_vcap_bit fragment; /* Fragment */
> > +       enum ocelot_vcap_bit options;  /* Header options */
> > +       struct ocelot_vcap_u8 ds;
> > +       struct ocelot_vcap_u8 proto;      /* Protocol */
> > +       struct ocelot_vcap_ipv4 sip;      /* Source IP address */
> > +       struct ocelot_vcap_ipv4 dip;      /* Destination IP address */
> > +       struct ocelot_vcap_u48 data;      /* Not UDP/TCP: IP data */
> > +       struct ocelot_vcap_udp_tcp sport; /* UDP/TCP: Source port */
> > +       struct ocelot_vcap_udp_tcp dport; /* UDP/TCP: Destination port */
> > +       enum ocelot_vcap_bit tcp_fin;
> > +       enum ocelot_vcap_bit tcp_syn;
> > +       enum ocelot_vcap_bit tcp_rst;
> > +       enum ocelot_vcap_bit tcp_psh;
> > +       enum ocelot_vcap_bit tcp_ack;
> > +       enum ocelot_vcap_bit tcp_urg;
> > +       enum ocelot_vcap_bit sip_eq_dip;     /* SIP equals DIP  */
> > +       enum ocelot_vcap_bit sport_eq_dport; /* SPORT equals DPORT  */
> > +       enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
> > +};
> > +
> > +struct ocelot_ace_frame_ipv6 {
> > +       struct ocelot_vcap_u8 proto; /* IPv6 protocol */
> > +       struct ocelot_vcap_u128 sip; /* IPv6 source (byte 0-7 ignored) */
> > +       enum ocelot_vcap_bit ttl;  /* TTL zero */
> > +       struct ocelot_vcap_u8 ds;
> > +       struct ocelot_vcap_u48 data; /* Not UDP/TCP: IP data */
> > +       struct ocelot_vcap_udp_tcp sport;
> > +       struct ocelot_vcap_udp_tcp dport;
> > +       enum ocelot_vcap_bit tcp_fin;
> > +       enum ocelot_vcap_bit tcp_syn;
> > +       enum ocelot_vcap_bit tcp_rst;
> > +       enum ocelot_vcap_bit tcp_psh;
> > +       enum ocelot_vcap_bit tcp_ack;
> > +       enum ocelot_vcap_bit tcp_urg;
> > +       enum ocelot_vcap_bit sip_eq_dip;     /* SIP equals DIP  */
> > +       enum ocelot_vcap_bit sport_eq_dport; /* SPORT equals DPORT  */
> > +       enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
> > +};
> > +
> > +enum ocelot_ace_action {
> > +       OCELOT_ACL_ACTION_DROP,
> > +       OCELOT_ACL_ACTION_TRAP,
> > +};
> > +
> > +struct ocelot_ace_stats {
> > +       u64 bytes;
> > +       u64 pkts;
> > +       u64 used;
> > +};
> > +
> > +struct ocelot_ace_rule {
> > +       struct list_head list;
> > +       struct ocelot_port *port;
> > +
> > +       u16 prio;
> > +       u32 id;
> > +
> > +       enum ocelot_ace_action action;
> > +       struct ocelot_ace_stats stats;
> > +       int chip_port;
> > +
> > +       enum ocelot_vcap_bit dmac_mc;
> > +       enum ocelot_vcap_bit dmac_bc;
> > +       struct ocelot_ace_vlan vlan;
> > +
> > +       enum ocelot_ace_type type;
> > +       union {
> > +               /* ocelot_ACE_TYPE_ANY: No specific fields */
> > +               struct ocelot_ace_frame_etype etype;
> > +               struct ocelot_ace_frame_llc llc;
> > +               struct ocelot_ace_frame_snap snap;
> > +               struct ocelot_ace_frame_arp arp;
> > +               struct ocelot_ace_frame_ipv4 ipv4;
> > +               struct ocelot_ace_frame_ipv6 ipv6;
> > +       } frame;
> > +};
> > +
> > +struct ocelot_acl_block {
> > +       struct list_head rules;
> > +       struct ocelot *ocelot;
> > +       int count;
> > +};
> > +
> > +int ocelot_ace_rule_offload_add(struct ocelot_ace_rule *rule);
> > +int ocelot_ace_rule_offload_del(struct ocelot_ace_rule *rule);
> > +int ocelot_ace_rule_stats_update(struct ocelot_ace_rule *rule);
> > +
> > +int ocelot_ace_init(struct ocelot *ocelot);
> > +void ocelot_ace_deinit(void);
> > +
> > +#endif /* _MSCC_OCELOT_ACE_H_ */
> > diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
> > index e7f9010..58bde1a 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_board.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_board.c
> > @@ -188,6 +188,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >                 { QSYS, "qsys" },
> >                 { ANA, "ana" },
> >                 { QS, "qs" },
> > +               { S2, "s2" },
> >         };
> >
> >         if (!np && !pdev->dev.platform_data)
> > diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
> > index 9271af1..6c387f9 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_regs.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_regs.c
> > @@ -224,12 +224,23 @@ static const u32 ocelot_sys_regmap[] = {
> >         REG(SYS_PTP_CFG,                   0x0006c4),
> >  };
> >
> > +static const u32 ocelot_s2_regmap[] = {
> > +       REG(S2_CORE_UPDATE_CTRL,           0x000000),
> > +       REG(S2_CORE_MV_CFG,                0x000004),
> > +       REG(S2_CACHE_ENTRY_DAT,            0x000008),
> > +       REG(S2_CACHE_MASK_DAT,             0x000108),
> > +       REG(S2_CACHE_ACTION_DAT,           0x000208),
> > +       REG(S2_CACHE_CNT_DAT,              0x000308),
> > +       REG(S2_CACHE_TG_DAT,               0x000388),
> > +};
> > +
> >  static const u32 *ocelot_regmap[] = {
> >         [ANA] = ocelot_ana_regmap,
> >         [QS] = ocelot_qs_regmap,
> >         [QSYS] = ocelot_qsys_regmap,
> >         [REW] = ocelot_rew_regmap,
> >         [SYS] = ocelot_sys_regmap,
> > +       [S2] = ocelot_s2_regmap,
> >  };
> >
> >  static const struct reg_field ocelot_regfields[] = {
> > diff --git a/drivers/net/ethernet/mscc/ocelot_s2.h b/drivers/net/ethernet/mscc/ocelot_s2.h
> > new file mode 100644
> > index 0000000..80107be
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mscc/ocelot_s2.h
> > @@ -0,0 +1,64 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> > +/* Microsemi Ocelot Switch driver
> > + * Copyright (c) 2018 Microsemi Corporation
> > + */
> > +
> > +#ifndef _OCELOT_S2_CORE_H_
> > +#define _OCELOT_S2_CORE_H_
> > +
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_CMD(x)      (((x) << 22) & GENMASK(24, 22))
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_CMD_M       GENMASK(24, 22)
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_CMD_X(x)    (((x) & GENMASK(24, 22)) >> 22)
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_ENTRY_DIS   BIT(21)
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_ACTION_DIS  BIT(20)
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_CNT_DIS     BIT(19)
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_ADDR(x)     (((x) << 3) & GENMASK(18, 3))
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_ADDR_M      GENMASK(18, 3)
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_ADDR_X(x)   (((x) & GENMASK(18, 3)) >> 3)
> > +#define S2_CORE_UPDATE_CTRL_UPDATE_SHOT        BIT(2)
> > +#define S2_CORE_UPDATE_CTRL_CLEAR_CACHE        BIT(1)
> > +#define S2_CORE_UPDATE_CTRL_MV_TRAFFIC_IGN     BIT(0)
> > +
> > +#define S2_CORE_MV_CFG_MV_NUM_POS(x)           (((x) << 16) & GENMASK(31, 16))
> > +#define S2_CORE_MV_CFG_MV_NUM_POS_M            GENMASK(31, 16)
> > +#define S2_CORE_MV_CFG_MV_NUM_POS_X(x)         (((x) & GENMASK(31, 16)) >> 16)
> > +#define S2_CORE_MV_CFG_MV_SIZE(x)              ((x) & GENMASK(15, 0))
> > +#define S2_CORE_MV_CFG_MV_SIZE_M               GENMASK(15, 0)
> > +
> > +#define S2_CACHE_ENTRY_DAT_RSZ                 0x4
> > +
> > +#define S2_CACHE_MASK_DAT_RSZ                  0x4
> > +
> > +#define S2_CACHE_ACTION_DAT_RSZ                0x4
> > +
> > +#define S2_CACHE_CNT_DAT_RSZ                   0x4
> > +
> > +#define S2_STICKY_VCAP_ROW_DELETED_STICKY      BIT(0)
> > +
> > +#define S2_BIST_CTRL_TCAM_BIST                 BIT(1)
> > +#define S2_BIST_CTRL_TCAM_INIT                 BIT(0)
> > +
> > +#define S2_BIST_CFG_TCAM_BIST_SOE_ENA          BIT(8)
> > +#define S2_BIST_CFG_TCAM_HCG_DIS               BIT(7)
> > +#define S2_BIST_CFG_TCAM_CG_DIS                BIT(6)
> > +#define S2_BIST_CFG_TCAM_BIAS(x)               ((x) & GENMASK(5, 0))
> > +#define S2_BIST_CFG_TCAM_BIAS_M                GENMASK(5, 0)
> > +
> > +#define S2_BIST_STAT_BIST_RT_ERR               BIT(15)
> > +#define S2_BIST_STAT_BIST_PENC_ERR             BIT(14)
> > +#define S2_BIST_STAT_BIST_COMP_ERR             BIT(13)
> > +#define S2_BIST_STAT_BIST_ADDR_ERR             BIT(12)
> > +#define S2_BIST_STAT_BIST_BL1E_ERR             BIT(11)
> > +#define S2_BIST_STAT_BIST_BL1_ERR              BIT(10)
> > +#define S2_BIST_STAT_BIST_BL0E_ERR             BIT(9)
> > +#define S2_BIST_STAT_BIST_BL0_ERR              BIT(8)
> > +#define S2_BIST_STAT_BIST_PH1_ERR              BIT(7)
> > +#define S2_BIST_STAT_BIST_PH0_ERR              BIT(6)
> > +#define S2_BIST_STAT_BIST_PV1_ERR              BIT(5)
> > +#define S2_BIST_STAT_BIST_PV0_ERR              BIT(4)
> > +#define S2_BIST_STAT_BIST_RUN                  BIT(3)
> > +#define S2_BIST_STAT_BIST_ERR                  BIT(2)
> > +#define S2_BIST_STAT_BIST_BUSY                 BIT(1)
> > +#define S2_BIST_STAT_TCAM_RDY                  BIT(0)
> > +
> > +#endif /* _OCELOT_S2_CORE_H_ */
> > diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
> > new file mode 100644
> > index 0000000..e22eac1
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
> > @@ -0,0 +1,403 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > + * Microsemi Ocelot Switch driver
> > + * Copyright (c) 2019 Microsemi Corporation
> > + */
> > +
> > +#ifndef _OCELOT_VCAP_H_
> > +#define _OCELOT_VCAP_H_
> > +
> > +/* =================================================================
> > + *  VCAP Common
> > + * =================================================================
> > + */
> > +
> > +/* VCAP Type-Group values */
> > +#define VCAP_TG_NONE 0 /* Entry is invalid */
> > +#define VCAP_TG_FULL 1 /* Full entry */
> > +#define VCAP_TG_HALF 2 /* Half entry */
> > +#define VCAP_TG_QUARTER 3 /* Quarter entry */
> > +
> > +/* =================================================================
> > + *  VCAP IS2
> > + * =================================================================
> > + */
> > +
> > +#define VCAP_IS2_CNT 64
> > +#define VCAP_IS2_ENTRY_WIDTH 376
> > +#define VCAP_IS2_ACTION_WIDTH 99
> > +#define VCAP_PORT_CNT 11
> > +
> > +/* IS2 half key types */
> > +#define IS2_TYPE_ETYPE 0
> > +#define IS2_TYPE_LLC 1
> > +#define IS2_TYPE_SNAP 2
> > +#define IS2_TYPE_ARP 3
> > +#define IS2_TYPE_IP_UDP_TCP 4
> > +#define IS2_TYPE_IP_OTHER 5
> > +#define IS2_TYPE_IPV6 6
> > +#define IS2_TYPE_OAM 7
> > +#define IS2_TYPE_SMAC_SIP6 8
> > +#define IS2_TYPE_ANY 100 /* Pseudo type */
> > +
> > +/* IS2 half key type mask for matching any IP */
> > +#define IS2_TYPE_MASK_IP_ANY 0xe
> > +
> > +/* IS2 action types */
> > +#define IS2_ACTION_TYPE_NORMAL 0
> > +#define IS2_ACTION_TYPE_SMAC_SIP 1
> > +
> > +/* IS2 MASK_MODE values */
> > +#define IS2_ACT_MASK_MODE_NONE 0
> > +#define IS2_ACT_MASK_MODE_FILTER 1
> > +#define IS2_ACT_MASK_MODE_POLICY 2
> > +#define IS2_ACT_MASK_MODE_REDIR 3
> > +
> > +/* IS2 REW_OP values */
> > +#define IS2_ACT_REW_OP_NONE 0
> > +#define IS2_ACT_REW_OP_PTP_ONE 2
> > +#define IS2_ACT_REW_OP_PTP_TWO 3
> > +#define IS2_ACT_REW_OP_SPECIAL 8
> > +#define IS2_ACT_REW_OP_PTP_ORG 9
> > +#define IS2_ACT_REW_OP_PTP_ONE_SUB_DELAY_1 (IS2_ACT_REW_OP_PTP_ONE | (1 << 3))
> > +#define IS2_ACT_REW_OP_PTP_ONE_SUB_DELAY_2 (IS2_ACT_REW_OP_PTP_ONE | (2 << 3))
> > +#define IS2_ACT_REW_OP_PTP_ONE_ADD_DELAY (IS2_ACT_REW_OP_PTP_ONE | (1 << 5))
> > +#define IS2_ACT_REW_OP_PTP_ONE_ADD_SUB BIT(7)
> > +
> > +#define VCAP_PORT_WIDTH 4
> > +
> > +/* IS2 quarter key - SMAC_SIP4 */
> > +#define IS2_QKO_IGR_PORT 0
> > +#define IS2_QKL_IGR_PORT VCAP_PORT_WIDTH
> > +#define IS2_QKO_L2_SMAC (IS2_QKO_IGR_PORT + IS2_QKL_IGR_PORT)
> > +#define IS2_QKL_L2_SMAC 48
> > +#define IS2_QKO_L3_IP4_SIP (IS2_QKO_L2_SMAC + IS2_QKL_L2_SMAC)
> > +#define IS2_QKL_L3_IP4_SIP 32
> > +
> > +/* IS2 half key - common */
> > +#define IS2_HKO_TYPE 0
> > +#define IS2_HKL_TYPE 4
> > +#define IS2_HKO_FIRST (IS2_HKO_TYPE + IS2_HKL_TYPE)
> > +#define IS2_HKL_FIRST 1
> > +#define IS2_HKO_PAG (IS2_HKO_FIRST + IS2_HKL_FIRST)
> > +#define IS2_HKL_PAG 8
> > +#define IS2_HKO_IGR_PORT_MASK (IS2_HKO_PAG + IS2_HKL_PAG)
> > +#define IS2_HKL_IGR_PORT_MASK (VCAP_PORT_CNT + 1)
> > +#define IS2_HKO_SERVICE_FRM (IS2_HKO_IGR_PORT_MASK + IS2_HKL_IGR_PORT_MASK)
> > +#define IS2_HKL_SERVICE_FRM 1
> > +#define IS2_HKO_HOST_MATCH (IS2_HKO_SERVICE_FRM + IS2_HKL_SERVICE_FRM)
> > +#define IS2_HKL_HOST_MATCH 1
> > +#define IS2_HKO_L2_MC (IS2_HKO_HOST_MATCH + IS2_HKL_HOST_MATCH)
> > +#define IS2_HKL_L2_MC 1
> > +#define IS2_HKO_L2_BC (IS2_HKO_L2_MC + IS2_HKL_L2_MC)
> > +#define IS2_HKL_L2_BC 1
> > +#define IS2_HKO_VLAN_TAGGED (IS2_HKO_L2_BC + IS2_HKL_L2_BC)
> > +#define IS2_HKL_VLAN_TAGGED 1
> > +#define IS2_HKO_VID (IS2_HKO_VLAN_TAGGED + IS2_HKL_VLAN_TAGGED)
> > +#define IS2_HKL_VID 12
> > +#define IS2_HKO_DEI (IS2_HKO_VID + IS2_HKL_VID)
> > +#define IS2_HKL_DEI 1
> > +#define IS2_HKO_PCP (IS2_HKO_DEI + IS2_HKL_DEI)
> > +#define IS2_HKL_PCP 3
> > +
> > +/* IS2 half key - MAC_ETYPE/MAC_LLC/MAC_SNAP/OAM common */
> > +#define IS2_HKO_L2_DMAC (IS2_HKO_PCP + IS2_HKL_PCP)
> > +#define IS2_HKL_L2_DMAC 48
> > +#define IS2_HKO_L2_SMAC (IS2_HKO_L2_DMAC + IS2_HKL_L2_DMAC)
> > +#define IS2_HKL_L2_SMAC 48
> > +
> > +/* IS2 half key - MAC_ETYPE */
> > +#define IS2_HKO_MAC_ETYPE_ETYPE (IS2_HKO_L2_SMAC + IS2_HKL_L2_SMAC)
> > +#define IS2_HKL_MAC_ETYPE_ETYPE 16
> > +#define IS2_HKO_MAC_ETYPE_L2_PAYLOAD                                           \
> > +       (IS2_HKO_MAC_ETYPE_ETYPE + IS2_HKL_MAC_ETYPE_ETYPE)
> > +#define IS2_HKL_MAC_ETYPE_L2_PAYLOAD 27
> > +
> > +/* IS2 half key - MAC_LLC */
> > +#define IS2_HKO_MAC_LLC_L2_LLC IS2_HKO_MAC_ETYPE_ETYPE
> > +#define IS2_HKL_MAC_LLC_L2_LLC 40
> > +
> > +/* IS2 half key - MAC_SNAP */
> > +#define IS2_HKO_MAC_SNAP_L2_SNAP IS2_HKO_MAC_ETYPE_ETYPE
> > +#define IS2_HKL_MAC_SNAP_L2_SNAP 40
> > +
> > +/* IS2 half key - ARP */
> > +#define IS2_HKO_MAC_ARP_L2_SMAC IS2_HKO_L2_DMAC
> > +#define IS2_HKL_MAC_ARP_L2_SMAC 48
> > +#define IS2_HKO_MAC_ARP_ARP_ADDR_SPACE_OK                                      \
> > +       (IS2_HKO_MAC_ARP_L2_SMAC + IS2_HKL_MAC_ARP_L2_SMAC)
> > +#define IS2_HKL_MAC_ARP_ARP_ADDR_SPACE_OK 1
> > +#define IS2_HKO_MAC_ARP_ARP_PROTO_SPACE_OK                                     \
> > +       (IS2_HKO_MAC_ARP_ARP_ADDR_SPACE_OK + IS2_HKL_MAC_ARP_ARP_ADDR_SPACE_OK)
> > +#define IS2_HKL_MAC_ARP_ARP_PROTO_SPACE_OK 1
> > +#define IS2_HKO_MAC_ARP_ARP_LEN_OK                                             \
> > +       (IS2_HKO_MAC_ARP_ARP_PROTO_SPACE_OK +                                  \
> > +        IS2_HKL_MAC_ARP_ARP_PROTO_SPACE_OK)
> > +#define IS2_HKL_MAC_ARP_ARP_LEN_OK 1
> > +#define IS2_HKO_MAC_ARP_ARP_TGT_MATCH                                          \
> > +       (IS2_HKO_MAC_ARP_ARP_LEN_OK + IS2_HKL_MAC_ARP_ARP_LEN_OK)
> > +#define IS2_HKL_MAC_ARP_ARP_TGT_MATCH 1
> > +#define IS2_HKO_MAC_ARP_ARP_SENDER_MATCH                                       \
> > +       (IS2_HKO_MAC_ARP_ARP_TGT_MATCH + IS2_HKL_MAC_ARP_ARP_TGT_MATCH)
> > +#define IS2_HKL_MAC_ARP_ARP_SENDER_MATCH 1
> > +#define IS2_HKO_MAC_ARP_ARP_OPCODE_UNKNOWN                                     \
> > +       (IS2_HKO_MAC_ARP_ARP_SENDER_MATCH + IS2_HKL_MAC_ARP_ARP_SENDER_MATCH)
> > +#define IS2_HKL_MAC_ARP_ARP_OPCODE_UNKNOWN 1
> > +#define IS2_HKO_MAC_ARP_ARP_OPCODE                                             \
> > +       (IS2_HKO_MAC_ARP_ARP_OPCODE_UNKNOWN +                                  \
> > +        IS2_HKL_MAC_ARP_ARP_OPCODE_UNKNOWN)
> > +#define IS2_HKL_MAC_ARP_ARP_OPCODE 2
> > +#define IS2_HKO_MAC_ARP_L3_IP4_DIP                                             \
> > +       (IS2_HKO_MAC_ARP_ARP_OPCODE + IS2_HKL_MAC_ARP_ARP_OPCODE)
> > +#define IS2_HKL_MAC_ARP_L3_IP4_DIP 32
> > +#define IS2_HKO_MAC_ARP_L3_IP4_SIP                                             \
> > +       (IS2_HKO_MAC_ARP_L3_IP4_DIP + IS2_HKL_MAC_ARP_L3_IP4_DIP)
> > +#define IS2_HKL_MAC_ARP_L3_IP4_SIP 32
> > +#define IS2_HKO_MAC_ARP_DIP_EQ_SIP                                             \
> > +       (IS2_HKO_MAC_ARP_L3_IP4_SIP + IS2_HKL_MAC_ARP_L3_IP4_SIP)
> > +#define IS2_HKL_MAC_ARP_DIP_EQ_SIP 1
> > +
> > +/* IS2 half key - IP4_TCP_UDP/IP4_OTHER common */
> > +#define IS2_HKO_IP4 IS2_HKO_L2_DMAC
> > +#define IS2_HKL_IP4 1
> > +#define IS2_HKO_L3_FRAGMENT (IS2_HKO_IP4 + IS2_HKL_IP4)
> > +#define IS2_HKL_L3_FRAGMENT 1
> > +#define IS2_HKO_L3_FRAG_OFS_GT0 (IS2_HKO_L3_FRAGMENT + IS2_HKL_L3_FRAGMENT)
> > +#define IS2_HKL_L3_FRAG_OFS_GT0 1
> > +#define IS2_HKO_L3_OPTIONS (IS2_HKO_L3_FRAG_OFS_GT0 + IS2_HKL_L3_FRAG_OFS_GT0)
> > +#define IS2_HKL_L3_OPTIONS 1
> > +#define IS2_HKO_L3_TTL_GT0 (IS2_HKO_L3_OPTIONS + IS2_HKL_L3_OPTIONS)
> > +#define IS2_HKL_L3_TTL_GT0 1
> > +#define IS2_HKO_L3_TOS (IS2_HKO_L3_TTL_GT0 + IS2_HKL_L3_TTL_GT0)
> > +#define IS2_HKL_L3_TOS 8
> > +#define IS2_HKO_L3_IP4_DIP (IS2_HKO_L3_TOS + IS2_HKL_L3_TOS)
> > +#define IS2_HKL_L3_IP4_DIP 32
> > +#define IS2_HKO_L3_IP4_SIP (IS2_HKO_L3_IP4_DIP + IS2_HKL_L3_IP4_DIP)
> > +#define IS2_HKL_L3_IP4_SIP 32
> > +#define IS2_HKO_DIP_EQ_SIP (IS2_HKO_L3_IP4_SIP + IS2_HKL_L3_IP4_SIP)
> > +#define IS2_HKL_DIP_EQ_SIP 1
> > +
> > +/* IS2 half key - IP4_TCP_UDP */
> > +#define IS2_HKO_IP4_TCP_UDP_TCP (IS2_HKO_DIP_EQ_SIP + IS2_HKL_DIP_EQ_SIP)
> > +#define IS2_HKL_IP4_TCP_UDP_TCP 1
> > +#define IS2_HKO_IP4_TCP_UDP_L4_DPORT                                           \
> > +       (IS2_HKO_IP4_TCP_UDP_TCP + IS2_HKL_IP4_TCP_UDP_TCP)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_DPORT 16
> > +#define IS2_HKO_IP4_TCP_UDP_L4_SPORT                                           \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_DPORT + IS2_HKL_IP4_TCP_UDP_L4_DPORT)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_SPORT 16
> > +#define IS2_HKO_IP4_TCP_UDP_L4_RNG                                             \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_SPORT + IS2_HKL_IP4_TCP_UDP_L4_SPORT)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_RNG 8
> > +#define IS2_HKO_IP4_TCP_UDP_SPORT_EQ_DPORT                                     \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_RNG + IS2_HKL_IP4_TCP_UDP_L4_RNG)
> > +#define IS2_HKL_IP4_TCP_UDP_SPORT_EQ_DPORT 1
> > +#define IS2_HKO_IP4_TCP_UDP_SEQUENCE_EQ0                                       \
> > +       (IS2_HKO_IP4_TCP_UDP_SPORT_EQ_DPORT +                                  \
> > +        IS2_HKL_IP4_TCP_UDP_SPORT_EQ_DPORT)
> > +#define IS2_HKL_IP4_TCP_UDP_SEQUENCE_EQ0 1
> > +#define IS2_HKO_IP4_TCP_UDP_L4_FIN                                             \
> > +       (IS2_HKO_IP4_TCP_UDP_SEQUENCE_EQ0 + IS2_HKL_IP4_TCP_UDP_SEQUENCE_EQ0)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_FIN 1
> > +#define IS2_HKO_IP4_TCP_UDP_L4_SYN                                             \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_FIN + IS2_HKL_IP4_TCP_UDP_L4_FIN)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_SYN 1
> > +#define IS2_HKO_IP4_TCP_UDP_L4_RST                                             \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_SYN + IS2_HKL_IP4_TCP_UDP_L4_SYN)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_RST 1
> > +#define IS2_HKO_IP4_TCP_UDP_L4_PSH                                             \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_RST + IS2_HKL_IP4_TCP_UDP_L4_RST)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_PSH 1
> > +#define IS2_HKO_IP4_TCP_UDP_L4_ACK                                             \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_PSH + IS2_HKL_IP4_TCP_UDP_L4_PSH)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_ACK 1
> > +#define IS2_HKO_IP4_TCP_UDP_L4_URG                                             \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_ACK + IS2_HKL_IP4_TCP_UDP_L4_ACK)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_URG 1
> > +#define IS2_HKO_IP4_TCP_UDP_L4_1588_DOM                                        \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_URG + IS2_HKL_IP4_TCP_UDP_L4_URG)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_1588_DOM 8
> > +#define IS2_HKO_IP4_TCP_UDP_L4_1588_VER                                        \
> > +       (IS2_HKO_IP4_TCP_UDP_L4_1588_DOM + IS2_HKL_IP4_TCP_UDP_L4_1588_DOM)
> > +#define IS2_HKL_IP4_TCP_UDP_L4_1588_VER 4
> > +
> > +/* IS2 half key - IP4_OTHER */
> > +#define IS2_HKO_IP4_OTHER_L3_PROTO IS2_HKO_IP4_TCP_UDP_TCP
> > +#define IS2_HKL_IP4_OTHER_L3_PROTO 8
> > +#define IS2_HKO_IP4_OTHER_L3_PAYLOAD                                           \
> > +       (IS2_HKO_IP4_OTHER_L3_PROTO + IS2_HKL_IP4_OTHER_L3_PROTO)
> > +#define IS2_HKL_IP4_OTHER_L3_PAYLOAD 56
> > +
> > +/* IS2 half key - IP6_STD */
> > +#define IS2_HKO_IP6_STD_L3_TTL_GT0 IS2_HKO_L2_DMAC
> > +#define IS2_HKL_IP6_STD_L3_TTL_GT0 1
> > +#define IS2_HKO_IP6_STD_L3_IP6_SIP                                             \
> > +       (IS2_HKO_IP6_STD_L3_TTL_GT0 + IS2_HKL_IP6_STD_L3_TTL_GT0)
> > +#define IS2_HKL_IP6_STD_L3_IP6_SIP 128
> > +#define IS2_HKO_IP6_STD_L3_PROTO                                               \
> > +       (IS2_HKO_IP6_STD_L3_IP6_SIP + IS2_HKL_IP6_STD_L3_IP6_SIP)
> > +#define IS2_HKL_IP6_STD_L3_PROTO 8
> > +
> > +/* IS2 half key - OAM */
> > +#define IS2_HKO_OAM_OAM_MEL_FLAGS IS2_HKO_MAC_ETYPE_ETYPE
> > +#define IS2_HKL_OAM_OAM_MEL_FLAGS 7
> > +#define IS2_HKO_OAM_OAM_VER                                                    \
> > +       (IS2_HKO_OAM_OAM_MEL_FLAGS + IS2_HKL_OAM_OAM_MEL_FLAGS)
> > +#define IS2_HKL_OAM_OAM_VER 5
> > +#define IS2_HKO_OAM_OAM_OPCODE (IS2_HKO_OAM_OAM_VER + IS2_HKL_OAM_OAM_VER)
> > +#define IS2_HKL_OAM_OAM_OPCODE 8
> > +#define IS2_HKO_OAM_OAM_FLAGS (IS2_HKO_OAM_OAM_OPCODE + IS2_HKL_OAM_OAM_OPCODE)
> > +#define IS2_HKL_OAM_OAM_FLAGS 8
> > +#define IS2_HKO_OAM_OAM_MEPID (IS2_HKO_OAM_OAM_FLAGS + IS2_HKL_OAM_OAM_FLAGS)
> > +#define IS2_HKL_OAM_OAM_MEPID 16
> > +#define IS2_HKO_OAM_OAM_CCM_CNTS_EQ0                                           \
> > +       (IS2_HKO_OAM_OAM_MEPID + IS2_HKL_OAM_OAM_MEPID)
> > +#define IS2_HKL_OAM_OAM_CCM_CNTS_EQ0 1
> > +
> > +/* IS2 half key - SMAC_SIP6 */
> > +#define IS2_HKO_SMAC_SIP6_IGR_PORT IS2_HKL_TYPE
> > +#define IS2_HKL_SMAC_SIP6_IGR_PORT VCAP_PORT_WIDTH
> > +#define IS2_HKO_SMAC_SIP6_L2_SMAC                                              \
> > +       (IS2_HKO_SMAC_SIP6_IGR_PORT + IS2_HKL_SMAC_SIP6_IGR_PORT)
> > +#define IS2_HKL_SMAC_SIP6_L2_SMAC 48
> > +#define IS2_HKO_SMAC_SIP6_L3_IP6_SIP                                           \
> > +       (IS2_HKO_SMAC_SIP6_L2_SMAC + IS2_HKL_SMAC_SIP6_L2_SMAC)
> > +#define IS2_HKL_SMAC_SIP6_L3_IP6_SIP 128
> > +
> > +/* IS2 full key - common */
> > +#define IS2_FKO_TYPE 0
> > +#define IS2_FKL_TYPE 2
> > +#define IS2_FKO_FIRST (IS2_FKO_TYPE + IS2_FKL_TYPE)
> > +#define IS2_FKL_FIRST 1
> > +#define IS2_FKO_PAG (IS2_FKO_FIRST + IS2_FKL_FIRST)
> > +#define IS2_FKL_PAG 8
> > +#define IS2_FKO_IGR_PORT_MASK (IS2_FKO_PAG + IS2_FKL_PAG)
> > +#define IS2_FKL_IGR_PORT_MASK (VCAP_PORT_CNT + 1)
> > +#define IS2_FKO_SERVICE_FRM (IS2_FKO_IGR_PORT_MASK + IS2_FKL_IGR_PORT_MASK)
> > +#define IS2_FKL_SERVICE_FRM 1
> > +#define IS2_FKO_HOST_MATCH (IS2_FKO_SERVICE_FRM + IS2_FKL_SERVICE_FRM)
> > +#define IS2_FKL_HOST_MATCH 1
> > +#define IS2_FKO_L2_MC (IS2_FKO_HOST_MATCH + IS2_FKL_HOST_MATCH)
> > +#define IS2_FKL_L2_MC 1
> > +#define IS2_FKO_L2_BC (IS2_FKO_L2_MC + IS2_FKL_L2_MC)
> > +#define IS2_FKL_L2_BC 1
> > +#define IS2_FKO_VLAN_TAGGED (IS2_FKO_L2_BC + IS2_FKL_L2_BC)
> > +#define IS2_FKL_VLAN_TAGGED 1
> > +#define IS2_FKO_VID (IS2_FKO_VLAN_TAGGED + IS2_FKL_VLAN_TAGGED)
> > +#define IS2_FKL_VID 12
> > +#define IS2_FKO_DEI (IS2_FKO_VID + IS2_FKL_VID)
> > +#define IS2_FKL_DEI 1
> > +#define IS2_FKO_PCP (IS2_FKO_DEI + IS2_FKL_DEI)
> > +#define IS2_FKL_PCP 3
> > +
> > +/* IS2 full key - IP6_TCP_UDP/IP6_OTHER common */
> > +#define IS2_FKO_L3_TTL_GT0 (IS2_FKO_PCP + IS2_FKL_PCP)
> > +#define IS2_FKL_L3_TTL_GT0 1
> > +#define IS2_FKO_L3_TOS (IS2_FKO_L3_TTL_GT0 + IS2_FKL_L3_TTL_GT0)
> > +#define IS2_FKL_L3_TOS 8
> > +#define IS2_FKO_L3_IP6_DIP (IS2_FKO_L3_TOS + IS2_FKL_L3_TOS)
> > +#define IS2_FKL_L3_IP6_DIP 128
> > +#define IS2_FKO_L3_IP6_SIP (IS2_FKO_L3_IP6_DIP + IS2_FKL_L3_IP6_DIP)
> > +#define IS2_FKL_L3_IP6_SIP 128
> > +#define IS2_FKO_DIP_EQ_SIP (IS2_FKO_L3_IP6_SIP + IS2_FKL_L3_IP6_SIP)
> > +#define IS2_FKL_DIP_EQ_SIP 1
> > +
> > +/* IS2 full key - IP6_TCP_UDP */
> > +#define IS2_FKO_IP6_TCP_UDP_TCP (IS2_FKO_DIP_EQ_SIP + IS2_FKL_DIP_EQ_SIP)
> > +#define IS2_FKL_IP6_TCP_UDP_TCP 1
> > +#define IS2_FKO_IP6_TCP_UDP_L4_DPORT                                           \
> > +       (IS2_FKO_IP6_TCP_UDP_TCP + IS2_FKL_IP6_TCP_UDP_TCP)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_DPORT 16
> > +#define IS2_FKO_IP6_TCP_UDP_L4_SPORT                                           \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_DPORT + IS2_FKL_IP6_TCP_UDP_L4_DPORT)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_SPORT 16
> > +#define IS2_FKO_IP6_TCP_UDP_L4_RNG                                             \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_SPORT + IS2_FKL_IP6_TCP_UDP_L4_SPORT)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_RNG 8
> > +#define IS2_FKO_IP6_TCP_UDP_SPORT_EQ_DPORT                                     \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_RNG + IS2_FKL_IP6_TCP_UDP_L4_RNG)
> > +#define IS2_FKL_IP6_TCP_UDP_SPORT_EQ_DPORT 1
> > +#define IS2_FKO_IP6_TCP_UDP_SEQUENCE_EQ0                                       \
> > +       (IS2_FKO_IP6_TCP_UDP_SPORT_EQ_DPORT +                                  \
> > +        IS2_FKL_IP6_TCP_UDP_SPORT_EQ_DPORT)
> > +#define IS2_FKL_IP6_TCP_UDP_SEQUENCE_EQ0 1
> > +#define IS2_FKO_IP6_TCP_UDP_L4_FIN                                             \
> > +       (IS2_FKO_IP6_TCP_UDP_SEQUENCE_EQ0 + IS2_FKL_IP6_TCP_UDP_SEQUENCE_EQ0)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_FIN 1
> > +#define IS2_FKO_IP6_TCP_UDP_L4_SYN                                             \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_FIN + IS2_FKL_IP6_TCP_UDP_L4_FIN)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_SYN 1
> > +#define IS2_FKO_IP6_TCP_UDP_L4_RST                                             \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_SYN + IS2_FKL_IP6_TCP_UDP_L4_SYN)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_RST 1
> > +#define IS2_FKO_IP6_TCP_UDP_L4_PSH                                             \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_RST + IS2_FKL_IP6_TCP_UDP_L4_RST)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_PSH 1
> > +#define IS2_FKO_IP6_TCP_UDP_L4_ACK                                             \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_PSH + IS2_FKL_IP6_TCP_UDP_L4_PSH)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_ACK 1
> > +#define IS2_FKO_IP6_TCP_UDP_L4_URG                                             \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_ACK + IS2_FKL_IP6_TCP_UDP_L4_ACK)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_URG 1
> > +#define IS2_FKO_IP6_TCP_UDP_L4_1588_DOM                                        \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_URG + IS2_FKL_IP6_TCP_UDP_L4_URG)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_1588_DOM 8
> > +#define IS2_FKO_IP6_TCP_UDP_L4_1588_VER                                        \
> > +       (IS2_FKO_IP6_TCP_UDP_L4_1588_DOM + IS2_FKL_IP6_TCP_UDP_L4_1588_DOM)
> > +#define IS2_FKL_IP6_TCP_UDP_L4_1588_VER 4
> > +
> > +/* IS2 full key - IP6_OTHER */
> > +#define IS2_FKO_IP6_OTHER_L3_PROTO IS2_FKO_IP6_TCP_UDP_TCP
> > +#define IS2_FKL_IP6_OTHER_L3_PROTO 8
> > +#define IS2_FKO_IP6_OTHER_L3_PAYLOAD                                           \
> > +       (IS2_FKO_IP6_OTHER_L3_PROTO + IS2_FKL_IP6_OTHER_L3_PROTO)
> > +#define IS2_FKL_IP6_OTHER_L3_PAYLOAD 56
> > +
> > +/* IS2 full key - CUSTOM */
> > +#define IS2_FKO_CUSTOM_CUSTOM_TYPE IS2_FKO_L3_TTL_GT0
> > +#define IS2_FKL_CUSTOM_CUSTOM_TYPE 1
> > +#define IS2_FKO_CUSTOM_CUSTOM                                                  \
> > +       (IS2_FKO_CUSTOM_CUSTOM_TYPE + IS2_FKL_CUSTOM_CUSTOM_TYPE)
> > +#define IS2_FKL_CUSTOM_CUSTOM 320
> > +
> > +/* IS2 action - BASE_TYPE */
> > +#define IS2_AO_HIT_ME_ONCE 0
> > +#define IS2_AL_HIT_ME_ONCE 1
> > +#define IS2_AO_CPU_COPY_ENA (IS2_AO_HIT_ME_ONCE + IS2_AL_HIT_ME_ONCE)
> > +#define IS2_AL_CPU_COPY_ENA 1
> > +#define IS2_AO_CPU_QU_NUM (IS2_AO_CPU_COPY_ENA + IS2_AL_CPU_COPY_ENA)
> > +#define IS2_AL_CPU_QU_NUM 3
> > +#define IS2_AO_MASK_MODE (IS2_AO_CPU_QU_NUM + IS2_AL_CPU_QU_NUM)
> > +#define IS2_AL_MASK_MODE 2
> > +#define IS2_AO_MIRROR_ENA (IS2_AO_MASK_MODE + IS2_AL_MASK_MODE)
> > +#define IS2_AL_MIRROR_ENA 1
> > +#define IS2_AO_LRN_DIS (IS2_AO_MIRROR_ENA + IS2_AL_MIRROR_ENA)
> > +#define IS2_AL_LRN_DIS 1
> > +#define IS2_AO_POLICE_ENA (IS2_AO_LRN_DIS + IS2_AL_LRN_DIS)
> > +#define IS2_AL_POLICE_ENA 1
> > +#define IS2_AO_POLICE_IDX (IS2_AO_POLICE_ENA + IS2_AL_POLICE_ENA)
> > +#define IS2_AL_POLICE_IDX 9
> > +#define IS2_AO_POLICE_VCAP_ONLY (IS2_AO_POLICE_IDX + IS2_AL_POLICE_IDX)
> > +#define IS2_AL_POLICE_VCAP_ONLY 1
> > +#define IS2_AO_PORT_MASK (IS2_AO_POLICE_VCAP_ONLY + IS2_AL_POLICE_VCAP_ONLY)
> > +#define IS2_AL_PORT_MASK VCAP_PORT_CNT
> > +#define IS2_AO_REW_OP (IS2_AO_PORT_MASK + IS2_AL_PORT_MASK)
> > +#define IS2_AL_REW_OP 9
> > +#define IS2_AO_LM_CNT_DIS (IS2_AO_REW_OP + IS2_AL_REW_OP)
> > +#define IS2_AL_LM_CNT_DIS 1
> > +#define IS2_AO_ISDX_ENA                                                        \
> > +       (IS2_AO_LM_CNT_DIS + IS2_AL_LM_CNT_DIS + 1) /* Reserved bit */
> > +#define IS2_AL_ISDX_ENA 1
> > +#define IS2_AO_ACL_ID (IS2_AO_ISDX_ENA + IS2_AL_ISDX_ENA)
> > +#define IS2_AL_ACL_ID 6
> > +
> > +/* IS2 action - SMAC_SIP */
> > +#define IS2_AO_SMAC_SIP_CPU_COPY_ENA 0
> > +#define IS2_AL_SMAC_SIP_CPU_COPY_ENA 1
> > +#define IS2_AO_SMAC_SIP_CPU_QU_NUM 1
> > +#define IS2_AL_SMAC_SIP_CPU_QU_NUM 3
> > +#define IS2_AO_SMAC_SIP_FWD_KILL_ENA 4
> > +#define IS2_AL_SMAC_SIP_FWD_KILL_ENA 1
> > +#define IS2_AO_SMAC_SIP_HOST_MATCH 5
> > +#define IS2_AL_SMAC_SIP_HOST_MATCH 1
> > +
> > +#endif /* _OCELOT_VCAP_H_ */
> > --
> > 2.7.4
> >
> 
> Regards,
> -Vladimir

-- 
/Horatiu
