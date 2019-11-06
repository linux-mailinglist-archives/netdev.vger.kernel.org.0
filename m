Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1445F1D73
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbfKFSXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:23:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfKFSXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 13:23:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 865431537CE87;
        Wed,  6 Nov 2019 10:23:13 -0800 (PST)
Date:   Wed, 06 Nov 2019 10:23:13 -0800 (PST)
Message-Id: <20191106.102313.1861746284831681758.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     rain.1986.08.12@gmail.com, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: Re: [PATCHv5 1/1] net: forcedeth: add xmit_more support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573020071-10503-1-git-send-email-yanjun.zhu@oracle.com>
References: <1573020071-10503-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 10:23:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Wed,  6 Nov 2019 01:01:11 -0500

> This change adds support for xmit_more based on the igb commit 6f19e12f6230
> ("igb: flush when in xmit_more mode and under descriptor pressure") and
> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
> were made to igb to support this feature.
 ...

Applied to net-next, thank you.
