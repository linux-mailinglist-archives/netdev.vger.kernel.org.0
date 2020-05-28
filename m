Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81931E6916
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405738AbgE1SLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405700AbgE1SLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:11:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E57C08C5CB;
        Thu, 28 May 2020 11:11:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20C1A1295A290;
        Thu, 28 May 2020 11:11:10 -0700 (PDT)
Date:   Thu, 28 May 2020 11:11:09 -0700 (PDT)
Message-Id: <20200528.111109.1342245458513992889.davem@davemloft.net>
To:     doshir@vmware.com
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] vmxnet3: upgrade to version 4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528.110746.401143968929865213.davem@davemloft.net>
References: <20200528015426.8285-1-doshir@vmware.com>
        <20200528.110746.401143968929865213.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 11:11:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVGh1LCAyOCBN
YXkgMjAyMCAxMTowNzo0NiAtMDcwMCAoUERUKQ0KDQo+IFNlcmllcyBhcHBsaWVkLCB0aGFuayB5
b3UuDQoNClRoaXMgZG9lc24ndCBldmVuIGNvbXBpbGUgc3VjY2Vzc2Z1bGx5LCByZXZlcnRlZC4u
LiA6KA0KDQpkcml2ZXJzL25ldC92bXhuZXQzL3ZteG5ldDNfZHJ2LmM6IEluIGZ1bmN0aW9uIKF2
bXhuZXQzX3RxX3htaXSiOg0KZHJpdmVycy9uZXQvdm14bmV0My92bXhuZXQzX2Rydi5jOjExNDU6
NTogZXJyb3I6IGV4cGVjdGVkIKF9oiBiZWZvcmUgoWVsc2WiDQogMTE0NSB8ICAgfSBlbHNlIHsN
CiAgICAgIHwgICAgIF5+fn4NCmRyaXZlcnMvbmV0L3ZteG5ldDMvdm14bmV0M19ldGh0b29sLmM6
IEluIGZ1bmN0aW9uIKF2bXhuZXQzX2dldF9yc3NfaGFzaF9vcHRzojoNCmRyaXZlcnMvbmV0L3Zt
eG5ldDMvdm14bmV0M19ldGh0b29sLmM6NzQ0OjY6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1h
eSBmYWxsIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQ0KICA3NDQgfCAgIGlmIChy
c3NfZmllbGRzICYgVk1YTkVUM19SU1NfRklFTERTX0VTUElQNCkNCiAgICAgIHwgICAgICBeDQpk
cml2ZXJzL25ldC92bXhuZXQzL3ZteG5ldDNfZXRodG9vbC5jOjc0NjoyOiBub3RlOiBoZXJlDQog
IDc0NiB8ICBjYXNlIFNDVFBfVjRfRkxPVzoNCiAgICAgIHwgIF5+fn4NCm1ha2VbM106ICoqKiBb
c2NyaXB0cy9NYWtlZmlsZS5idWlsZDoyNjc6IGRyaXZlcnMvbmV0L3ZteG5ldDMvdm14bmV0M19k
cnYub10gRXJyb3IgMQ0KbWFrZVszXTogKioqIFdhaXRpbmcgZm9yIHVuZmluaXNoZWQgam9icy4u
Li4NCm1ha2VbMl06ICoqKiBbc2NyaXB0cy9NYWtlZmlsZS5idWlsZDo0ODg6IGRyaXZlcnMvbmV0
L3ZteG5ldDNdIEVycm9yIDINCm1ha2VbMV06ICoqKiBbc2NyaXB0cy9NYWtlZmlsZS5idWlsZDo0
ODg6IGRyaXZlcnMvbmV0XSBFcnJvciAyDQptYWtlWzFdOiAqKiogV2FpdGluZyBmb3IgdW5maW5p
c2hlZCBqb2JzLi4uLg0KbWFrZTogKioqIFtNYWtlZmlsZToxNzI5OiBkcml2ZXJzXSBFcnJvciAy
DQo=
