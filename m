Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7827358
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbfEWAf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:35:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWAf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:35:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37F95150428A2;
        Wed, 22 May 2019 17:35:26 -0700 (PDT)
Date:   Wed, 22 May 2019 17:35:25 -0700 (PDT)
Message-Id: <20190522.173525.2194008118986088715.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com,
        indranil@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v2] cxgb4: Enable hash filter with offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558541772-14745-1-git-send-email-vishal@chelsio.com>
References: <1558541772-14745-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:35:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Wed, 22 May 2019 21:46:12 +0530

> Hash (exact-match) filters used for offloading flows share the
> same active region resources on the chip with upper layer drivers,
> like iw_cxgb4, chcr, etc. Currently, only either Hash filters
> or ULDs can use the active region resources, but not both. Hence,
> use the new firmware configuration parameters (when available)
> to allow both the Hash filters and ULDs to share the
> active region simultaneously.
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Applied.
