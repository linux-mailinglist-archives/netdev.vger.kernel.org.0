Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC891EA894
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfJaBRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:17:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49288 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJaBRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:17:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B1F714EBB7B6;
        Wed, 30 Oct 2019 18:17:51 -0700 (PDT)
Date:   Wed, 30 Oct 2019 18:17:50 -0700 (PDT)
Message-Id: <20191030.181750.550341558923185674.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net, 0/2] hv_netvsc: fix error handling in
 netvsc_attach/set_features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572449471-5219-1-git-send-email-haiyangz@microsoft.com>
References: <1572449471-5219-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 18:17:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 30 Oct 2019 15:32:05 +0000

> The error handling code path in these functions are not correct.
> This patch set fixes them.

Series applied, thank you.
