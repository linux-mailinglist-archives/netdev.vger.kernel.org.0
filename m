Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAF812BB49
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfL0Vf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:35:26 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54022 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfL0Vf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:35:26 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so5231968pjc.3
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c/yejJonKg2ETotFvUztoWIeYIH1zzTbHN8F2hlQjVM=;
        b=VipnRuu3Ymj16EUTiZLA1VB5RnrIRgVlKnBEF4acRU048VjLkPKti/XtMzFEPMtC/i
         8i04/vCPTk4F7LQ5qkUOOjsJYBG/vfKSCRk7850HBO6V57qGbC0c7gLWaY1P8ctqcs2N
         FHzhl0FcVrojExH7/C5C2cdIweW6Hin9b3LCK3R/nOvLVJ79kBlAM+Vs7lELmENS0Tvu
         m5srJK/W987vfxUIb4aKIkxdZPDTfnjdwirkBThb55qleLptEa9ZkcGog7Cj8GyucZg2
         zOn9VILwnP+LkqpCrh6iwvanU4Vp94+dkO9MRy4qbRoEPZHNEzsA8fikSrp7J/WWjbTB
         SYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c/yejJonKg2ETotFvUztoWIeYIH1zzTbHN8F2hlQjVM=;
        b=JOzT7vPllRIi4zkWH/6bYzrgdlR7M+fDL4kBJAfJBZZxhERkzAe4v8H/zSc/6j3+xR
         IRFyoElp9E9DgpHjU4xqAfZHKm2K4H8oPp0GLSkB+cpgi8KaQqtA0F4FwKI/QTZtQHRq
         w583bJWLoEywnUlxeYsi31wWMvtMCClCV2M+v71jkZqSVrlxJfp6+SZmhfmPOwCVJwvs
         C9BdFEaZxSX1aUVgbYMggwK0QV4kxb/SncmaNZL7gVanUXAgdIiw/CtPdAkUASL5qAFk
         ljS7m0UyHerXocD2+BbGFaIzEJfkFfnYjFUDzR4bKP6rGgUA5oYieCxuQliMnl8boaqq
         smhA==
X-Gm-Message-State: APjAAAVEPFnbTjpfSJ3PhvBWu4LO72pk/Hk+El5emVYTumRkDAvplchN
        YPgR/mGuOYE4EIQb3uOJ3GPt8yULSrxpzQ==
X-Google-Smtp-Source: APXvYqxl62P1/lnUplcMFBWDzSDtJOKU0RSfHKfWvLNuU9aq0mjAPfrp5Gf7SnanU0eIJei27sQ4Uw==
X-Received: by 2002:a17:90a:b10b:: with SMTP id z11mr29477408pjq.132.1577482525137;
        Fri, 27 Dec 2019 13:35:25 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w8sm40078561pfn.186.2019.12.27.13.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:35:24 -0800 (PST)
Date:   Fri, 27 Dec 2019 13:35:16 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     PGNet Dev <pgnet.dev@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: with kernel 5.4.6, two Eth interfaces -- one 'reliably named',
 the other not. used to work , what's changed?
Message-ID: <20191227133516.0b0dba3a@hermes.lan>
In-Reply-To: <42a3cd4b-c42f-b2c2-da84-e1fd433a4219@gmail.com>
References: <42a3cd4b-c42f-b2c2-da84-e1fd433a4219@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Dec 2019 11:24:09 -0800
PGNet Dev <pgnet.dev@gmail.com> wrote:

> =C2=A0I recently upgraded a linux/64 box to
>=20
> 	uname -rm
> 		5.4.6-24.ge5f8301-default x86_64
>=20
> For 'ages' prior, I've had two functional Eth interfaces on it
>=20
> 	inxi -n
> (1)		Network:   Card-1: Realtek RTL8111/8168/8411 PCI Express Gigabit Eth=
ernet Controller driver: r8169
> 		           IF: eth0 state: down mac: 18:d6:c7:01:15:11
> (2)		           Card-2: Realtek RTL8111/8168/8411 PCI Express Gigabit Eth=
ernet Controller driver: r8169
> 		           IF: enp3s0 state: up speed: 1000 Mbps duplex: full mac: 00:5=
2:35:50:44:04
>=20
> where (2)'s the Mobo ETH, and (1)'s an ETH PCI-e card
>=20
> Both expect/use the same driver,
>=20
> 	lspci -tv | grep -i eth
> 		+-04.0-[02]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 =
PCI Express Gigabit Ethernet Controller
> 		+-06.0-[03]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 =
PCI Express Gigabit Ethernet Controller
>=20
>=20
> The driver's up
>=20
> 	lsmod | grep 8169
> 		r8169                  94208  0
> 		libphy                 98304  2 r8169,realtek
>=20
> provided by
>=20
> 	rpm -q --whatprovides /lib/modules/5.4.6-24.ge5f8301-default/kernel/driv=
ers/net/ethernet/realtek/r8169.ko
> 		kernel-default-5.4.6-24.1.ge5f8301.x86_64
>=20
> the cards are available,
>=20
> I've had reliable naming enabled
>=20
> 	cat /proc/cmdline
> 		... net.ifnames=3D1 biosdevname=3D0=20
>=20
> and the two interfaces, Mobo & PCI, _had_ always appeared as enp2s0 & enp=
3s0
>=20
> with current kernel,
>=20
> 	uname -rm
> 		5.4.6-24.ge5f8301-default x86_64
>=20
> & firmware packages,
>=20
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
>=20
> The TPLINK PCI card no longer comes up as an 'en*'-named card, per
>=20
> 	https://www.freedesktop.org/software/systemd/man/systemd.net-naming-sche=
me.html
>=20
> but rather, incorrectly (?), as 'eth0'
>=20
> 	hwinfo --netcard | egrep -i "Ethernet controller|Driver|addr|Model:|Devi=
ce:|Device file"
> 		07: PCI 300.0: 0200 Ethernet controller
> 		  Model: "Realtek RTL8111/8168 PCI Express Gigabit Ethernet controller"
> 		  Device: pci 0x8168 "RTL8111/8168/8411 PCI Express Gigabit Ethernet Co=
ntroller"
> 		  SubDevice: pci 0x8168 "RTL8111/8168 PCI Express Gigabit Ethernet cont=
roller"
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
> 		  Device: pci 0x8168 "RTL8111/8168/8411 PCI Express Gigabit Ethernet Co=
ntroller"
> 		  SubDevice: pci 0x3468 "TG-3468 Gigabit PCI Express Network Adapter"
> 		  Driver: "r8169"
> 		  Driver Modules: "r8169"
> ??		  Device File: eth0
> 		  HW Address: 18:d6:c7:01:15:11
> 		  Permanent HW Address: 18:d6:c7:01:15:11
> 		  Driver Info #0:
> 		    Driver Status: r8169 is active
> 		    Driver Activation Cmd: "modprobe r8169"
>=20
> noting,
>=20
> 	ls -1 /sys/class/net/
> 		enp3s0@
> 		eth0@
> 		lo@=20
>=20
> in `dmesg`
>=20
> 	dmesg | egrep -i "eth|enp"
> 		[    4.564854] r8169 0000:02:00.0 eth0: RTL8168e/8111e, 18:d6:c7:01:15:=
11, XID 2c2, IRQ 27
> 		[    4.564856] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 by=
tes, tx checksumming: ko]
> 		[    4.568641] r8169 0000:03:00.0 eth1: RTL8168c/8111c, 00:52:35:50:44:=
04, XID 3c4, IRQ 18
> 		[    4.568643] r8169 0000:03:00.0 eth1: jumbo features [frames: 6128 by=
tes, tx checksumming: ko]
> 		[    4.614030] r8169 0000:03:00.0 enp3s0: renamed from eth1
> 		[   28.179613] RTL8211B Gigabit Ethernet r8169-300:00: attached PHY dri=
ver [RTL8211B Gigabit Ethernet] (mii_bus:phy_addr=3Dr8169-300:00, irq=3DIGN=
ORE)
> 		[   28.283488] r8169 0000:03:00.0 enp3s0: Link is Down
> 		[   30.498955] r8169 0000:03:00.0 enp3s0: Link is Up - 1Gbps/Full - flo=
w control rx/tx
> 		[   30.498976] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0: link becomes ready
>=20
> Something's changed -- as both interfaces used to be properly named per r=
eliable-naming standard.
>=20
> I _can_ bring up the network on the Mobo's renamed enp3s0 interface ... b=
ut no longer on the PCI card.
>=20
> I'm not clear on why one interface IS using the reliable-naming scheme, a=
nd the other is NOT.
>=20
> Any hints/clues as to the problem &/or a fix?
>=20

Network renaming is not a kernel responsibility. This list is not directly =
relevant
to your issue.

Various user packages (usually systemd/udev) do this based on distribution.

The naming schemes mostly rely on information reported by sysfs, such as PC=
I address, slot or other
values. Look for any changes in that information that might cause naming to=
 change. I.e one
version had PCI slot information, and the other did not.=20

Read the documentation here: https://www.freedesktop.org/software/systemd/m=
an/systemd.net-naming-scheme.html
To see what the systemd policy is.

