Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3223D109594
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfKYWll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:41:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfKYWll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:41:41 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 323F915070768;
        Mon, 25 Nov 2019 14:41:40 -0800 (PST)
Date:   Mon, 25 Nov 2019 14:41:39 -0800 (PST)
Message-Id: <20191125.144139.1331751213975518867.davem@davemloft.net>
To:     oliver.peter.herms@gmail.com
Cc:     yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: ip/tnl: Set iph->id only when don't fragment
 is not set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191124132418.GA13864@fuckup>
References: <20191124132418.GA13864@fuckup>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 14:41:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Herms <oliver.peter.herms@gmail.com>
Date: Sun, 24 Nov 2019 14:24:18 +0100

> From RFC 6864 "Updated Specification of the IPv4 ID Field" section 4.1:

Just reading the abstract of this RFC I cannot take it seriously:

	This document updates the specification of the IPv4 ID field
	in RFCs 791, 1122, and 2003 to more closely reflect current
	practice...

"more closely reflect current practice" ?!?!

That statement is a joke right?

Linux generates the bulk of the traffic on the internet and we've had
the current behavior of the ID field for decades.

Therefore, I don't think even the premise of this document is valid.

These are all red flags to me, and I think we should keep the current
behavior.

I'm not applying your patch, sorry.
