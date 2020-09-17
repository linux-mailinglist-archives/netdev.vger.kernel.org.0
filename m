Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7797926D002
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIQAgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQAgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:36:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCA7C06178A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 17:36:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6EECA13C83C2A;
        Wed, 16 Sep 2020 17:19:19 -0700 (PDT)
Date:   Wed, 16 Sep 2020 17:36:05 -0700 (PDT)
Message-Id: <20200916.173605.439755171915317304.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next] ionic: dynamic interrupt moderation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915235903.373-1-snelson@pensando.io>
References: <20200915235903.373-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 17:19:19 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue, 15 Sep 2020 16:59:03 -0700

> Use the dim library to manage dynamic interrupt
> moderation in ionic.
> 
> v3: rebase
> v2: untangled declarations in ionic_dim_work()
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Applied, thank you.
