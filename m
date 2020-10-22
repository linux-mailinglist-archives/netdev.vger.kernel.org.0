Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6812A2965E7
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 22:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371532AbgJVUWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 16:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507574AbgJVUWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 16:22:37 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64314C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 13:22:36 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 09MKLXoF092159;
        Thu, 22 Oct 2020 22:21:33 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 09MKLWN6002728;
        Thu, 22 Oct 2020 22:21:33 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 09MKLWmY002725;
        Thu, 22 Oct 2020 22:21:32 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Pavel Machek <pavel@ucw.cz>,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>
Subject: Re: [PATCH v6 3/6] can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.
Date:   Thu, 22 Oct 2020 22:21:31 +0200
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz> <886a8e0749e0521bf83a88313008a3f38031590b.1603354744.git.pisa@cmp.felk.cvut.cz> <20201022110213.GC26350@duo.ucw.cz>
In-Reply-To: <20201022110213.GC26350@duo.ucw.cz>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202010222221.31952.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 09MKLXoF092159
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.099, required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.40,
        NICE_REPLY_A -0.00, SPF_HELO_NONE 0.00, SPF_NONE 0.00,
        URIBL_BLOCKED 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1604002896.0371@YIrqIaPFEAgKEUsQ68uedw
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pavel,

thanks for review.

For everybody: the amount of code, analyses etc. is really huge.
If you do not have time and consider this discussion as lost of your
time and or badwidth send me a note. I will remove your from the
recipients list and if you think that some lists should be omitted
as well, please give me notice too. Same if you want to receive
only final resolutions, patches when they pass through some
of the lists.

On Thursday 22 of October 2020 13:02:13 Pavel Machek wrote:
> Hi!
>
> > From: Martin Jerabek <martin.jerabek01@gmail.com>
> >
> > This driver adds support for the CTU CAN FD open-source IP core.
> > More documentation and core sources at project page
> > (https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
> > The core integration to Xilinx Zynq system as platform driver
> > is available
> > (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top).
> > Implementation on Intel FGA based PCI Express board is available from
> > project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).
>
> Is "FGA" a typo? Yes, it is.

Done, thanks for catching.

I really need to force some of other people from the project
and follow up project to read all original Matin Jerabek's
and mine texts. I am blind to many of these typos as I see
same text many times.

> Anyway, following link tells me:
>
> Project 'canbus/pcie-ctu_can_fd' was moved to
> 'canbus/pcie-ctucanfd'. Please update any links and bookmarks that may
> still have the old path. Fixing it in Kconfig is more important.

Done, move is result of some more steps to name unification.

> > +++ b/drivers/net/can/ctucanfd/Kconfig
> > @@ -0,0 +1,15 @@
> >
> > +if CAN_CTUCANFD
> > +
> > +endif
>
> Empty -> drop?

Considering as appropriate after other patches comments read.
If you have other idea for patches series build give me a hint.

> > +++ b/drivers/net/can/ctucanfd/Makefile
> > @@ -0,0 +1,7 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> >
> > +++ b/drivers/net/can/ctucanfd/ctu_can_fd.c
> > @@ -0,0 +1,1105 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
>
> Having Makefile and sources with different licenses is rather unusual.

Makefile changed to GPL-2.0-or-later.
I do not consider use of Linux specific Makefile outside
GPL 2 only Linux kernel tree. But C sources are important
for us even in userspace tests and possible future projects. 

> > +static const char * const ctucan_state_strings[] = {
> > +	"CAN_STATE_ERROR_ACTIVE",
> > +	"CAN_STATE_ERROR_WARNING",
> > +	"CAN_STATE_ERROR_PASSIVE",
> > +	"CAN_STATE_BUS_OFF",
> > +	"CAN_STATE_STOPPED",
> > +	"CAN_STATE_SLEEPING"
> > +};
>
> Put this near function that uses this?

I prefer defines at start of the file, but I agree that in this
case it is different case and used only in ctucan_state_to_str .
I would prefer to move function up after array.

> > +/**
> > + * ctucan_set_bittiming - CAN set bit timing routine
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * This is the driver set bittiming routine.
> > + * Return: 0 on success and failure value on error
> > + */
> >
> > +/**
> > + * ctucan_chip_start - This routine starts the driver
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * This is the drivers start routine.
> > + *
> > + * Return: 0 on success and failure value on error
> > + */
>
> Good documentation is nice, but repeating "This routine starts the
> driver" in "This is the drivers start routine." is not too helpful.

OK, initially probably more or less placeholder to add more infomation.
I will remove it.

> > +/**
> > + * ctucan_start_xmit - Starts the transmission
> > + * @skb:	sk_buff pointer that contains data to be Txed
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * This function is invoked from upper layers to initiate transmission.
> > This + * function uses the next available free txbuf and populates their
> > fields to + * start the transmission.
> > + *
> > + * Return: %NETDEV_TX_OK on success and failure value on error
> > + */
>
> Based on other documentation, I'd expect this to return -ESOMETHING on
> error, but it returns NETDEV_TX_BUSY.

I add information about explicit error/need for postpone type.

> > +	/* Check if the TX buffer is full */
> > +	if (unlikely(!CTU_CAN_FD_TXTNF(ctu_can_get_status(&priv->p)))) {
> > +		netif_stop_queue(ndev);
> > +		netdev_err(ndev, "BUG!, no TXB free when queue awake!\n");
> > +		return NETDEV_TX_BUSY;
> > +	}
>
> You call stop_queue() without spinlock...
>
> > +	spin_lock_irqsave(&priv->tx_lock, flags);
> > +
> > +	ctucan_hw_txt_set_rdy(&priv->p, txb_id);
> > +
> > +	priv->txb_head++;
> > +
> > +	/* Check if all TX buffers are full */
> > +	if (!CTU_CAN_FD_TXTNF(ctu_can_get_status(&priv->p)))
> > +		netif_stop_queue(ndev);
> > +
> > +	spin_unlock_irqrestore(&priv->tx_lock, flags);
>
> ...and then with spinlock held. One of them is buggy.

I did not feel it that way initially. But may it be there is a problem.

I expect that NET core does not invoke net_device_ops::ndo_start_xmit
aka ctucan_start_xmit when previous invocation is in progress still.
I think I have even checked it in the sources.
So we can do check for free message buffer in hardware without
locking. If there is no space we stop further transmit
but then there is something wrong anyway, because when
there was xmit started then there was already free space
in hardware. So generally this is some fatal error in logic
or hardware or driver. I hope that concurrent run of netif_wake_queue
internal functions to ctucan_start_xmit is prevented by NET
core logic and locking. So even if some buffer becomes free
in meanwhile and invokes netif_wake_queue, it waits with
next ctucan_start_xmit invocation till previous one
finishes.

Incorrect concurrence can happen if ctucan_hw_txt_set_rdy
and frame transmission finishes before ctucan_start_xmit
finishes. In such case there appear incorrect sequence
of manipulation with hardware and counting occupied
and free buffers. So buffer counting is protected
by spinlock....

If this is the last empty TX buffer filled by xmit then
further xmit has to be stopped. So we call
netif_stop_queue(ndev); In the theory, it can
be called after spin lock release (if netif_wake_queue
is synchronized). So if mine analysis is right then
I can check HW for empty buffer under spinlock,
keep result and call netif_stop_queue later.
It seems that netif_stop_queue is called in other
drivers with irq locks held. So there should not be
a problem, netif_stop_queue locking is orthogonal
to &priv->tx_lock which protects HW and slots
counting.

But if somebody can check and clarify that my idea
is wrong or confirm, that moving out of spinlock
section is correct way to go, I would be happy.
Many CAN controllers use only single buffer for TX
so they do not solve these conditions. These
which solve more parallel Tx buffers seems to
not prove me wrong according to my reading.

> > +/**
> > + * xcan_rx -  Is called from CAN isr to complete the received
> > + *		frame processing
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * This function is invoked from the CAN isr(poll) to process the Rx
> > frames. It + * does minimal processing and invokes "netif_receive_skb" to
> > complete further + * processing.
> > + * Return: 1 on success and 0 on failure.
> > + */
>
> Adapt to usual 0 / -EFOO?

OK

> > +	/* Check for Arbitration Lost interrupt */
> > +	if (isr.s.ali) {
> > +		if (dologerr)
> > +			netdev_info(ndev, "  arbitration lost");
> > +		priv->can.can_stats.arbitration_lost++;
> > +		if (skb) {
> > +			cf->can_id |= CAN_ERR_LOSTARB;
> > +			cf->data[0] = CAN_ERR_LOSTARB_UNSPEC;
> > +		}
> > +	}
> > +
> > +	/* Check for Bus Error interrupt */
> > +	if (isr.s.bei) {
> > +		netdev_info(ndev, "  bus error");
>
> Missing "if (dologerr)" here?

Intention was to left this one to appear without rate limit, it is really
indication of bigger problem. But on the other hand without dologerr
would be quite short/unclear, but does not overflow the log buffers...
We would discuss what to do with my colleagues, suggestions welcomed.

> > +static int ctucan_rx_poll(struct napi_struct *napi, int quota)
> > +{
> > +	struct net_device *ndev = napi->dev;
> > +	struct ctucan_priv *priv = netdev_priv(ndev);
> > +	int work_done = 0;
> > +	union ctu_can_fd_status status;
> > +	u32 framecnt;
> > +
> > +	framecnt = ctucan_hw_get_rx_frame_count(&priv->p);
> > +	netdev_dbg(ndev, "rx_poll: %d frames in RX FIFO", framecnt);
>
> This will be rather noisy, right?

It has use to debug during development but may be it should be removed
or controlled by other option.

> > +	/* Check for RX FIFO Overflow */
> > +	status = ctu_can_get_status(&priv->p);
> > +	if (status.s.dor) {
> > +		struct net_device_stats *stats = &ndev->stats;
> > +		struct can_frame *cf;
> > +		struct sk_buff *skb;
> > +
> > +		netdev_info(ndev, "  rx fifo overflow");
>
> And this goes at different loglevel, which will be confusing?

I add prefix there, this condition is more important to be noticed.

> > +/**
> > + * xcan_tx_interrupt - Tx Done Isr
> > + * @ndev:	net_device pointer
> > + */
> > +static void ctucan_tx_interrupt(struct net_device *ndev)
>
> Mismatch between code and docs.

Corrected.

> > +	netdev_dbg(ndev, "%s", __func__);
>
> This is inconsistent with other debugging.... and perhaps it is time
> to remove this kind of debugging for merge.

OK

> > +/**
> > + * xcan_interrupt - CAN Isr
> > + */
> > +static irqreturn_t ctucan_interrupt(int irq, void *dev_id)
>
> Inconsistent.

Corrected

> > +		/* Error interrupts */
> > +		if (isr.s.ewli || isr.s.fcsi || isr.s.ali) {
> > +			union ctu_can_fd_int_stat ierrmask = { .s = {
> > +				  .ewli = 1, .fcsi = 1, .ali = 1, .bei = 1 } };
> > +			icr.u32 = isr.u32 & ierrmask.u32;
>
> We normally do bit arithmetics instead of this.

This is attempt to use only HW definitions generated from registers definition 
in IPXACT format

https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core/-/blob/master/spec/CTU/ip/CAN_FD_IP_Core/2.1/CAN_FD_IP_Core.2.1.xml

Which I consider as good option which should be preserved.
I prefer to have only singe source of infomation
which is kept with rest in automatic sync.

> > +	{
> > +		union ctu_can_fd_int_stat imask;
> > +
> > +		imask.u32 = 0xffffffff;
> > +		ctucan_hw_int_ena_clr(&priv->p, imask);
> > +		ctucan_hw_int_mask_set(&priv->p, imask);
> > +	}
>
> More like this. Plus avoid block here...?

Blocks is to document that imask is really local for these
two lines, no need to look for it elsewhere in the function.
But I can move declaration to start of the function.

> > +/**
> > + * ctucan_close - Driver close routine
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * Return: 0 always
> > + */
>
> You see, this is better. No need to say "Driver close routine"
> twice. Now, make the rest consistent :-).
>
> > +EXPORT_SYMBOL(ctucan_suspend);
> > +EXPORT_SYMBOL(ctucan_resume);
>
> _GPL?

Should we be so strict??? Ondrej Ille can provide his opinion there.

> And what kind of multi-module stuff are you doing that you need
> symbols exported?
>
> > +int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq,
> > unsigned int ntxbufs, +			unsigned long can_clk_rate, int pm_enable_call,
> > +			void (*set_drvdata_fnc)(struct device *dev, struct net_device *ndev))
> > +{
>
> Splitting/simplifying this somehow would be good.

This is attempt to hide the most of all other functions from bus integration
modules. Prototype is not nice, but it is only one of a few function exported.
The arguments can be passed through structure. May it be better???

> > +/* Register descriptions: */
> > +union ctu_can_fd_frame_form_w {
> > +	uint32_t u32;
>
> u32, as you write elsewhere.

I would be happy, if we can keep uint32_t there.
The header files are generated from IPXACT and are intended to be used
even outside of Linux kernel. I.e. QEMU

https://git.qemu.org/?p=qemu.git;a=blob;f=hw/net/can/ctu_can_fd_regs.h

Easy way to compare these together is great to keep consistency.
Adaptation of generation tools to run in multiple modes would
be overhead. So if the uint32_t type in HW definition
is acceptable for Linux kernel it would save us lot of
headaches and possible errors in the future.

Enforce u32 in all other projects in form visible
from this and other header files is problematic. 

> > +	struct ctu_can_fd_frame_form_w_s {
> > +#ifdef __LITTLE_ENDIAN_BITFIELD
> > +  /* FRAME_FORM_W */
> > +		uint32_t dlc                     : 4;
> > +		uint32_t reserved_4              : 1;
> > +		uint32_t rtr                     : 1;
> > +		uint32_t ide                     : 1;
> > +		uint32_t fdf                     : 1;
> > +		uint32_t reserved_8              : 1;
> > +		uint32_t brs                     : 1;
> > +		uint32_t esi_rsv                 : 1;
> > +		uint32_t rwcnt                   : 5;
> > +		uint32_t reserved_31_16         : 16;
> > +#else
>
> I believe you should simply avoid using bitfields.

I would prefer style I have negotiated with my students for generated
HW description for RTEMS TI TMS570 support

  https://git.rtems.org/rtems/tree/bsps/arm/tms570/include/bsp/ti_herc/reg_dcan.h

but Ondrej Ille argued that the macro names are long and you need more of them
or ?: hack to encode filed position and its length. Which is correct arguments.
There are more Linux kernel files using this style

  grep -r  __LITTLE_ENDIAN_BITFIELD include

so we agreed that it should be acceptable. Big and little endian part
match is guaranteed because files are autogenerated.
Actual access and move to bitfiled typed variable is done
through right IO access functions and offsets are given by defines.
So there are no registers HW access overlay structures used.

> > +union ctu_can_fd_timestamp_l_w {
> > +	uint32_t u32;
> > +	struct ctu_can_fd_timestamp_l_w_s {
> > +  /* TIMESTAMP_L_W */
> > +		uint32_t time_stamp_31_0        : 32;
> > +	} s;
> > +};
>
> This is crazy.

Hmmm, we can add special rules to tools to skip some special cases
but actual files exactly math what is in documentation and VHDL
sources and registers implementation. See page 61 / PDF 67 of

  http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/Progdokum.pdf

Yes there is still space for improvements but we need to have
acceptable base for already running applications.

> > +union ctu_can_fd_data_5_8_w {
> > +	uint32_t u32;
> > +	struct ctu_can_fd_data_5_8_w_s {
> > +#ifdef __LITTLE_ENDIAN_BITFIELD
> > +  /* DATA_5_8_W */
> > +		uint32_t data_5                  : 8;
> > +		uint32_t data_6                  : 8;
> > +		uint32_t data_7                  : 8;
> > +		uint32_t data_8                  : 8;
> > +#else
> > +		uint32_t data_8                  : 8;
> > +		uint32_t data_7                  : 8;
> > +		uint32_t data_6                  : 8;
> > +		uint32_t data_5                  : 8;
> > +#endif
> > +	} s;
> > +};
>
> even more crazy.

Data part other then DATA_1_4_W is not referenced from the driver.
And yes, I would like more DATA_0_3_W etc... But question is indexing
in the standards. I have tried to help the project to move into direction
to be sustainable in our small team and enhance consistency.
But we have not resources to start whole
work from scratch again and due to effort into testing, analyses
etc. it would be extremely hard to get into same state again.
And I hope that there are not many really painfull limits for future
enhancements.

The design can be extended for 8 TX frames for examle. Above that there
would be problem with atomic priority management. But this should be
enough for most applications and if sequential stream at some priority
is required then we can combine core with DMA. The same for RX.
I plan DMA there. Actual design with SW controllable priorities
allows us to maintain single TX FIFO but even more dynamic multiqueue
FIFOs. I want to have time to experiment in these directions,
but until the code is mainlined it would be really headache
to keep additional features above base changing according to reviewer
requests. So when there is this really simple minimal base for CAN/CAN FD
functionality agreed upon then we want to develop extensions in more
directions interresting for us and our applications.

> > +#ifdef __KERNEL__
> > +# include <linux/can/dev.h>
> > +#else
> > +/* The hardware registers mapping and low level layer should build
> > + * in userspace to allow development and verification of CTU CAN IP
> > + * core VHDL design when loaded into hardware. Debugging hardware
> > + * from kernel driver is really difficult, leads to system stucks
> > + * by error reporting etc. Testing of exactly the same code
> > + * in userspace together with headers generated automatically
> > + * generated from from IP-XACT/cactus helps to driver to hardware
> > + * and QEMU emulation model consistency keeping.
> > + */
> > +# include "ctu_can_fd_linux_defs.h"
> > +#endif
>
> Please remove non-kernel code for merge.

This is only one line which allows us to run code test in userspace
which is of big help to keep code consistent. This part of kernel
driver sources is used during userspace test of hardware registers
implemented right in each FPGA build run so it checks that SW
and HW matches

  https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top/-/jobs/73445

See the line cantest/test_regtest.py::test_regtest PASSED

If you confirm that it is really required to remove this single
include ifdef then we remove it. But it would break our tooling
and we have to patching during tests or keep in sync two versions
of this C file which has to be prepared manually, it cannot be autogenerated,
because it holds algorithmic description how to access structures
defined by hardware.

> > +void ctucan_hw_write32(struct ctucan_hw_priv *priv,
> > +		       enum ctu_can_fd_can_registers reg, u32 val)
> > +{
> > +	iowrite32(val, priv->mem_base + reg);
> > +}
>
> And get rid of this kind of abstraction layer.

We need big and little endian support. This works and is tiny.
I can try to switch to linux/regmap.h, but it seems to me as a monster
and I do not understand it fully yet.

MCAN uses similar approach, common part

static inline u32 m_can_read(struct m_can_classdev *cdev, enum m_can_reg reg)
{
        return cdev->ops->read_reg(cdev, reg);
}

platform bus specific one

static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
{
        struct m_can_plat_priv *priv = cdev->device_data;

        return readl(priv->base + reg);
}

So I think that it is not against actual conventions.

When the CTU CAN FD IP core driver runs on big endian systems
then PCI bus is usually still mapped little endian way but platform
IP mapping is native big endian. Actual driver automatically decides
according to CTU_CAN_FD_DEVICE_ID register read.

> > +// TODO: rename or do not depend on previous value of id
>
> TODO: grep for TODO and C++ comments before attempting merge.

That is my mistake, but some of these are really there for future
development or cleanups, some only remarks. As I have said
I do not consider projects as perfect or finished but as in
state usable for broader community and when format is really
agreed/accepted then we can continue. But I do not want waste
my time to work above code base which has to be changed again
and again. So there are much more TODOs in my head.

> > +static bool ctucan_hw_len_to_dlc(u8 len, u8 *dlc)
> > +{
> > +	*dlc = can_len2dlc(len);
> > +	return true;
> > +}
>
> Compared to how well other code is documented... This one is voodoo.

OK, I have invested lot of time after Marin Jerabek's submission of diploma
theses to make code really documented etc.. I add there something
even that it is really simple use of can_len2dlc. May it be, we can
use that directly. It is Linux specific, but clean.

> > +bool ctucan_hw_set_ret_limit(struct ctucan_hw_priv *priv, bool enable,
> > u8 limit) +{
> > +	union ctu_can_fd_mode_settings reg;
> > +
> > +	if (limit > CTU_CAN_FD_RETR_MAX)
> > +		return false;
> > +
> > +	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_MODE);
> > +	reg.s.rtrle = enable ? RTRLE_ENABLED : RTRLE_DISABLED;
> > +	reg.s.rtrth = limit & 0xF;
> > +	priv->write_reg(priv, CTU_CAN_FD_MODE, reg.u32);
> > +	return true;
> > +}
>
> As elsewhere, I'd suggest 0/-ERRNO.

Hmm, generally there is attempt to keep ctu_can_fd_hw.c dependant
only on generated hardware description and independent of OS
specific constructs. It helps its testing in other environments.
Yes, there exists even Windows drier for other SkodaAuto
project and CTU CAN FD integration which runs same ctu_can_fd_hw.c
And it is the only part which directly depends on HW registers
placement. We do not go typical direction of Windows code and then
adaptation for Linux. We try to be OS agnostic in lowest level HW
adaptation and provide minimal well matching driver which does
not take care of generated sources.

> > +void ctucan_hw_set_mode_reg(struct ctucan_hw_priv *priv,
> > +			    const struct can_ctrlmode *mode)
> > +{
> > +	u32 flags = mode->flags;
> > +	union ctu_can_fd_mode_settings reg;
> > +
> > +	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_MODE);
> >
> > +	if (mode->mask & CAN_CTRLMODE_LOOPBACK)
> > +		reg.s.ilbp = flags & CAN_CTRLMODE_LOOPBACK ?
> > +					INT_LOOP_ENABLED : INT_LOOP_DISABLED;
> Not sure what is going on here, but having mode->flags in same format
> as hardware register would help...?
>

In this case we prefer to use defines which match Linux SocketCAN
defines (CAN_CTRLMODE_LOOPBACK,...) and translate them to HW specific
bits only inside ctu_can_fd_hw.c to not pollute driver by hardware
specific details. As you can see, we use Linux specific define
and adapt other builds to match Linux convention.

> > +	switch (fnum) {
> > +	case CTU_CAN_FD_FILTER_A:
> > +		if (reg.s.sfa)
> > +			return true;
> > +	break;
> > +	case CTU_CAN_FD_FILTER_B:
> > +		if (reg.s.sfb)
> > +			return true;
> > +	break;
> > +	case CTU_CAN_FD_FILTER_C:
> > +		if (reg.s.sfc)
> > +			return true;
> > +	break;
> > +	}
>
> Check indentation of break statemnts, also elsewhere in this file

OK, I look at examples, I am not sure if I have overlooked checkpatch.pl warnings...
I think that not. So it seems to be acceptabe for some case at least in 4.19 RT.

> > +bool ctucan_hw_get_range_filter_support(struct ctucan_hw_priv *priv)
> > +{
> > +	union ctu_can_fd_filter_control_filter_status reg;
> > +
> > +	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_FILTER_CONTROL);
> > +
> > +	if (reg.s.sfr)
> > +		return true;
>
> return !!reg.s.sfr; ?

OK.

> > +enum ctu_can_fd_tx_status_tx1s ctucan_hw_get_tx_status(struct
> > ctucan_hw_priv +							*priv, u8 buf)
>
> ...
>
> > +	default:
> > +		status = ~0;
> > +	}
> > +	return (enum ctu_can_fd_tx_status_tx1s)status;
> > +}
>
> Is ~0 in the enum?

This can happen only when there is fundamental internal error
in the code logic, but good catch, I add something to enum. 

> > +	// TODO: use named constants for the command
>
> TODO...

It is intenal mechanism between ctu_can_fd_hw.c and ctu_can_fd_hw.h
with fully documented external API in ctu_can_fd_hw.h .
So it is questionable if to polute user visible header
there by another definitions. May it be we should switch to
type ctu_can_fd_tx_command for command or do other optimization
which I can imagine.

This TODO is Ondrej Ille and Marin Jerabek leftover, so they
should provide their suggestion and intention there as well
as consequences of change for other projects which are
not mine busyness.
   

> > +// TODO: AL_CAPTURE and ERROR_CAPTURE
>

Again colleagues remark for future work. For me, it is important
basic function under GNU/Linux.

>
> > +#if defined(__LITTLE_ENDIAN_BITFIELD) == defined(__BIG_ENDIAN_BITFIELD)
> > +# error __BIG_ENDIAN_BITFIELD or __LITTLE_ENDIAN_BITFIELD must be
> > defined. +#endif
> >
> :-).

To catch problems in another more undermined environments which I am
happy not to take care at all.


> > +// True if Core is transceiver of current frame
> > +#define CTU_CAN_FD_IS_TRANSMITTER(stat) (!!(stat).ts)
> > +
> > +// True if Core is receiver of current frame
> > +#define CTU_CAN_FD_IS_RECEIVER(stat) (!!(stat).s.rxs)
>
> Why not, documentation is nice. But it is in big contrast to other
> parts of code where there's no docs at all.

This is to document things outside of ctu_can_fd_hw.c.
On the other hand actual HW is documented in referenced generated
PDF file so there is not so big need to documents each bit
of ctu_can_fd_hw.c . There is even internal HW docuemntation

  http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/ctu_can_fd_architecture.pdf

so in the fact these parts are documented for those who poke with them
quite well and for regular driver developer the functions of ctu_can_fd_hw.h
should provide all what is needed. And yes you can use referenced documentation
and go deeper

  https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core/-/blob/master/src/memory_registers/memory_registers.vhd

so basically ctu_can_fd_hw.c is interface between those who wants to go deeper,
try to modify HW, do verification etc. and these who do not care about these
HW specific bits and ctu_can_fd_hw.h should be sufficient for driver developers.

All this division to abstraction layers is result of more iterations thoughts and experiments.
There are not many open-source/open-hardware projects of this scale where to learn from
and we are really limited team. Chips Alliance aims this direction now
but CTU CAN FD project predates its founding by many years.

> > +struct ctucan_hw_priv;
> > +#ifndef ctucan_hw_priv
> > +struct ctucan_hw_priv {
> > +	void __iomem *mem_base;
> > +	u32 (*read_reg)(struct ctucan_hw_priv *priv,
> > +			enum ctu_can_fd_can_registers reg);
> > +	void (*write_reg)(struct ctucan_hw_priv *priv,
> > +			  enum ctu_can_fd_can_registers reg, u32 val);
> > +};
> > +#endif
>
> Should not be needed in kernel.

I am really not sure if this is required for some userpace tests or other CTU CAN FD
based projects. It is to colleagues participating in other projects to defend this
ifndef. I think that it is remnant of hacks before I have separated
ctucan_priv and ctucan_hw_priv structures for proper layering.


> > +/**
> > + * ctucan_hw_read_rx_word - Reads one word of CAN Frame from RX FIFO
> > Buffer. + *
> > + * @priv: Private info
> > + *
> > + * Return: One wword of received frame
>
> Typo 'word'.

Thanks.

> > +++ b/drivers/net/can/ctucanfd/ctu_can_fd_regs.h
> > @@ -0,0 +1,971 @@
> > +
> > +/* This file is autogenerated, DO NOT EDIT! */
> > +
>
> Yay. How is that supposed to work after merge?

I think that it is really better to not edit this file directly.
It has to match exactly hardware. So we provide compatible
license which allows you edit, but you have been warned
to not shoot into your own leg.

And for sure you can clone CTU CAN FD repo and experiment and generate
your own core derivative. You can even include tools into Linux
kernel tree or reference them

  https://github.com/Blebowski/Reg_Map_Gen
  https://github.com/Blebowski/ipyxact

same as use complete Kactus2 IP cores editor to manage specification file.

But if somebody wants to do such massive changes without coordination
with us it would be polite to copy driver do different directory under
another name and change "ctu,ctucanfd" in device tree to something
different.

Again thanks for review, I try to follow most of your suggestions
for some I would be really happy if you and other reviewers
try to look at the project as the whole. Linux driver is really
small (but very important) part and some relatively small
and I think not so important changes can result in significant
problems in another parts of the quite large project
and its automatic testing and inject errors without our notice.
Actual setup allows us to run full synthetic and real hardware
tests for each changed line in driver or HDL sources. This is simple
test and each night complex test including simulated jitter on CAN lines etc.
is run. In sum, it takes servers about three hours to do all testing
on multiple projects to provide next day results for the previous
day development step.

Best wishes,

                Pavel
