Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC804020CC
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 22:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243527AbhIFUxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 16:53:10 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57668 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhIFUxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 16:53:09 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 186KpskO037276;
        Mon, 6 Sep 2021 15:51:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1630961514;
        bh=CaGvOIn5BfLBICoO2Syfm1nTIE98ALRNKcUG8DqS28Y=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=FCLoq88EgFSlhRVh3RrfZgE8gCcERYu9svnRT/G+dmXvrfpWXaKYL/XgODlo975dv
         ZDQFmrWjErP2pEkAzdntUSTJhD4r2L7GvNPKawi9zYZe8p+BAakc4uOnhDpSIAMb1z
         LMGv4p94MbCTtt2q1IJ6wjc20k7sKL349HV2dZXM=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 186KpsmK046914
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Sep 2021 15:51:54 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 6
 Sep 2021 15:51:54 -0500
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.2308.014; Mon, 6 Sep 2021 15:51:54 -0500
From:   "Modi, Geet" <geet.modi@ti.com>
To:     Andrew Lunn <andrew@lunn.ch>, "Nagalla, Hari" <hnagalla@ti.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sharma, Vikram" <vikram.sharma@ti.com>
Subject: Re: [EXTERNAL] Re: [PATCH] net: phy: dp83tc811: modify list of
 interrupts enabled at initialization
Thread-Topic: [EXTERNAL] Re: [PATCH] net: phy: dp83tc811: modify list of
 interrupts enabled at initialization
Thread-Index: AQHXoC4XSSkBWxKBYUuzA52mb5z+zauRtoAAgAWhA4A=
Date:   Mon, 6 Sep 2021 20:51:53 +0000
Message-ID: <99232B33-1C2F-45AF-A259-0868AC7D3FBC@ti.com>
References: <20210902190944.4963-1-hnagalla@ti.com> <YTFc6pyEtlRO/4r/@lunn.ch>
In-Reply-To: <YTFc6pyEtlRO/4r/@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.52.21080801
x-originating-ip: [10.250.200.196]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="utf-8"
Content-ID: <8EAD9598455E4F41B2E9AFE87D9E830F@owa.mail.ti.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpUaGlzIGZlYXR1cmUgaXMgbm90IHVzZWQgYnkgb3VyIG1haW5zdHJlYW0g
Y3VzdG9tZXJzIGFzIHRoZXkgaGF2ZSBhZGRpdGlvbmFsIG1lY2hhbmlzbSB0byBtb25pdG9yIHRo
ZSBzdXBwbHkgYXQgU3lzdGVtIGxldmVsLiANCg0KSGVuY2Ugd2FudCB0byBrZWVwIGl0IGRpc2Fi
bGUgYnkgZGVmYXVsdC4NCg0KUmVnYXJkcywNCkdlZXQNCg0KDQrvu79PbiA5LzIvMjEsIDQ6MjMg
UE0sICJBbmRyZXcgTHVubiIgPGFuZHJld0BsdW5uLmNoPiB3cm90ZToNCg0KICAgIE9uIFRodSwg
U2VwIDAyLCAyMDIxIGF0IDAyOjA5OjQ0UE0gLTA1MDAsIGhuYWdhbGxhQHRpLmNvbSB3cm90ZToN
CiAgICA+IEZyb206IEhhcmkgTmFnYWxsYSA8aG5hZ2FsbGFAdGkuY29tPg0KICAgID4gDQogICAg
PiBEaXNhYmxlIHRoZSBvdmVyIHZvbHRhZ2UgaW50ZXJydXB0IGF0IGluaXRpYWxpemF0aW9uIHRv
IG1lZXQgdHlwaWNhbA0KICAgID4gYXBwbGljYXRpb24gcmVxdWlyZW1lbnQuDQoNCiAgICBBcmUg
eW91IHNheWluZyBpdCBpcyB0eXBpY2FsIHRvIHN1cHBseSB0b28gaGlnaCBhIHZvbHRhZ2U/DQoN
CiAgICAgICAgQW5kcmV3DQoNCg==
