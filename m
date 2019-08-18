Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6747919AF
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 23:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfHRVQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 17:16:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49318 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfHRVQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 17:16:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83880145F4F53;
        Sun, 18 Aug 2019 14:16:11 -0700 (PDT)
Date:   Sun, 18 Aug 2019 14:16:11 -0700 (PDT)
Message-Id: <20190818.141611.1445041129399564089.davem@davemloft.net>
To:     sr@denx.de
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        opensource@vdorst.com, daniel@makrotopia.org,
        sean.wang@mediatek.com, john@phrozen.org
Subject: Re: [PATCH net-next 2/4 v3] net: ethernet: mediatek: Rename
 MTK_QMTK_INT_STATUS to MTK_QDMA_INT_STATUS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190816132325.28426-2-sr@denx.de>
References: <20190816132325.28426-1-sr@denx.de>
        <20190816132325.28426-2-sr@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 14:16:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Roese <sr@denx.de>
Date: Fri, 16 Aug 2019 15:23:23 +0200

> Currently all QDMA registers are named "MTK_QDMA_foo" in this driver
> with one exception: MTK_QMTK_INT_STATUS. This patch renames
> MTK_QMTK_INT_STATUS to MTK_QDMA_INT_STATUS so that all macros follow
> this rule.
> 
> Signed-off-by: Stefan Roese <sr@denx.de>

Applied.
