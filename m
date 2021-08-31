Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F813FCAE0
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239354AbhHaPcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:32:33 -0400
Received: from mout.gmx.net ([212.227.15.18]:44825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239133AbhHaPcc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 11:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1630423824;
        bh=jzyeFyo3ckfxsmJnJAtgJIurmySihzsZ3gd9ZE8lNpU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=QkuGJ7UiWqjf3rFMGZUpCBpC3UA6lCb0clBaNBx9Uez44gYtEz0FFCNrvFjMr40/0
         O60zO77VU3EZWd3K/xFYfTKpufhQQjWuO6CdvQINgOruqh0jR7PRdaqGyxAMkFITlS
         uz2DGpUtXfi4udoycTTyThp4OwYdCOqvXvOiC+mg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.44] ([95.91.192.147]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M9Wuk-1mOPdE2Sua-005W0n; Tue, 31
 Aug 2021 17:30:24 +0200
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in phy_disconnect
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+6a916267d9bc5fa2d9a6@syzkaller.appspotmail.com>,
        davem@davemloft.net, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000006a17f905cad88525@google.com>
 <20210831064845.1a8f5c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YS46wWr6WegVF4Er@lunn.ch>
From:   Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <a2135e89-e68e-1ba2-770a-84b3b0f5d3ed@rempel-privat.de>
Date:   Tue, 31 Aug 2021 17:30:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YS46wWr6WegVF4Er@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Ehb4VyXaUvNkfW8HeyDwCMWSXYA4zQZfdwyFZZgjtTzvu2q8IKg
 UNDxNWRdlVLmyOgMC5vseJjbkP9wHQ69hOThAgaGwuT8U7othbvXLQM4VhHQG25vim8j9t+
 kUjDqD+ipiHR/IsOTB9TSm6ai9CBb50KKhtF+0Omq/RL88L35YcY9TFmtaTbBOyarxOD8zi
 OKTaLKp7rimi+Cslpe1MQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2G4Odsj8JKo=:XXIDHq5qBvpMQYJ7x+TwVZ
 qqbJ31MoiPGGWfOFYx3JQqGCe6vduTjeVjWO6wxLKi8BtCBKrZO/bRGtF3Le5vo9daCGMRsVv
 kdrWYqCNqAUbuXd5i1mRMhRgVr4cHFqVg8ChG4CvjIJyvtlps63fh+0SkRHGWaOTx6kBM2ACt
 GpcMME6D3cFVEH8YFCF75tCRHsa6Nd0QrdbFekeZhHt3aRDalN1ByCjQE75dvHRDZ+juNcHu/
 JjmjS6ospQBp/bjEAnGk5C6bRBkR3VHoQyeaVWgmEm+K9sgUPbL+sRatazwn3bb2U4Ig6LZr1
 iz1sKEHm0ojKCmF/enA4WVyhGgM6gwvJkz3OiEbx7EhlzTxMGtMNPW76ouSZxWMlghDz1DE31
 YdwRk1udvYNT1kQdc+SnxEg/SH8X/R7q3HbzNr0h0kQOIBWRg+Wo5CXUJvaGl6i6Es9wrEgOk
 0RXD4wulC1LoTCXhNJ7+EvbgobepGg8eQqIWCGfnDmcC/A4nOXO0SB/UKKrnsAcgcMDTWcyPC
 M5DZFcqwdz4qWBZaIO8vuuo97NK5mX1Z70O3VeHuiT8STx9dSTCa8oIH/rLBLPFluCiKJpU19
 otoTv4xB1+ENuy9JZbyb6n0wrYb66IP7VVBcnOHuLDfubhwIkUf8eQYpEN669BjmbBFQclyxA
 rP/9G8PCaKmzv26WdzecVtyMkWiIZ0EB6DaXaZ+elZTWE4hj01VAH6rTn4JeV1F4SRGTxF/u5
 /zDggxk3OwVb2ZYykz2+SoTrIMUAF4RW61RI78YqHvu68onyCBlvZ53NqDC+SarhIlCoDtOmz
 yjdEmbXTygY1OChED6wHsjzA/moVYQ/bI57FmM2hTt/EjYSa0l9UYaitpIvsy63qQBLbXyNEg
 VYbHXGwkmwM97lHBH3KMhIQZuZ6uolNP27UzQXGeuZ3/psk+Z+GCcI+5H0XVWrCenqpE9b6U5
 4t5rpapCf7ZwxMMzyWG8sdZva8tOHI3ohsMdH/r+NuI1WBGZ8ldyuU5axwZA6MXXqw8oXnpG4
 bTyZNNAD48ZWRC6UVURoX18AJWoBukLmZ6yxhTuQjF/R9FzqbftqM37tXQUCUJbd7yn6cL2/E
 NX9bhQ4WSM/UuHwub9v59gVdMWCMPhheNe0O7ca6afbGktmuIbMOBkdSQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 31.08.21 um 16:20 schrieb Andrew Lunn:
> On Tue, Aug 31, 2021 at 06:48:45AM -0700, Jakub Kicinski wrote:
>> On Tue, 31 Aug 2021 03:36:23 -0700 syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    9c1587d99f93 usb: isp1760: otg control register access
>>> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh=
/usb.git usb-testing
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1690729130=
0000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D24756feea2=
12a6b0
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D6a916267d9bc=
5fa2d9a6
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Bin=
utils for Debian) 2.35.1
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D166de449=
300000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D12c5ddce30=
0000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the c=
ommit:
>>> Reported-by: syzbot+6a916267d9bc5fa2d9a6@syzkaller.appspotmail.com
>>>
>>> asix 1-1:0.0 eth1: register 'asix' at usb-dummy_hcd.0-1, ASIX AX88178 =
USB 2.0 Ethernet, 8a:c0:d1:1e:27:4c
>>> usb 1-1: USB disconnect, device number 2
>>> asix 1-1:0.0 eth1: unregister 'asix' usb-dummy_hcd.0-1, ASIX AX88178 U=
SB 2.0 Ethernet
>>> general protection fault, probably for non-canonical address 0xdffffc0=
0000000c3: 0000 [#1] SMP KASAN
>>> KASAN: null-ptr-deref in range [0x0000000000000618-0x000000000000061f]
>>> CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 5.14.0-rc7-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIO=
S Google 01/01/2011
>>> Workqueue: usb_hub_wq hub_event
>>> RIP: 0010:phy_is_started include/linux/phy.h:947 [inline]
>>> RIP: 0010:phy_disconnect+0x22/0x110 drivers/net/phy/phy_device.c:1097
>>> Code: 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 46 33 68 fe 48 8d bd 1=
8 06 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 0=
2 84 c0 74 08 3c 03 0f 8e c5 00 00 00 8b 9d 18 06 00 00
>>> RSP: 0018:ffffc900001a7780 EFLAGS: 00010206
>>> RAX: dffffc0000000000 RBX: ffff88811a410bc0 RCX: 0000000000000000
>>> RDX: 00000000000000c3 RSI: ffffffff82d9305a RDI: 0000000000000618
>>> RBP: 0000000000000000 R08: 0000000000000055 R09: 0000000000000000
>>> R10: ffffffff814c05fb R11: 0000000000000000 R12: ffff8881063cc300
>>> R13: ffffffff83870d90 R14: ffffffff86805a20 R15: ffffffff868059e0
>>> FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000=
000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007fb4c30b3008 CR3: 00000001021e1000 CR4: 00000000001506e0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> Call Trace:
>>>  ax88772_unbind+0x51/0x90 drivers/net/usb/asix_devices.c:816
>
> Looking at the console messages:
>
> [   36.456221][   T32] usb 1-1: new high-speed USB device number 2 using=
 dummy_hcd
> [   36.976035][   T32] usb 1-1: New USB device found, idVendor=3D0df6, i=
dProduct=3D0056, bcdDevice=3D42.6c
> [   36.985338][   T32] usb 1-1: New USB device strings: Mfr=3D1, Product=
=3D2, SerialNumber=3D3
> [   36.993579][   T32] usb 1-1: Product: syz
> [   36.997817][   T32] usb 1-1: Manufacturer: syz
> [   37.002423][   T32] usb 1-1: SerialNumber: syz
> [   37.013578][   T32] usb 1-1: config 0 descriptor??
> [   37.276018][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized)=
: invalid hw address, using random
> executing program
> [   37.715517][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized)=
: Failed to write reg index 0x0000: -71
> [   37.725693][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized)=
: Failed to send software reset: ffffffb9
> [   37.925418][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized)=
: Failed to write reg index 0x0000: -71
> [   37.936461][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized)=
: Failed to send software reset: ffffffb9
> [   38.119561][   T32] asix 1-1:0.0 eth1: register 'asix' at usb-dummy_h=
cd.0-1, ASIX AX88178 USB 2.0 Ethernet, 8a:c0:d1:1e:27:4c
> [   38.138828][   T32] usb 1-1: USB disconnect, device number 2
> [   38.150689][   T32] asix 1-1:0.0 eth1: unregister 'asix' usb-dummy_hc=
d.0-1, ASIX AX88178 USB 2.0 Ethernet
>
> So this is a AX88178, and you would expect it to use
> ax88178_bind(). That function never calls ax88772_init_phy() which is
> what connects the PHY to the MAC, and sets priv->phydev.
>
> static void ax88772_unbind(struct usbnet *dev, struct usb_interface *int=
f)
> {
>         struct asix_common_private *priv =3D dev->driver_priv;
>
>         phy_disconnect(priv->phydev);
>
> So this passes a NULL pointer.
>
> static const struct driver_info ax88178_info =3D {
>         .description =3D "ASIX AX88178 USB 2.0 Ethernet",
>         .bind =3D ax88178_bind,
>         .unbind =3D ax88772_unbind,
>         .status =3D asix_status,
>
> You cannot pair ax88178_bind with ax88772_unbind. Either a
> ax88178_unbind is needed, or ax88772_unbind needs to check for a NULL
> pointer.
>
> 	Andrew
>

Yes, this was fixed following patch:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/driv=
ers/net/usb/asix_devices.c?id=3D1406e8cb4b05fdc67692b1af2da39d7ca5278713

=2D-
Regards,
Oleksij
