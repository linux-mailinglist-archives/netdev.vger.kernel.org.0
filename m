Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26DD8823C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407192AbfHISUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:20:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfHISUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:20:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 941C5154316F1;
        Fri,  9 Aug 2019 11:20:54 -0700 (PDT)
Date:   Fri, 09 Aug 2019 11:20:54 -0700 (PDT)
Message-Id: <20190809.112054.1126098316584513793.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 00/17] Networking driver debugfs cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809123108.27065-1-gregkh@linuxfoundation.org>
References: <20190809123108.27065-1-gregkh@linuxfoundation.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 11:20:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCkRh
dGU6IEZyaSwgIDkgQXVnIDIwMTkgMTQ6MzA6NTEgKzAyMDANCg0KPiB2MjogZml4IHVwIGJ1aWxk
IHdhcm5pbmdzLCBpdCdzIGFzIGlmIEkgbmV2ZXIgZXZlbiBidWlsdCB0aGVzZS4gIFVnaCwgc28N
Cj4gICAgIHNvcnJ5IGZvciB3YXN0aW5nIHBlb3BsZSdzIHRpbWUgd2l0aCB0aGUgdjEgc2VyaWVz
LiAgSSBuZWVkIHRvIHN0b3ANCj4gICAgIHJlbHlpbmcgb24gMC1kYXkgYXMgaXQgaXNuJ3Qgd29y
a2luZyB3ZWxsIGFueW1vcmUgOigNCg0KT25lIG1vcmUgdHJ5IEdyZWc6DQoNCmRyaXZlcnMvbmV0
L3dpbWF4L2kyNDAwbS9kZWJ1Z2ZzLmM6IEluIGZ1bmN0aW9uIKFpMjQwMG1fZGVidWdmc19hZGSi
Og0KZHJpdmVycy9uZXQvd2ltYXgvaTI0MDBtL2RlYnVnZnMuYzoxOTI6MTc6IHdhcm5pbmc6IHVu
dXNlZCB2YXJpYWJsZSChZGV2oiBbLVd1bnVzZWQtdmFyaWFibGVdDQogIHN0cnVjdCBkZXZpY2Ug
KmRldiA9IGkyNDAwbV9kZXYoaTI0MDBtKTsNCiAgICAgICAgICAgICAgICAgXn5+DQo=
