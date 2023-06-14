Return-Path: <netdev+bounces-10673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 197E072FBB3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78ED22812C5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D0163C7;
	Wed, 14 Jun 2023 10:52:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569B8138C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:52:13 +0000 (UTC)
X-Greylist: delayed 10286 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Jun 2023 03:52:10 PDT
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 178EBE41
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:52:09 -0700 (PDT)
Received: from linma$zju.edu.cn ( [42.120.103.51] ) by
 ajax-webmail-mail-app2 (Coremail) ; Wed, 14 Jun 2023 18:51:55 +0800
 (GMT+08:00)
X-Originating-IP: [42.120.103.51]
Date: Wed, 14 Jun 2023 18:51:55 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Lin Ma" <linma@zju.edu.cn>
To: "Tung Quang Nguyen" <tung.q.nguyen@dektech.com.au>
Cc: "davem@davemloft.net" <davem@davemloft.net>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>
Subject: RE: [PATCH v1] tipc: resize nlattr array to correct size
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20220622(41e5976f)
 Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4df6dc2c-e274-4d1c-b502-72c5c3dfa9ce-zj.edu.cn
In-Reply-To: <DB9PR05MB90781C45A3592E3962F6F3D8885AA@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230614080013.1112884-1-linma@zju.edu.cn>
 <DB9PR05MB90781C45A3592E3962F6F3D8885AA@DB9PR05MB9078.eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <6bce9e01.84f02.188b9889498.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:by_KCgDXV3zMm4lkRnTDBg--.3386W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwQGEmSIheIHhQAMsW
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAKPiBXaGljaCBicmFuY2ggKG5ldCBvciBuZXQtbmV4dCkgZG8geW91IHdhbnQgdG8gYXBwbHkg
dGhpcyBjaGFuZ2UgdG8gPwo+IAoKSSBkb24ndCByZWFsbHkga25vdyB0aGUgZGlmZmVyZW5jZSA6
RAoKU2luY2UgdGhpcyBhIG5vdCBhbnkgbmV3IGZlYXR1cmUgcGF0Y2ggYnV0IGp1c3Qgc29sdmlu
ZyBhIHR5cG8gbGlrZSBidWcuIEkgZ3Vlc3MKaXQgY2FuIGdvIHRvIChuZXQpIGJyYW5jaCBpbnN0
ZWFkIHRoZSAobmV0LW5leHQpID8KClJlZ2FyZHMKTGluCgoKPiA+IG5ldC90aXBjL2JlYXJlci5j
IHwgNCArKy0tCj4gPiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQo+ID4KPiA+ZGlmZiAtLWdpdCBhL25ldC90aXBjL2JlYXJlci5jIGIvbmV0L3RpcGMvYmVh
cmVyLmMKPiA+aW5kZXggNTM4ODE0MDZlMjAwLi5jZGNkMjczMTg2MGIgMTAwNjQ0Cj4gPi0tLSBh
L25ldC90aXBjL2JlYXJlci5jCj4gPisrKyBiL25ldC90aXBjL2JlYXJlci5jCj4gPkBAIC0xMjU4
LDcgKzEyNTgsNyBAQCBpbnQgdGlwY19ubF9tZWRpYV9nZXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwg
c3RydWN0IGdlbmxfaW5mbyAqaW5mbykKPiA+IAlzdHJ1Y3QgdGlwY19ubF9tc2cgbXNnOwo+ID4g
CXN0cnVjdCB0aXBjX21lZGlhICptZWRpYTsKPiA+IAlzdHJ1Y3Qgc2tfYnVmZiAqcmVwOwo+ID4t
CXN0cnVjdCBubGF0dHIgKmF0dHJzW1RJUENfTkxBX0JFQVJFUl9NQVggKyAxXTsKPiA+KwlzdHJ1
Y3QgbmxhdHRyICphdHRyc1tUSVBDX05MQV9NRURJQV9NQVggKyAxXTsKPiA+Cj4gPiAJaWYgKCFp
bmZvLT5hdHRyc1tUSVBDX05MQV9NRURJQV0pCj4gPiAJCXJldHVybiAtRUlOVkFMOwo+ID5AQCAt
MTMwNyw3ICsxMzA3LDcgQEAgaW50IF9fdGlwY19ubF9tZWRpYV9zZXQoc3RydWN0IHNrX2J1ZmYg
KnNrYiwgc3RydWN0IGdlbmxfaW5mbyAqaW5mbykKPiA+IAlpbnQgZXJyOwo+ID4gCWNoYXIgKm5h
bWU7Cj4gPiAJc3RydWN0IHRpcGNfbWVkaWEgKm07Cj4gPi0Jc3RydWN0IG5sYXR0ciAqYXR0cnNb
VElQQ19OTEFfQkVBUkVSX01BWCArIDFdOwo+ID4rCXN0cnVjdCBubGF0dHIgKmF0dHJzW1RJUENf
TkxBX01FRElBX01BWCArIDFdOwo+ID4KPiA+IAlpZiAoIWluZm8tPmF0dHJzW1RJUENfTkxBX01F
RElBXSkKPiA+IAkJcmV0dXJuIC1FSU5WQUw7Cj4gPi0tCj4gPjIuMTcuMQo+ID4K

