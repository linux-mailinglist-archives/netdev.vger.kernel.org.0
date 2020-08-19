Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C6B24A74A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHST4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHST4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:56:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3735CC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:56:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9AE0311E45763;
        Wed, 19 Aug 2020 12:39:55 -0700 (PDT)
Date:   Wed, 19 Aug 2020 12:56:40 -0700 (PDT)
Message-Id: <20200819.125640.1848130299373351106.davem@davemloft.net>
To:     jchapman@katalix.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] Documentation/networking: update l2tp docs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819092032.23198-1-jchapman@katalix.com>
References: <20200819092032.23198-1-jchapman@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 12:39:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jchapman@katalix.com
Date: Wed, 19 Aug 2020 10:20:32 +0100

> From: James Chapman <jchapman@katalix.com>
> 
> Kernel documentation of L2TP has not been kept up to date and lacks
> coverage of some L2TP APIs. While addressing this, refactor to improve
> readability, separating the parts which focus on user APIs and
> internal implementation into sections.
> 
> Changes in v2:
> 
>  - fix checkpatch warnings about trailing whitespace and long lines
> 
> Signed-off-by: James Chapman <jchapman@katalix.com>

Applied, thanks James.
