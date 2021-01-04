Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F572E94F2
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 13:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhADMfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 07:35:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56634 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhADMfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 07:35:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104CTUfo191806;
        Mon, 4 Jan 2021 12:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=OZAIZZ+LOOMd8Q8EORWxprLVkOWQwkn33zW7h438YtU=;
 b=pDh31UXUplxTwEIhg1ksfyfQ423ntLZFe/CeAQL2ERkCinvm6k2dUWamo0yYtTWvMqHg
 W+69YGgsw1biRL8J0FdmxdjVclhE6/pTvr57yoE2anKvf+wwSQLZjSMhDSlFo41aN887
 4WkN98nB1sM1SlsxW0qgvU8xTDCDcTAVJzkxvI4r711ogB2IqIA9EWFyGXuMQnS/6V/N
 a1lzIGHfCsx6DvvYqqPZizHGH4Iopqw1T6lBfLs3zBc4NFBSyS3vkPKkSMTWBq5gLJXt
 urQ6Bdt0aViy+DPuj4ouCa5ZWkr/yAYuMS0HGl3K1G3KqBGfqYtrqDt7cXOvn6wnC841 ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35tg8qv28y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 12:34:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104CULL0124671;
        Mon, 4 Jan 2021 12:34:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35v23x1y71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 12:34:44 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 104CYgmp030126;
        Mon, 4 Jan 2021 12:34:42 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 04:34:40 -0800
Date:   Mon, 4 Jan 2021 15:34:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 09/24] wfx: add hwio.c/hwio.h
Message-ID: <20210104123410.GN2809@kadam>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
 <87lfdp98rw.fsf@codeaurora.org>
 <X+IQRct0Zsm87H4+@kroah.com>
 <4279510.LvFx2qVVIh@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4279510.LvFx2qVVIh@pc-42>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9853 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9853 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 10:02:09PM +0100, Jérôme Pouiller wrote:
> On Tuesday 22 December 2020 16:27:01 CET Greg Kroah-Hartman wrote:
> > 
> > On Tue, Dec 22, 2020 at 05:10:11PM +0200, Kalle Valo wrote:
> > > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> > >
> > > > +/*
> > > > + * Internal helpers.
> > > > + *
> > > > + * About CONFIG_VMAP_STACK:
> > > > + * When CONFIG_VMAP_STACK is enabled, it is not possible to run DMA on stack
> > > > + * allocated data. Functions below that work with registers (aka functions
> > > > + * ending with "32") automatically reallocate buffers with kmalloc. However,
> > > > + * functions that work with arbitrary length buffers let's caller to handle
> > > > + * memory location. In doubt, enable CONFIG_DEBUG_SG to detect badly located
> > > > + * buffer.
> > > > + */
> > >
> > > This sounds very hacky to me, I have understood that you should never
> > > use stack with DMA.
> > 
> > You should never do that because some platforms do not support it, so no
> > driver should ever try to do that as they do not know what platform they
> > are running on.
> 
> Yes, I have learned this rule the hard way.
> 
> There is no better way than a comment to warn the user that the argument
> will be used with a DMA? A Sparse annotation, for example?
> 

There is a Smatch warning for this, but I hadn't looked at the results
in a while. :/  I'm not sure how many are valid.  Some kind of
annotation would be nice.

regards,
dan carpenter

drivers/staging/gdm724x/gdm_usb.c:69 request_mac_address() error: doing dma on the stack (buf)
drivers/staging/rtl8192u/r8192U_core.c:1553 rtl8192_tx() error: doing dma on the stack (&zero)
drivers/staging/comedi/drivers/dt9812.c:249 dt9812_read_info() error: doing dma on the stack (&cmd)
drivers/staging/comedi/drivers/dt9812.c:273 dt9812_read_multiple_registers() error: doing dma on the stack (&cmd)
drivers/staging/comedi/drivers/dt9812.c:299 dt9812_write_multiple_registers() error: doing dma on the stack (&cmd)
drivers/staging/comedi/drivers/dt9812.c:318 dt9812_rmw_multiple_registers() error: doing dma on the stack (&cmd)
drivers/staging/comedi/drivers/dt9812.c:330 dt9812_digital_in() error: doing dma on the stack (value)
drivers/staging/comedi/drivers/dt9812.c:456 dt9812_analog_in() error: doing dma on the stack (val)
drivers/staging/comedi/drivers/dt9812.c:692 dt9812_reset_device() error: doing dma on the stack (&tmp8)
drivers/staging/comedi/drivers/dt9812.c:700 dt9812_reset_device() error: doing dma on the stack (&tmp8)
drivers/staging/comedi/drivers/dt9812.c:711 dt9812_reset_device() error: doing dma on the stack (&tmp16)
drivers/staging/comedi/drivers/dt9812.c:718 dt9812_reset_device() error: doing dma on the stack (&tmp16)
drivers/staging/comedi/drivers/dt9812.c:725 dt9812_reset_device() error: doing dma on the stack (&tmp16)
drivers/staging/comedi/drivers/dt9812.c:732 dt9812_reset_device() error: doing dma on the stack (&tmp32)
drivers/usb/storage/alauda.c:498 alauda_check_status2() error: doing dma on the stack (command)
drivers/usb/storage/alauda.c:503 alauda_check_status2() error: doing dma on the stack (data)
drivers/usb/storage/alauda.c:527 alauda_get_redu_data() error: doing dma on the stack (command)
drivers/usb/storage/alauda.c:702 alauda_erase_block() error: doing dma on the stack (command)
drivers/usb/storage/alauda.c:707 alauda_erase_block() error: doing dma on the stack (buf)
drivers/usb/storage/alauda.c:731 alauda_read_block_raw() error: doing dma on the stack (command)
drivers/usb/storage/alauda.c:782 alauda_write_block() error: doing dma on the stack (command)
drivers/usb/class/usblp.c:593 usblp_ioctl() error: doing dma on the stack (&newChannel)
drivers/usb/serial/iuu_phoenix.c:542 iuu_uart_flush() error: doing dma on the stack (&rxcmd)
drivers/firewire/core-device.c:565 read_config_rom() error: doing dma on the stack (&dummy)
drivers/firewire/core-device.c:1111 reread_config_rom() error: doing dma on the stack (&q)
drivers/media/usb/uvc/uvc_v4l2.c:910 uvc_ioctl_g_input() error: doing dma on the stack (&i)
drivers/media/usb/uvc/uvc_v4l2.c:942 uvc_ioctl_s_input() error: doing dma on the stack (&i)
drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c:662 initialize_cx231xx() error: doing dma on the stack (data)
drivers/media/usb/cx231xx/cx231xx-avcore.c:90 uninitGPIO() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:1297 cx231xx_enable_i2c_port_3() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:1313 cx231xx_enable_i2c_port_3() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:1546 cx231xx_set_Colibri_For_LowIF() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2261 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2278 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2288 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2297 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2311 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2321 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2332 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2342 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2353 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2376 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2386 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2396 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2407 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2417 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2446 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2457 cx231xx_set_power_mode() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2469 cx231xx_power_suspend() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2481 cx231xx_power_suspend() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2497 cx231xx_start_stream() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2509 cx231xx_start_stream() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2523 cx231xx_stop_stream() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2534 cx231xx_stop_stream() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2591 cx231xx_initialize_stream_xfer() error: doing dma on the stack (val)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2599 cx231xx_initialize_stream_xfer() error: doing dma on the stack (val)
drivers/media/usb/cx231xx/cx231xx-core.c:635 cx231xx_demod_reset() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-core.c:644 cx231xx_demod_reset() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-core.c:649 cx231xx_demod_reset() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-core.c:654 cx231xx_demod_reset() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-core.c:658 cx231xx_demod_reset() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-core.c:1253 cx231xx_stop_TS1() error: doing dma on the stack (val)
drivers/media/usb/cx231xx/cx231xx-core.c:1260 cx231xx_stop_TS1() error: doing dma on the stack (val)
drivers/media/usb/cx231xx/cx231xx-core.c:1272 cx231xx_start_TS1() error: doing dma on the stack (val)
drivers/media/usb/cx231xx/cx231xx-core.c:1279 cx231xx_start_TS1() error: doing dma on the stack (val)
drivers/media/usb/cx231xx/cx231xx-core.c:1533 cx231xx_mode_register() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-core.c:1546 cx231xx_mode_register() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-video.c:1236 cx231xx_g_register() error: doing dma on the stack (value)
drivers/media/usb/cx231xx/cx231xx-video.c:1297 cx231xx_s_register() error: doing dma on the stack (data)
drivers/media/usb/gspca/kinect.c:209 write_register() error: doing dma on the stack (reply)
drivers/net/usb/rndis_host.c:129 rndis_command() error: doing dma on the stack (&notification)

