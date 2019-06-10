Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4983BF1B
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389723AbfFJWEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:04:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34904 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389083AbfFJWEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:04:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1439115101561;
        Mon, 10 Jun 2019 15:04:53 -0700 (PDT)
Date:   Mon, 10 Jun 2019 15:04:50 -0700 (PDT)
Message-Id: <20190610.150450.1486548651691855934.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jmaxwell37@gmail.com
Subject: Re: [PATCH net-next] tcp: take care of SYN_RECV sockets in
 tcp_v4_send_ack() and tcp_v6_send_response()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610214543.92576-1-edumazet@google.com>
References: <20190610214543.92576-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 15:04:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPg0KRGF0ZTogTW9uLCAxMCBK
dW4gMjAxOSAxNDo0NTo0MyAtMDcwMA0KDQo+IFVzaW5nIHNrX3RvX2Z1bGxfc2soKSBzaG91bGQg
Z2V0IGJhY2sgdG8gdGhlIGxpc3RlbmVyIHNvY2tldC4NCg0KbmV0L2lwdjYvdGNwX2lwdjYuYzog
SW4gZnVuY3Rpb24goXRjcF92Nl9zZW5kX3Jlc3BvbnNlojoNCm5ldC9pcHY2L3RjcF9pcHY2LmM6
ODg3OjIyOiB3YXJuaW5nOiBwYXNzaW5nIGFyZ3VtZW50IDEgb2YgoXNrX3RvX2Z1bGxfc2uiIGRp
c2NhcmRzIKFjb25zdKIgcXVhbGlmaWVyIGZyb20gcG9pbnRlciB0YXJnZXQgdHlwZSBbLVdkaXNj
YXJkZWQtcXVhbGlmaWVyc10NCg==
