Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF4350F43
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbfFXOyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:54:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55226 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfFXOyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:54:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0828915042EB0;
        Mon, 24 Jun 2019 07:54:02 -0700 (PDT)
Date:   Mon, 24 Jun 2019 07:54:01 -0700 (PDT)
Message-Id: <20190624.075401.2133643399244322061.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH v2 net-next 0/4] cxgb4: Reference count MPS TCAM
 entries within a PF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624.075323.2257534731180163594.davem@davemloft.net>
References: <20190624085037.2358-1-rajur@chelsio.com>
        <20190624.075132.2137301224911651949.davem@davemloft.net>
        <20190624.075323.2257534731180163594.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 07:54:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 24 Jun 2019 07:53:23 -0700 (PDT)

> You just changed it to a refcount_t and didn't try compiling the
> result?

You also need to fix this, which I tried to take care of this time:

Applying: cxgb4: Re-work the logic for mps refcounting
.git/rebase-apply/patch:291: new blank line at EOF.
+
