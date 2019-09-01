Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E45C5A4B34
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 20:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbfIASpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 14:45:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbfIASpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 14:45:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5E0C1516654B;
        Sun,  1 Sep 2019 11:45:22 -0700 (PDT)
Date:   Sun, 01 Sep 2019 11:45:22 -0700 (PDT)
Message-Id: <20190901.114522.824322370364603821.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     paul@paul-moore.com, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlabel: remove redundant assignment to pointer iter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190901155205.16877-1-colin.king@canonical.com>
References: <20190901155205.16877-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Sep 2019 11:45:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Sun,  1 Sep 2019 16:52:05 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer iter is being initialized with a value that is never read and
> is being re-assigned a little later on. The assignment is redundant
> and hence can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
