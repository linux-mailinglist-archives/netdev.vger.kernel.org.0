Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE05C5FD52
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 21:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfGDTMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 15:12:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGDTMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 15:12:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D84D6142A612C;
        Thu,  4 Jul 2019 12:12:32 -0700 (PDT)
Date:   Thu, 04 Jul 2019 12:12:30 -0700 (PDT)
Message-Id: <20190704.121230.1258734619521898253.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: sun: remove redundant assignment to
 variable err
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704123651.31672-1-colin.king@canonical.com>
References: <20190704123651.31672-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jul 2019 12:12:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu,  4 Jul 2019 13:36:51 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is being assigned with a value that is never
> read and it is being updated in the next statement with a new value.
> The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
