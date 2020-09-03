Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FF725C914
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgICTFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgICTFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:05:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92CEC061244;
        Thu,  3 Sep 2020 12:05:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0048915C818F6;
        Thu,  3 Sep 2020 11:48:13 -0700 (PDT)
Date:   Thu, 03 Sep 2020 12:04:57 -0700 (PDT)
Message-Id: <20200903.120457.83314264328395264.davem@davemloft.net>
To:     pbarker@konsulko.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] doc: net: dsa: Fix typo in config code sample
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200903084925.124494-1-pbarker@konsulko.com>
References: <20200903084925.124494-1-pbarker@konsulko.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 11:48:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Barker <pbarker@konsulko.com>
Date: Thu,  3 Sep 2020 09:49:25 +0100

> In the "single port" example code for configuring a DSA switch without
> tagging support from userspace the command to bring up the "lan2" link
> was typo'd.
> 
> Signed-off-by: Paul Barker <pbarker@konsulko.com>

Applied, thank you.
