Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36389B0683
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 03:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbfILBac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 21:30:32 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39253 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfILBac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 21:30:32 -0400
Received: by mail-ed1-f68.google.com with SMTP id u6so22415937edq.6
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 18:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ZVaql9j9NMYQ1gsmxtVZzyasg8HyyteOLjL4IQBSX7U=;
        b=l30NsSjzpfyICN2lprfEIVx74SD/kk2asWz4pI9pnagbhU3phjzeJ30vJjRI03u3bz
         qo7arCZsaMMgtJx9uZDlciNwg5swDEso04KXbwUll9gCD5LscesP7WIZNreezjD7DoMp
         U5IHgsIz2YGWlT1AxZHgLgj68KxJxKPppTixgmwNFGepzRjNH9w2GikF6yt8BAIo5oVb
         t0OqPtklvRksIGqWrCFiXGrJQnrfFX1qNEM5v5KBcHB6amUz4W5mrQjD1pz7HVHS9Jrs
         xKTSUqSoVIw+hW4nC7schcRxqj5A8rBMaBWKu0H7vclQ/clJUO00ySjN162WROLb5fRt
         klJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=ZVaql9j9NMYQ1gsmxtVZzyasg8HyyteOLjL4IQBSX7U=;
        b=dGsyx6qhLg6KwwmDaoxFlacbKBpQ/SKKtlWE923621zrdhapSEwExP9L5019vYJymP
         XUMIBF2ka1NnmerygOMQAjTYL1wE+BYp30qhHcYPSeXJwy2zEzrcsPvOhW9dgHGAYSDw
         LRQNk94w51VNs7fvGDLpsUHSVhT4tB6xQP1i4isC24zXeDkH+5K3MRRa7iGH0x+cG+eP
         Q+th3X1LZtDwAU/dmujWS3XjPShchPXYjUWHzV94IYe7+EA/szMH8EmMnvSEc6PeDwzN
         u66AEk6FBMggPaBk3i5p93M9Ngm8Lks93sfcIY0iXwWkDO0ulyPJpjPa65M6K3OTXf9m
         oHvA==
X-Gm-Message-State: APjAAAUjFwSqWCKSft9BIbR7sr3OOvvxczjtaZaNu/1fZe4n/69bo66+
        Jhss7fqr0neLV5h4x6fGihR5NZzjccx5yi96Dng=
X-Google-Smtp-Source: APXvYqyj/Llq3ro5f7BKoENdUcEjTpNBcZqhuQA7J51owHySdKHNauEjiCWL7sYbLEx3/Ob0xs337i+X3R8OSaXfrkk=
X-Received: by 2002:a50:c351:: with SMTP id q17mr1910621edb.123.1568251829951;
 Wed, 11 Sep 2019 18:30:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:e258:0:0:0:0 with HTTP; Wed, 11 Sep 2019 18:30:29
 -0700 (PDT)
In-Reply-To: <87woeeipm8.fsf@linux.intel.com>
References: <20190902162544.24613-1-olteanv@gmail.com> <20190902162544.24613-13-olteanv@gmail.com>
 <87woeeipm8.fsf@linux.intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 12 Sep 2019 02:30:29 +0100
Message-ID: <CA+h21hqZ=VPauk1HWY2sbm6_qQjSKuyRpgsXj7Hhjgs80D_fjQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 12/15] net: dsa: sja1105: Configure the
 Time-Aware Scheduler via tc-taprio offload
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vedang.patel@intel.com,
        richardcochran@gmail.com, weifeng.voon@intel.com,
        jiri@mellanox.com, m-karicheri2@ti.com, Jose.Abreu@synopsys.com,
        ilias.apalodimas@linaro.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kurt.kanzenbach@linutronix.de,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 11/09/2019, Vinicius Costa Gomes <vinicius.gomes@intel.com> wrote:
> Hi,
>
> Vladimir Oltean <olteanv@gmail.com> writes:
>
>> This qdisc offload is the closest thing to what the SJA1105 supports in
>> hardware for time-based egress shaping. The switch core really is built
>> around SAE AS6802/TTEthernet (a TTTech standard) but can be made to
>> operate similarly to IEEE 802.1Qbv with some constraints:
>>
>> - The gate control list is a global list for all ports. There are 8
>>   execution threads that iterate through this global list in parallel.
>>   I don't know why 8, there are only 4 front-panel ports.
>>
>> - Care must be taken by the user to make sure that two execution threads
>>   never get to execute a GCL entry simultaneously. I created a O(n^4)
>>   checker for this hardware limitation, prior to accepting a taprio
>>   offload configuration as valid.
>>
>> - The spec says that if a GCL entry's interval is shorter than the frame
>>   length, you shouldn't send it (and end up in head-of-line blocking).
>>   Well, this switch does anyway.
>>
>> - The switch has no concept of ADMIN and OPER configurations. Because
>>   it's so simple, the TAS settings are loaded through the static config
>>   tables interface, so there isn't even place for any discussion about
>>   'graceful switchover between ADMIN and OPER'. You just reset the
>>   switch and upload a new OPER config.
>>
>> - The switch accepts multiple time sources for the gate events. Right
>>   now I am using the standalone clock source as opposed to PTP. So the
>>   base time parameter doesn't really do much. Support for the PTP clock
>>   source will be added in the next patch.
>>
>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>> ---
>> Changes since RFC:
>> - Removed the sja1105_tas_config_work workqueue.
>> - Allocating memory with GFP_KERNEL.
>> - Made the ASCII art drawing fit in < 80 characters.
>> - Made most of the time-holding variables s64 instead of u64 (for fear
>>   of them not holding the result of signed arithmetics properly).
>>
>>  drivers/net/dsa/sja1105/Kconfig        |   8 +
>>  drivers/net/dsa/sja1105/Makefile       |   4 +
>>  drivers/net/dsa/sja1105/sja1105.h      |   5 +
>>  drivers/net/dsa/sja1105/sja1105_main.c |  19 +-
>>  drivers/net/dsa/sja1105/sja1105_tas.c  | 420 +++++++++++++++++++++++++
>>  drivers/net/dsa/sja1105/sja1105_tas.h  |  42 +++
>>  6 files changed, 497 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.c
>>  create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.h
>>
>> diff --git a/drivers/net/dsa/sja1105/Kconfig
>> b/drivers/net/dsa/sja1105/Kconfig
>> index 770134a66e48..55424f39cb0d 100644
>> --- a/drivers/net/dsa/sja1105/Kconfig
>> +++ b/drivers/net/dsa/sja1105/Kconfig
>> @@ -23,3 +23,11 @@ config NET_DSA_SJA1105_PTP
>>  	help
>>  	  This enables support for timestamping and PTP clock manipulations in
>>  	  the SJA1105 DSA driver.
>> +
>> +config NET_DSA_SJA1105_TAS
>> +	bool "Support for the Time-Aware Scheduler on NXP SJA1105"
>> +	depends on NET_DSA_SJA1105
>> +	help
>> +	  This enables support for the TTEthernet-based egress scheduling
>> +	  engine in the SJA1105 DSA driver, which is controlled using a
>> +	  hardware offload of the tc-tqprio qdisc.
>> diff --git a/drivers/net/dsa/sja1105/Makefile
>> b/drivers/net/dsa/sja1105/Makefile
>> index 4483113e6259..66161e874344 100644
>> --- a/drivers/net/dsa/sja1105/Makefile
>> +++ b/drivers/net/dsa/sja1105/Makefile
>> @@ -12,3 +12,7 @@ sja1105-objs := \
>>  ifdef CONFIG_NET_DSA_SJA1105_PTP
>>  sja1105-objs += sja1105_ptp.o
>>  endif
>> +
>> +ifdef CONFIG_NET_DSA_SJA1105_TAS
>> +sja1105-objs += sja1105_tas.o
>> +endif
>> diff --git a/drivers/net/dsa/sja1105/sja1105.h
>> b/drivers/net/dsa/sja1105/sja1105.h
>> index 3ca0b87aa3e4..d95f9ce3b4f9 100644
>> --- a/drivers/net/dsa/sja1105/sja1105.h
>> +++ b/drivers/net/dsa/sja1105/sja1105.h
>> @@ -21,6 +21,7 @@
>>  #define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
>>
>>  #include "sja1105_ptp.h"
>> +#include "sja1105_tas.h"
>>
>>  /* Keeps the different addresses between E/T and P/Q/R/S */
>>  struct sja1105_regs {
>> @@ -96,6 +97,7 @@ struct sja1105_private {
>>  	struct mutex mgmt_lock;
>>  	struct sja1105_tagger_data tagger_data;
>>  	struct sja1105_ptp_data ptp_data;
>> +	struct sja1105_tas_data tas_data;
>>  };
>>
>>  #include "sja1105_dynamic_config.h"
>> @@ -111,6 +113,9 @@ typedef enum {
>>  	SPI_WRITE = 1,
>>  } sja1105_spi_rw_mode_t;
>>
>> +/* From sja1105_main.c */
>> +int sja1105_static_config_reload(struct sja1105_private *priv);
>> +
>>  /* From sja1105_spi.c */
>>  int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
>>  				sja1105_spi_rw_mode_t rw, u64 reg_addr,
>> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c
>> b/drivers/net/dsa/sja1105/sja1105_main.c
>> index 8b930cc2dabc..4b393782cc84 100644
>> --- a/drivers/net/dsa/sja1105/sja1105_main.c
>> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/if_ether.h>
>>  #include <linux/dsa/8021q.h>
>>  #include "sja1105.h"
>> +#include "sja1105_tas.h"
>>
>>  static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int
>> pulse_len,
>>  			     unsigned int startup_delay)
>> @@ -1382,7 +1383,7 @@ static void sja1105_bridge_leave(struct dsa_switch
>> *ds, int port,
>>   * modify at runtime (currently only MAC) and restore them after
>> uploading,
>>   * such that this operation is relatively seamless.
>>   */
>> -static int sja1105_static_config_reload(struct sja1105_private *priv)
>> +int sja1105_static_config_reload(struct sja1105_private *priv)
>>  {
>>  	struct ptp_system_timestamp ptp_sts_before;
>>  	struct ptp_system_timestamp ptp_sts_after;
>> @@ -1761,6 +1762,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
>>  {
>>  	struct sja1105_private *priv = ds->priv;
>>
>> +	sja1105_tas_teardown(priv);
>>  	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
>>  	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
>>  	sja1105_ptp_clock_unregister(priv);
>> @@ -2088,6 +2090,18 @@ static bool sja1105_port_txtstamp(struct dsa_switch
>> *ds, int port,
>>  	return true;
>>  }
>>
>> +static int sja1105_port_setup_tc(struct dsa_switch *ds, int port,
>> +				 enum tc_setup_type type,
>> +				 void *type_data)
>> +{
>> +	switch (type) {
>> +	case TC_SETUP_QDISC_TAPRIO:
>> +		return sja1105_setup_tc_taprio(ds, port, type_data);
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +}
>> +
>>  static const struct dsa_switch_ops sja1105_switch_ops = {
>>  	.get_tag_protocol	= sja1105_get_tag_protocol,
>>  	.setup			= sja1105_setup,
>> @@ -2120,6 +2134,7 @@ static const struct dsa_switch_ops
>> sja1105_switch_ops = {
>>  	.port_hwtstamp_set	= sja1105_hwtstamp_set,
>>  	.port_rxtstamp		= sja1105_port_rxtstamp,
>>  	.port_txtstamp		= sja1105_port_txtstamp,
>> +	.port_setup_tc		= sja1105_port_setup_tc,
>>  };
>>
>>  static int sja1105_check_device_id(struct sja1105_private *priv)
>> @@ -2229,6 +2244,8 @@ static int sja1105_probe(struct spi_device *spi)
>>  	}
>>  	mutex_init(&priv->mgmt_lock);
>>
>> +	sja1105_tas_setup(priv);
>> +
>>  	return dsa_register_switch(priv->ds);
>>  }
>>
>> diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c
>> b/drivers/net/dsa/sja1105/sja1105_tas.c
>> new file mode 100644
>> index 000000000000..769e1d8e5e8f
>> --- /dev/null
>> +++ b/drivers/net/dsa/sja1105/sja1105_tas.c
>> @@ -0,0 +1,420 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
>> + */
>> +#include "sja1105.h"
>> +
>> +#define SJA1105_TAS_CLKSRC_DISABLED	0
>> +#define SJA1105_TAS_CLKSRC_STANDALONE	1
>> +#define SJA1105_TAS_CLKSRC_AS6802	2
>> +#define SJA1105_TAS_CLKSRC_PTP		3
>> +#define SJA1105_GATE_MASK		GENMASK_ULL(SJA1105_NUM_TC - 1, 0)
>> +#define SJA1105_TAS_MAX_DELTA		BIT(19)
>> +
>> +/* This is not a preprocessor macro because the "ns" argument may or may
>> not be
>> + * s64 at caller side. This ensures it is properly type-cast before
>> div_s64.
>> + */
>> +static s64 ns_to_sja1105_delta(s64 ns)
>> +{
>> +	return div_s64(ns, 200);
>> +}
>> +
>> +/* Lo and behold: the egress scheduler from hell.
>> + *
>> + * At the hardware level, the Time-Aware Shaper holds a global linear
>> arrray of
>> + * all schedule entries for all ports. These are the Gate Control List
>> (GCL)
>> + * entries, let's call them "timeslots" for short. This linear array of
>> + * timeslots is held in BLK_IDX_SCHEDULE.
>> + *
>> + * Then there are a maximum of 8 "execution threads" inside the switch,
>> which
>> + * iterate cyclically through the "schedule". Each "cycle" has an entry
>> point
>> + * and an exit point, both being timeslot indices in the schedule table.
>> The
>> + * hardware calls each cycle a "subschedule".
>> + *
>> + * Subschedule (cycle) i starts when
>> + *   ptpclkval >= ptpschtm + BLK_IDX_SCHEDULE_ENTRY_POINTS[i].delta.
>> + *
>> + * The hardware scheduler iterates BLK_IDX_SCHEDULE with a k ranging
>> from
>> + *   k = BLK_IDX_SCHEDULE_ENTRY_POINTS[i].address to
>> + *   k = BLK_IDX_SCHEDULE_PARAMS.subscheind[i]
>> + *
>> + * For each schedule entry (timeslot) k, the engine executes the gate
>> control
>> + * list entry for the duration of BLK_IDX_SCHEDULE[k].delta.
>> + *
>> + *         +---------+
>> + *         |         | BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS
>> + *         +---------+
>> + *              |
>> + *              +-----------------+
>> + *                                | .actsubsch
>> + *  BLK_IDX_SCHEDULE_ENTRY_POINTS v
>> + *                 +-------+-------+
>> + *                 |cycle 0|cycle 1|
>> + *                 +-------+-------+
>> + *                   |  |      |  |
>> + *  +----------------+  |      |
>> +-------------------------------------+
>> + *  |   .subschindx     |      |             .subschindx
>> |
>> + *  |                   |      +---------------+
>> |
>> + *  |          .address |        .address      |
>> |
>> + *  |                   |                      |
>> |
>> + *  |                   |                      |
>> |
>> + *  |  BLK_IDX_SCHEDULE v                      v
>> |
>> + *  |              +-------+-------+-------+-------+-------+------+
>> |
>> + *  |              |entry 0|entry 1|entry 2|entry 3|entry 4|entry5|
>> |
>> + *  |              +-------+-------+-------+-------+-------+------+
>> |
>> + *  |                                  ^                    ^  ^  ^
>> |
>> + *  |                                  |                    |  |  |
>> |
>> + *  |        +-------------------------+                    |  |  |
>> |
>> + *  |        |              +-------------------------------+  |  |
>> |
>> + *  |        |              |              +-------------------+  |
>> |
>> + *  |        |              |              |                      |
>> |
>> + *  | +---------------------------------------------------------------+
>> |
>> + *  | |subscheind[0]<=subscheind[1]<=subscheind[2]<=...<=subscheind[7]|
>> |
>> + *  | +---------------------------------------------------------------+
>> |
>> + *  |        ^              ^                BLK_IDX_SCHEDULE_PARAMS
>> |
>> + *  |        |              |
>> |
>> + *  +--------+
>> +-------------------------------------------+
>> + *
>> + *  In the above picture there are two subschedules (cycles):
>> + *
>> + *  - cycle 0: iterates the schedule table from 0 to 2 (and back)
>> + *  - cycle 1: iterates the schedule table from 3 to 5 (and back)
>> + *
>> + *  All other possible execution threads must be marked as unused by
>> making
>> + *  their "subschedule end index" (subscheind) equal to the last valid
>> + *  subschedule's end index (in this case 5).
>> + */
>> +static int sja1105_init_scheduling(struct sja1105_private *priv)
>> +{
>> +	struct sja1105_schedule_entry_points_entry *schedule_entry_points;
>> +	struct sja1105_schedule_entry_points_params_entry
>> +					*schedule_entry_points_params;
>> +	struct sja1105_schedule_params_entry *schedule_params;
>> +	struct sja1105_tas_data *tas_data = &priv->tas_data;
>> +	struct sja1105_schedule_entry *schedule;
>> +	struct sja1105_table *table;
>> +	int subscheind[8] = {0};
>> +	int schedule_start_idx;
>> +	s64 entry_point_delta;
>> +	int schedule_end_idx;
>> +	int num_entries = 0;
>> +	int num_cycles = 0;
>> +	int cycle = 0;
>> +	int i, k = 0;
>> +	int port;
>> +
>> +	/* Discard previous Schedule Table */
>> +	table = &priv->static_config.tables[BLK_IDX_SCHEDULE];
>> +	if (table->entry_count) {
>> +		kfree(table->entries);
>> +		table->entry_count = 0;
>> +	}
>> +
>> +	/* Discard previous Schedule Entry Points Parameters Table */
>> +	table =
>> &priv->static_config.tables[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS];
>> +	if (table->entry_count) {
>> +		kfree(table->entries);
>> +		table->entry_count = 0;
>> +	}
>> +
>> +	/* Discard previous Schedule Parameters Table */
>> +	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_PARAMS];
>> +	if (table->entry_count) {
>> +		kfree(table->entries);
>> +		table->entry_count = 0;
>> +	}
>> +
>> +	/* Discard previous Schedule Entry Points Table */
>> +	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_ENTRY_POINTS];
>> +	if (table->entry_count) {
>> +		kfree(table->entries);
>> +		table->entry_count = 0;
>> +	}
>> +
>> +	/* Figure out the dimensioning of the problem */
>> +	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
>> +		if (tas_data->config[port]) {
>> +			num_entries += tas_data->config[port]->num_entries;
>> +			num_cycles++;
>> +		}
>> +	}
>> +
>> +	/* Nothing to do */
>> +	if (!num_cycles)
>> +		return 0;
>> +
>> +	/* Pre-allocate space in the static config tables */
>> +
>> +	/* Schedule Table */
>> +	table = &priv->static_config.tables[BLK_IDX_SCHEDULE];
>> +	table->entries = kcalloc(num_entries, table->ops->unpacked_entry_size,
>> +				 GFP_KERNEL);
>> +	if (!table->entries)
>> +		return -ENOMEM;
>> +	table->entry_count = num_entries;
>> +	schedule = table->entries;
>> +
>> +	/* Schedule Points Parameters Table */
>> +	table =
>> &priv->static_config.tables[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS];
>> +	table->entries =
>> kcalloc(SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
>> +				 table->ops->unpacked_entry_size, GFP_KERNEL);
>> +	if (!table->entries)
>> +		return -ENOMEM;
>
> Should this free the previous allocation, in case this one fails?
> (also applies to the statements below)
>

I had to take a look at the overall driver code again, since it's
already been a while since I added it and I couldn't remember exactly.
All memory is freed automagically in sja1105_static_config_free from
sja1105_static_config.c. That simplifies driver code considerably,
although it's so generic that I forgot that it's there.

Thanks,
-Vladimir
