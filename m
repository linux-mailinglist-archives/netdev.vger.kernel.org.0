Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DCB248ECC
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgHRTfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgHRTfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:35:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DCEC061389;
        Tue, 18 Aug 2020 12:35:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DEE0C1279E923;
        Tue, 18 Aug 2020 12:19:04 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:35:50 -0700 (PDT)
Message-Id: <20200818.123550.1614770957816770142.davem@davemloft.net>
To:     vulab@iscas.ac.cn
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rpl_iptunnel: simplify the return expression of
 rpl_do_srh()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818085454.12224-1-vulab@iscas.ac.cn>
References: <20200818085454.12224-1-vulab@iscas.ac.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 12:19:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWHUgV2FuZyA8dnVsYWJAaXNjYXMuYWMuY24+DQpEYXRlOiBUdWUsIDE4IEF1ZyAyMDIw
IDA4OjU0OjU0ICswMDAwDQoNCj4gQEAgLTE5NywxMSArMTk3LDcgQEAgc3RhdGljIGludCBycGxf
ZG9fc3JoKHN0cnVjdCBza19idWZmICpza2IsIGNvbnN0IHN0cnVjdCBycGxfbHd0ICpybHd0KQ0K
PiAgDQo+ICAJdGluZm8gPSBycGxfZW5jYXBfbHd0dW5uZWwoZHN0LT5sd3RzdGF0ZSk7DQo+ICAN
Cj4gLQllcnIgPSBycGxfZG9fc3JoX2lubGluZShza2IsIHJsd3QsIHRpbmZvLT5zcmgpOw0KPiAt
CWlmIChlcnIpDQo+IC0JCXJldHVybiBlcnI7DQo+IC0NCj4gLQlyZXR1cm4gMDsNCj4gKwlyZXR1
cm4gcnBsX2RvX3NyaF9pbmxpbmUoc2tiLCBybHd0LCB0aW5mby0+c3JoKTsNCj4gIH0NCg0KUGxl
YXNlIGF0IGxlYXN0IGNvbXBpbGUgdGVzdCB5b3VyIGNoYW5nZXM6DQoNCm5ldC9pcHY2L3JwbF9p
cHR1bm5lbC5jOiBJbiBmdW5jdGlvbiChcnBsX2RvX3NyaKI6DQpuZXQvaXB2Ni9ycGxfaXB0dW5u
ZWwuYzoxOTM6Njogd2FybmluZzogdW51c2VkIHZhcmlhYmxlIKFlcnKiIFstV3VudXNlZC12YXJp
YWJsZV0NCiAgMTkzIHwgIGludCBlcnIgPSAwOw0K
