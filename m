Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7A975712
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfGYSiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:38:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37030 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfGYSiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:38:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95E59143750EB;
        Thu, 25 Jul 2019 11:38:04 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:38:04 -0700 (PDT)
Message-Id: <20190725.113804.1819709229869319575.davem@davemloft.net>
To:     dingxiang@cmss.chinamobile.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: ptp_dte: remove redundant dev_err message
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563872045-3692-1-git-send-email-dingxiang@cmss.chinamobile.com>
References: <1563872045-3692-1-git-send-email-dingxiang@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 11:38:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Date: Tue, 23 Jul 2019 16:54:05 +0800

> devm_ioremap_resource already contains error message, so remove
> the redundant dev_err message
> 
> Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>

Applied to net-next.
