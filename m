Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1CA23B847
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 11:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbgHDJ5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 05:57:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:60716 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgHDJ5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 05:57:22 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D493F1C0BDD; Tue,  4 Aug 2020 11:57:17 +0200 (CEST)
Date:   Tue, 4 Aug 2020 11:57:17 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     pisa@cmp.felk.cvut.cz
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        mkl@pengutronix.de, socketcan@hartkopp.net, wg@grandegger.com,
        davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        c.emde@osadl.org, armbru@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com
Subject: Re: [PATCH v4 3/6] can: ctucanfd: add support for CTU CAN FD
 open-source IP core - bus independent part.
Message-ID: <20200804095717.irnchkz2imw7tdf7@duo.ucw.cz>
References: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
 <7360abc6087f63c34acdef6a2bf4b8c8cdbe9aa1.1596408856.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lf7ydybhil42shnj"
Content-Disposition: inline
In-Reply-To: <7360abc6087f63c34acdef6a2bf4b8c8cdbe9aa1.1596408856.git.pisa@cmp.felk.cvut.cz>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lf7ydybhil42shnj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> More about CAN related projects used and developed at the Faculty
> of the Electrical Engineering (http://www.fel.cvut.cz/en/)
> of Czech Technical University (https://www.cvut.cz/en)
> in at Prague http://canbus.pages.fel.cvut.cz/ .

Should this go to Documentation, not a changelog?

> +	help
> +	  This driver adds support for the CTU CAN FD open-source IP core.
> +	  More documentation and core sources at project page
> +	  (https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
> +	  The core integration to Xilinx Zynq system as platform driver
> +	  is available (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000=
-top).
> +	  Implementation on Intel FGA based PCI Express board is available
> +	  from project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).
> +	  More about CAN related projects used and developed at the Faculty
> +	  of the Electrical Engineering (http://www.fel.cvut.cz/en/)
> +	  of Czech Technical University in Prague (https://www.cvut.cz/en)
> +	  at http://canbus.pages.fel.cvut.cz/ .

Again, links to university main mage here are little bit excessive.

> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/***********************************************************************=
********
> + *
> + * CTU CAN FD IP Core
> + * Copyright (C) 2015-2018
> + *
> + * Authors:
> + *     Ondrej Ille <ondrej.ille@gmail.com>
> + *     Martin Jerabek <martin.jerabek01@gmail.com>
> + *     Jaroslav Beran <jara.beran@gmail.com>
> + *
> + * Project advisors:
> + *     Jiri Novak <jnovak@fel.cvut.cz>
> + *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
> + *
> + * Department of Measurement         (http://meas.fel.cvut.cz/)
> + * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
> + * Czech Technical University        (http://www.cvut.cz/)

Again, a bit too many links... and important information is missing:
who is the copyright holder?

> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.

With SPDX, this should be removed.

> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Martin Jerabek");
> +MODULE_DESCRIPTION("CTU CAN FD interface");

This normally goes to end of the file, MODULE_AUTHOR usually has <>
section with email address.

> +/* TX buffer rotation:
> + * - when a buffer transitions to empty state, rotate order and prioriti=
es
> + * - if more buffers seem to transition at the same time, rotate
> + *   by the number of buffers
> + * - it may be assumed that buffers transition to empty state in FIFO or=
der
> + *   (because we manage priorities that way)
> + * - at frame filling, do not rotate anything, just increment buffer mod=
ulo
> + *   counter
> + */
> +
> +#define CTUCAN_FLAG_RX_FFW_BUFFERED	1
> +
> +static int ctucan_reset(struct net_device *ndev)
> +{
> +	int i;
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +
> +	netdev_dbg(ndev, "ctucan_reset");
> +
> +	ctucan_hw_reset(&priv->p);
> +	for (i =3D 0; i < 100; ++i) {

i++ would be usual kernel style.

> +		if (ctucan_hw_check_access(&priv->p))
> +			return 0;
> +		usleep_range(100, 200);
> +	}
> +
> +	netdev_warn(ndev, "device did not leave reset\n");
> +	return -ETIMEDOUT;
> +}

This does extra sleep after last check_access... but I doubt that
matters.

> +static int ctucan_set_bittiming(struct net_device *ndev)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +	struct can_bittiming *bt =3D &priv->can.bittiming;
> +
> +	netdev_dbg(ndev, "ctucan_set_bittiming");
> +
> +	if (ctucan_hw_is_enabled(&priv->p)) {
> +		netdev_alert(ndev,
> +			     "BUG! Cannot set bittiming - CAN is enabled\n");
> +		return -EPERM;
> +	}

alert is normally reserved for .. way higher severity.


> +	/* Note that bt may be modified here */
> +	ctucan_hw_set_nom_bittiming(&priv->p, bt);
> +
> +	return 0;
> +}
> +
> +/**
> + * ctucan_set_data_bittiming - CAN set data bit timing routine
> + * @ndev:	Pointer to net_device structure
> + *
> + * This is the driver set data bittiming routine.
> + * Return: 0 on success and failure value on error
> + */
> +static int ctucan_set_data_bittiming(struct net_device *ndev)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +	struct can_bittiming *dbt =3D &priv->can.data_bittiming;
> +
> +	netdev_dbg(ndev, "ctucan_set_data_bittiming");
> +
> +	if (ctucan_hw_is_enabled(&priv->p)) {
> +		netdev_alert(ndev,
> +			     "BUG! Cannot set bittiming - CAN is enabled\n");
> +		return -EPERM;
> +	}
> +
> +	/* Note that dbt may be modified here */
> +	ctucan_hw_set_data_bittiming(&priv->p, dbt);
> +
> +	return 0;
> +}
> +
> +/**
> + * ctucan_set_secondary_sample_point - CAN set secondary sample point ro=
utine
> + * @ndev:	Pointer to net_device structure
> + *
> + * Return: 0 on success and failure value on error
> + */
> +static int ctucan_set_secondary_sample_point(struct net_device *ndev)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +	struct can_bittiming *dbt =3D &priv->can.data_bittiming;
> +	int ssp_offset =3D 0;
> +	bool ssp_ena;
> +
> +	netdev_dbg(ndev, "ctucan_set_secondary_sample_point");
> +
> +	if (ctucan_hw_is_enabled(&priv->p)) {
> +		netdev_alert(ndev,
> +			     "BUG! Cannot set SSP - CAN is enabled\n");
> +		return -EPERM;
> +	}
> +
> +	// Use for bit-rates above 1 Mbits/s

/* */ style comment would be more common here.

> +	if (dbt->bitrate > 1000000) {
> +		ssp_ena =3D true;
> +
> +		// Calculate SSP in minimal time quanta
> +		ssp_offset =3D (priv->can.clock.freq / 1000) *
> +			      dbt->sample_point / dbt->bitrate;
> +
> +		if (ssp_offset > 127) {
> +			netdev_warn(ndev, "SSP offset saturated to 127\n");
> +			ssp_offset =3D 127;
> +		}
> +	} else {
> +		ssp_ena =3D false;
> +	}

Init ssp_ena to false, and you can get rid of else branch?

> +/**
> + * ctucan_chip_start - This the drivers start routine
> + * @ndev:	Pointer to net_device structure
> + *
> + * This is the drivers start routine.

driver's?

> +/**
> + * ctucan_start_xmit - Starts the transmission
=2E..
> + * Return: 0 on success and failure value on error

Umm, no, AFAICT.

> +static int ctucan_start_xmit(struct sk_buff *skb, struct net_device *nde=
v)

Should it return netdev_tx_t ?

> +/**
> + * xcan_rx -  Is called from CAN isr to complete the received
> + *		frame  processing

Double space.

> +static const char *ctucan_state_to_str(enum can_state state)
> +{
> +	if (state >=3D CAN_STATE_MAX)
> +		return "UNKNOWN";
> +	return ctucan_state_strings[state];
> +}

Is enum always unsigned?

> +/**
> + * ctucan_err_interrupt - error frame Isr
> + * @ndev:	net_device pointer
> + * @isr:	interrupt status register value
> + *
> + * This is the CAN error interrupt and it will
> + * check the the type of error and forward the error
> + * frame to upper layers.
> + */

You are free to use 80 columns...

> +	skb =3D alloc_can_err_skb(ndev, &cf);
> +
> +	/* EWLI:  error warning limit condition met
> +	 * FCSI: Fault confinement State changed
> +	 * ALI:  arbitration lost (just informative)
> +	 * BEI:  bus error interrupt
> +	 */

Extra space before "error"... and something is wrong with big letters there.

> +		if (state =3D=3D CAN_STATE_BUS_OFF) {
> +			priv->can.can_stats.bus_off++;
> +			can_bus_off(ndev);
> +			if (skb)
> +				cf->can_id |=3D CAN_ERR_BUSOFF;
> +		} else if (state =3D=3D CAN_STATE_ERROR_PASSIVE) {
> +			priv->can.can_stats.error_passive++;
> +			if (skb) {
> +				cf->can_id |=3D CAN_ERR_CRTL;
> +				cf->data[1] =3D (berr.rxerr > 127) ?
> +						CAN_ERR_CRTL_RX_PASSIVE :
> +						CAN_ERR_CRTL_TX_PASSIVE;
> +				cf->data[6] =3D berr.txerr;
> +				cf->data[7] =3D berr.rxerr;
> +			}
> +		} else if (state =3D=3D CAN_STATE_ERROR_WARNING) {
> +			priv->can.can_stats.error_warning++;
> +			if (skb) {
> +				cf->can_id |=3D CAN_ERR_CRTL;
> +				cf->data[1] |=3D (berr.txerr > berr.rxerr) ?
> +					CAN_ERR_CRTL_TX_WARNING :
> +					CAN_ERR_CRTL_RX_WARNING;
> +				cf->data[6] =3D berr.txerr;
> +				cf->data[7] =3D berr.rxerr;
> +			}
> +		} else if (state =3D=3D CAN_STATE_ERROR_ACTIVE) {
> +			cf->data[1] =3D CAN_ERR_CRTL_ACTIVE;
> +			cf->data[6] =3D berr.txerr;
> +			cf->data[7] =3D berr.rxerr;
> +		} else {
> +			netdev_warn(ndev, "    unhandled error state (%d:%s)!",
> +				    state, ctucan_state_to_str(state));
> +		}

This sounds like switch (state) to me?


> +	/* Check for Bus Error interrupt */
> +	if (isr.s.bei) {
> +		netdev_info(ndev, "  bus error");
> +		priv->can.can_stats.bus_error++;
> +		stats->tx_errors++; // TODO: really?

really? :-).

> +		some_buffers_processed =3D false;
> +		while ((int)(priv->txb_head - priv->txb_tail) > 0) {
> +			u32 txb_idx =3D priv->txb_tail & priv->txb_mask;
> +			u32 status =3D ctucan_hw_get_tx_status(&priv->p, txb_idx);
> +
> +			netdev_dbg(ndev, "TXI: TXB#%u: status 0x%x",
> +				   txb_idx, status);
> +
> +			switch (status) {
> +			case TXT_TOK:
> +				netdev_dbg(ndev, "TXT_OK");
> +				can_get_echo_skb(ndev, txb_idx);
> +				stats->tx_packets++;
> +				break;
> +			case TXT_ERR:
> +				/* This indicated that retransmit limit has been
> +				 * reached. Obviously we should not echo the
> +				 * frame, but also not indicate any kind
> +				 * of error. If desired, it was already reported
> +				 * (possible multiple times) on each arbitration
> +				 * lost.
> +				 */
> +				netdev_warn(ndev, "TXB in Error state");
> +				can_free_echo_skb(ndev, txb_idx);
> +				stats->tx_dropped++;
> +				break;
> +			case TXT_ABT:
> +				/* Same as for TXT_ERR, only with different
> +				 * cause. We *could* re-queue the frame, but
> +				 * multiqueue/abort is not supported yet anyway.
> +				 */
> +				netdev_warn(ndev, "TXB in Aborted state");
> +				can_free_echo_skb(ndev, txb_idx);
> +				stats->tx_dropped++;
> +				break;
> +			default:
> +				/* Bug only if the first buffer is not finished,
> +				 * otherwise it is pretty much expected
> +				 */
> +				if (first) {
> +					netdev_err(ndev, "BUG: TXB#%u not in a finished state (0x%x)!",
> +						   txb_idx, status);
> +					spin_unlock_irqrestore(&priv->tx_lock,
> +							       flags);
> +					/* do not clear nor wake */
> +					return;
> +				}
> +				goto clear;
> +			}
> +			priv->txb_tail++;
> +			first =3D false;
> +			some_buffers_processed =3D true;
> +			/* Adjust priorities *before* marking the buffer
> +			 * as empty.
> +			 */
> +			ctucan_rotate_txb_prio(ndev);
> +			ctucan_hw_txt_set_empty(&priv->p, txb_idx);
> +		}
> +clear:
> +		spin_unlock_irqrestore(&priv->tx_lock, flags);

Could some part of this be split into separate function?

> +		/* If no buffers were processed this time, wa cannot

we

> +		 * clear - that would introduce a race condition.
> +		 */
> +		if (some_buffers_processed) {
> +			/* Clear the interrupt again as not to receive it again
> +			 * for a buffer we already handled (possibly causing
> +			 * the bug log)
> +			 */

Not sure this is correct english.

> +static irqreturn_t ctucan_interrupt(int irq, void *dev_id)
> +{
> +	struct net_device *ndev =3D (struct net_device *)dev_id;
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +	union ctu_can_fd_int_stat isr, icr;
> +	int irq_loops =3D 0;
> +
> +	netdev_dbg(ndev, "ctucan_interrupt");
> +
> +	do {
> +		/* Get the interrupt status */
> +		isr =3D ctu_can_fd_int_sts(&priv->p);

> +		}
> +		/* Ignore RI, TI, LFI, RFI, BSI */
> +	} while (irq_loops++ < 10000);

For loop would be more usual here.

> +static void ctucan_chip_stop(struct net_device *ndev)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +	union ctu_can_fd_int_stat mask;
> +
> +	netdev_dbg(ndev, "ctucan_chip_stop");
> +
> +	mask.u32 =3D 0xffffffff;
> +
> +	/* Disable interrupts and disable can */

can->CAN?

> +	netdev_dbg(ndev, "ctucan_open");
> +
> +	ret =3D pm_runtime_get_sync(priv->dev);
> +	if (ret < 0) {
> +		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> +			   __func__, ret);
> +		return ret;
> +	}

IIRC pm_runtime_get... is special, and you need to put even in the
error case.

> +	ret =3D pm_runtime_get_sync(priv->dev);
> +	if (ret < 0) {
> +		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> +			   __func__, ret);
> +		return ret;

Same here.


> +int ctucan_suspend(struct device *dev)
> +EXPORT_SYMBOL(ctucan_suspend);
> +int ctucan_resume(struct device *dev)
> +EXPORT_SYMBOL(ctucan_resume);

Exporting these is quite unusual.

> +int ctucan_probe_common(struct device *dev, void __iomem *addr,
> +			int irq, unsigned int ntxbufs, unsigned long can_clk_rate,
> +			int pm_enable_call, void (*set_drvdata_fnc)(struct device *dev,
> +			struct net_device *ndev))

At least format it so that set_drvdata_fnc is on single line?

> +{
=2E..
> +	if (set_drvdata_fnc !=3D NULL)
> +		set_drvdata_fnc(dev, ndev);

No need for !=3D NULL.

> +	SET_NETDEV_DEV(ndev, dev);
> +	ndev->netdev_ops =3D &ctucan_netdev_ops;
> +
> +	/* Getting the CAN can_clk info */
> +	if (can_clk_rate =3D=3D 0) {

!can_clk_rate would work, too.

> +		priv->can_clk =3D devm_clk_get(dev, NULL);
> +		if (IS_ERR(priv->can_clk)) {
> +			dev_err(dev, "Device clock not found.\n");
> +			ret =3D PTR_ERR(priv->can_clk);
> +			goto err_free;
> +		}
> +		can_clk_rate =3D clk_get_rate(priv->can_clk);
> +	}
> +
> +	priv->p.write_reg =3D ctucan_hw_write32;
> +	priv->p.read_reg =3D ctucan_hw_read32;
> +
> +	if (pm_enable_call)
> +		pm_runtime_enable(dev);
> +	ret =3D pm_runtime_get_sync(dev);
> +	if (ret < 0) {

put?

> +	if ((priv->p.read_reg(&priv->p, CTU_CAN_FD_DEVICE_ID) &
> +			    0xFFFF) !=3D CTU_CAN_FD_ID) {
> +		priv->p.write_reg =3D ctucan_hw_write32_be;
> +		priv->p.read_reg =3D ctucan_hw_read32_be;
> +		if ((priv->p.read_reg(&priv->p, CTU_CAN_FD_DEVICE_ID) &
> +			      0xFFFF) !=3D CTU_CAN_FD_ID) {
> +			netdev_err(ndev, "CTU_CAN_FD signature not found\n");
> +			ret =3D -ENODEV;
> +			goto err_disableclks;
> +		}
> +	}
> +
> +	ret =3D ctucan_reset(ndev);
> +	if (ret < 0)
> +		goto err_pmdisable;

Should be goto err_disableclks, AFAICT. Plus that label is quite confusing.

> +static __init int ctucan_init(void)
> +{
> +	pr_info("%s CAN netdevice driver\n", DRV_NAME);
> +
> +	return 0;
> +}
> +
> +module_init(ctucan_init);

> +static __exit void ctucan_exit(void)
> +{
> +	pr_info("%s: driver removed\n", DRV_NAME);
> +}
> +
> +module_exit(ctucan_exit);

Remove?

> +#ifndef __KERNEL__
> +# include "ctu_can_fd_linux_defs.h"
> +#else
> +# include <linux/can/dev.h>
> +#endif

Should always assume kernel?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--lf7ydybhil42shnj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXykw/QAKCRAw5/Bqldv6
8hjLAJ9NpyEfZvBP5a2AeZYr0dwN1Q4PawCgq1JN0ymZVT9m7Ovloub9NAqPPKo=
=L+bf
-----END PGP SIGNATURE-----

--lf7ydybhil42shnj--
