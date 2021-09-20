Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F61941146F
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbhITMbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:31:07 -0400
Received: from out0.migadu.com ([94.23.1.103]:45269 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233543AbhITMbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:31:07 -0400
Date:   Mon, 20 Sep 2021 20:29:36 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1632140979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=uBCmRcisKlSt3ObWK4WdMRxTcoeLbQdbL7SDIIgNY6M=;
        b=OwMlmbROjAyIKPfHTQCQyaFX3HA+p1Z54nUavMJcA3IhJYvWnbv6fS+tKaCud+oO/qCPKI
        8nlTFUXNeRyQ8N/sZI/Qzy9kkobwhfLYyLQcVOLWus93OkNyLScS4H5Ci/EqVHmwx9iWrQ
        wBb02Fa70vBjCZRsKZfNGur5WMZv0O0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "yajun.deng@linux.dev" <yajun.deng@linux.dev>
To:     "Cong Wang" <xiyou.wangcong@gmail.com>
Cc:     davem <davem@davemloft.net>, kuba <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH net-next] net: net_namespace: Fix undefined member in key_remove_domain()
References: <20210918090410.29772-1-yajun.deng@linux.dev>, 
        <CAM_iQpW8hGBinQKTqKidYfn5sJjAYMUMHyr4U-=dn_CfWVLtMQ@mail.gmail.com>
X-Priority: 3
X-GUID: 10065B5B-7E8A-409D-8144-9D3CBF151A9F
X-Has-Attach: no
MIME-Version: 1.0
Message-ID: <202109202029339411609@linux.dev>
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: base64
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTrCoENvbmcgV2FuZwpEYXRlOsKgMjAyMS0wOS0yMMKgMDc6MjUKVG86wqBZYWp1biBEZW5n
CkNDOsKgRGF2aWQgTWlsbGVyOyBKYWt1YiBLaWNpbnNraTsgTGludXggS2VybmVsIE5ldHdvcmsg
RGV2ZWxvcGVyczsgTEtNTApTdWJqZWN0OsKgUmU6IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBuZXRf
bmFtZXNwYWNlOiBGaXggdW5kZWZpbmVkIG1lbWJlciBpbiBrZXlfcmVtb3ZlX2RvbWFpbigpCk9u
IFNhdCwgU2VwIDE4LCAyMDIxIGF0IDc6MjggQU0gWWFqdW4gRGVuZyA8eWFqdW4uZGVuZ0BsaW51
eC5kZXY+IHdyb3RlOgo+Cj4gVGhlIGtleV9kb21haW4gbWVtYmVyIGluIHN0cnVjdCBuZXQgb25s
eSBleGlzdHMgaWYgd2UgZGVmaW5lIENPTkZJR19LRVlTLgo+IFNvIHdlIHNob3VsZCBhZGQgdGhl
IGRlZmluZSB3aGVuIHdlIHVzZWQga2V5X2RvbWFpbi4KwqAKQnV0IGtleV9yZW1vdmVfZG9tYWlu
KCkgaXMganVzdCBhIG5vcCBpZiAhQ09ORklHX0tFWVM6CsKgCiNlbHNlIC8qIENPTkZJR19LRVlT
ICovCi4uLgojZGVmaW5lIGtleV9yZW1vdmVfZG9tYWluKGQpwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBkbyB7IH0gd2hpbGUoMCkgCgpZZXMsIHlvdSdyZSByaWdodC4KwqAKU28gd2hhdCBleGFjdGx5
IGFyZSB5b3UgZml4aW5nPwrCoApUaGFua3Mu

