Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C112241BC
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGQRZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGQRZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:25:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F43C0619D2;
        Fri, 17 Jul 2020 10:25:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 05CF3135A8FC4;
        Fri, 17 Jul 2020 10:25:37 -0700 (PDT)
Date:   Fri, 17 Jul 2020 10:25:37 -0700 (PDT)
Message-Id: <20200717.102537.1536007719047673454.davem@davemloft.net>
To:     min.li.xe@renesas.com
Cc:     richardcochran@gmail.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH net 1/1] docs: ptp.rst: add support for Renesas (IDT)
 ClockMatrix
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594746920-28760-1-git-send-email-min.li.xe@renesas.com>
References: <1594746920-28760-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 10:25:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogPG1pbi5saS54ZUByZW5lc2FzLmNvbT4NCkRhdGU6IFR1ZSwgMTQgSnVsIDIwMjAgMTM6
MTU6MjAgLTA0MDANCg0KPiBGcm9tOiBNaW4gTGkgPG1pbi5saS54ZUByZW5lc2FzLmNvbT4NCj4g
DQo+IEFkZCBiZWxvdyB0byDigJxBbmNpbGxhcnkgY2xvY2sgZmVhdHVyZXPigJ0gc2VjdGlvbg0K
PiAgIC0gTG93IFBhc3MgRmlsdGVyIChMUEYpIGFjY2VzcyBmcm9tIHVzZXIgc3BhY2UNCj4gDQo+
IEFkZCBiZWxvdyB0byBsaXN0IG9mIOKAnFN1cHBvcnRlZCBoYXJkd2FyZeKAnSBzZWN0aW9uDQo+
ICAgKyBSZW5lc2FzIChJRFQpIENsb2NrTWF0cml44oSiDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBN
aW4gTGkgPG1pbi5saS54ZUByZW5lc2FzLmNvbT4NCg0KQXBwbGllZCwgdGhhbmsgeW91Lg0K
