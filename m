Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7BEB645
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfJaRkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:40:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbfJaRkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:40:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E830114FA67EA;
        Thu, 31 Oct 2019 10:40:36 -0700 (PDT)
Date:   Thu, 31 Oct 2019 10:40:36 -0700 (PDT)
Message-Id: <20191031.104036.906328689737801166.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: Signed-off-by missing for commit in the net-next
 tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031181044.0f96b16d@canb.auug.org.au>
References: <20191031181044.0f96b16d@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 10:40:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 31 Oct 2019 18:10:44 +1100

> Commit
> 
>   a7023819404a ("e1000e: Use rtnl_lock to prevent race conditions between net and pci/pm")
> 
> is missing a Signed-off-by from its committer.

Ok Jeff, that's two pull requests I've taken from you this week where
there were incorrect SHA1 IDs in Fixes tags or missing signoffs.

Please use some scripts or other forms of automation to keep this from
happening in the future.

Thank you.
