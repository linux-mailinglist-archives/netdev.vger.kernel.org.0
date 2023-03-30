Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B356CFADB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjC3Flm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjC3Flj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:41:39 -0400
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48267102;
        Wed, 29 Mar 2023 22:41:35 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
        by mail.fintek.com.tw with ESMTP id 32U5e75i021508;
        Thu, 30 Mar 2023 13:40:07 +0800 (+08)
        (envelope-from peter_hong@fintek.com.tw)
Received: from [192.168.1.132] (192.168.1.132) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server id 14.3.498.0; Thu, 30 Mar 2023
 13:40:08 +0800
Message-ID: <0685977a-07ec-51c3-8e38-7d33730b4337@fintek.com.tw>
Date:   Thu, 30 Mar 2023 13:40:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH V3] can: usb: f81604: add Fintek F81604 support
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     <wg@grandegger.com>, <michal.swiatkowski@linux.intel.com>,
        <Steen.Hegelund@microchip.com>, <mailhol.vincent@wanadoo.fr>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <frank.jungclaus@esd.eu>,
        <linux-kernel@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <hpeter+linux_kernel@gmail.com>
References: <20230327051048.11589-1-peter_hong@fintek.com.tw>
 <20230327150949.ywchpe26cg54oe5v@pengutronix.de>
From:   Peter Hong <peter_hong@fintek.com.tw>
In-Reply-To: <20230327150949.ywchpe26cg54oe5v@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.132]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27534.001
X-TM-AS-Result: No-21.491900-8.000000-10
X-TMASE-MatchedRID: X4bcv0S75Kn/9O/B1c/Qy2lHv4vQHqYTlmG/61+LLCeqvcIF1TcLYI5a
        mlqOXwWaLJoLOSH2KMaaqI8cUXP2EZz3nEP4SjjAiH95tLFH8edxXefgn/TNQ+ZgZoDMqQBTkYd
        nzk6dz7Zb0Qfj4Am8o3S2PxEKCE3LGU9P+A3Ax1W/QNwZdfw3FUqAhuLHn5fEnt/M15zYPUOMdY
        0AmKDmKrgB9p1+8Xf32Jo9UgoRtVDRNC/bt6LI3MczWng2hbKDAajW+EL+laP3+1ivLwUn72sWZ
        V9YMDBbuJ64xTCW1982Qeaz4CaaKgV3ZG79eNI14t2mucDkRBGh1AldoN7HpysZ0Y5X+/lrN1Ne
        JEsbqQ5jIp9ZavJC/IL03FCbUBj2b7A96mLiSaSeAiCmPx4NwFkMvWAuahr8+gD2vYtOFhgqtq5
        d3cxkNQP90fJP9eHt
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--21.491900-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27534.001
X-TM-SNTS-SMTP: 320FB9D4C5A2C6987D027DE8CD881F36EF7E1B9D7C4C22FABB26CEE46C15E1302000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL: mail.fintek.com.tw 32U5e75i021508
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

Marc Kleine-Budde 於 2023/3/27 下午 11:09 寫道:
> On 27.03.2023 13:10:48, Ji-Ze Hong (Peter Hong) wrote:
>> This patch add support for Fintek USB to 2CAN controller support.
> In addition to Vincent's comment, please describe your change
> declarative, e.g.:
>
> | Add support for the Fintek USB to 2CAN controller.
>
> Please add an entry in the MAINTAINERS file.
>

We'll add description to MAINTAINERS file as following:

FINTEK F81604 USB to 2CAN DEVICE DRIVERS
M:      Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
L:      linux-can@vger.kernel.org
S:      Maintained

Is this OK?

>> +	u8 bulk_read_buffer[F81604_MAX_RX_URBS][F81604_BULK_SIZE];
> allocate the URB dynamic with kmalloc() and use urb->transfer_flags |=
> URB_FREE_BUFFER for automatic free()ing.

Could I use kmalloc on device probe() and kfree on disconnect() ?
It may reduce a lot malloc/free times.

>> +
>> +	struct urb *write_urb;
>> +	u8 bulk_write_buffer[F81604_DATA_SIZE];
> With just 1 TX URB the TX would be quite slow. Does your hardware
> support more than 1 TX URB at a time? USB devices usually answer with
> NAK it they are busy, automatic and transparent retry is handled by the
> USB host controller.

This device only NAK when TX EP buf full. It maybe malfunction when sending
TX URB while CAN transmitting.

>> +};
>> +
>> +/* Interrupt endpoint data format: SR/IR/IER/ALC/ECC/EWLR/RXERR/TXERR/VAL */
>> +struct f81604_int_data {
>> +	u8 sr;
>> +	u8 isrc;
>> +	u8 ier;
>> +	u8 alc;
>> +	u8 ecc;
>> +	u8 ewlr;
>> +	u8 rxerr;
>> +	u8 txerr;
>> +	u8 val;
>> +} __packed;
> I think this struct is always aligned to 4 bytes, so add a __aligned(4)
> behind __packed.
>> +
>> +struct f81604_sff {
>> +	__be16 id;
>> +	u8 data[CAN_MAX_DLEN];
>> +} __packed;
> __aligned(2)
>
>> +
>> +struct f81604_eff {
>> +	__be32 id;
>> +	u8 data[CAN_MAX_DLEN];
>> +} __packed;
> __aligned(2)
>
>> +
>> +struct f81604_bulk_data {
>> +	u8 cmd;
>> +
>> +	/* According for F81604 DLC define:
>> +	 *	#define F81604_DLC_LEN_MASK 0x0f
>> +	 *	#define F81604_DLC_EFF_BIT BIT(7)
>> +	 *	#define F81604_DLC_RTR_BIT BIT(6)
> no need to duplicate code
>
>> +	 */
>> +	u8 dlc;
>> +
>> +	union {
>> +		struct f81604_sff sff;
>> +		struct f81604_eff eff;
>> +	};
>> +} __packed;
> __aligned(4)

I had add following aligned is OK.
     struct f81604_int_data;    __aligned(4)
     struct f81604_sff;       __aligned(2)
     struct f81604_eff;        __aligned(2)

But when I add __aligned(4) to struct f81604_bulk_data, It'll generate 
error about size != 14.

./include/linux/build_bug.h:78:41: error: static assertion failed:
"sizeof(struct f81604_bulk_data) == F81604_DATA_SIZE"

So I'll add align to these structs without f81604_bulk_data. Is it OK?

>> +		usb_fill_bulk_urb(priv->read_urb[i], priv->dev,
>> +				  usb_rcvbulkpipe(priv->dev, bulk_in_addr[id]),
>> +				  priv->bulk_read_buffer[i], F81604_BULK_SIZE,
>> +				  f81604_read_bulk_callback, netdev);
>> +	}
>> +
>> +	priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
>> +	if (!priv->write_urb)
>> +		goto error;
>> +
>> +	usb_fill_bulk_urb(priv->write_urb, priv->dev,
>> +			  usb_sndbulkpipe(priv->dev, bulk_out_addr[id]),
>> +			  priv->bulk_write_buffer, F81604_DATA_SIZE,
>> +			  f81604_write_bulk_callback, netdev);
>> +
>> +	priv->int_urb = usb_alloc_urb(0, GFP_KERNEL);
>> +	if (!priv->int_urb)
>> +		goto error;
>> +
>> +	usb_fill_int_urb(priv->int_urb, priv->dev,
>> +			 usb_rcvintpipe(priv->dev, int_in_addr[id]),
>> +			 priv->int_read_buffer, F81604_INT_SIZE,
>> +			 f81604_read_int_callback, netdev, 1);
> Does the endpoint descriptor specify a proper interval?

The interval of interrupt endpoint is 1 (1ms).

Bus 001 Device 010: ID 2c42:1709 FINTEK USB TO CANBUS BRIDGE
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x2c42
   idProduct          0x1709
   bcdDevice            0.01
   iManufacturer           1 FINTEK
   iProduct                2 USB TO CANBUS BRIDGE
   iSerial                 3 88635600168801
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x003c
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           6
       bInterfaceClass         0
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0010  1x 16 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0010  1x 16 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
Device Status:     0xa780
   (Bus Powered)

Thanks

