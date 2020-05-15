Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567601D5770
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgEORT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgEORT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:19:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD652C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 10:19:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6095E14C68344;
        Fri, 15 May 2020 10:19:28 -0700 (PDT)
Date:   Fri, 15 May 2020 10:19:27 -0700 (PDT)
Message-Id: <20200515.101927.562090553428345383.davem@davemloft.net>
To:     tobias@waldekranz.com
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next] net: core: recursively find netdev by device
 node
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515095252.8501-1-tobias@waldekranz.com>
References: <20200515095252.8501-1-tobias@waldekranz.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:19:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>
Date: Fri, 15 May 2020 11:52:52 +0200

> The assumption that a device node is associated either with the
> netdev's device, or the parent of that device, does not hold for all
> drivers. E.g. Freescale's DPAA has two layers of platform devices
> above the netdev. Instead, recursively walk up the tree from the
> netdev, allowing any parent to match against the sought after node.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Applied, thanks Tobias.
