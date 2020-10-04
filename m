Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA06C282A8B
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 14:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgJDMGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 08:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgJDMGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 08:06:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE85EC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 05:06:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kP2mT-0005JQ-SU; Sun, 04 Oct 2020 14:06:22 +0200
Received: from [IPv6:2a03:f580:87bc:d400:fc36:ae63:3b35:518b] (unknown [IPv6:2a03:f580:87bc:d400:fc36:ae63:3b35:518b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A2396571D7B;
        Sun,  4 Oct 2020 12:06:15 +0000 (UTC)
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:USB ACM DRIVER" <linux-usb@vger.kernel.org>
References: <20201002154219.4887-1-mailhol.vincent@wanadoo.fr>
 <20201002154219.4887-7-mailhol.vincent@wanadoo.fr>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v3 6/7] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
Message-ID: <c501e9ea-5412-fa90-b403-d34ca4720c89@pengutronix.de>
Date:   Sun, 4 Oct 2020 14:06:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002154219.4887-7-mailhol.vincent@wanadoo.fr>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="wMhVG32HjFARa34XVG4nZwLDIUokyA1hY"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wMhVG32HjFARa34XVG4nZwLDIUokyA1hY
Content-Type: multipart/mixed; boundary="HiCipzREk1B7fELUCveWtQNVHh66zw9bN";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
 Masahiro Yamada <masahiroy@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "open list:USB ACM DRIVER" <linux-usb@vger.kernel.org>
Message-ID: <c501e9ea-5412-fa90-b403-d34ca4720c89@pengutronix.de>
Subject: Re: [PATCH v3 6/7] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
References: <20201002154219.4887-1-mailhol.vincent@wanadoo.fr>
 <20201002154219.4887-7-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20201002154219.4887-7-mailhol.vincent@wanadoo.fr>

--HiCipzREk1B7fELUCveWtQNVHh66zw9bN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/2/20 5:41 PM, Vincent Mailhol wrote:
> This driver supports the ES581.4, ES582.1 and ES584.1 interfaces from
> ETAS GmbH (https://www.etas.com/en/products/es58x.php).
>=20
> Co-developed-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.=
com>
> Signed-off-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.co=
m>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>=20
> Changes in v3:
>   - Remove all the calls to likely() and unlikely().
>=20
> Changes in v2:
>   - Fixed -W1 warnings (v1 was tested with GCC -WExtra but not with -W1=
).
> ---
>  drivers/net/can/usb/Kconfig                 |    9 +
>  drivers/net/can/usb/Makefile                |    1 +
>  drivers/net/can/usb/etas_es58x/Makefile     |    3 +
>  drivers/net/can/usb/etas_es58x/es581_4.c    |  559 ++++
>  drivers/net/can/usb/etas_es58x/es581_4.h    |  237 ++
>  drivers/net/can/usb/etas_es58x/es58x_core.c | 2725 +++++++++++++++++++=

>  drivers/net/can/usb/etas_es58x/es58x_core.h |  700 +++++
>  drivers/net/can/usb/etas_es58x/es58x_fd.c   |  648 +++++
>  drivers/net/can/usb/etas_es58x/es58x_fd.h   |  243 ++
>  9 files changed, 5125 insertions(+)
>  create mode 100644 drivers/net/can/usb/etas_es58x/Makefile
>  create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.c
>  create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.h
>  create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.c
>  create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.h
>  create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.c
>  create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.h

[...]

Just one header file for now :)

> diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/=
can/usb/etas_es58x/es58x_core.h
> new file mode 100644
> index 000000000000..359ddc44a3ad
> --- /dev/null
> +++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
> @@ -0,0 +1,700 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
> + *
> + * File es58x_core.h: All common definitions and declarations.
> + *
> + * Copyright (C) 2019 Robert Bosch Engineering and Business
> + * Solutions. All rights reserved.
> + * Copyright (C) 2020 ETAS K.K.. All rights reserved.
> + */
> +
> +#ifndef __ES58X_COMMON_H__
> +#define __ES58X_COMMON_H__
> +
> +#include <linux/types.h>
> +#include <linux/usb.h>
> +#include <linux/netdevice.h>
> +#include <linux/can.h>
> +#include <linux/can/dev.h>
> +
> +#include "es581_4.h"
> +#include "es58x_fd.h"
> +
> +/* Size of a CAN Standard Frame (rounded up and ignoring bitsuffing). =
*/
> +#define ES58X_SFF_BYTES(data_len) (round_up(47, 8) / 8 + (data_len))

DIV_ROUNDUP

> +/* Size of a CAN Extended Frame (rounded up and ignoring bitsuffing). =
*/
> +#define ES58X_EFF_BYTES(data_len) (round_up(67, 8) / 8 + (data_len))

dame here
> +/* Maximum size of a CAN frame (rounded up and ignoring bitsuffing). *=
/
> +#define ES58X_CAN_FRAME_BYTES_MAX ES58X_EFF_BYTES(CAN_MAX_DLEN)

please add a new file between the define and the doc of the next one

> +/* Maximum size of a CAN-FD frame (rough estimation because
> + * ES58X_SFF_BYTES() and ES58X_EFF_BYTES() macros are using the
> + * constant values for CAN not CAN-FD).
> + */
> +#define ES58X_CANFD_FRAME_BYTES_MAX ES58X_EFF_BYTES(CANFD_MAX_DLEN)
> +
> +/* Driver constants */
> +#define ES58X_RX_URBS_MAX         5	// Empirical value
> +#define ES58X_TX_URBS_MAX         8	// Empirical value

please use one space only

> +
> +#define ES58X_MAX(param)				\
> +	(ES581_4_##param > ES58X_FD_##param ?		\
> +		ES581_4_##param : ES58X_FD_##param)
> +#define ES58X_TX_BULK_MAX ES58X_MAX(TX_BULK_MAX)
> +#define ES58X_RX_BULK_MAX ES58X_MAX(RX_BULK_MAX)
> +#define ES58X_RX_LOOPBACK_BULK_MAX ES58X_MAX(RX_LOOPBACK_BULK_MAX)
> +#define ES58X_NUM_CAN_CH_MAX ES58X_MAX(NUM_CAN_CH)
> +
> +/* Use this when channel index is irrelevant (e.g. device
> + * timestamp).
> + */
> +#define ES58X_CHANNEL_IDX_NA 0xFF
> +#define ES58X_EMPTY_MSG NULL
> +
> +/* Threshold on consecutive CAN_STATE_ERROR_PASSIVE. If we receive
> + * ES58X_CONSECUTIVE_ERR_PASSIVE_MAX times the event
> + * ES58X_ERR_CRTL_PASSIVE in a row without any successful Rx or Tx,
> + * we force the device to switch to CAN_STATE_BUS_OFF state.
> + */
> +#define ES58X_CONSECUTIVE_ERR_PASSIVE_MAX 254

Does the device recover from bus off automatically or why is this needed?=


> +
> +enum es58x_self_reception_mode {
> +	ES58X_SELF_RECEPTION_OFF =3D 0,
> +	ES58X_SELF_RECEPTION_ON =3D 1
> +};

nitpick: can you name all enums (here and below) according to the type?

e.g. ES58x_SELF_RECEPTION_MODE_OFF

> +
> +enum es58x_physical_media {
> +	ES58X_MEDIA_HIGH_SPEED =3D 1,
> +	ES58X_MEDIA_FAULT_TOLERANT =3D 2

You mean with FAULT_TOLERANT you mean ISO 11898-3? According to [1] they =
should
be named low speed.

[1]
https://can-cia.org/news/press-releases/view/harmonized-transceiver-namin=
g/2020/7/16/

> +};
> +
> +enum es58x_samples_per_bit {
> +	ES58X_ONE_SAMPLE_PER_BIT =3D 1,
> +
> +	/* Some CAN controllers do not support three samples per
> +	 * bit. In this case the default value of one sample per bit
> +	 * is used, even if the configuration is set to
> +	 * ES58X_THREE_SAMPLES_PER_BIT.
> +	 */

Can you autodetect the controller and avoid announcing tripple sample mod=
e to
the driver framework?

> +	ES58X_THREE_SAMPLES_PER_BIT =3D 2
> +};
> +
> +enum es58x_sync_edge {
> +	/* ISO CAN specification defines the use of a single edge
> +	 * synchronization. The synchronization should be done on
> +	 * recessive to dominant level change.
> +	 */
> +	ES58X_SINGLE_SYNC_EDGE =3D 1,
> +
> +	/* In addition to the ISO CAN specification, a double
> +	 * synchronization is also supported: recessive to dominant
> +	 * level change and dominant to recessive level change.
> +	 */
> +	ES58X_DUAL_SYNC_EDGE =3D 2

We don't have a setting in the CAN framework for this....

> +};
> +
> +/**
> + * enum es58x_flag_type - CAN flags for RX/TX messages.
> + * @ES58X_FLAG_EFF: Extended Frame Format (EFF).
> + * @ES58X_FLAG_RTR: Remote Transmission Request (RTR).
> + * @ES58X_FLAG_SELFRECEPTION: The message is a Self reception frame
> + *	(not used yet in this implementation).
> + * @ES58X_FLAG_FD_BRS: Bit rate switch (BRS): second bitrate for
> + *	payload data.
> + * @ES58X_FLAG_FD_MSG_TRUNCATED: FD message was truncated and padded
> + *	(not used).
> + * @ES58X_FLAG_FD_ESI: Error State Indicator (ESI): tell if the
> + *	transmitting node is in error passive mode.
> + * @ES58X_FLAG_FD_DATA: CAN FD frame.
> + */
> +enum es58x_flag_type {
> +	ES58X_FLAG_EFF =3D BIT(0),
> +	ES58X_FLAG_RTR =3D BIT(1),
> +	ES58X_FLAG_SELFRECEPTION =3D BIT(2),
> +	ES58X_FLAG_FD_BRS =3D BIT(3),
> +	ES58X_FLAG_FD_MSG_TRUNCATED =3D BIT(4),
> +	ES58X_FLAG_FD_ESI =3D BIT(5),
> +	ES58X_FLAG_FD_DATA =3D BIT(6)
> +};
> +
> +/**
> + * enum es58x_error - CAN error detection.
> + * @ES58X_ERR_OK: No errors.
> + * @ES58X_ERR_PROT_STUFF: Bit stuffing error: more than 5 consecutive
> + *	equal bits.
> + * @ES58X_ERR_PROT_FORM: Frame format error.
> + * @ES58X_ERR_ACK: Received no ACK on transmission.
> + * @ES58X_ERR_PROT_BIT: Single bit error.
> + * @ES58X_ERR_PROT_CRC: Incorrect 15, 17 or 21 bits CRC.
> + * @ES58X_ERR_PROT_BIT1: Unable to send recessive bit: tried to send
> + *	recessive bit 1 but monitored dominant bit 0.
> + * @ES58X_ERR_PROT_BIT0: Unable to send dominant bit: tried to send
> + *	dominant bit 0 but monitored recessive bit 1.
> + * @ES58X_ERR_PROT_OVERLOAD: Bus overload.
> + * @ES58X_ERR_PROT_UNSPEC: Unspecified.
> + *
> + * Please refer to ISO 11898-1:2015, section 10.11 "Error detection"
> + * and section 10.13 "Overload signaling" for additional details.
> + */
> +enum es58x_error {
> +	ES58X_ERR_OK =3D 0,
> +	ES58X_ERR_PROT_STUFF =3D BIT(0),
> +	ES58X_ERR_PROT_FORM =3D BIT(1),
> +	ES58X_ERR_ACK =3D BIT(2),
> +	ES58X_ERR_PROT_BIT =3D BIT(3),
> +	ES58X_ERR_PROT_CRC =3D BIT(4),
> +	ES58X_ERR_PROT_BIT1 =3D BIT(5),
> +	ES58X_ERR_PROT_BIT0 =3D BIT(6),
> +	ES58X_ERR_PROT_OVERLOAD =3D BIT(7),
> +	ES58X_ERR_PROT_UNSPEC =3D BIT(31)
> +};
> +
> +/**
> + * enum es58x_event - CAN error codes returned by the device.
> + * @ES58X_EVENT_OK: No errors.
> + * @ES58X_ERR_CRTL_ACTIVE: Active state: both TR and RX error count is=

> + *	less than 128.
> + * @ES58X_ERR_CRTL_PASSIVE: Passive state: either TX or RX error count=

> + *	is greater than 127.
> + * @ES58X_ERR_CRTL_WARNING: Warning state: either TX or RX error count=

> + *	is greater than 96.
> + * @ES58X_ERR_BUSOFF: Bus off.
> + * @ES58X_ERR_SINGLE_WIRE: Lost connection on either CAN high or CAN l=
ow.
> + *
> + * Please refer to ISO 11898-1:2015, section 12.1.4 "Rules of fault
> + * confinement" for additional details.
> + */
> +enum es58x_event {
> +	ES58X_EVENT_OK =3D 0,
> +	ES58X_ERR_CRTL_ACTIVE =3D BIT(0),
> +	ES58X_ERR_CRTL_PASSIVE =3D BIT(1),
> +	ES58X_ERR_CRTL_WARNING =3D BIT(2),
> +	ES58X_ERR_BUSOFF =3D BIT(3),
> +	ES58X_ERR_SINGLE_WIRE =3D BIT(4)
> +};
> +
> +/**
> + * enum es58x_dev_ret_code_u8 - Device error codes, 8 bit format.
> + *
> + * Specific to ES581.4.
> + */
> +enum es58x_dev_ret_code_u8 {
> +	ES58X_RET_U8_OK =3D 0x00,
> +	ES58X_RET_U8_ERR_UNSPECIFIED_FAILURE =3D 0x80,
> +	ES58X_RET_U8_ERR_NO_MEM =3D 0x81,
> +	ES58X_RET_U8_ERR_BAD_CRC =3D 0x99
> +};
> +
> +/**
> + * enum es58x_dev_ret_code_u32 - Device error codes, 32 bit format.
> + */
> +enum es58x_cmd_ret_code_u32 {
> +	ES58X_RET_U32_OK =3D 0x00000000UL,
> +	ES58X_RET_U32_ERR_UNSPECIFIED_FAILURE =3D 0x80000000UL,
> +	ES58X_RET_U32_ERR_NO_MEM =3D 0x80004001UL,
> +	ES58X_RET_U32_WARN_PARAM_ADJUSTED =3D 0x40004000UL,
> +	ES58X_RET_U32_WARN_TX_MAYBE_REORDER =3D 0x40004001UL,
> +	ES58X_RET_U32_ERR_TIMEOUT =3D 0x80000008UL,
> +	ES58X_RET_U32_ERR_FIFO_FULL =3D 0x80003002UL,
> +	ES58X_RET_U32_ERR_BAD_CONFIG =3D 0x80004000UL,
> +	ES58X_RET_U32_ERR_NO_RESOURCE =3D 0x80004002UL
> +};
> +
> +enum es58x_cmd_ret_type {
> +	ES58X_RET_TYPE_SET_BITTIMING,
> +	ES58X_RET_TYPE_ENABLE_CHANNEL,
> +	ES58X_RET_TYPE_DISABLE_CHANNEL,
> +	ES58X_RET_TYPE_TX_MSG,
> +	ES58X_RET_TYPE_RESET_RX,
> +	ES58X_RET_TYPE_RESET_TX,
> +	ES58X_RET_TYPE_DEVICE_ERR_FRAME,
> +	ES58X_CMD_RET_TYPE_NUM_ENTRIES
> +};
> +
> +/**
> + * struct es58x_abstracted_can_frame - Common structure to hold can
> + *	frame information.

why do you have an itermediate can frame format? We have the struct can_f=
rame
and the skb for this.

> + * @timestamp: Hardware time stamp (only relevant in rx branches).
> + * @data: CAN payload.
> + * @can_id: CAN ID.
> + * @is_can_fd: false: non-FD CAN, true: CAN-FD.
> + * @flags: Please refer to enum es58x_flag_type.
> + * @dlc: Data Length Code (raw value). When using standard (non-FD)
> + *	CAN, ES58X devices allow to send DLC bigger than 8
> + *	(i.e. values 9 to 15 reserved for CAN-FD) as specified in ISO
> + *	11898-1:2015 section 8.4.2.4 "DLC field". In such case, the
> + *	@dlc field will contain whatever value was obtained when
> + *	sending or receiving but the @len field will contain the
> + *	sanitized length of the @data field (i.e. not more than
> + *	CAN_MAX_DLEN for standard CAN). To be able to send/receive
> + *	such "out of range" DLC values, you would need to modify the
> + *	first occurrence of the if conditions "cfd->len >
> + *	CAN_MAX_DLEN" into "cfd->len > CANFD_MAX_DLC" in functions
> + *	net/can/af_can.c:can_send() and net/can/af_can.c:can_rcv().
> + * @len: Length of @data field (sanitized in es58x_core.c).
> + *
> + * ES581.4 and the ES58X FD family uses different tx_can_msg
> + * structures (same fields but in different order). This abstracted
> + * structure allows to calculate the parameters once for all. The
> + * specific functions of each device model can then use the
> + * pre-computed information from this abstracted can frame.
> + */
> +struct es58x_abstracted_can_frame {
> +	u64 timestamp;
> +	const u8 *data;
> +	canid_t can_id;
> +	bool is_can_fd;
> +	u8 flags;
> +	u8 dlc;
> +	u8 len;
> +};
> +
> +union es58x_urb_cmd {
> +	u8 raw_cmd[0];

I have to polish my C, what's an empty array in the beginning of a struct=
?

> +	struct es581_4_urb_cmd es581_4_urb_cmd;
> +	struct es58x_fd_urb_cmd es58x_fd_urb_cmd;
> +	struct {		// Common header parts of all variants

no // comments please

> +		__le16 sof;
> +		u8 cmd_type;
> +		u8 cmd_id;
> +	} __packed;
> +};
> +
> +/**
> + * struct es58x_priv - All information specific to a can channel.
> + * @can: struct can_priv must be the first member (Socket CAN relies
> + *	on the fact that function netdev_priv() returns a pointer to
> + *	a struct can_priv).
> + * @es58x_dev: pointer to the corresponding ES58X device.
> + * @echo_skb_spinlock: Spinlock to protect the access to the echo skb
> + *	FIFO.
> + * @current_packet_idx: Keeps track of the packet indexes.
> + * @echo_skb_tail_idx: beginning of the echo skb FIFO, i.e. index of
> + *	the first element.
> + * @echo_skb_head_idx: end of the echo skb FIFO plus one, i.e. first
> + *	free index.
> + * @num_echo_skb: actual number of elements in the FIFO. Thus, the end=

> + *	of the FIFO is echo_skb_head =3D (echo_skb_tail_idx +
> + *	num_echo_skb) % can.echo_skb_max.
> + * @tx_urb: Used as a buffer to concatenate the TX messages and to do
> + *	a bulk send. Please refer to es58x_start_xmit() for more
> + *	details.
> + * @tx_can_msg_is_fd: false: all messages in @tx_urb are non-FD CAN,
> + *	true: all messages in @tx_urb are CAN-FD. Rationale: ES58X FD
> + *	devices do not allow to mix standard and FD CAN in one single
> + *	bulk transmission.
> + * @tx_can_msg_cnt: Number of messages in @tx_urb.
> + * @err_passive_before_rtx_success: The ES58X device might enter in a
> + *	state in which it keeps alternating between error passive
> + *	and active state. This counter keeps track of the number of
> + *	error passive and if it gets bigger than
> + *	ES58X_CONSECUTIVE_ERR_PASSIVE_MAX, es58x_rx_err_msg() will
> + *	force the status to bus-off.

Is this a bug or a feature?

> + * @channel_idx: Channel index, starts at zero.
> + */
> +struct es58x_priv {
> +	struct can_priv can;
> +	struct es58x_device *es58x_dev;
> +
> +	spinlock_t echo_skb_spinlock;	// Comments: c.f. supra

please no // comments

> +	u32 current_packet_idx;
> +	u16 echo_skb_tail_idx;
> +	u16 echo_skb_head_idx;
> +	u16 num_echo_skb;
> +
> +	struct urb *tx_urb;
> +	bool tx_can_msg_is_fd;
> +	u8 tx_can_msg_cnt;
> +
> +	u8 err_passive_before_rtx_success;
> +
> +	u8 channel_idx;
> +};
> +
> +/**
> + * struct es58x_parameters - Constant parameters of a given hardware
> + *	variant.
> + * @can_bittiming_const: Nominal bittimming parameters (used for
> + *	non-FD CAN and arbitration field of CAN-FD).
> + * @data_bittiming_const: Data bittiming parameters (used for CAN-FD
> + *	payload)
> + * @bitrate_max: Maximum bitrate supported by the device.
> + * @clock: CAN clock parameters.
> + * @ctrlmode_supported: List of supported modes. Please refer to
> + *	can/netlink.h file for additional details.
> + * @tx_start_of_frame: Magic number at the beginning of each TX URB
> + *	command.
> + * @rx_start_of_frame: Magic number at the beginning of each RX URB
> + *	command.
> + * @tx_urb_cmd_max_len: Maximum length of a TX URB command.
> + * @rx_urb_cmd_max_len: Maximum length of a RX URB command.
> + * @echo_skb_max: Maximum number of echo SKB. This value must not
> + *	exceed the maximum size of the device internal TX FIFO
> + *	length. This parameter is used to control the network queue
> + *	wake/stop logic.
> + * @dql_limit_min: Dynamic Queue Limits (DQL) absolute minimum limit
> + *	of bytes allowed to be queued on this network device transmit
> + *	queue. Used by the Byte Queue Limits (BQL) to determine how
> + *	frequently the xmit_more flag will be set to true in
> + *	es58x_start_xmit(). Set this value higher to optimize for
> + *	throughput but be aware that it might have a negative impact
> + *	on the latency! This value can also be set dynamically. Please
> + *	refer to Documentation/ABI/testing/sysfs-class-net-queues for
> + *	more details.
> + * @tx_bulk_max: Maximum number of Tx messages that can be sent in one=

> + *	single URB packet.
> + * @urb_cmd_header_len: Length of the URB command header.
> + * @rx_urb_max: Number of RX URB to be allocated during device probe.
> + * @tx_urb_max: Number of TX URB to be allocated during device probe.
> + * @channel_idx_offset: Some of the ES58x starts channel numbering
> + *	from 0 (ES58X FD), others from 1 (ES581.4).
> + */
> +struct es58x_parameters {
> +	const struct can_bittiming_const *bittiming_const;
> +	const struct can_bittiming_const *data_bittiming_const;
> +	u32 bitrate_max;
> +	struct can_clock clock;
> +	u32 ctrlmode_supported;
> +	u16 tx_start_of_frame;
> +	u16 rx_start_of_frame;
> +	u16 tx_urb_cmd_max_len;
> +	u16 rx_urb_cmd_max_len;
> +	u16 echo_skb_max;
> +	u16 dql_limit_min;
> +	u8 tx_bulk_max;
> +	u8 urb_cmd_header_len;
> +	u8 rx_urb_max;
> +	u8 tx_urb_max;
> +	u8 channel_idx_offset;
> +};
> +
> +/**
> + * struct es58x_operators - Function pointers used to encode/decode
> + *	the TX/RX messages.
> + * @get_msg_len: Get field msg_len of the urb_cmd. The offset of
> + *	msg_len inside urb_cmd depends of the device model.
> + * @handle_urb_cmd: Handle URB command received from the device and
> + *	manage the return code from device.
> + * @fill_urb_header: Fill the header of urb_cmd.
> + * @tx_can_msg: Encode a TX CAN message and add it to the bulk buffer
> + *	cmd_buf of es58x_dev.
> + * @set_bittiming: Encode the bittiming information and send it.
> + * @enable_channel: Start the CAN channel with index channel_idx.
> + * @disable_channel: Stop the CAN channel with index channel_idx.
> + * @reset_rx: Reset the RX queue of the ES58X device.
> + * @reset_tx: Reset the TX queue of the ES58X device.
> + * @get_timestamp: Request a timestamp from the ES58X device.
> + */
> +struct es58x_operators {
> +	u16 (*get_msg_len)(const union es58x_urb_cmd *urb_cmd);
> +	int (*handle_urb_cmd)(struct es58x_device *es58x_dev,
> +			      const union es58x_urb_cmd *urb_cmd);
> +	void (*fill_urb_header)(union es58x_urb_cmd *urb_cmd, u8 cmd_type,
> +				u8 cmd_id, u8 channel_idx, u16 cmd_len);
> +	int (*tx_can_msg)(struct es58x_device *es58x_dev, int channel_idx,
> +			  u32 packet_idx,
> +			   struct es58x_abstracted_can_frame *es58x_frame,
> +			   union es58x_urb_cmd *urb_cmd, u32 *urb_cmd_len);
> +	int (*set_bittiming)(struct es58x_device *es58x_dev, int channel_idx)=
;
> +	int (*enable_channel)(struct es58x_device *es58x_dev,
> +			      int channel_idx);
> +	int (*disable_channel)(struct es58x_device *es58x_dev,
> +			       int channel_idx);
> +	int (*reset_rx)(struct es58x_device *es58x_dev, int channel_idx);
> +	int (*reset_tx)(struct es58x_device *es58x_dev, int channel_idx);
> +	int (*get_timestamp)(struct es58x_device *es58x_dev);
> +};
> +
> +/**
> + * struct es58x_device - All information specific to an ES58X device.
> + * @dev: Device information.
> + * @udev: USB device information.
> + * @netdev: Array of our CAN channels.
> + * @param: The constant parameters.
> + * @ops: Operators.
> + * @rx_pipe: USB reception pipe.
> + * @tx_pipe: USB transmission pipe.
> + * @rx_urbs: Anchor for received URBs.
> + * @tx_urbs_busy: Anchor for TX URBs which were send to the device.
> + * @tx_urbs_idle: Anchor for TX USB which are idle. This driver
> + *	allocates the memory for the URBs during the probe. When a TX
> + *	URB is needed, it can be taken from this anchor. The network
> + *	queue wake/stop logic should prevent this URB from getting
> + *	empty. Please refer to es58x_get_tx_urb() for more details.
> + * @tx_urbs_idle_cnt: number of urbs in @tx_urbs_idle.
> + * @ktime_req_ns: kernel timestamp when es58x_set_realtime_diff_ns()
> + *	was called.
> + * @realtime_diff_ns: difference in nanoseconds between the clocks of
> + *	the ES58X device and the kernel.
> + * @timestamps: a temporary buffer to store the time stamps before
> + *	feeding them to es58x_can_get_echo_skb(). Can only be used
> + *	in rx branches.
> + * @can_frames: a temporary buffer to store the can frames before
> + *	feeding them to es58x_rx_can_msg(). Can only be used in rx
> + *	branches.
> + * @rx_max_packet_size: Maximum length of bulk-in URB.
> + * @num_can_ch: Number of CAN channel (i.e. number of elements of @net=
dev).
> + * @rx_cmd_buf_len: Length of @rx_cmd_buf.
> + * @rx_cmd_buf: The device might split the URB commands in an
> + *	arbitrary amount of pieces. This buffer is used to concatenate
> + *	all those pieces. Can only be used in rx branches. This field
> + *	has to be the last one of the structure because it is has a
> + *	flexible size (c.f. ES58X_SIZEOF_ES58X_DEVICE() macro).
> + */
> +struct es58x_device {
> +	struct device *dev;
> +	struct usb_device *udev;
> +	struct net_device *netdev[ES58X_NUM_CAN_CH_MAX];
> +
> +	const struct es58x_parameters *param;
> +	const struct es58x_operators *ops;
> +
> +	int rx_pipe;
> +	int tx_pipe;
> +
> +	struct usb_anchor rx_urbs;
> +	struct usb_anchor tx_urbs_busy;
> +	struct usb_anchor tx_urbs_idle;
> +	atomic_t tx_urbs_idle_cnt;
> +
> +	u64 ktime_req_ns;
> +	s64 realtime_diff_ns;
> +
> +	union {
> +		u64 timestamps[ES58X_RX_LOOPBACK_BULK_MAX];
> +		struct es58x_abstracted_can_frame can_frames[ES58X_RX_BULK_MAX];
> +	};
> +
> +	u16 rx_max_packet_size;
> +	u8 num_can_ch;
> +
> +	u16 rx_cmd_buf_len;
> +	union es58x_urb_cmd rx_cmd_buf;
> +};
> +
> +/**
> + * ES58X_SIZEOF_ES58X_DEVICE() - Calculate the maximum length of
> + *	struct es58x_device.
> + * @es58x_dev_param: The constant parameters of the device.
> + *
> + * The length of struct es58x_device depends on the length of its last=

> + * field: rx_cmd_buf. This macro allows to optimize size for memory
> + * allocation.
> + *
> + * Return: length of struct es58x_device.
> + */
> +#define ES58X_SIZEOF_ES58X_DEVICE(es58x_dev_param)			\
> +	(offsetof(struct es58x_device, rx_cmd_buf) +			\
> +		(es58x_dev_param)->rx_urb_cmd_max_len)

can this be made a static inline?

> +
> +/* Megabit per second (multiply x per one million) */
> +#define ES58X_MBPS(x) (1000000UL * (x))
> +/* Megahertz (multiply x per one million) */
> +#define ES58X_MHZ(x)  (1000000UL * (x))
> +
> +/**
> + * es58x_check_msg_len() - Check the size of a received message.
> + * @dev: Device, used to print error messages.
> + * @msg: Received message, must not be a pointer.
> + * @actual_len: Length of the message as advertised in the command hea=
der.
> + *
> + * Must be a macro in order to retrieve the actual size using
> + * sizeof(). Can be use with any of the messages which have a fixed
> + * length. Check for an exact match of the size.

You can provide an outer macro that does the sizeof() and then calls the =
a
normal (static inline) function to do the actual work. Applied to the nex=
t 3 macros.

> + *
> + * Return: zero on success, -EMSGSIZE if @actual_len differs from the
> + * expected length.
> + */
> +#define es58x_check_msg_len(dev, msg, actual_len)			\
> +({									\
> +	size_t __expected_len =3D sizeof(msg);				\
> +	size_t __actual_len =3D (actual_len);				\
> +	int __res =3D 0;							\
> +	if (__expected_len !=3D __actual_len) {				\
> +		dev_err(dev,						\
> +			"%s: Length of %s is %zu but received command is %zu.\n",		\
> +			__func__, __stringify(msg),			\
> +			__expected_len, __actual_len);			\
> +		__res =3D -EMSGSIZE;					\
> +	}								\
> +	__res;								\
> +})
> +
> +/**
> + * es58x_check_msg_max_len() - Check the maximum size of a received me=
ssage.
> + * @dev: Device, used to print error messages.
> + * @msg: Received message, must not be a pointer.
> + * @actual_len: Length of the message as advertised in the command hea=
der.
> + *
> + * Must be a macro in order to retrieve the actual size using
> + * sizeof(). To be used with the messages of variable sizes. Only
> + * check that the message is not bigger than the maximum expected
> + * size.
> + *
> + * Return: zero on success, -EOVERFLOW if @actual_len is greater than
> + * the expected length.
> + */
> +#define es58x_check_msg_max_len(dev, msg, actual_len)			\
> +({									\
> +	size_t __actual_len =3D (actual_len);				\
> +	size_t __expected_len =3D sizeof(msg);				\
> +	int __res =3D 0;							\
> +	if (__actual_len > __expected_len) {				\
> +		dev_err(dev,						\
> +			"%s: Maximum length for %s is %zu but received command is %zu.\n",	=
\
> +			__func__, __stringify(msg),			\
> +			__expected_len, __actual_len);			\
> +		__res =3D -EOVERFLOW;					\
> +	}								\
> +	__res;								\
> +})
> +
> +/**
> + * es58x_msg_num_element() - Check size and give the number of
> + *	elements in a message of array type.
> + * @dev: Device, used to print error messages.
> + * @msg: Received message, must be an array.
> + * @actual_len: Length of the message as advertised in the command
> + *	header.
> + *
> + * Must be a macro in order to retrieve the actual size using
> + * sizeof(). To be used on message of array type. Array's element has
> + * to be of fixed size (else use es58x_check_msg_max_len()). Check
> + * that the total length is an exact multiple of the length of a
> + * single element.
> + *
> + * Return: number of elements in the array on success, -EOVERFLOW if
> + * @actual_len is greater than the expected length, -EMSGSIZE if
> + * @actual_len is not a multiple of a single element.
> + */
> +#define es58x_msg_num_element(dev, msg, actual_len)			\
> +({									\
> +	const struct device *__dev =3D (dev);				\
> +	size_t __actual_len =3D (actual_len);				\
> +	size_t __elem_len =3D sizeof((msg)[0]) + __must_be_array(msg);	\
> +	size_t __actual_num_elem =3D __actual_len / __elem_len;		\
> +	size_t __expected_num_elem =3D sizeof(msg) / __elem_len;		\
> +	int __res =3D __actual_num_elem;					\
> +	if (__actual_num_elem =3D=3D 0) {					\
> +		dev_err(__dev,						\
> +			"%s: Minimum length for %s is %zu but received command is %zu.\n",	=
\
> +			__func__, __stringify(msg),			\
> +			__elem_len, __actual_len);			\
> +		__res =3D -EMSGSIZE;					\
> +	} else if ((__actual_len % __elem_len) !=3D 0) {			\
> +		dev_err(__dev,						\
> +			"%s: Received command length: %zu is not a multiple of %s[0]: %zu\n=
",	\
> +			__func__, __actual_len,				\
> +			__stringify(msg), __elem_len);			\
> +		__res =3D -EMSGSIZE;					\
> +	} else if (__actual_num_elem >	__expected_num_elem) {		\
> +		dev_err(__dev,						\
> +			"%s: Array %s is supposed to have %zu elements each of size %zu...\=
n",	\
> +			__func__, __stringify(msg),			\
> +			__expected_num_elem, __elem_len);		\
> +		dev_err(__dev,						\
> +			"... But received command has %zu elements (total length %zu).\n",	=
\
> +			__actual_num_elem, __actual_len);		\
> +		__res =3D -EOVERFLOW;					\
> +	}								\
> +	__res;								\
> +})
> +
> +/**
> + * es58x_priv() - Get the priv member and cast it to struct es58x_priv=
=2E
> + * @netdev: CAN network device.
> + *
> + * Return: ES58X device.
> + */
> +static inline struct es58x_priv *es58x_priv(struct net_device *netdev)=

> +{
> +	return (struct es58x_priv *)netdev_priv(netdev);
> +}
> +
> +/**
> + * ES58X_SIZEOF_URB_CMD() - Calculate the maximum length of an urb
> + *	command for a given message field name.
> + * @es58x_urb_cmd_type: type (either "struct es581_4_urb_cmd" or
> + *	"struct es58x_fd_urb_cmd").
> + * @msg_field: name of the message field.
> + *
> + * Return: length of the urb command.
> + */
> +#define ES58X_SIZEOF_URB_CMD(es58x_urb_cmd_type, msg_field)		\
> +	(offsetof(es58x_urb_cmd_type, raw_msg)				\
> +		+ sizeof_field(es58x_urb_cmd_type, msg_field)		\
> +		+ sizeof_field(es58x_urb_cmd_type,			\
> +			reserved_for_crc16_do_not_use))

static inline?

> +
> +/**
> + * es58x_get_urb_cmd_len() - Calculate the actual length of an urb
> + *	command for a given message length.
> + * @es58x_dev: ES58X device.
> + * @msg_len: Length of the message.
> + *
> + * Add the header and CRC lengths to the message length.
> + *
> + * Return: length of the urb command.
> + */
> +static inline size_t es58x_get_urb_cmd_len(struct es58x_device *es58x_=
dev,
> +					   u16 msg_len)
> +{
> +	/* URB Length =3D URB header len + Message len + sizeof crc16 */
> +	return es58x_dev->param->urb_cmd_header_len + msg_len + sizeof(u16);
> +}
> +
> +/**
> + * es58x_get_netdev() - Get the network device.
> + * @es58x_dev: ES58X device.
> + * @channel_no: The channel number as advertised in the urb command.
> + * @netdev: CAN network device.
> + *
> + * ES581.4 starts the numbering on channels from 1, ES58X FD family
> + * starts it from 0. This method does the sanity check.
> + *
> + * Return: zero on success, -ECHRNG if the received channel number is
> + * out of range and -ENODEV if the network device is not yet
> + * configured.
> + */
> +static inline int es58x_get_netdev(struct es58x_device *es58x_dev,
> +				   int channel_no, struct net_device **netdev)
> +{
> +	int channel_idx =3D channel_no - es58x_dev->param->channel_idx_offset=
;
> +
> +	*netdev =3D NULL;
> +	if (channel_idx < 0 || channel_idx >=3D es58x_dev->num_can_ch)
> +		return -ECHRNG;
> +
> +	*netdev =3D es58x_dev->netdev[channel_idx];
> +	if (!netdev || !netif_device_present(*netdev))
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +int es58x_can_get_echo_skb(struct net_device *netdev, u32 packet_idx,
> +			   u64 *tstamps, unsigned int pkts);
> +int es58x_tx_ack_msg(struct net_device *netdev, u16 tx_free_entries,
> +		     enum es58x_cmd_ret_code_u32 rx_cmd_ret_u32);
> +int es58x_rx_can_msg(struct net_device *netdev,
> +		     struct es58x_abstracted_can_frame *es58x_cf,
> +		     unsigned int pkts);
> +int es58x_rx_err_msg(struct net_device *netdev, enum es58x_error error=
,
> +		     enum es58x_event event, u64 timestamp);
> +int es58x_rx_timestamp(struct es58x_device *es58x_dev, u64 timestamp);=

> +int es58x_rx_dev_ret_u8(struct device *dev,
> +			enum es58x_cmd_ret_type cmd_ret_type,
> +			enum es58x_dev_ret_code_u8 rx_dev_ret_u8);
> +int es58x_rx_cmd_ret_u32(struct net_device *netdev,
> +			 enum es58x_cmd_ret_type cmd_ret_type,
> +			 enum es58x_cmd_ret_code_u32 rx_cmd_ret_u32);
> +int es58x_send_msg(struct es58x_device *es58x_dev, u8 cmd_type, u8 cmd=
_id,
> +		   const void *msg, u16 cmd_len, int channel_idx);
> +
> +extern const struct es58x_parameters es581_4_param;
> +extern const struct es58x_operators es581_4_ops;
> +
> +extern const struct es58x_parameters es58x_fd_param;
> +extern const struct es58x_operators es58x_fd_ops;
> +
> +#endif				//__ES58X_COMMON_H__

just one space please

regards.
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--HiCipzREk1B7fELUCveWtQNVHh66zw9bN--

--wMhVG32HjFARa34XVG4nZwLDIUokyA1hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl95urMACgkQqclaivrt
76m5sgf/T8dsnb0j01AcEfB5byW5dYNJE0zBsdF94mQ81PtA4EJyNhSnMieCtqsi
VaLNpFO3Tr0XXjRYdhvdMA2GX3x/QxDnBThz5FxQFNqZFBIM5QbBF110ak790ExO
+DXA3RBEvWI401bpoTGmeJ/LQYQNq8azkwROvx+Ws0Wmvk89BO/YAFJ2rtsG1E+l
wYjlgWxQxgoXN8Yo941mJ8Yu+vD7WcSEyFno7NyOIYwZX7MbYv0E5AaXsqfVGHPO
5ojhOYDQgI1Dru4iGbMBYexI5IT89orjIELRuQ3IulOP+n7EyIRw0NMZ01bWM5JQ
aXWawQj/7rPjwI63Pg6/xdmAD1c8gg==
=T2iv
-----END PGP SIGNATURE-----

--wMhVG32HjFARa34XVG4nZwLDIUokyA1hY--
