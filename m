Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8E490925
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 22:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfHPUES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 16:04:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38968 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfHPUES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 16:04:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C46FC13E99252;
        Fri, 16 Aug 2019 13:04:17 -0700 (PDT)
Date:   Fri, 16 Aug 2019 13:04:17 -0700 (PDT)
Message-Id: <20190816.130417.1610388599335442981.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/4] net: bridge: mdb: allow dump/add/del
 of host-joined entries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814170501.1808-1-nikolay@cumulusnetworks.com>
References: <81258876-5f03-002c-5aa8-2d6d00e6d99e@cumulusnetworks.com>
        <20190814170501.1808-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 Aug 2019 13:04:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTmlrb2xheSBBbGVrc2FuZHJvdiA8bmlrb2xheUBjdW11bHVzbmV0d29ya3MuY29tPg0K
RGF0ZTogV2VkLCAxNCBBdWcgMjAxOSAyMDowNDo1NyArMDMwMA0KDQo+IFRoaXMgc2V0IG1ha2Vz
IHRoZSBicmlkZ2UgZHVtcCBob3N0LWpvaW5lZCBtZGIgZW50cmllcywgdGhleSBzaG91bGQgYmUN
Cj4gdHJlYXRlZCBhcyBub3JtYWwgZW50cmllcyBzaW5jZSB0aGV5IHRha2UgYSBzbG90IGFuZCBh
cmUgYWdpbmcgb3V0Lg0KIC4uLg0KDQpQbGVhc2UgcmVzcGluIHdpdGggdGhpcyB3YXJuaW5nIGZp
eGVkOg0KDQpuZXQvYnJpZGdlL2JyX21kYi5jOiBJbiBmdW5jdGlvbiChYnJfbWRiX2FkZKI6DQpu
ZXQvYnJpZGdlL2JyX21kYi5jOjcyNTo0OiB3YXJuaW5nOiChcKIgbWF5IGJlIHVzZWQgdW5pbml0
aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uIFstV21heWJlLXVuaW5pdGlhbGl6ZWRdDQogICAgX19i
cl9tZGJfbm90aWZ5KGRldiwgcCwgZW50cnksIFJUTV9ORVdNREIpOw0KICAgIF5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KDQpbZGF2ZW1AbG9jYWxob3N0IG5ldC1u
ZXh0XSQgZ2NjIC0tdmVyc2lvbg0KZ2NjIChHQ0MpIDguMy4xIDIwMTkwMjIzIChSZWQgSGF0IDgu
My4xLTIpDQpDb3B5cmlnaHQgKEMpIDIwMTggRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLCBJbmMu
DQpUaGlzIGlzIGZyZWUgc29mdHdhcmU7IHNlZSB0aGUgc291cmNlIGZvciBjb3B5aW5nIGNvbmRp
dGlvbnMuICBUaGVyZSBpcyBOTw0Kd2FycmFudHk7IG5vdCBldmVuIGZvciBNRVJDSEFOVEFCSUxJ
VFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuDQo=
