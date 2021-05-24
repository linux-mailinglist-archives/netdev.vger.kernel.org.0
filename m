Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0E238F374
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 21:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhEXTHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 15:07:38 -0400
Received: from mout.gmx.net ([212.227.17.21]:42917 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232983AbhEXTHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 15:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621883167;
        bh=01aaUwr3W28DgyAPFMxBF4fMLffoT+lK2RPq8+7dH7Q=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=Sff2wHHjGNsxk/hSRWDEzj0Tqu+3Henew7DXUoacs5xtwE3w/RmUjsCs0XqRYJxdA
         XP24WKMuHZ15b/mihX2z59JS3z5xmPmpiW36itzNrX3+HkZkpptw5SpbRUDEtiKB50
         9+iGpzRmobSY+kZ0X+o2IVWvGxz543qeXGe3AR6Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([80.245.78.161]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mzyuc-1lYOF70qX8-00wzjU; Mon, 24
 May 2021 21:06:07 +0200
Date:   Mon, 24 May 2021 21:06:02 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20210517123628.13624eeb@hermes.local>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46> <20210516141745.009403b7@hermes.local> <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57> <20210517123628.13624eeb@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: Crosscompiling iproute2
Reply-to: frank-w@public-files.de
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     netdev@vger.kernel.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de>
X-Provags-ID: V03:K1:T3rWJcXF/nNxSOIeQeg1BpiAccf3/Fwn0QLqbFhmHzlW3DX8hSd
 qXHsKWqx5mVCUrk/Aghi53PCBji7ChmjymiTmUEDzYKOhSSNcCC9EL114LogD/xqyCzJQy/
 DbEOzTzgw3aF5rErpMWfVx5nwjYQoFSUg0ZB+XAQrEOXcgYkWv/2pXvHuxjMRvZ6RIwDxI3
 /j+csZqauEkCiBTPWEQtg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jw6dCzBtEKQ=:LWEwH8+sju5gICq/chaS7a
 k1ZWvz4xhy1sFtld5X0rUnH8Wd3+RwGxtRW3MwJQclYgfYt06vWefhBXPc0XFTAlnkHY2CiLe
 0EM8D54iHFwd3nW+AO1cNWgz8j+d6j/28pni9xRcUa8wuenTqgA0otD4SZFn8sV+VE2ZaRSNp
 Ro1CxTaT7LBlcA2sgQ2yrMGM4q1IDMjXbZqruxIhnU/oi3bHDD+kzMiCuUUH1FORo79i3fg9g
 U3gSXklFhVtt2lHoMJqAtrMN4hP/ReozejJAlLeCeCMmuWA4ySSLZQ2+AMeI+bWUUssQvOqMq
 t36Q9+cjTdNCBXBIZuHLuznHeZLYrZiBZFw5J7rTwHzjXAI2fs+icCcgqkD9/4W9qEUVguDDs
 ILM2dtU1YGg++Hu4OHhVe7j8wx5jq+QtzvmVnfQFTKAz8ilE+hFukIt5G/6niHRiVPLc3Pu+i
 qcXhr2g0i240LVb0ULVbuDgbZpiPrreOHaI5zPzbN0CRdU/9qwL/dA6MgbP6yTSR1A71O5Njy
 MXQScVnD5cTnaWoEh2C6i4pIUCYkC3C/ZxnfDmGJW9nao1Id5Bvk5OxtUqERFCFFomY0Plnw7
 ogCFf7yxAEJ+eJy9ccQlwSTwBrmJHqjWb7HgazwehYwq3pCihwUA21VOOi4Hozi8yA9v44FvO
 QnZyWyoXBvGxcCAiXKwCAq1BHh4GuFca7Grpb0KGODadohf/IaIptZ9duqRU5c2rcmdJCqCaa
 lKSg0M0u+gytaGLBciBTU7wi6ST9irSJDzHiyiWLXX/DeOX6wAECCeYHVZq5sL1tbu2UUVaZ3
 FcgBO1nTMGmGMK4uz0iOZV5NEo9ybPq6/6z1pkw0mpYitvfGuDx4mfOYMJx5JAELobjhiA3kv
 PrNRLw8lxSwPD9bhky6BebMcWPG9DBL1YJLiJLIHD+NOqOwKR1T8ZYQLKo2LUjqaMxwmbv2Ak
 M/+6z5/F9hoJBqdUeNpFvaRao7tP3jm4+1mHydIJDzpvuQNOw1In0qI3Ih9+7N5rGZSf5W/ot
 o+u75mMDGy1Ry4LfQjdyQFDX4bpIm9U5wdCvlyF4eELcWtOv5Dzib3VGH9gcRisOybD7o/hhV
 6Qapx5RIPriYqZHmo8DwrDyYlvkCIGHJzP8vUchCPMD21nD2BrvKbs1K26vxKly9UfBQF8jQK
 8NonuNnpMfP7aGiRPtkt2H7qH8C4dm9iwyoZz/DEQ5gozSaWmDgYodoSEztLECG8sdNdLnRYI
 QApbRRzM6tO0WMY8q
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 17=2E Mai 2021 21:36:28 MESZ schrieb Stephen Hemminger <stephen@networkp=
lumber=2Eorg>:
>On Mon, 17 May 2021 09:44:21 +0200
>This works for me:
>
>make CC=3D"$CC" LD=3D"$LD" HOSTCC=3Dgcc

Hi,

Currently have an issue i guess from install=2E After compile i install in=
to local directory,pack it and unpack on target system (/usr/local/sbin)=2E=
tried

https://github=2Ecom/frank-w/iproute2/blob/main/crosscompile=2Esh#L17

Basic ip commands work,but if i try e=2Eg=2E this

ip link add name lanbr0 type bridge vlan_filtering 1 vlan_default_pvid 500

I get this:

Garbage instead of arguments "vlan_filtering =2E=2E=2E"=2E Try "ip link he=
lp"=2E

I guess ip tries to call bridge binary from wrong path (tried $PRFX/usr/lo=
cal/bin)=2E

regards Frank
