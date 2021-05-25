Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDA8390288
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhEYNbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:31:49 -0400
Received: from mout.gmx.net ([212.227.17.21]:56809 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233170AbhEYNbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 09:31:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621949414;
        bh=+36ql1hrXHfVbSpn957tc+hYURQHqApsVIjIVg/O0P8=;
        h=X-UI-Sender-Class:From:To:Subject:Date:In-Reply-To:References;
        b=GPZC8hhxL8+UzcX06goYZ3KX+O244amJjOxt0Of/5rff4nJCb8gpZyphUQ3QwZLab
         z8N0WTtlujZtpONbyxuudZ2T/PhGutzCK/17Q/0N/oMkDHlnph+/L0uaGlgapqGAm8
         +NtrRZqE8HwdsA1JAddz6PFudsPINQEi4DPXR/rk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.224.228] ([157.180.224.228]) by web-mail.gmx.net
 (3c-app-gmx-bs13.server.lan [172.19.170.65]) (via HTTP); Tue, 25 May 2021
 15:30:14 +0200
MIME-Version: 1.0
Message-ID: <trinity-0fb4d69c-cf47-46fb-8a4d-522aee2627dd-1621949414214@3c-app-gmx-bs13>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Aw: Re: Crosscompiling iproute2
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 25 May 2021 15:30:14 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
 <20210516141745.009403b7@hermes.local>
 <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
 <20210517123628.13624eeb@hermes.local>
 <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:4L5ktGzJQpe6WiYB0eiPMmPlYefzxAFIL8O4VzQ5RB5giKg1jj93iBNSB5FCUBqpS3kAb
 CzoiTL2B79qUFqw1Xv2WJ0x2x9pSw7Debilezujn4EVd69jS2iaYIgxOJZD7GPzZOhf3SgzCBMhG
 ZZ2PzOO7UwWSNVTybso7NiU9+ZL/WGK35EGkFQFs+N0l03ibal+HgSBIn6kLvsFb5OBy4KqSnZbx
 9DKzjyy6JqM+KhOx9kp2hnsZAwqp2CarTEKh7Zaen4UDho0G1qJLiuLys1oRj2/3zZ8A9gWPtXBz
 iY=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5dro349tO4k=:7xfSXwP9EyvHutF45Hk5nS
 AnPLj2ULnlJjGMT8JPs8iGNuH769vuV3Kb3gUjM2UxS0tGDY6MP0jFxStza2f8hn1VZYpjZRb
 Kna+tAzIHcJFDdSzFwuKOtOGvYjhsj5yKXNjkXSbRBctP2aFwsgTbUgIZVb+08OxWsv9CScET
 wlGi8coEIc1NGl06I+BSJLZ8h27e+KLN14srH6sw+mmD2NFJ4kpU9Vu9FhKhLNXImNbc67PaN
 ufmRMiHZcCObLgmVuVPRzu1P21ss40zIRgzkv6ZT0TqIiHzVrvXGdJGWmpAeQ2gDMBK3SXE/I
 ImV4+sKAkItgdEuEMpKd+p+BzOXVYHDNEXA94tW83BemNwFABBJC5WFJBFAqzuHQJLrHsWw1e
 cvcbobKbl93BTDrLh+MCd0E2wZSfl3G5ps0kLLahBdzoRuDGj7LhDDH3qM4xMzDjfqqo+V2Uc
 SgOCZZLbJtzSEH0613uuDYeOjlbdvqs7VWdPOh5iFf+3ZtFNlMBefI4fGpseoPtGVDgKcVWxw
 uFsfAg9/T2ARI0DJDjhRW/++/UNOe8MFsJ9Ey1SInNYpXkhpx0X5B06in7BI9Tgl9ZRbJsFFn
 SHk/4f+4UVkafzsc1p7f3FJPpiBMgR7AzZF62TmNq/gpqj8gWtTtH17lvpAw3biRQuYQAzlwe
 27FQeryIGjE23RV+sR7AJlQS6dMdDWTZfBlb1+sZDSjAGHwr9B+rJiUReCjpkunI9as1AsDQQ
 zZi52zxv9BFMoUc75t8Z5UTvPjlblysWTuHlGt+exLUdGJeSvPr6Sqbpdw7zjxlmTC+jPNDxR
 JA7U3iN7FmNLBjGTYoI4Twf6iSYkMf+1dG/t533uTzCxTgHU/M2uZbHDNKJYMQk2rp482PkOE
 5fhigAg+4v20aZy1jEUolm1jH/USb3ozp+RXhijxFW/EWf42iARc5OzaJM3V6XomeIfSN1gAk
 96bO/gqWVqA==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Currently have an issue i guess from install. After compile i install in=
to local directory,pack it and unpack on target system (/usr/local/sbin).t=
ried
>
> https://github.com/frank-w/iproute2/blob/main/crosscompile.sh#L17
>
> Basic ip commands work,but if i try e.g. this
>
> ip link add name lanbr0 type bridge vlan_filtering 1 vlan_default_pvid 5=
00
>
> I get this:
>
> Garbage instead of arguments "vlan_filtering ...". Try "ip link help".
>
> I guess ip tries to call bridge binary from wrong path (tried $PRFX/usr/=
local/bin).

based on Makefile i tried this install line after building

make DESTDIR=3D$PRFX PREFIX=3D/usr/local SBINDIR=3D/usr/local/sbin ARPDDIR=
=3D/var/lib/arpd CONFDIR=3D/etc/iproute2 install

it installs to the local folder instead of system-directories, but error o=
n target is still the same :(

same line with binaries from debian working, so i'm sure the command is ri=
ght (and have depencies in linux kernel available), except there was any c=
hange in code causing this

any idea?
