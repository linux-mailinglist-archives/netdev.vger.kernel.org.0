Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED0C1287A3
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfLUFm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:42:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56992 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:42:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6C55153D865A;
        Fri, 20 Dec 2019 21:42:26 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:42:26 -0800 (PST)
Message-Id: <20191220.214226.433431092772993348.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        ndagan@amazon.com, shayagr@amazon.com, sameehj@amazon.com
Subject: Re: [PATCH V2 net 0/2] fixes of interrupt moderation bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576770056-1304-1-git-send-email-akiyano@amazon.com>
References: <1576770056-1304-1-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:42:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Thu, 19 Dec 2019 17:40:54 +0200

> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> 
> Differences from V1:
> 1. Updated default tx interrupt moderation to 64us
> 2. Added "Fixes:" tags.
> 3. Removed cosmetic changes that are not relevant for these bug fixes
> 
> This patchset includes a couple of fixes of bugs in the implemenation of
> interrupt moderation.

I'll apply this series, but... why do you put empty lines between the Fixes
and other tags?  Please don't do that.

When people do stuff like this I have to ask, where did you see someone else
do this?  Where did you pick up this convention?

Thank you.
