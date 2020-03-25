Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1897B19310C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgCYTWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:22:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46642 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgCYTWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:22:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF25E15A09DB4;
        Wed, 25 Mar 2020 12:22:53 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:22:52 -0700 (PDT)
Message-Id: <20200325.122252.966436204777154509.davem@davemloft.net>
To:     rahul.kundu@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com,
        rajur@chelsio.com
Subject: Re: [PATCH net] cxgb4: Add support to catch bits set in INT_CAUSE5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4908cdd761d1eec90abd7b6815e07be1d243e5cd.1585137120.git.rahul.kundu@chelsio.com>
References: <4908cdd761d1eec90abd7b6815e07be1d243e5cd.1585137120.git.rahul.kundu@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 12:22:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Kundu <rahul.kundu@chelsio.com>
Date: Wed, 25 Mar 2020 04:53:09 -0700

> This commit adds support to catch any bits set in SGE_INT_CAUSE5 for Parity Errors.
> F_ERR_T_RXCRC flag is used to ignore that particular bit as it is not considered as fatal.
> So, we clear out the bit before looking for error.
> This patch now read and report separately all three registers(Cause1, Cause2, Cause5).
> Also, checks for errors if any.
> 
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>
> Signed-off-by: Rahul Kundu <rahul.kundu@chelsio.com>

This doesn't seem like a critical bug fix at all so I applied it to net-next,
thank you.
