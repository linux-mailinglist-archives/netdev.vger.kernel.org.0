Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02DA43689F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfFFALT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:11:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43006 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFFALT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:11:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A410113AEF25D;
        Wed,  5 Jun 2019 17:11:18 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:11:18 -0700 (PDT)
Message-Id: <20190605.171118.681501460677717252.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org, tom@quantonium.net
Subject: Re: [PATCH v2 net-next] ipv6: Send ICMP errors for exceeding
 extension header limits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559576867-4241-1-git-send-email-tom@quantonium.net>
References: <1559576867-4241-1-git-send-email-tom@quantonium.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:11:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Mon,  3 Jun 2019 08:47:47 -0700

> Define constants and add support to send ICMPv6 Parameter Problem
> errors as specified in draft-ietf-6man-icmp-limits-02.

Tom, I've kinda had enough of this pushing your agenda by trying to
add support for ipv6 features that are in draft state with the IETF
and you are the author of said drafts.

I'm not applying this stuff, sorry.
