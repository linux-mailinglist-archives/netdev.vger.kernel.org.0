Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEF87F2322
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfKGAPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:15:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58202 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfKGAPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 19:15:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2AA2E14FE1C56;
        Wed,  6 Nov 2019 16:15:07 -0800 (PST)
Date:   Wed, 06 Nov 2019 16:15:04 -0800 (PST)
Message-Id: <20191106.161504.1066221896470708005.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/6] net: various KCSAN inspired fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105221154.232754-1-edumazet@google.com>
References: <20191105221154.232754-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 16:15:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  5 Nov 2019 14:11:48 -0800

> This is a series of minor fixes, mostly dealing with
> lockless accesses to socket 'sk_ack_backlog', 'sk_max_ack_backlog'
> ane neighbour 'confirmed' fields.

Series applied, thanks Eric.
