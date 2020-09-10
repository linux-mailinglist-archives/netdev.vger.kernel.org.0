Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC332654E0
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgIJWOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgIJWOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:14:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DDFC061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 15:14:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 779AD135E9FC2;
        Thu, 10 Sep 2020 14:57:22 -0700 (PDT)
Date:   Thu, 10 Sep 2020 15:14:08 -0700 (PDT)
Message-Id: <20200910.151408.1783447300691062404.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, johannes.berg@intel.com
Subject: Re: [PATCH net] netlink: fix doc about nlmsg_parse/nla_validate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910133439.2608-1-nicolas.dichtel@6wind.com>
References: <20200910133439.2608-1-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 14:57:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu, 10 Sep 2020 15:34:39 +0200

> There is no @validate argument.
> 
> CC: Johannes Berg <johannes.berg@intel.com>
> Fixes: 3de644035446 ("netlink: re-add parse/validate functions in strict mode")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thank you.
