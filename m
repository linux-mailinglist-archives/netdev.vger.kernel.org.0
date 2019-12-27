Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C69812B9D1
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfL0SNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:13:05 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39062 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfL0SNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 13:13:04 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so9051644plp.6
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 10:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:subject:from:to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RfmxrvYNlNuyWWLyvAcRXeqyA0h3ul30ME0arb0fBlk=;
        b=uYl/wptNf2evK6CkM6rhVNn/PQUr1NzPWO7zJuK0JpwH2nK+iociek1uGtZr5+X9k9
         nsRPj5+ulnOX0GwVuzs6yxgddB6bDHffPglbpWVvQyRqRKqeQWJuGDXHavzucjSQnbnG
         f5/GC88US+6ywtNGTNA5HsHcbrecoBFVjRkETO3HGcnqMuF5gFYnhC43qxFvIr6LGhWQ
         aLPXqDZxo/Gu040wqViKwXy1X1hmvLeoUzUPGgDDhr1RVSKssn6iVmtlRZ3Pfm4Af/XQ
         0pjEMVCOMz+VHvVk38CTFiDLmG2jiuxYW+MvJY2hxkC4HJuUdg4pSkLkRngIm9nfwAXm
         sA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:from:to:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RfmxrvYNlNuyWWLyvAcRXeqyA0h3ul30ME0arb0fBlk=;
        b=sKe1dv2rtqRpuN9kd+blqF8HPfDF5XN/M9zE7/oskMRiBdPy3Ie31Llzn7CdHb7uEC
         jTjblq0A0xL1xWf2zVnPxH427I1JBIxMzsWcVQcal1x2kFS68RP9oJ0ox68ZKOoxDu1x
         WNX+MbETEPIWx5BXLiFZlyDOoi+5HndddVLhoNxQseWU20HCgQ/DYvKfKuTcHG3cmZas
         SHCEAO6ygvxrulLXH+3Z89QcnWDrV0MrBXt94sUDTV138r2mq24Pivo7KS24L/5aA9KF
         CYaWaQL5ys4A5B3b4e3BoQ9jsEIqYgLObqt1bL3CPiOxNHEPjhHtQjyrIBAf1md1DuG6
         dmnA==
X-Gm-Message-State: APjAAAWKwfGQbRw4isN1MrXqMb+pJie0mEFJRiSkKf0jmuATqCiJWRuZ
        aI2M32z2rzOGMh2ii6WXDukNtE94
X-Google-Smtp-Source: APXvYqw/LjUB15D/aKu3ppFqjCezAt1p8OOm85Ux+ZhIDP4DzkpTgID3O4cv4ILIp9RUfbWzHjF6lg==
X-Received: by 2002:a17:902:6ac3:: with SMTP id i3mr29578316plt.111.1577470383066;
        Fri, 27 Dec 2019 10:13:03 -0800 (PST)
Received: from mua.localhost (99-7-172-215.lightspeed.snmtca.sbcglobal.net. [99.7.172.215])
        by smtp.gmail.com with ESMTPSA id g22sm38258295pgk.85.2019.12.27.10.13.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2019 10:13:02 -0800 (PST)
Reply-To: pgnet.dev@gmail.com
Subject: Re: with kernel 5.4.6, two Eth interfaces -- one 'reliably named',
 the other not. used to work , what's changed?
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     netdev@vger.kernel.org
References: <42a3cd4b-c42f-b2c2-da84-e1fd433a4219@gmail.com>
Message-ID: <f83cf0f0-ebfe-eff0-36ae-923649f9780b@gmail.com>
Date:   Fri, 27 Dec 2019 10:13:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <42a3cd4b-c42f-b2c2-da84-e1fd433a4219@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sanity check -- Is this the right, or wrong, list for this question?

On 12/24/19 11:24 AM, PGNet Dev wrote:
>   I recently upgraded a linux/64 box to
> 
> 	uname -rm
> 		5.4.6-24.ge5f8301-default x86_64
> 
> For 'ages' prior, I've had two functional Eth interfaces on it
> 
> 	inxi -n
> (1)		Network:   Card-1: Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller driver: r8169
> 		           IF: eth0 state: down mac: 18:d6:c7:01:15:11
> (2)		           Card-2: Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller driver: r8169
> 		           IF: enp3s0 state: up speed: 1000 Mbps duplex: full mac: 00:52:35:50:44:04
> 
> where (2)'s the Mobo ETH, and (1)'s an ETH PCI-e card
> 
> Both expect/use the same driver,
> 
> 	lspci -tv | grep -i eth
> 		+-04.0-[02]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
> 		+-06.0-[03]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
> 
> 
> The driver's up
> 
> 	lsmod | grep 8169
> 		r8169                  94208  0
> 		libphy                 98304  2 r8169,realtek
> 
> provided by
> 
> 	rpm -q --whatprovides /lib/modules/5.4.6-24.ge5f8301-default/kernel/drivers/net/ethernet/realtek/r8169.ko
> 		kernel-default-5.4.6-24.1.ge5f8301.x86_64
> 
> the cards are available,
> 
> I've had reliable naming enabled
> 
> 	cat /proc/cmdline
> 		... net.ifnames=1 biosdevname=0
> 
> and the two interfaces, Mobo & PCI, _had_ always appeared as enp2s0 & enp3s0
> 
> with current kernel,
> 
> 	uname -rm
> 		5.4.6-24.ge5f8301-default x86_64
> 
> & firmware packages,
> 
> 	rpm -qa | grep -i kernel-firmware | sort
> 		kernel-firmware-all-20191118-36.13.noarch
> 		kernel-firmware-amdgpu-20191118-36.13.noarch
> 		kernel-firmware-ath10k-20191118-36.13.noarch
> 		kernel-firmware-atheros-20191118-36.13.noarch
> 		kernel-firmware-bluetooth-20191118-36.13.noarch
> 		kernel-firmware-bnx2-20191118-36.13.noarch
> 		kernel-firmware-brcm-20191118-36.13.noarch
> 		kernel-firmware-chelsio-20191118-36.13.noarch
> 		kernel-firmware-dpaa2-20191118-36.13.noarch
> 		kernel-firmware-i915-20191118-36.13.noarch
> 		kernel-firmware-intel-20191118-36.13.noarch
> 		kernel-firmware-iwlwifi-20191118-36.13.noarch
> 		kernel-firmware-liquidio-20191118-36.13.noarch
> 		kernel-firmware-marvell-20191118-36.13.noarch
> 		kernel-firmware-media-20191118-36.13.noarch
> 		kernel-firmware-mediatek-20191118-36.13.noarch
> 		kernel-firmware-mellanox-20191118-36.13.noarch
> 		kernel-firmware-mwifiex-20191118-36.13.noarch
> 		kernel-firmware-network-20191118-36.13.noarch
> 		kernel-firmware-nfp-20191118-36.13.noarch
> 		kernel-firmware-nvidia-20191118-36.13.noarch
> 		kernel-firmware-platform-20191118-36.13.noarch
> 		kernel-firmware-qlogic-20191118-36.13.noarch
> 		kernel-firmware-radeon-20191118-36.13.noarch
> 		kernel-firmware-realtek-20191118-36.13.noarch
> 		kernel-firmware-serial-20191118-36.13.noarch
> 		kernel-firmware-sound-20191118-36.13.noarch
> 		kernel-firmware-ti-20191118-36.13.noarch
> 		kernel-firmware-ueagle-20191118-36.13.noarch
> 		kernel-firmware-usb-network-20191118-36.13.noarch
> 
> The TPLINK PCI card no longer comes up as an 'en*'-named card, per
> 
> 	https://www.freedesktop.org/software/systemd/man/systemd.net-naming-scheme.html
> 
> but rather, incorrectly (?), as 'eth0'
> 
> 	hwinfo --netcard | egrep -i "Ethernet controller|Driver|addr|Model:|Device:|Device file"
> 		07: PCI 300.0: 0200 Ethernet controller
> 		  Model: "Realtek RTL8111/8168 PCI Express Gigabit Ethernet controller"
> 		  Device: pci 0x8168 "RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller"
> 		  SubDevice: pci 0x8168 "RTL8111/8168 PCI Express Gigabit Ethernet controller"
> 		  Driver: "r8169"
> 		  Driver Modules: "r8169"
> 		  Device File: enp3s0
> 		  HW Address: 00:52:35:50:44:04
> 		  Permanent HW Address: 00:52:35:50:44:04
> 		  Driver Info #0:
> 		    Driver Status: r8169 is active
> 		    Driver Activation Cmd: "modprobe r8169"
> 		11: PCI 200.0: 0200 Ethernet controller
> 		  Model: "TP-LINK TG-3468 Gigabit PCI Express Network Adapter"
> 		  Device: pci 0x8168 "RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller"
> 		  SubDevice: pci 0x3468 "TG-3468 Gigabit PCI Express Network Adapter"
> 		  Driver: "r8169"
> 		  Driver Modules: "r8169"
> ??		  Device File: eth0
> 		  HW Address: 18:d6:c7:01:15:11
> 		  Permanent HW Address: 18:d6:c7:01:15:11
> 		  Driver Info #0:
> 		    Driver Status: r8169 is active
> 		    Driver Activation Cmd: "modprobe r8169"
> 
> noting,
> 
> 	ls -1 /sys/class/net/
> 		enp3s0@
> 		eth0@
> 		lo@
> 
> in `dmesg`
> 
> 	dmesg | egrep -i "eth|enp"
> 		[    4.564854] r8169 0000:02:00.0 eth0: RTL8168e/8111e, 18:d6:c7:01:15:11, XID 2c2, IRQ 27
> 		[    4.564856] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
> 		[    4.568641] r8169 0000:03:00.0 eth1: RTL8168c/8111c, 00:52:35:50:44:04, XID 3c4, IRQ 18
> 		[    4.568643] r8169 0000:03:00.0 eth1: jumbo features [frames: 6128 bytes, tx checksumming: ko]
> 		[    4.614030] r8169 0000:03:00.0 enp3s0: renamed from eth1
> 		[   28.179613] RTL8211B Gigabit Ethernet r8169-300:00: attached PHY driver [RTL8211B Gigabit Ethernet] (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)
> 		[   28.283488] r8169 0000:03:00.0 enp3s0: Link is Down
> 		[   30.498955] r8169 0000:03:00.0 enp3s0: Link is Up - 1Gbps/Full - flow control rx/tx
> 		[   30.498976] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0: link becomes ready
> 
> Something's changed -- as both interfaces used to be properly named per reliable-naming standard.
> 
> I _can_ bring up the network on the Mobo's renamed enp3s0 interface ... but no longer on the PCI card.
> 
> I'm not clear on why one interface IS using the reliable-naming scheme, and the other is NOT.
> 
> Any hints/clues as to the problem &/or a fix?
> 

