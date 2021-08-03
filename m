Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD9B3DEBA3
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhHCLSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbhHCLSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 07:18:13 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6FEC061757;
        Tue,  3 Aug 2021 04:18:02 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627989479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LgCqQlSSX2PcnXFJh1Yaw7vD5bKUCJpn+z41x69Wmwg=;
        b=KUSvzizTn2JjWKrhAZYHOhoTmlZA/q9vTlYyNs50v9UnNeGdSiTvVRP5aJkpxua9wTZZKL
        vutGwtvzIu0xHxkGwZQxu8rWsIQezy/bmyeysTtOjDYYC+2npCto3izoKRzU+cwdS3BEw3
        FX8GeJ8Q9UoI6EQXS5ofH3RETq44Wf8=
Date:   Tue, 03 Aug 2021 11:17:59 +0000
Content-Type: multipart/mixed;
 boundary="--=_RainLoop_288_567298312.1627989479"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <7177b79774f6be76431ff4af9fa164f8@linux.dev>
Subject: Fwd: Re: [PATCH] net: convert fib_treeref from int to refcount_t
To:     m.szyprowski@samsung.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <2033809a-1a07-1f5d-7732-f10f6e094f3d@gmail.com>
References: <2033809a-1a07-1f5d-7732-f10f6e094f3d@gmail.com>
 <20210729071350.28919-1-yajun.deng@linux.dev>
 <20210802133727.bml3be3tpjgld45j@skbuf>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


----=_RainLoop_288_567298312.1627989479
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

This patch from David Ahern was applied in the newest net-next.=0A=0A----=
---- Forwarded message -------=0AFrom: "David Ahern" <dsahern@gmail.com>=
=0ATo: "Ioana Ciornei" <ciorneiioana@gmail.com>, "Yajun Deng" <yajun.deng=
@linux.dev>=0ACC: davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ip=
v6.org, dsahern@kernel.org,=0Anetdev@vger.kernel.org, linux-kernel@vger.k=
ernel.org, linux-decnet-user@lists.sourceforge.net=0ASent: August 2, 2021=
 10:36 PM=0ASubject: Re: [PATCH] net: convert fib_treeref from int to ref=
count_t=0AOn 8/2/21 7:37 AM, Ioana Ciornei wrote:=0A=0A> Unfortunately, w=
ith this patch applied I get into the following WARNINGs=0A> when booting=
 over NFS:=0A=0ACan you test the attached?=0A=0AThanks,

----=_RainLoop_288_567298312.1627989479
Content-Type: application/octet-stream;
 name="0001-ipv4-Fix-refcount-warning-for-new-fib_info.patch"
Content-Disposition: attachment;
 filename="0001-ipv4-Fix-refcount-warning-for-new-fib_info.patch"
Content-Transfer-Encoding: base64

RnJvbSBlYzlkMTY5ZWIzM2U2YTY1ZGI2NDE3OTI4MjFjYzZhMjU5ZWQ5MzYyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBrZXJuZWwub3Jn
PgpEYXRlOiBNb24sIDIgQXVnIDIwMjEgMDg6Mjk6MjYgLTA2MDAKU3ViamVjdDogW1BBVENI
IG5ldC1uZXh0XSBpcHY0OiBGaXggcmVmY291bnQgd2FybmluZyBmb3IgbmV3IGZpYl9pbmZv
CgpJb2FuYSByZXBvcnRlZCBhIHJlZmNvdW50IHdhcm5pbmcgd2hlbiBib290aW5nIG92ZXIg
TkZTOgoKWyAgICA1LjA0MjUzMl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0t
LS0tClsgICAgNS4wNDcxODRdIHJlZmNvdW50X3Q6IGFkZGl0aW9uIG9uIDA7IHVzZS1hZnRl
ci1mcmVlLgpbICAgIDUuMDUyMzI0XSBXQVJOSU5HOiBDUFU6IDcgUElEOiAxIGF0IGxpYi9y
ZWZjb3VudC5jOjI1IHJlZmNvdW50X3dhcm5fc2F0dXJhdGUrMHhhNC8weDE1MAouLi4KWyAg
ICA1LjE2NzIwMV0gQ2FsbCB0cmFjZToKWyAgICA1LjE2OTYzNV0gIHJlZmNvdW50X3dhcm5f
c2F0dXJhdGUrMHhhNC8weDE1MApbICAgIDUuMTc0MDY3XSAgZmliX2NyZWF0ZV9pbmZvKzB4
YzAwLzB4YzkwClsgICAgNS4xNzc5ODJdICBmaWJfdGFibGVfaW5zZXJ0KzB4OGMvMHg2MjAK
WyAgICA1LjE4MTg5M10gIGZpYl9tYWdpYy5pc3JhLjArMHgxMTAvMHgxMWMKWyAgICA1LjE4
NTg5MV0gIGZpYl9hZGRfaWZhZGRyKzB4YjgvMHgxOTAKWyAgICA1LjE4OTYyOV0gIGZpYl9p
bmV0YWRkcl9ldmVudCsweDhjLzB4MTQwCgpmaWJfdHJlZXJlZiBuZWVkcyB0byBiZSBzZXQg
YWZ0ZXIga3phbGxvYy4gVGhlIG9sZCBjb2RlIGhhZCBhICsrIHdoaWNoCmxlZCB0byB0aGUg
Y29uZnVzaW9uIHdoZW4gdGhlIGludCB3YXMgcmVwbGFjZWQgYnkgYSByZWZjb3VudF90LgoK
Rml4ZXM6IDc5OTc2ODkyZjdlYSAoIm5ldDogY29udmVydCBmaWJfdHJlZXJlZiBmcm9tIGlu
dCB0byByZWZjb3VudF90IikKU2lnbmVkLW9mZi1ieTogRGF2aWQgQWhlcm4gPGRzYWhlcm5A
a2VybmVsLm9yZz4KUmVwb3J0ZWQtYnk6IElvYW5hIENpb3JuZWkgPGNpb3JuZWlpb2FuYUBn
bWFpbC5jb20+CkNjOiBZYWp1biBEZW5nIDx5YWp1bi5kZW5nQGxpbnV4LmRldj4KLS0tCiBu
ZXQvaXB2NC9maWJfc2VtYW50aWNzLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9maWJfc2Vt
YW50aWNzLmMgYi9uZXQvaXB2NC9maWJfc2VtYW50aWNzLmMKaW5kZXggZmExOWY0Y2RmM2E0
Li5mMjlmZWI3NzcyZGEgMTAwNjQ0Ci0tLSBhL25ldC9pcHY0L2ZpYl9zZW1hbnRpY3MuYwor
KysgYi9uZXQvaXB2NC9maWJfc2VtYW50aWNzLmMKQEAgLTE1NTEsNyArMTU1MSw3IEBAIHN0
cnVjdCBmaWJfaW5mbyAqZmliX2NyZWF0ZV9pbmZvKHN0cnVjdCBmaWJfY29uZmlnICpjZmcs
CiAJCXJldHVybiBvZmk7CiAJfQogCi0JcmVmY291bnRfaW5jKCZmaS0+ZmliX3RyZWVyZWYp
OworCXJlZmNvdW50X3NldCgmZmktPmZpYl90cmVlcmVmLCAxKTsKIAlyZWZjb3VudF9zZXQo
JmZpLT5maWJfY2xudHJlZiwgMSk7CiAJc3Bpbl9sb2NrX2JoKCZmaWJfaW5mb19sb2NrKTsK
IAlobGlzdF9hZGRfaGVhZCgmZmktPmZpYl9oYXNoLAotLSAKMi4yNC4zIChBcHBsZSBHaXQt
MTI4KQoK

----=_RainLoop_288_567298312.1627989479--
