Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7674271FE
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 22:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242230AbhJHUZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 16:25:36 -0400
Received: from smtp12.skoda.cz ([185.50.127.89]:16344 "EHLO smtp12.skoda.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhJHUZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 16:25:35 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Oct 2021 16:25:35 EDT
DKIM-Signature: v=1; a=rsa-sha256; d=skoda.cz; s=plzenjune2021; c=relaxed/simple;
        q=dns/txt; i=@skoda.cz; t=1633723717; x=1634328517;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ebaflvg25xpQkSZ3ZsvpkAyJ9i3Elnf/esMEmWzOxek=;
        b=C1s6QJ9kHI7ZEnxzAGq4d3kxrf6PpizV5FOANHPBndKPmITqM6O511LbS5+yfztP
        yeOCw24smB+/sBLtJr856kDev2Yrfxob3DoZOVl8RHzi+p826iZ7yWZeDzX2Qvhr
        WWmVPt2+mwIdQwjmUqR7hrr2xdVJQ0E73D6WBL8Gxpsm58VjG1QmDyrnwQIAjs0k
        YjbrIegBbuReCYT9QwMv8YzX6GbwzJ10irexdwLGjGvOlFccd2ZXPC45pHEkPr9Y
        AxBR04YxUR/4prnFi5W8VryJ1DTyGUwf2lU7ongiA3zqaTMaMnJnsf6jPoWl5ljt
        Olf/3NQ7ZrtBmDoGzz32Kg==;
X-AuditID: 0a2aa12f-365c070000001bf1-57-6160a545c618
Received: from srv-exch-01.skoda.cz (srv-exch-01.skoda.cz [10.42.11.91])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by smtp12.skoda.cz (Mail Gateway) with SMTP id 42.F0.07153.545A0616; Fri,  8 Oct 2021 22:08:37 +0200 (CEST)
Received: from srv-exch-04.skoda.cz (10.42.11.94) by srv-exch-01.skoda.cz
 (10.42.11.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7; Fri, 8 Oct 2021
 22:08:36 +0200
Received: from srv-exch-04.skoda.cz ([fe80::fcf6:f37d:8437:b10d]) by
 srv-exch-04.skoda.cz ([fe80::fcf6:f37d:8437:b10d%2]) with mapi id
 15.01.2375.007; Fri, 8 Oct 2021 22:08:36 +0200
From:   Strejc Cyril <cyril.strejc@skoda.cz>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: PROBLEM: multicast router does not fill UDP csum of its own forwarded
 packets
Thread-Topic: PROBLEM: multicast router does not fill UDP csum of its own
 forwarded packets
Thread-Index: AQHXvH3UafZJxk5N4EOL3naqFoMQCg==
Date:   Fri, 8 Oct 2021 20:08:36 +0000
Message-ID: <3fc5b9be1d73417a99756404c0089814@skoda.cz>
Accept-Language: cs-CZ, en-US
Content-Language: cs-CZ
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.42.12.26]
Content-Type: multipart/mixed;
        boundary="_002_3fc5b9be1d73417a99756404c0089814skodacz_"
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsXCpcUdreu6NCHRYPJ2YYs551tYLC5s62O1
        OLZAzIHZY8vKm0wem1Z1snl83iQXwBzFZZOSmpNZllqkb5fAlbH5ziXmguNaFXffrmdrYNyn
        2sXIySEhYCKxa0k3cxcjF4eQwBImiRk3zrBAOM8YJWZMmwuV2ckosXbOR2aQFjYBLYlFW9ay
        gdgiAr4SnW/msIDYzAKmEs9OvwWyOTiEBSIkbv3SgSiJlVhz8jkrhK0n8fPnKVaQEhYBFYlb
        f9xBwrwC5hKt07YygdiMArISezo/M0JMFJd49/wLE8ShIhIPL55mg7BFJV4+/scKYctLfNqw
        gRmiPlLiW8MhJoiZghInZz5hmcAoPAvJqFlIymYhKYOI60k8OzULytaWWLbwNfMsoEuZBVIk
        HjSkQIRDJP7uaoIac49R4vhSDQhbUWJK90P2BYycqxj5i3NLCgyN9Iqz81MS9ZKrNjGCI26h
        /g7GfUvTDzEycTAeYlQB6nm0YfUFRimWvPy8VCUR3nz72EQh3pTEyqrUovz4otKc1OJDjNIc
        LErivDe/GyYKCaQnlqRmp6YWpBbBZJk4OKUaGJd8j2qZmTZNtcV4keq8pQxxBX+vtrz5OP3t
        B/Un7++vqp2xhbGzalf1JLe2Eyt3TClY4n6z2m7OuWMx2ydNZ78dG9KvuUNl8szY3Vl3zbam
        eBXVH150vvT0m9nxOlm1s7bcXCVaH8/7KqJbm+2P7II4m1MC70JXbHhu6mV6rTYwi+njUUvB
        vceUWIozEg21mIuKEwHUwhpHsgIAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_3fc5b9be1d73417a99756404c0089814skodacz_
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable

Hi,

please let me summarize a problem regarding Linux multicast routing in comb=
ination with L4 checksum offloading and own (locally produced) multicast pa=
ckets being forwarded.

* Application observation *

Multicast router does not fill-in UDP checksum into locally produced, loope=
d-back and forwarded UDP datagrams, if an original output NIC the datagrams=
 are sent to has UDP TX checksum offload enabled.

* Full description / User story *

I run an application which uses Linux multicast routing capabilities to sen=
d equal multicast UDP datagrams to multiple networks. The application sets =
IP_MULTICAST_IF  and sends each datagram by a single write to a single sock=
et. Properly configured Linux multicast routing in combination with a multi=
cast loop-back ensures the datagrams are forwarded to other network interfa=
ces.

If the outgoing IP_MULTICAST_IF interface has UDP TX checksum offload enabl=
ed, the csum is not calculated and is not filled into skb data by kernel. T=
he NIC with TX csum offload calculates and fills csum during transmission, =
but does not modify skb data in RAM (at least both NICs I have tested).

Then, packet is looped back in ip_mc_finish_output() and dev_loopback_xmit(=
), where skb->ip_summed is set to CHECKSUM_UNNECESSARY. Since then, packet =
traverse the network stack with wrong (not filled in) L4 checksum, is forwa=
rded to multicast routing output interfaces with CHECKSUM_UNNECESSARY and h=
ence not correctly updated.

* Kernel info *

Tested: 5.4, 5.15-rc3
I do not know, when the problem was introduced, probably long time ago, may=
be in 35fc92a9 ("[NET]: Allow forwarding of ip_summed except CHECKSUM_COMPL=
ETE").

* NIC tested *

I've tested two drivers (NIC) with TX checksum offloading: e1000e in vanill=
a kernel and NXP's DPAA with out-of-vanilla-tree open-source drivers.

* Steps to reproduce *

It's possible to use shell, ip, smcroute and socat to reproduce the problem=
. Tested in Linux Mint with smcrouted shell wrapper.

# UCO_IF=3Deth0              # Interface with UDP TX Checksum Offload enabl=
ed.
# DST_IF=3Deth1
# ip addr add 192.168.1.1/24 dev $UCO_IF
# ip addr add 192.168.2.1/24 dev $DST_IF
# smcroute -d
# smcroute -a $UCO_IF 192.168.1.1 239.192.0.1 $DST_IF
# echo "check" | socat - UDP:239.192.0.1:9,ip-multicast-ttl=3D2,ip-multicas=
t-if=3D192.168.1.1

The "check" datagram is sent with wrong UDP csum out of DST_IF. An other co=
mputer or physical wire loopback is needed to capture packet as it leaved t=
he DST_IF.

* Workaround *

I use the attached patch as the workaround, not sure at all if it is correc=
t in all cases.

I would be very pleased if anyone could think about a correct approach to t=
he problem.

Thanks,

Cyril=

--_002_3fc5b9be1d73417a99756404c0089814skodacz_
Content-Type: text/x-patch;
	name="0001-net-multicast-calc-csum-of-looped-back-and-forwarded.patch"
Content-Description: 0001-net-multicast-calc-csum-of-looped-back-and-forwarded.patch
Content-Disposition: attachment;
	filename="0001-net-multicast-calc-csum-of-looped-back-and-forwarded.patch";
	size=1421; creation-date="Fri, 08 Oct 2021 20:04:06 GMT";
	modification-date="Fri, 08 Oct 2021 20:04:06 GMT"
Content-Transfer-Encoding: base64

RnJvbSAyMTdlNjUxNmFhNDA2OWE1NTVhNzU4NDc4MzMzZTQ3NmVhZGNmNDYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDeXJpbCBTdHJlamMgPGN5cmlsLnN0cmVqY0Bza29kYS5jej4K
RGF0ZTogRnJpLCA4IE9jdCAyMDIxIDIxOjMwOjUzICswMjAwClN1YmplY3Q6IFtQQVRDSF0gbmV0
OiBtdWx0aWNhc3Q6IGNhbGMgY3N1bSBvZiBsb29wZWQtYmFjayBhbmQgZm9yd2FyZGVkCiBwYWNr
ZXRzCgpTaWduZWQtb2ZmLWJ5OiBDeXJpbCBTdHJlamMgPGN5cmlsLnN0cmVqY0Bza29kYS5jej4K
LS0tCiBpbmNsdWRlL2xpbnV4L3NrYnVmZi5oIHwgNSArKysrLQogbmV0L2NvcmUvZGV2LmMgICAg
ICAgICB8IDEgLQogMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9za2J1ZmYuaCBiL2luY2x1ZGUvbGludXgv
c2tidWZmLmgKaW5kZXggODQxZTJmMGY1MjQwLi5iYmZhNmIyNTliZjMgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvbGludXgvc2tidWZmLmgKKysrIGIvaW5jbHVkZS9saW51eC9za2J1ZmYuaApAQCAtNDA0
OCw3ICs0MDQ4LDEwIEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBfX3NrYl9jaGVja3N1bV92YWxpZGF0
ZV9uZWVkZWQoc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAkJCQkJCSAgYm9vbCB6ZXJvX29rYXksCiAJ
CQkJCQkgIF9fc3VtMTYgY2hlY2spCiB7Ci0JaWYgKHNrYl9jc3VtX3VubmVjZXNzYXJ5KHNrYikg
fHwgKHplcm9fb2theSAmJiAhY2hlY2spKSB7CisJaWYgKHNrYl9jc3VtX3VubmVjZXNzYXJ5KHNr
YikgfHwKKyAgICAgICh6ZXJvX29rYXkgJiYgIWNoZWNrKSB8fAorICAgICAgKHNrYi0+cGt0X3R5
cGUgPT0gUEFDS0VUX0xPT1BCQUNLKSkKKyAgewogCQlza2ItPmNzdW1fdmFsaWQgPSAxOwogCQlf
X3NrYl9kZWNyX2NoZWNrc3VtX3VubmVjZXNzYXJ5KHNrYik7CiAJCXJldHVybiBmYWxzZTsKZGlm
ZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0L2NvcmUvZGV2LmMKaW5kZXggN2VlOWZlY2Qz
YWZmLi5iYTRhMDk5NGQ5N2IgMTAwNjQ0Ci0tLSBhL25ldC9jb3JlL2Rldi5jCisrKyBiL25ldC9j
b3JlL2Rldi5jCkBAIC0zOTA2LDcgKzM5MDYsNiBAQCBpbnQgZGV2X2xvb3BiYWNrX3htaXQoc3Ry
dWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IpCiAJc2ti
X3Jlc2V0X21hY19oZWFkZXIoc2tiKTsKIAlfX3NrYl9wdWxsKHNrYiwgc2tiX25ldHdvcmtfb2Zm
c2V0KHNrYikpOwogCXNrYi0+cGt0X3R5cGUgPSBQQUNLRVRfTE9PUEJBQ0s7Ci0Jc2tiLT5pcF9z
dW1tZWQgPSBDSEVDS1NVTV9VTk5FQ0VTU0FSWTsKIAlXQVJOX09OKCFza2JfZHN0KHNrYikpOwog
CXNrYl9kc3RfZm9yY2Uoc2tiKTsKIAluZXRpZl9yeF9uaShza2IpOwotLSAKMi4yNS4xCgo=

--_002_3fc5b9be1d73417a99756404c0089814skodacz_--
