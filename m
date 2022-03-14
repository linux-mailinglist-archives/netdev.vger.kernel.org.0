Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270974D866B
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242119AbiCNOGi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Mar 2022 10:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238728AbiCNOGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:06:38 -0400
Received: from mail.bix.bg (mail.bix.bg [193.105.196.21])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 480FD6557
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:05:27 -0700 (PDT)
Received: (qmail 10220 invoked from network); 14 Mar 2022 14:05:25 -0000
Received: from d2.declera.com (HELO ?212.116.131.122?) (212.116.131.122)
  by indigo.declera.com with SMTP; 14 Mar 2022 14:05:25 -0000
Message-ID: <37bd0b005af4e10fd7e9ada2437775a4735d40a0.camel@declera.com>
Subject: Re: r8169:  rtl8168ep_driver_stop disables the DASH port
From:   Yanko Kaneti <yaneti@declera.com>
To:     Kevin_cheng <kevin_cheng@realtek.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nicfae <Nicfae@realtek.com>
Date:   Mon, 14 Mar 2022 16:05:25 +0200
In-Reply-To: <ed2850b12b304a7cb89972850e503026@realtek.com>
References: <d654c98b90d98db13b84752477fe2c63834bcf59.camel@declera.com>
        ,<42304a71ed72415c803ec22d3a750b33@realtek.com>
         <ed2850b12b304a7cb89972850e503026@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.43.3 (3.43.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-14 at 01:00 +0000, Kevin_cheng wrote:
Hello Kevin,

> Thanks for your email. Linux DASH requires specific driver and client
> tool. It depends on the manufacturer’s requirement. You need to
> contact ASRock to make sure they support Linux DASH and have verified
> it.

Thanks for the answer but its not much help for me.
I am not going to use a driver that's not in mainline.

I wasn't really expecting full DASH support but that at least
r8169/linux does not prevent the limied DASH web interface functionality
from working.

Currently this is not the case on this board with the current BIOS:
 - Once the kernel is loaded the DASH web interface power management
(reset, hard off) no longer works
 - Normal shutdown or r8169 module unload actually disconnects the phy.
 
It would be nice if DASH basics worked without being broken/supported by
the OS.

Regards
Yanko

> 
> Best Regards
> Kevin Cheng
> Technical Support Dept.
> Realtek Semiconductor Corp.
> 
> -----Original Message-----
> From: Yanko Kaneti <yaneti@declera.com> 
> Sent: Friday, March 11, 2022 9:12 PM
> To: Heiner Kallweit <hkallweit1@gmail.com>; nic_swsd
> <nic_swsd@realtek.com>
> Cc: netdev <netdev@vger.kernel.org>
> Subject: r8169: rtl8168ep_driver_stop disables the DASH port
> 
> Hello,
> 
> Testing DASH on a ASRock A520M-HDVP/DASH, which has a RTL8111/8168 EP
> chip. DASH is enabled and seems to work on BIOS/firmware level.
> 
> It seems that r8169's cleanup/exit in rtl8168ep_driver_stop manages to
> actually stop the LAN port, hence cutting the system remote
> management.
> 
> This is evident on plain shutdown or rmmod r8169.
> If one does a hardware reset or echo "b" > /proc/sysrq-trigger  the
> cleanup doesn't happen and the DASH firmware remains in working order
> and the LAN port remains up.
> 
> A520M-HDVP/DASH BIOS ver 1.70
> Reatlek fw:
>  Firmware Version:               3.0.0.20200423
>  Version String:         20200428.1200000113
>  
> I have no idea if its possible or how to update the realtek firmware,
> preferably from Linux.
> 
> Various other DASH functionality seems to not work but basic working
> power managements is really a deal breaker for the whole thing.
> 
> 
> Regards
> Yanko
> ------Please consider the environment before printing this e-mail.

