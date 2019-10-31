Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725D8EBA1B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfJaW66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:58:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33870 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbfJaW66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 18:58:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70A7A15005EFB;
        Thu, 31 Oct 2019 15:58:57 -0700 (PDT)
Date:   Thu, 31 Oct 2019 15:58:54 -0700 (PDT)
Message-Id: <20191031.155854.590623922622551708.davem@davemloft.net>
To:     lariel@mellanox.com
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com, sd@queasysnail.net,
        sbrivio@redhat.com, nikolay@cumulusnetworks.com, jiri@mellanox.com,
        dsahern@gmail.com, stephen@networkplumber.org
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <74DE7158-E844-4CCD-9827-D0A5C59F8B32@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
        <20191031.133102.2235634960268789909.davem@davemloft.net>
        <74DE7158-E844-4CCD-9827-D0A5C59F8B32@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 15:58:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQXJpZWwgTGV2a292aWNoIDxsYXJpZWxAbWVsbGFub3guY29tPg0KRGF0ZTogVGh1LCAz
MSBPY3QgMjAxOSAyMjoyMDo1NSArMDAwMA0KDQo+IA0KPiANCj4g77u/T24gMTAvMzEvMTksIDQ6
MzEgUE0sICJEYXZpZCBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0PiB3cm90ZToNCj4gDQo+
ICAgICANCj4+ICAgIFRoZSBwcmV2aW91cyBwb3N0ZWQgdmVyc2lvbiB3YXMgYWxzbyB2Miwgd2hh
dCBhcmUgeW91IGRvaW5nPw0KPiANCj4gSSByZXN0YXJ0ZWQgdGhpcyBzZXJpZXMgc2luY2UgbXkg
Zmlyc3Qgc3VibWlzc2lvbiBoYWQgYSBtaXN0YWtlIGluIHRoZSBzdWJqZWN0IHByZWZpeC4NCj4g
VGhpcyBpcyB0aGUgMm5kIHZlcnNpb24gb2YgdGhhdCBuZXcgc3VibWlzc2lvbiB3aGlsZSBwcmV2
aW91cyBoYXMgYSBkaWZmZXJlbnQgc3ViamVjdA0KPiBhbmQgY2FuIGJlIGlnbm9yZWQuICANCg0K
QWx3YXlzIGluY3JlbWVudCB0aGUgdmVyc2lvbiBudW1iZXIgd2hlbiB5b3UgcG9zdCBhIHBhdGNo
IHNlcmllcyBhbmV3Lg0KDQpPdGhlcndpc2UgaXQgaXMgYW1iaWd1b3VzIHRvIG1lIHdoaWNoIG9u
ZSBpcyB0aGUgbGF0ZXN0Lg0K
