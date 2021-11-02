Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F00F442E49
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhKBMlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhKBMlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 08:41:02 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF30C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 05:38:27 -0700 (PDT)
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 0A70E4FB1D94C;
        Tue,  2 Nov 2021 05:38:25 -0700 (PDT)
Date:   Tue, 02 Nov 2021 12:38:19 +0000 (GMT)
Message-Id: <20211102.123819.2234808975786380183.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net-next 0/7] mlx5 updates 2021-11-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211102002914.1052888-1-saeed@kernel.org>
References: <20211102002914.1052888-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 02 Nov 2021 05:38:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpUaGlzIGRvZXNuJ3QgYnVpbGQ6DQoNCmRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl90Yy5jOiBJbiBmdW5jdGlvbiChcGFyc2VfdGNfZmRiX2FjdGlvbnOiOg0KZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmM6NDAwNzoyNTogZXJy
b3I6IKFhY3Rpb26iIHVuZGVjbGFyZWQgKGZpcnN0IHVzZSBpbiB0aGlzIGZ1bmN0aW9uKQ0KIDQw
MDcgfCAgICAgICAgICAgICAgICAgICAgICAgICBhY3Rpb24gfD0gTUxYNV9GTE9XX0NPTlRFWFRf
QUNUSU9OX0ZXRF9ERVNUIHwNCiAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+
DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYzo0MDA3OjI1
OiBub3RlOiBlYWNoIHVuZGVjbGFyZWQgaWRlbnRpZmllciBpcyByZXBvcnRlZCBvbmx5IG9uY2Ug
Zm9yIGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFycyBpbg0KbWFrZVs1XTogKioqIFtzY3JpcHRzL01h
a2VmaWxlLmJ1aWxkOjI3NzogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX3RjLm9dIEVycm9yIDENCm1ha2VbNV06ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpv
YnMuLi4uDQptYWtlWzRdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6NTQwOiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmVdIEVycm9yIDINCm1ha2VbM106ICoqKiBb
c2NyaXB0cy9NYWtlZmlsZS5idWlsZDo1NDA6IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
XSBFcnJvciAyDQptYWtlWzJdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6NTQwOiBkcml2
ZXJzL25ldC9ldGhlcm5ldF0gRXJyb3IgMg0KbWFrZVsxXTogKioqIFtzY3JpcHRzL01ha2VmaWxl
LmJ1aWxkOjU0MDogZHJpdmVycy9uZXRdIEVycm9yIDINCm1ha2U6ICoqKiBbTWFrZWZpbGU6MTg3
MTogZHJpdmVyc10gRXJyb3IgMg0KbWFrZTogKioqIFdhaXRpbmcgZm9yIHVuZmluaXNoZWQgam9i
cy4uLi4NCg==
