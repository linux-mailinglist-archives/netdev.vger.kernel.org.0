Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8921ECC7F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 11:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgFCJYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 05:24:05 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:57499 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgFCJYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 05:24:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id BBED05801C5;
        Wed,  3 Jun 2020 05:24:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 03 Jun 2020 05:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UR0I4Q
        CMoLiMU6pIEsiStrIm037Un+/01YcygpOZItk=; b=fm5nVMtkHwSsiVcyEhCsQI
        fu9XTd8vpOudJY0TrSa2GNCIkan+QqW2vb7ceRemcwpsa4ThCtC2v9gNx+Ru5QyQ
        htuybz6lCjPr0TvIApCKKW1uM4h8Pr50UE/0BM1ALR21iEiKK2f3xSD+sr7m8VSB
        AE5EOaSjTK+wdREeixUELup0yMc1w+RgpPozdkj+Le4Nr2B4h+sztb7/q/oM3wx/
        ikMfxxRt8qgdDt/sP5Bbma2BZIprmgP1pvaHwsw8jZVe7yh1sWIG0N8knGFJ7DGE
        FMXh7toxixIMgj3wR4zIxG3tCaQQubS2IKWfoxZdY3oQVpk/5pvrNBCvNJE8+d3A
        ==
X-ME-Sender: <xms:MGzXXn_lJ-ulgwLRkoGYgcK6Vx4fOkDlQ0vUQWQ9PgAj-CnjW7tgWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefledguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MGzXXjvtNvNUNGe7mfLBnAExQ-jPl4BdOrhXKgLqkbOu7gSWk3ifeA>
    <xmx:MGzXXlBcSrsrzZFEjXEoL8_ADyBxeYpYEnhB1qL4dW8syv7tK5q6OQ>
    <xmx:MGzXXjeaPEzMcQd_sp1z0gREtG0MtfT9i5XYf0B2_AFb4T2SnBsvzw>
    <xmx:MWzXXtHgenB6D9aji1_IRx2T2mVLETMZ3OfGcVnaHv3L-cw4_AlH0Q>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B6DA30618C1;
        Wed,  3 Jun 2020 05:24:00 -0400 (EDT)
Date:   Wed, 3 Jun 2020 12:23:58 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 1/6] net: marvell: prestera: Add driver for Prestera
 family ASIC devices
Message-ID: <20200603092358.GA1841966@splinter>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-2-vadym.kochan@plvision.eu>
 <20200530154801.GB1624759@splinter>
 <20200601105013.GB25323@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601105013.GB25323@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 01:50:13PM +0300, Vadym Kochan wrote:
> Hi Ido,
> 
> On Sat, May 30, 2020 at 06:48:01PM +0300, Ido Schimmel wrote:
> > On Thu, May 28, 2020 at 06:12:40PM +0300, Vadym Kochan wrote:
> > 
> 
> [...]
> 
> > Nit: "From" ?
> > 
> > > +	PRESTERA_DSA_CMD_FROM_CPU,
> > > +};
> > > +
> > > +struct prestera_dsa_vlan {
> > > +	u16 vid;
> > > +	u8 vpt;
> > > +	u8 cfi_bit;
> > > +	bool is_tagged;
> > > +};
> > > +
> > > +struct prestera_dsa {
> > > +	struct prestera_dsa_vlan vlan;
> > > +	u32 hw_dev_num;
> > > +	u32 port_num;
> > > +};
> > > +
> > > +int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf);
> > > +int prestera_dsa_build(const struct prestera_dsa *dsa, u8 *dsa_buf);
> > > +
> > > +#endif /* _PRESTERA_DSA_H_ */
> > > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> > > new file mode 100644
> > > index 000000000000..3aa3974f957a
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> > > @@ -0,0 +1,610 @@
> > > +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> > > +/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
> > > +
> > > +#include <linux/etherdevice.h>
> > > +#include <linux/ethtool.h>
> > > +#include <linux/netdevice.h>
> > > +#include <linux/list.h>
> > > +
> > > +#include "prestera.h"
> > > +#include "prestera_hw.h"
> > > +
> > > +#define PRESTERA_SWITCH_INIT_TIMEOUT 30000000	/* 30sec */
> > 
> > Out of curiosity, how long does it actually take you to initialize the
> > hardware?
> > 
> > Also, I find it useful to note the units in the name, so:
> > 
> > #define PRESTERA_SWITCH_INIT_TIMEOUT_US (30 * 1000 * 1000)
> > 
> > BTW, it says 30 seconds in comment, but the call chain where it is used
> > is:
> > 
> > prestera_cmd_ret_wait(, PRESTERA_SWITCH_INIT_TIMEOUT)
> >   __prestera_cmd_ret(..., wait)
> >     prestera_fw_send_req(..., waitms)
> >       prestera_fw_cmd_send(..., waitms)
> >         prestera_fw_wait_reg32(..., waitms)
> > 	  readl_poll_timeout(..., waitms * 1000)
> > 
> > So I think you should actually define it as:
> > 
> > #define PRESTERA_SWITCH_INIT_TIMEOUT_MS (30 * 1000)
> > 
> > And rename all these 'wait' arguments to 'waitms' so it's clearer which
> > unit they expect.
> > 
> [...]
> > > +static int __prestera_cmd_ret(struct prestera_switch *sw,
> > > +			      enum prestera_cmd_type_t type,
> > > +			      struct prestera_msg_cmd *cmd, size_t clen,
> > > +			      struct prestera_msg_ret *ret, size_t rlen,
> > > +			      int wait)
> > > +{
> > > +	struct prestera_device *dev = sw->dev;
> > > +	int err;
> > > +
> > > +	cmd->type = type;
> > > +
> > > +	err = dev->send_req(dev, (u8 *)cmd, clen, (u8 *)ret, rlen, wait);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	if (ret->cmd.type != PRESTERA_CMD_TYPE_ACK)
> > > +		return -EBADE;
> > > +	if (ret->status != PRESTERA_CMD_ACK_OK)
> > 
> > You don't have more states here other than OK / FAIL ? It might help you
> > in debugging if you include them. You might find trace_devlink_hwerr()
> > useful.
> Thanks, I will consider this.
> 
> > 
> > > +		return -EINVAL;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int prestera_cmd_ret(struct prestera_switch *sw,
> > > +			    enum prestera_cmd_type_t type,
> > > +			    struct prestera_msg_cmd *cmd, size_t clen,
> > > +			    struct prestera_msg_ret *ret, size_t rlen)
> > > +{
> > > +	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, 0);
> > > +}
> > > +
> > > +static int prestera_cmd_ret_wait(struct prestera_switch *sw,
> > > +				 enum prestera_cmd_type_t type,
> > > +				 struct prestera_msg_cmd *cmd, size_t clen,
> > > +				 struct prestera_msg_ret *ret, size_t rlen,
> > > +				 int wait)
> > > +{
> > > +	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, wait);
> > > +}
> > > +
> > > +static int prestera_cmd(struct prestera_switch *sw,
> > > +			enum prestera_cmd_type_t type,
> > > +			struct prestera_msg_cmd *cmd, size_t clen)
> > > +{
> > > +	struct prestera_msg_common_resp resp;
> > > +
> > > +	return prestera_cmd_ret(sw, type, cmd, clen, &resp.ret, sizeof(resp));
> > > +}
> > > +
> > > +static int prestera_fw_parse_port_evt(u8 *msg, struct prestera_event *evt)
> > > +{
> > > +	struct prestera_msg_event_port *hw_evt;
> > > +
> > > +	hw_evt = (struct prestera_msg_event_port *)msg;
> > > +
> > > +	evt->port_evt.port_id = hw_evt->port_id;
> > > +
> > > +	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED)
> > > +		evt->port_evt.data.oper_state = hw_evt->param.oper_state;
> > > +	else
> > > +		return -EINVAL;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static struct prestera_fw_evt_parser {
> > > +	int (*func)(u8 *msg, struct prestera_event *evt);
> > > +} fw_event_parsers[PRESTERA_EVENT_TYPE_MAX] = {
> > > +	[PRESTERA_EVENT_TYPE_PORT] = {.func = prestera_fw_parse_port_evt},
> > > +};
> > > +
> > > +static struct prestera_fw_event_handler *
> > > +__find_event_handler(const struct prestera_switch *sw,
> > > +		     enum prestera_event_type type)
> > > +{
> > > +	struct prestera_fw_event_handler *eh;
> > > +
> > > +	list_for_each_entry_rcu(eh, &sw->event_handlers, list) {
> > 
> > It does not look that this is always called under RCU which will result
> > in various splats. For example in the following call path:
> > 
> > prestera_device_register()
> >   prestera_switch_init()
> >     prestera_event_handlers_register()
> >       prestera_hw_event_handler_register()
> >         __find_event_handler()
> > 
> > You want to make sure that you are testing with various debug options.
> > For example:
> So, right. Currently this prestera_hw_event_handler_register is called
> synchronously and as I understand does not require additional locking
> when use list rcu API. I will check with these options which you
> suggested.
> 
> > 
> > # Debug options
> > ## General debug options
> > config_enable CONFIG_PREEMPT
> > config_enable CONFIG_DEBUG_PREEMPT
> > config_enable CONFIG_DEBUG_INFO
> > config_enable CONFIG_UNWINDER_ORC
> > config_enable CONFIG_DYNAMIC_DEBUG
> > config_enable CONFIG_DEBUG_NOTIFIERS
> > ## Lock debugging
> > config_enable CONFIG_LOCKDEP
> > config_enable CONFIG_PROVE_LOCKING
> > config_enable CONFIG_DEBUG_ATOMIC_SLEEP
> > config_enable CONFIG_PROVE_RCU
> > config_enable CONFIG_DEBUG_MUTEXES
> > config_enable CONFIG_DEBUG_SPINLOCK
> > config_enable CONFIG_LOCK_STAT
> > ## Memory debugging
> > config_enable CONFIG_DEBUG_VM
> > config_enable CONFIG_FORTIFY_SOURCE
> > config_enable CONFIG_KASAN
> > config_enable CONFIG_KASAN_EXTRA
> > config_enable CONFIG_KASAN_INLINE
> > ## Reference counting debugging
> > config_enable CONFIG_REFCOUNT_FULL
> > ## Lockups debugging
> > config_enable CONFIG_LOCKUP_DETECTOR
> > config_enable CONFIG_SOFTLOCKUP_DETECTOR
> > config_enable CONFIG_HARDLOCKUP_DETECTOR
> > config_enable CONFIG_DETECT_HUNG_TASK
> > config_enable CONFIG_WQ_WATCHDOG
> > config_enable CONFIG_DETECT_HUNG_TASK
> > config_set_val CONFIG_DEFAULT_HUNG_TASK_TIMEOUT 120
> > ## Undefined behavior debugging
> > config_enable CONFIG_UBSAN
> > config_enable CONFIG_UBSAN_SANITIZE_ALL
> > config_disable CONFIG_UBSAN_ALIGNMENT
> > config_disable CONFIG_UBSAN_NULL
> > ## Memory debugging
> > config_enable CONFIG_SLUB_DEBUG
> > config_enable CONFIG_SLUB_DEBUG_ON
> > config_enable CONFIG_DEBUG_PAGEALLOC
> > config_enable CONFIG_DEBUG_KMEMLEAK
> > config_disable CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> > config_set_val CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE 8192
> > config_enable CONFIG_DEBUG_STACKOVERFLOW
> > config_enable CONFIG_DEBUG_LIST
> > config_enable CONFIG_DEBUG_PER_CPU_MAPS
> > config_set_val CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT 1
> > config_enable CONFIG_DEBUG_OBJECTS
> > config_enable CONFIG_DEBUG_OBJECTS_FREE
> > config_enable CONFIG_DEBUG_OBJECTS_TIMERS
> > config_enable CONFIG_DEBUG_OBJECTS_WORK
> > config_enable CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
> > config_enable CONFIG_DMA_API_DEBUG
> > ## Lock debugging
> > config_enable CONFIG_DEBUG_LOCK_ALLOC
> > config_enable CONFIG_PROVE_LOCKING
> > config_enable CONFIG_LOCK_STAT
> > config_enable CONFIG_DEBUG_OBJECTS_RCU_HEAD
> > config_enable CONFIG_SPARSE_RCU_POINTER
> > 
> > > +		if (eh->type == type)
> > > +			return eh;
> > > +	}
> > > +
> > > +	return NULL;
> > > +}
> > > +
> > > +static int prestera_find_event_handler(const struct prestera_switch *sw,
> > > +				       enum prestera_event_type type,
> > > +				       struct prestera_fw_event_handler *eh)
> > > +{
> > > +	struct prestera_fw_event_handler *tmp;
> > > +	int err = 0;
> > > +
> > > +	rcu_read_lock();
> > > +	tmp = __find_event_handler(sw, type);
> > > +	if (tmp)
> > > +		*eh = *tmp;
> > > +	else
> > > +		err = -EEXIST;
> > > +	rcu_read_unlock();
> > > +
> > > +	return err;
> > > +}
> > > +
> > > +static int prestera_evt_recv(struct prestera_device *dev, u8 *buf, size_t size)
> > > +{
> > > +	struct prestera_msg_event *msg = (struct prestera_msg_event *)buf;
> > > +	struct prestera_switch *sw = dev->priv;
> > > +	struct prestera_fw_event_handler eh;
> > > +	struct prestera_event evt;
> > > +	int err;
> > > +
> > > +	if (msg->type >= PRESTERA_EVENT_TYPE_MAX)
> > > +		return -EINVAL;
> > > +
> > > +	err = prestera_find_event_handler(sw, msg->type, &eh);
> > > +
> > > +	if (err || !fw_event_parsers[msg->type].func)
> > > +		return 0;
> > > +
> > > +	evt.id = msg->id;
> > > +
> > > +	err = fw_event_parsers[msg->type].func(buf, &evt);
> > > +	if (!err)
> > > +		eh.func(sw, &evt, eh.arg);
> > > +
> > > +	return err;
> > > +}
> > > +
> > > +static void prestera_pkt_recv(struct prestera_device *dev)
> > > +{
> > > +	struct prestera_switch *sw = dev->priv;
> > > +	struct prestera_fw_event_handler eh;
> > > +	struct prestera_event ev;
> > > +	int err;
> > > +
> > > +	ev.id = PRESTERA_RXTX_EVENT_RCV_PKT;
> > > +
> > > +	err = prestera_find_event_handler(sw, PRESTERA_EVENT_TYPE_RXTX, &eh);
> > > +	if (err)
> > > +		return;
> > > +
> > > +	eh.func(sw, &ev, eh.arg);
> > > +}
> > > +
> > > +int prestera_hw_port_info_get(const struct prestera_port *port,
> > > +			      u16 *fp_id, u32 *hw_id, u32 *dev_id)
> > > +{
> > > +	struct prestera_msg_port_info_resp resp;
> > > +	struct prestera_msg_port_info_req req = {
> > > +		.port = port->id
> > > +	};
> > > +	int err;
> > > +
> > > +	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_INFO_GET,
> > > +			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	*hw_id = resp.hw_id;
> > > +	*dev_id = resp.dev_id;
> > > +	*fp_id = resp.fp_id;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +int prestera_hw_switch_mac_set(struct prestera_switch *sw, char *mac)
> > > +{
> > > +	struct prestera_msg_switch_attr_req req = {
> > > +		.attr = PRESTERA_CMD_SWITCH_ATTR_MAC,
> > > +	};
> > > +
> > > +	memcpy(req.param.mac, mac, sizeof(req.param.mac));
> > > +
> > > +	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SWITCH_ATTR_SET,
> > > +			    &req.cmd, sizeof(req));
> > > +}
> > > +
> > > +int prestera_hw_switch_init(struct prestera_switch *sw)
> > > +{
> > > +	struct prestera_msg_switch_init_resp resp;
> > > +	struct prestera_msg_common_req req;
> > > +	int err;
> > > +
> > > +	INIT_LIST_HEAD(&sw->event_handlers);
> > > +
> > > +	err = prestera_cmd_ret_wait(sw, PRESTERA_CMD_TYPE_SWITCH_INIT,
> > > +				    &req.cmd, sizeof(req),
> > > +				    &resp.ret, sizeof(resp),
> > > +				    PRESTERA_SWITCH_INIT_TIMEOUT);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	sw->id = resp.switch_id;
> > > +	sw->port_count = resp.port_count;
> > > +	sw->mtu_min = PRESTERA_MIN_MTU;
> > > +	sw->mtu_max = resp.mtu_max;
> > > +	sw->dev->recv_msg = prestera_evt_recv;
> > > +	sw->dev->recv_pkt = prestera_pkt_recv;
> > > +
> > > +	return 0;
> > > +}
> > 
> > Consider adding prestera_hw_switch_fini() that verifies that
> > '&sw->event_handlers' is empty.
> > 
> As I see it can just warn on if list is not empty, right ?

Yes, something like:

WARN_ON(!list_empty(&sw->event_handlers));

> 
> > > +
> > > +int prestera_hw_port_state_set(const struct prestera_port *port,
> > > +			       bool admin_state)
> > > +{
> > > +	struct prestera_msg_port_attr_req req = {
> > > +		.attr = PRESTERA_CMD_PORT_ATTR_ADMIN_STATE,
> > > +		.port = port->hw_id,
> > > +		.dev = port->dev_id,
> > > +		.param = {.admin_state = admin_state}
> > > +	};
> > > +
> > > +	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
> > > +			    &req.cmd, sizeof(req));
> > > +}
> > > +
> 
> [...]
> 
> > > +
> > > +struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
> > > +						 u32 dev_id, u32 hw_id)
> > > +{
> > > +	struct prestera_port *port;
> > > +
> > > +	rcu_read_lock();
> > > +
> > > +	list_for_each_entry_rcu(port, &sw->port_list, list) {
> > > +		if (port->dev_id == dev_id && port->hw_id == hw_id) {
> > > +			rcu_read_unlock();
> > > +			return port;
> > 
> > This does not look correct. You call rcu_read_unlock(), but do not take
> > a reference on the object, so nothing prevents it from being freed. 
> > 
> Currently there is no logic which can dynamically create/delete the
> port, so how do you think may I just use synchronize_rcu() when freeing
> the port instance on module unlolad ?

I don't understand what RCU is meant to protect here. You call
rcu_read_unlock() and then return the port. Calling synchronize_rcu()
before freeing the port will not prevent the caller of
prestera_port_find_by_hwid() from accessing freed memory.

> 
> > > +		}
> > > +	}
> > > +
> > > +	rcu_read_unlock();
> > > +
> > > +	return NULL;
> > > +}
> > > +
> > > +static struct prestera_port *prestera_find_port(struct prestera_switch *sw,
> > > +						u32 port_id)
> > > +{
> > > +	struct prestera_port *port;
> > > +
> > > +	rcu_read_lock();
> > > +
> > > +	list_for_each_entry_rcu(port, &sw->port_list, list) {
> > > +		if (port->id == port_id)
> > > +			break;
> > > +	}
> > > +
> > > +	rcu_read_unlock();
> > > +
> > > +	return port;
> > 
> > Same here.
> > 
> > > +}
> > > +
> > > +static int prestera_port_state_set(struct net_device *dev, bool is_up)
> > > +{
> > > +	struct prestera_port *port = netdev_priv(dev);
> > > +	int err;
> > > +
> > > +	if (!is_up)
> > > +		netif_stop_queue(dev);
> > > +
> > > +	err = prestera_hw_port_state_set(port, is_up);
> > > +
> > > +	if (is_up && !err)
> > > +		netif_start_queue(dev);
> > > +
> > > +	return err;
> > > +}
> > > +
> 
> [...]
> 
> > > +static void prestera_port_destroy(struct prestera_port *port)
> > > +{
> > > +	struct net_device *dev = port->dev;
> > > +
> > > +	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
> > > +	unregister_netdev(dev);
> > > +
> > > +	list_del_rcu(&port->list);
> > > +
> > 
> > I'm not sure what is the point of these blank lines. Best to remove
> > them.
> Will fix it.
> 
> > 
> > > +	free_netdev(dev);
> > > +}
> > > +
> > > +static void prestera_destroy_ports(struct prestera_switch *sw)
> > > +{
> > > +	struct prestera_port *port, *tmp;
> > > +	struct list_head remove_list;
> > > +
> > > +	INIT_LIST_HEAD(&remove_list);
> > > +
> > > +	list_splice_init(&sw->port_list, &remove_list);
> > > +
> > > +	list_for_each_entry_safe(port, tmp, &remove_list, list)
> > > +		prestera_port_destroy(port);
> > > +}
> > > +
> > > +static int prestera_create_ports(struct prestera_switch *sw)
> > > +{
> > > +	u32 port;
> > > +	int err;
> > > +
> > > +	for (port = 0; port < sw->port_count; port++) {
> > > +		err = prestera_port_create(sw, port);
> > > +		if (err)
> > > +			goto err_ports_init;
> > 
> > err_port_create ?
> > 
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +err_ports_init:
> > > +	prestera_destroy_ports(sw);
> > 
> > I'm not a fan of this construct. I find it best to always do proper
> > rollback in the error path. Then you can always maintain init() being
> > followed by fini() which is much easier to review.
> As I understand you meant to move this destroy_ports() recovery to the
> error path in xxx_switch_init() ?

No, I mean do proper rollback in this error path by calling
prestera_port_destroy() for each port you created thus far.

Then move prestera_destroy_ports() after prestera_create_ports(),
instead of before it.

> 
> > 
> > > +	return err;
> > > +}
> > > +
> > > +static void prestera_port_handle_event(struct prestera_switch *sw,
> > > +				       struct prestera_event *evt, void *arg)
> > > +{
> > > +	struct delayed_work *caching_dw;
> > > +	struct prestera_port *port;
> > > +
> > > +	port = prestera_find_port(sw, evt->port_evt.port_id);
> > > +	if (!port)
> > > +		return;
> > > +
> > > +	caching_dw = &port->cached_hw_stats.caching_dw;
> > > +
> > > +	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED) {
> > > +		if (evt->port_evt.data.oper_state) {
> > > +			netif_carrier_on(port->dev);
> > > +			if (!delayed_work_pending(caching_dw))
> > > +				queue_delayed_work(prestera_wq, caching_dw, 0);
> > > +		} else {
> > > +			netif_carrier_off(port->dev);
> > > +			if (delayed_work_pending(caching_dw))
> > > +				cancel_delayed_work(caching_dw);
> > > +		}
> > > +	}
> > > +}
> > > +
> > > +static void prestera_event_handlers_unregister(struct prestera_switch *sw)
> > > +{
> > > +	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_PORT,
> > > +					     prestera_port_handle_event);
> > > +}
> > 
> > Please reverse the order so that register() is first.
> > 
> > > +
> > > +static int prestera_event_handlers_register(struct prestera_switch *sw)
> > > +{
> > > +	return prestera_hw_event_handler_register(sw, PRESTERA_EVENT_TYPE_PORT,
> > > +						  prestera_port_handle_event,
> > > +						  NULL);
> > > +}
> > > +
> > > +static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
> > > +{
> > > +	struct device_node *base_mac_np;
> > > +	struct device_node *np;
> > > +
> > > +	np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
> > > +	if (np) {
> > > +		base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
> > > +		if (base_mac_np) {
> > > +			const char *base_mac;
> > > +
> > > +			base_mac = of_get_mac_address(base_mac_np);
> > > +			of_node_put(base_mac_np);
> > > +			if (!IS_ERR(base_mac))
> > > +				ether_addr_copy(sw->base_mac, base_mac);
> > > +		}
> > > +	}
> > > +
> > > +	if (!is_valid_ether_addr(sw->base_mac)) {
> > > +		eth_random_addr(sw->base_mac);
> > > +		dev_info(sw->dev->dev, "using random base mac address\n");
> > > +	}
> > > +
> > > +	return prestera_hw_switch_mac_set(sw, sw->base_mac);
> > > +}
> > > +
> > > +static int prestera_switch_init(struct prestera_switch *sw)
> > > +{
> > > +	int err;
> > > +
> > > +	err = prestera_hw_switch_init(sw);
> > > +	if (err) {
> > > +		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
> > > +		return err;
> > > +	}
> > > +
> > > +	INIT_LIST_HEAD(&sw->port_list);
> > > +
> > > +	err = prestera_switch_set_base_mac_addr(sw);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	err = prestera_rxtx_switch_init(sw);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	err = prestera_event_handlers_register(sw);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	err = prestera_create_ports(sw);
> > > +	if (err)
> > > +		goto err_ports_create;
> > > +
> > > +	return 0;
> > > +
> > > +err_ports_create:
> > > +	prestera_event_handlers_unregister(sw);
> > > +
> > 
> > You are missing prestera_rxtx_switch_fini() here... With init() always
> > followed by fini() you can easily tell that the error path is not
> > symmetric with fini().
> Yeah, for some reason I mixed this fix with Switchdev patch, I will fix
> this.
> 
> > 
> > > +	return err;
> > > +}
> > > +
> > > +static void prestera_switch_fini(struct prestera_switch *sw)
> > > +{
> > > +	prestera_destroy_ports(sw);
> > > +	prestera_event_handlers_unregister(sw);
> > > +	prestera_rxtx_switch_fini(sw);
> > > +}
> > > +
> > > +int prestera_device_register(struct prestera_device *dev)
> > > +{
> > > +	struct prestera_switch *sw;
> > > +	int err;
> > > +
> > > +	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
> > > +	if (!sw)
> > > +		return -ENOMEM;
> > > +
> > > +	dev->priv = sw;
> > > +	sw->dev = dev;
> > > +
> > > +	err = prestera_switch_init(sw);
> > > +	if (err) {
> > > +		kfree(sw);
> > > +		return err;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL(prestera_device_register);
> > > +
> > > +void prestera_device_unregister(struct prestera_device *dev)
> > > +{
> > > +	struct prestera_switch *sw = dev->priv;
> > > +
> > > +	prestera_switch_fini(sw);
> > > +	kfree(sw);
> > > +}
> 
> [...]
> 
> > > +int prestera_rxtx_port_init(struct prestera_port *port)
> > > +{
> > > +	int err;
> > > +
> > > +	err = prestera_hw_rxtx_port_init(port);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	port->dev->needed_headroom = PRESTERA_DSA_HLEN + ETH_FCS_LEN;
> > 
> > Why do you need headroom for FCS?
> > 
> I had issue when the SKB did not have additional bytes for the FCS, so I
> thought to added this to the needed_headroom to be sure.

But FCS is at the end of the frame. 'needed_headroom' is for headers you
need to prepend to each frame.

Which issues did you have? In mlxsw FCS is computed in hardware and we
pass the length of the frame without the FCS when posting the frame to
hardware.

> 
> > > +	return 0;
> > > +}
> > > +
> > > +netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb)
> > > +{
> > > +	struct prestera_dsa dsa;
> > > +
> > > +	dsa.hw_dev_num = port->dev_id;
> > > +	dsa.port_num = port->hw_id;
> > > +
> > > +	if (skb_cow_head(skb, PRESTERA_DSA_HLEN) < 0)
> > > +		return NET_XMIT_DROP;
> > > +
> > > +	skb_push(skb, PRESTERA_DSA_HLEN);
> > > +	memmove(skb->data, skb->data + PRESTERA_DSA_HLEN, 2 * ETH_ALEN);
> > > +
> > > +	if (prestera_dsa_build(&dsa, skb->data + 2 * ETH_ALEN) != 0)
> > > +		return NET_XMIT_DROP;
> > > +
> > > +	return prestera_sdma_xmit(&port->sw->rxtx->sdma, skb);
> > > +}
> > > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> > > new file mode 100644
> > > index 000000000000..bbbadfa5accf
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> > > @@ -0,0 +1,21 @@
> > > +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> > > + *
> > > + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> > > + *
> > > + */
> > > +
> > > +#ifndef _PRESTERA_RXTX_H_
> > > +#define _PRESTERA_RXTX_H_
> > > +
> > > +#include <linux/netdevice.h>
> > > +
> > > +#include "prestera.h"
> > > +
> > > +int prestera_rxtx_switch_init(struct prestera_switch *sw);
> > > +void prestera_rxtx_switch_fini(struct prestera_switch *sw);
> > > +
> > > +int prestera_rxtx_port_init(struct prestera_port *port);
> > > +
> > > +netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb);
> > > +
> > > +#endif /* _PRESTERA_RXTX_H_ */
> > > -- 
> > > 2.17.1
> > > 
> 
> Thank you for review.
