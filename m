Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4686FEB0CC
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfJaNE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:04:26 -0400
Received: from imss-3.enac.fr ([195.220.159.36]:58375 "EHLO imss-3.enac.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfJaNE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 09:04:26 -0400
Received: from mta1.lfbq.aviation (localhost [127.0.0.1])
        by imss-3.enac.fr (Postfix) with ESMTP id E658E5FD76
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 14:04:23 +0100 (CET)
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=utf-8; format=flowed
Received: from [10.1.7.69] (pc-novales.personnel.interne.enac [10.1.7.69])
 by webmail.lfbq.aviation
 (Oracle Communications Messaging Exchange Server 7u4-22.01 32bit (built Apr 21
 2011)) with ESMTPSA id <0Q0800GSVPNBQV10@webmail.lfbq.aviation> for
 netdev@vger.kernel.org; Thu, 31 Oct 2019 14:04:23 +0100 (CET)
From:   Luc Novales <luc.novales@enac.fr>
Subject: Fwd: Bad permanent address 00:10:00:80:00:10 using r8168 module on
 some cards
To:     netdev@vger.kernel.org
References: <8e3ad60e-227a-a941-74b4-d4d19c2aa7a5@enac.fr>
Message-id: <3f9dad41-818e-4637-ab59-87f69b5c9212@enac.fr>
Date:   Thu, 31 Oct 2019 14:04:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-reply-to: <8e3ad60e-227a-a941-74b4-d4d19c2aa7a5@enac.fr>
Content-language: fr-FR
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-25012.007
X-TM-AS-User-Approved-Sender: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have no answer from realtek, could you help me for debugging and 
determine if problem is hardware or software and howto solve it ?

In complement, howto get more information about module parameters ?

Best regards

Luc Novales.


-------- Message transféré --------
Sujet : 	Bad permanent address 00:10:00:80:00:10 using r8168 module on 
some cards
Date : 	Tue, 29 Oct 2019 11:28:09 +0100
De : 	Luc Novales <luc.novales@enac.fr>
Pour : 	nicfae@realtek.com



Hi,

I am Luc Novales from ENAC in France.

We have some problems using tp-link PCI express network adapter (model : 
TG-3468(UN) ver:3.0, P/N:0152502214) under Debian Linux.

We uses this adapters on about 50 training computers.

Using r8168 compiled kernel driver, randomly and for unknown reasons bad 
address 00:10:00:80:00:10 is chosen at boot on some cards, causing some 
hardware address conflict on the network.

After that, 'ethtool -P' command returns bad permanent address and the 
only solution we have to solve this problem is to unplug computer from 
the power (to remove standby power on the adapter).

I didn't found any forum on your site and only this email address to 
have some help :

 1. Is there some users or developers forums ?
 2. Is there some howto debug kernel module ?
 3. Is there some way to make an hard reset to the chipset without
    unplug the computer (workaround before solving the problem) ?

Operating System context is :

lsb_release -a
Distributor ID:    Debian
Description:    Debian GNU/Linux 10 (buster)
Release:    10
Codename:    buster

uname -a
Linux G28-33 4.19.0-6-amd64 #1 SMP Debian 4.19.67-2+deb10u1 (2019-09-20) 
x86_64 GNU/Linux

modinfo r8168
filename: 
/lib/modules/4.19.0-6-amd64/kernel/drivers/net/ethernet/realtek/r8168.ko
version:        8.047.04-NAPI
license:        GPL
description:    RealTek RTL-8168 Gigabit Ethernet driver
author:         Realtek and the Linux r8168 crew <netdev@vger.kernel.org>
srcversion:     D3FC079D8040CD24274CA37
alias: pci:v00001186d00004300sv00001186sd00004B10bc*sc*i*
alias:          pci:v000010ECd00002600sv*sd*bc*sc*i*
alias:          pci:v000010ECd00002502sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008161sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008168sv*sd*bc*sc*i*
depends:
retpoline:      Y
name:           r8168
vermagic:       4.19.0-6-amd64 SMP mod_unload modversions
parm:           speed_mode:force phy operation. Deprecated by ethtool 
(8). (uint)
parm:           duplex_mode:force phy operation. Deprecated by ethtool 
(8). (uint)
parm:           autoneg_mode:force phy operation. Deprecated by ethtool 
(8). (uint)
parm:           advertising_mode:force phy operation. Deprecated by 
ethtool (8). (uint)
parm:           aspm:Enable ASPM. (int)
parm:           s5wol:Enable Shutdown Wake On Lan. (int)
parm:           s5_keep_curr_mac:Enable Shutdown Keep Current MAC 
Address. (int)
parm:           rx_copybreak:Copy breakpoint for copy-only-tiny-frames (int)
parm:           use_dac:Enable PCI DAC. Unsafe on 32 bit PCI slot. (int)
parm:           timer_count:Timer Interrupt Interval. (int)
parm:           eee_enable:Enable Energy Efficient Ethernet. (int)
parm:           hwoptimize:Enable HW optimization function. (ulong)
parm:           s0_magic_packet:Enable S0 Magic Packet. (int)
parm:           debug:Debug verbosity level (0=none, ..., 16=all) (int)



For information, we can't use stock kernel driver r8169 because card 
fails in a state which it doesn't auto-negotiate and doesn't establish 
any link with the switch (standby power must be remove to unlock the 
adapter).

Best regards

Luc Novales.

