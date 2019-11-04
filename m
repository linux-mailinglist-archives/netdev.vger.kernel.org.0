Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31BC6EE865
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbfKDTbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:31:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfKDTbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:31:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 108EC151D4FBA;
        Mon,  4 Nov 2019 11:31:32 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:31:31 -0800 (PST)
Message-Id: <20191104.113131.1498438752773891509.davem@davemloft.net>
To:     christophe.roullier@st.com
Cc:     robh@kernel.org, joabreu@synopsys.com, mark.rutland@arm.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH V2 1/1] net: ethernet: stmmac: drop unused variable in
 stm32mp1_set_mode()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104105100.4288-1-christophe.roullier@st.com>
References: <20191104105100.4288-1-christophe.roullier@st.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:31:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXN0b3BoZSBSb3VsbGllciA8Y2hyaXN0b3BoZS5yb3VsbGllckBzdC5jb20+DQpE
YXRlOiBNb24sIDQgTm92IDIwMTkgMTE6NTE6MDAgKzAxMDANCg0KPiBCdWlsZGluZyB3aXRoIFc9
MSAoY2Yuc2NyaXB0cy9NYWtlZmlsZS5leHRyYXdhcm4pIG91dHB1dHM6DQo+IHdhcm5pbmc6IHZh
cmlhYmxlIKFyZXSiIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVd
DQo+IA0KPiBEcm9wIHRoZSB1bnVzZWQgJ3JldCcgdmFyaWFibGUuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBDaHJpc3RvcGhlIFJvdWxsaWVyIDxjaHJpc3RvcGhlLnJvdWxsaWVyQHN0LmNvbT4NCg0K
QXBwbGllZCB0byBuZXQtbmV4dC4NCg==
