Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1966010A5A4
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 21:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfKZUv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 15:51:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfKZUv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 15:51:59 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CEB5114CDFE14;
        Tue, 26 Nov 2019 12:51:58 -0800 (PST)
Date:   Tue, 26 Nov 2019 12:51:56 -0800 (PST)
Message-Id: <20191126.125156.2138813710312929109.davem@davemloft.net>
To:     oliver.peter.herms@gmail.com
Cc:     yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: ip/tnl: Set iph->id only when don't fragment
 is not set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4e964168-2c83-24bb-8e44-f5f47555e589@gmail.com>
References: <20191124132418.GA13864@fuckup>
        <20191125.144139.1331751213975518867.davem@davemloft.net>
        <4e964168-2c83-24bb-8e44-f5f47555e589@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 12:51:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Herms <oliver.peter.herms@gmail.com>
Date: Tue, 26 Nov 2019 20:10:52 +0100

> Would you be willing to merge a patch that offers this?

No.

There is lots of precendence for incrementing the ID, look
at SLIP compression:

	deltaS = ntohs(ip->id) - ntohs(cs->cs_ip.id);
	if(deltaS != 1){
		cp = encode(cp,deltaS);
		changes |= NEW_I;
	}

That's just one example, it won't compress unless the ID
field is (unconditionally) incrementing.

The RFC being discussed here is poorly constructed and is founded on a
false basis of reality.  It's the usual tone deaf IETF stuff... and
Linux will not participate.

Thanks.
