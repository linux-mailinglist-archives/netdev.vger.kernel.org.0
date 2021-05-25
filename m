Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02D3905F4
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 17:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhEYP5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 11:57:47 -0400
Received: from mout.gmx.net ([212.227.17.21]:44905 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232071AbhEYP5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 11:57:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621958174;
        bh=OJghyn0yWmat2efuRvDd25gN+6XyEwD6LEv2OY1Xasw=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=j3kmWypOqWwUihRVVMF3NC8Do8IA0ARPTwF6Doi7Wdd+gkmuCrALEyI5Ouc0FtFck
         NI/fa9enXPOZex/dwHhFcST+omqyVlSMfN2U1OoDiEago9OJQGVmNup7ELkj4dBu0k
         yWLMnw4ALorbXJdFepM2yZFsKZJjg4DaF9ldvqcM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([157.180.224.228]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MHXFx-1lguid19jl-00Dalr; Tue, 25
 May 2021 17:56:14 +0200
Date:   Tue, 25 May 2021 17:56:09 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20210524143620.465dd25d@hermes.local>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46> <20210516141745.009403b7@hermes.local> <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57> <20210517123628.13624eeb@hermes.local> <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de> <20210524143620.465dd25d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: Crosscompiling iproute2
Reply-to: frank-w@public-files.de
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     netdev@vger.kernel.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <AACFD746-4047-49D5-81B2-C0CD5D037FAB@public-files.de>
X-Provags-ID: V03:K1:2J/mlB8A8cYtryIdw7yzS0+J0e20aOaNoatB4d8rhGP+912ynwH
 x3KI75hLiZnClFQbegdD6KeTP7/tlI55H+JKwVlo5TbbHwkzY5oNNkDkHBXxO2J99qOl4TD
 vUQ+pn3+4cK1QEmcbElL53x0IWoLIQSKE7Zj3G9uldANT4ZIOSAEADWhCw3J4AzcEr1haQk
 93OrD1HT0bEbdQFqB6TiQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KsQYv+cd/7Y=:tFccyAQPJkc+Nw3E0bb4rv
 T2SlSsyyrpgWpcALGKYJlUdbT5oXRlpA8Yx931/NGL90lmWsI77utWG722gsMnCJep89iwZeJ
 KlaUC/S0u4sM/t9HKB0ugUgI03sEphQTzzpntTq+tzVsoon22DJe4uQnMIdhu2VRzGgNrd8YP
 qgSCIiJEZJvVZcmSo0ymaUhMMtujjZgppmeKDUad1WHmkFLsSdu/08Cg9cbrfIfRH7LXI+9a0
 ycqdGGPWj92jqwvfkLu//PUqIXvM008tQ9piqc4k01Wje3Rkoqz1tWFdRLJOurvL0lv1U0sV0
 SCKKWHAMrBqbBh90nngkIw79IPPoTMzkkbkmXU0hyis0WK4FifV7EeSPCvM9jCwrT3G9pMwUn
 9jzRcoibTbjYzy2O2mdh6aH6b2oTeNlt/hP31wQWHWY92hHCjLkiQymYVzBGmrgc1Ncci6/Le
 fJvf7rvULsLDMNumR5IlJXj9HUbEf8l8mfFGss2GjzY095qYn9XTHd8J+DjGf6++MdXiDfZm/
 nAH5PE0bzWmj3RZfwI0s+t346+USl+a+6Bqx6XxjDYlS6B7eEUbem1DTwJcXwqKe4Oqlcw3mU
 nwsRDlZLD9BEKg/K/5K8h1LHVq22nIHDxWv+x6kO+VkPLVDXC52I0MSKGw4D0oNaPcnPOBrn3
 PbnKgrXApQ+/rPP+kWhnikR/NNijCp7RbxDTY6nGQkMFhyrXsyT4RMq+/5czlOJB8XIYrkD2R
 mOPpDK7Eaofm7FUcTr9BRPiOBGARViz0qunDrO5+WgHCBgUMINH/agQD4kqAnkKSkuAt1QMM8
 I2Vkl1aBKgq+yl6NWr+6m3yUCp/pCxRoqWofbdab3Dh+3UGjv2waAUwonQS5sOnhr7ZJEktQ8
 9IPQewD1SeF+iXBCzUsH4lczge9sabwFnna8O44wzjXQ317r+9KXGvxheEE0BzqK5mlKH8FhO
 VGSTM9ew7yNnlBHPxQAeqLC7HXgjdkzTSijbhh0ycwGds0lG279IqYVTcTm4YREsKZcpgi7WG
 1OfS/bsIvWbBFMlLXEVj0CFnFm5nuL3WvicAaqfE4IA2HM/jP9xJTpa6pCB2bdukg+4CA4Hz5
 lhL2IHwh7eKBj3rjBci7kEg6lNIeOhEHc/tAT7jEHYxAgCkN1ejkKWtQXTThY2w2uWTvmG0bY
 t7sWbdAd0PmJ1VhqeTCsU8wcy4jsn0R+o4drwp6MWC5rrPP/zfgjXyPMKVJ56sfvVW6KvByyh
 I52UHwUVKXEEoFq0m
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 24=2E Mai 2021 23:36:20 MESZ schrieb Stephen Hemminger <stephen@networkp=
lumber=2Eorg>:
>On Mon, 24 May 2021 21:06:02 +0200
>Frank Wunderlich <frank-w@public-files=2Ede> wrote:
>
>> Am 17=2E Mai 2021 21:36:28 MESZ schrieb Stephen Hemminger
><stephen@networkplumber=2Eorg>:
>> >On Mon, 17 May 2021 09:44:21 +0200
>> >This works for me:
>> >
>> >make CC=3D"$CC" LD=3D"$LD" HOSTCC=3Dgcc =20
>>=20
>> Hi,
>>=20
>> Currently have an issue i guess from install=2E After compile i install
>into local directory,pack it and unpack on target system
>(/usr/local/sbin)=2Etried
>>=20
>> https://github=2Ecom/frank-w/iproute2/blob/main/crosscompile=2Esh#L17
>
>>=20
>> Basic ip commands work,but if i try e=2Eg=2E this
>>=20
>> ip link add name lanbr0 type bridge vlan_filtering 1
>vlan_default_pvid 500
>>=20
>> I get this:
>>=20
>> Garbage instead of arguments "vlan_filtering =2E=2E=2E"=2E Try "ip link
>help"=2E
>>=20
>> I guess ip tries to call bridge binary from wrong path (tried
>$PRFX/usr/local/bin)=2E
>>=20
>> regards Frank
>
>No ip command does not call bridge=2E
>
>More likely either your kernel is out of date with the ip command (ie
>new ip command is asking for
>something kernel doesn't understand);
I use 5=2E13-rc2 and can use the same command with debians ip command

>or the iplink_bridge=2Ec was not
>compiled as part of your compile;
>or simple PATH issue
>or your system is not handling dlopen(NULL) correctly=2E

Which lib does ip load when using the vlanfiltering option?

>What happens is that the "type" field in ip link triggers the code
>to use dlopen as form of introspection (see get_link_kind)

I can use the command without vlan_filtering option (including type bridge=
)=2E

Maybe missing libnml while compile can cause this? had disabled in config=
=2Emk and was not reset by make clean,manual delete causes build error,see =
my last mail

You can crosscompile only with CC,LD and HOSTCC set?

regards Frank
