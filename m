Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C624A868C0
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbfHHS3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:29:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49486 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfHHS3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:29:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 80D11154FA01C;
        Thu,  8 Aug 2019 11:29:12 -0700 (PDT)
Date:   Thu, 08 Aug 2019 11:29:11 -0700 (PDT)
Message-Id: <20190808.112911.1552825941758779885.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/4] pull request for net-next: batman-adv 2019-08-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808130619.4481-1-sw@simonwunderlich.de>
References: <20190808130619.4481-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 11:29:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Thu,  8 Aug 2019 15:06:15 +0200

> here is a small feature/cleanup pull request of batman-adv to go into net-next.
> 
> Please pull or let me know of any problem!

Pulled, thanks.

That lockdep annotation in the 4th patch really helped with the review.
