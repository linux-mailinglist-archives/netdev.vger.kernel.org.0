Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020F2217B14
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgGGWjG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jul 2020 18:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGWjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:39:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DA4C061755;
        Tue,  7 Jul 2020 15:39:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3BD85120ED48D;
        Tue,  7 Jul 2020 15:39:05 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:39:04 -0700 (PDT)
Message-Id: <20200707.153904.491848475455000428.davem@davemloft.net>
To:     linus.luessing@c0d3.blue
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, martin@linuxlounge.net,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] bridge: mcast: Fix MLD2 Report IPv6 payload
 length check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200705191017.10546-1-linus.luessing@c0d3.blue>
References: <20200705191017.10546-1-linus.luessing@c0d3.blue>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:39:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>
Date: Sun,  5 Jul 2020 21:10:17 +0200

> Commit e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in
> igmp3/mld2 report handling") introduced a bug in the IPv6 header payload
> length check which would potentially lead to rejecting a valid MLD2 Report:
> 
> The check needs to take into account the 2 bytes for the "Number of
> Sources" field in the "Multicast Address Record" before reading it.
> And not the size of a pointer to this field.
> 
> Fixes: e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling")
> Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>

Applied and queued up for -stable, thank you.
