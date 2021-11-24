Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E81245B638
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240981AbhKXIIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:08:39 -0500
Received: from mout.gmx.net ([212.227.17.20]:57147 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233552AbhKXIIi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 03:08:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637741121;
        bh=GveQo0h8sUt9oirjZ/UP5JvsVcwvbv9in8jSuu4a0qw=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=hgHJssc0u7riAOX4vO6VKmvvvB/PXWzOPGa1M8raYRthO3K0uBoje43NxhORp5buh
         uGTUBe6+rJBk3EafSJFNdtZc1WZRHzFe7BaTfc7Ne1vwdKssdewrb5mZ1JuaS4B9DN
         L/Dzn/zvaQMiV223VTq5suRe9lGHbX2bMWaz617g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from machineone ([84.190.131.218]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MxUrx-1mR6hF3WIL-00xqmo; Wed, 24
 Nov 2021 09:05:20 +0100
Message-ID: <a525098b284e323edf2abecb3efa907992abc843.camel@gmx.de>
Subject: Re: [REGRESSION] Kernel 5.15 reboots / freezes upon ifup/ifdown
From:   Stefan Dietrich <roots@gmx.de>
To:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     regressions@lists.linux.dev
Date:   Wed, 24 Nov 2021 09:05:20 +0100
In-Reply-To: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
References: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RorKLRjyJL0sDDEB0YEcICUx/+xtNhEFCJiON6jwGOE122Az3aH
 DXAtYDcppoTJjq+l45pVQXEVn1mpx4oFUgO/Y7nlrH7tYHlmVc1m1DzNh4l59yOpO3KRXfw
 GE++ibY+ArF6FMLcB/WF6bAHdnujs196tB7l9XlpWXlXmEJFAnz3I+sr6OorKPbwymjJHeH
 A7rVYfsXuZNt433HYA16A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hijyk411OrY=:1bBZRGWtG+S6l1S2Lt+bzI
 I6cocloq8rK72+rcav4CZQsPpoFK5nT7kh33Qyrjoii1tbyapHE5eBmvb6jvIxzH5UravFPBM
 vra/zVtvlqo8Hpso7qo8+p3bi9V/iV8P/0e+b1MscTwpCEuYl3LKLA8ZHFmBDz5+PotW/+9nF
 RI21Z4zCtspKMdEaehofM+OJR0B99LYeXsy1F1lLks4T63oAHjX0300c6Dn5nD39IC1qcelB3
 MYIh2m7Qmul65D1M/xPQ35AvvjcXXZII1hsXiu0q1ku3e4SPp4imKmjpBRhnFL183eu23POIm
 ZJv67sBGhNPlgAJX+a5QAZCxQaYm20JskguE+Ejoi98Qfb2r7utAGAGdelQYBoNKMQfDZJy04
 rLPQs2hOzmCH8UziLI7elJMme7UrymwuE3jRp8TvuLiNCtWa0ytoDnzee+oD8z0mgHaQ1aZf7
 B1TbFBcf1u4MwLhgczx5mCxOrJvUQYGpOWVBl3Yzx3AblRvKEijeyN5KZlqF3u/MB5AGnzPbn
 bFXhIjn28jVch8BlKiz4RkDvl7IRne6iFwY3ZyglUWzn3I8x3NE6B1v5SekR7Dg+XOC8/VsFg
 CCo/9DKNNpUwgIDw9mk2llBwhD4sJ/nO9giQrFWoxekN1yaSDyg+OAhqNvrS0c0pHwRADMd9O
 rFPNyoBXR/vY0swc1DA5oWWGSy25r+n6EjZ97qwhU+1QrulDhGcJ4Sti3CP9oDNgObwdKcBkW
 t755VZOFzws0biHC5DwmTeVkTmy/Ukn8eE6QSFbDMdCSUC8Jb08bBNU31+Paqoc9Awlq3zWeA
 zxAnmuotC6Hf6AsnkmZtV2KPcLJ9InUFh7PiqmWSiPrKayrNksj4zQTRUluZ9udwsfBMJxccr
 /avP5BmYYadr/SUUNVtXu9ZcC+bRqyawnRM9L2CzyIKGPnv+2EaS7Ol2yB8G9P7pJvGa66n58
 lGe6NnoUXNb5cChwqVhDEWTTbu5vYo8w0jG/wyF0PczfspDhUlzb09jGI6neWrQIasxBh67Hf
 2uVI+k2rSGYKoZqaprzOuFWNgZSmiNLIoIbE5DXGAKe2cZXKMsyzu5KGGI0GLYHH6SQGfJYsw
 txMYK3f/pCa4Dg=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thorsten,

thanks for the pointer. netdev should be in the loop now.


Stefan

On Wed, 2021-11-24 at 08:28 +0100, Stefan Dietrich wrote:
> Summary: When attempting to rise or shut down a NIC manually or via
> network-manager under 5.15, the machine reboots or freezes.
>
> Occurs with: 5.15.4-051504-generic and earlier 5.15 mainline (
> https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.4/) as well as
> liquorix flavours.
> Does not occur with: 5.14 and 5.13 (both with various flavours)
>
>
> Hi all,
>
> I'm experiencing a severe bug that causes the machine to reboot or
> freeze when trying to login and/or rise/shutdown a NIC. Here's a
> brief
> description of scenarios I've tested:
>
> Scenario 1: enp6s0 managed manually using /etc/networking/interfaces,
> DHCP
> a. Issuing ifdown enp6s0 in terminal will throw
> 	"/etc/resolvconf/update.d/libc: Warning: /etc/resolv.conf is
> 	not a symbolic link to /run/resolvconf/resolv.conf"
> and cause the machine to reboot after ~10s of showing a blinking
> cursor
>
> b. Issuing shutdown -h now or trying to shutdown/reboot machine via
> GUI:
> shutdown will stop on "stop job is running for ifdown enp6s0" and
> after
> approx. 10..15s the countdown freezes. Repeated ALT-SysReq-REISUB
> does
> not reboot the machine, a hard reset is required.
>
> --
>
> Scenario 2: enp6s0 managed manually using /etc/networking/interfaces,
> STATIC
> a. Issuing ifdown enp6s0 in terminal will throw
> 	"send_packet: Operation not permitted
> 	dhclient.c:3010: Failed to send 300 byte long packet over
> 	fallback interface."
> and cause the machine to reboot after ~10s of blinking cursor.
>
> b. Issuing shutdown -h now or trying to shutdown or reboot machine
> via
> GUI: shutdown will stop on "stop job is running for ifdown enp6s0"
> and
> after approx. 10..15s the countdown freezes. Repeated ALT-SysReq-
> REISUB
> does not reboot the machine, a hard reset is required.
>
> --
>
> Scenario 3: enp6s0 managed by network manager
> a. After booting and logging in either via GUI or TTY, the display
> will
> stay blank and only show a blinking cursor and then freeze after
> 5..10s. ALT-SysReq-REISUB does not reboot the machine, a hard reset
> is
> required.
>
> --
>
> Here's a snippet from the journal for Scenario 1a:
>
> Nov 21 10:39:25 computer sudo[5606]:    user : TTY=3Dpts/0 ;
> PWD=3D/home/user ; USER=3Droot ; COMMAND=3D/usr/sbin/ifdown enp6s0
> Nov 21 10:39:25 computer sudo[5606]: pam_unix(sudo:session): session
> opened for user root by (uid=3D0)
> -- Reboot --
> Nov 21 10:40:14 computer systemd-journald[478]: Journal started
>
> --
>
> I'm running Alder Lake i9 12900K but I have E-cores disabled in BIOS.
> Here are some more specs with working kernel:
>
> $ inxi -bxz
> System:    Kernel: 5.14.0-19.2-liquorix-amd64 x86_64 bits: 64
> compiler:
> N/A Desktop: Xfce 4.16.3
>            Distro: Ubuntu 20.04.3 LTS (Focal Fossa)
> Machine:   Type: Desktop System: ASUS product: N/A v: N/A serial: N/A
>            Mobo: ASUSTeK model: ROG STRIX Z690-A GAMING WIFI D4 v:
> Rev
> 1.xx serial: <filter>
>            UEFI [Legacy]: American Megatrends v: 0707 date:
> 11/10/2021
> CPU:       8-Core: 12th Gen Intel Core i9-12900K type: MT MCP arch:
> N/A
> speed: 5381 MHz max: 3201 MHz
> Graphics:  Device-1: NVIDIA vendor: Gigabyte driver: nvidia v: 470.86
> bus ID: 01:00.0
>            Display: server: X.Org 1.20.11 driver: nvidia tty: N/A
>            Message: Unable to show advanced data. Required tool
> glxinfo
> missing.
> Network:   Device-1: Intel vendor: ASUSTeK driver: igc v: kernel
> port:
> 4000 bus ID: 06:00.0
>
>
> Please advice how I may assist in debugging!
>
> Thanks.
>

