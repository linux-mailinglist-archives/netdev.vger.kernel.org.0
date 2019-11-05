Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5CBF05DF
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390819AbfKETYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:24:30 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:36741 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390445AbfKETYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1572981865;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=cyEeja1O/3HJ7qE8/eP52LA1r1YFJ2AT82sSlB3RwDQ=;
        b=BLYVpH1X1u+Bh0du9niozUJ29UmdH/v5/P/UUhyEuNDQg531nrFlMr5ZC/jT9klPY3
        /OgtszLKykmflBaH/YLF7hjgMcF4B4y6+mhTYVzc7Jg5syYf7NVzqwLxq3nL/OgWT5P1
        h6aenWK/9y7R9aCFkVgX1drFwhXUhatZ/XHgB6bCQrI4DYLymkJiQ1UjewleDezpgPiF
        Ev8YAl8qgXgkiXVtKIFYfqst3Jsgv2U3C3oMaYlQfbbpD/QcCYkvZ4MwLleKtCWyBKOk
        P7ZgSPkLH6M+Y+tAPxKHiLHtHvlKpXOWUmeJgSCRcpwL+b0pjH0b2ns0732Kw/65qnCU
        9QVw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDlaZXA4Ef/k="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vA5JOFUrW
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 5 Nov 2019 20:24:15 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Long Delay on startup of wl18xx Wireless chip
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <CAHCN7xK0Y7=Wr9Kq02CWCbQjWVOocU02LLEB=QsVB22yNNoQPw@mail.gmail.com>
Date:   Tue, 5 Nov 2019 20:24:15 +0100
Cc:     Linux-OMAP <linux-omap@vger.kernel.org>, kvalo@codeaurora.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6D542255-6306-4982-9393-DCCC6D1961BB@goldelico.com>
References: <CAHCN7xJiJKBgkiRm-MF9NpgQqfV4=zSVRShc5Sb5Lya2TAxU0g@mail.gmail.com> <CAHCN7xK0Y7=Wr9Kq02CWCbQjWVOocU02LLEB=QsVB22yNNoQPw@mail.gmail.com>
To:     Adam Ford <aford173@gmail.com>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

> Am 05.11.2019 um 19:55 schrieb Adam Ford <aford173@gmail.com>:
>=20
> On Tue, Nov 5, 2019 at 12:25 PM Adam Ford <aford173@gmail.com> wrote:
>>=20
>> I am seeing a really long delay at startup of the wl18xx using the =
5.4 kernel.
>>=20
>=20
> Sorry I had to resend.  I forgot to do plaintext.  Google switched
> settings on me and neglected to inform me.
>=20
>=20
>> [    7.895551] wl18xx_driver wl18xx.2.auto: Direct firmware load for =
ti-connectivity/wl18xx-conf.bin failed with error -2
>> [    7.906416] wl18xx_driver wl18xx.2.auto: Falling back to sysfs =
fallback for: ti-connectivity/wl18xx-conf.bin
>>=20
>> At this point in the sequence, I can login to Linux, but the WL18xx =
is unavailable.
>>=20
>> [   35.032382] vwl1837: disabling
>> [   69.594874] wlcore: ERROR could not get configuration binary =
ti-connectivity/wl18xx-conf.bin: -11
>> [   69.604013] wlcore: WARNING falling back to default config
>> [   70.174821] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
>> [   70.189003] wlcore: WARNING Detected unconfigured mac address in =
nvs, derive from fuse instead.
>> [   70.197851] wlcore: WARNING This default nvs file can be removed =
from the file system
>> [   70.218816] wlcore: loaded
>>=20
>> It is now at this point when the wl18xx is available.
>>=20
>> I have the wl18xx and wlcore setup as a module so it should load =
after the filesystem is mounted.  I am not using a wl18xx-conf.bin, but =
I never needed to use this before.
>>=20
>> It seems to me unreasonable to wait 60+ seconds after everything is =
mounted for the wireless chip to become available.  Before I attempt to =
bisect this, I was hoping someone might have seen this.  I am also =
trying to avoid duplicating someone else's efforts.
>>=20
>> I know the 4.19 doesn't behave like this.

I have with v5.4-rc6 on omap5 + wl1835

root@letux:~# dmesg|fgrep wlcore
[   10.268847] wl18xx_driver wl18xx.0.auto: Direct firmware load for =
ti-connectivity/wl18xx-conf.bin failed with error -2
[   10.291610] wlcore: ERROR could not get configuration binary =
ti-connectivity/wl18xx-conf.bin: -2
[   10.303839] wlcore: WARNING falling back to default config
[   10.700055] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
[   10.703469] wlcore: WARNING Detected unconfigured mac address in nvs, =
derive from fuse instead.
[   10.703478] wlcore: WARNING This default nvs file can be removed from =
the file system
[   12.738721] wlcore: loaded
[   13.978498] wlcore: PHY firmware version: Rev 8.2.0.0.237
[   14.073765] wlcore: firmware booted (Rev 8.9.0.0.70)
[   14.096806] wlcore: down
[   14.589917] wlcore: PHY firmware version: Rev 8.2.0.0.237
[   14.693183] wlcore: firmware booted (Rev 8.9.0.0.70)
root@letux:~#=20

Hope this helps.

BR,
Nikolaus

