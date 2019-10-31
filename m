Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CC4EB942
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfJaVsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:48:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33220 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbfJaVsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:48:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DFC6415003976;
        Thu, 31 Oct 2019 14:48:51 -0700 (PDT)
Date:   Thu, 31 Oct 2019 14:48:51 -0700 (PDT)
Message-Id: <20191031.144851.211645703557989376.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/7] bnxt_en: Updates for net-next.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
References: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 14:48:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Thu, 31 Oct 2019 01:07:44 -0400

> This patch series adds TC Flower tunnel decap and rewrite actions in
> the first 4 patches.  The next 3 patches integrates the recently
> added error recovery with the RDMA driver by calling the proper
> hooks to stop and start.
> 
> v2: Fix pointer alignment issue in patch #1.

Series applied, thanks Michael.
