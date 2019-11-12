Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D368AF9A50
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKLUMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:12:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfKLUMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:12:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5411D154D2510;
        Tue, 12 Nov 2019 12:12:09 -0800 (PST)
Date:   Mon, 11 Nov 2019 22:05:29 -0800 (PST)
Message-Id: <20191111.220529.1787748247936127753.davem@redhat.com>
To:     colin.king@canonical.com
Cc:     jon.maloy@ericsson.com, ying.xue@windreiver.com,
        tuong.t.lien@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] tipc: fix update of the uninitialized variable
 err
From:   David Miller <davem@redhat.com>
In-Reply-To: <20191111123334.68401-1-colin.king@canonical.com>
References: <20191111123334.68401-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:12:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon, 11 Nov 2019 12:33:34 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable err is not uninitialized and hence can potentially contain
> any garbage value.  This may cause an error when logical or'ing the
> return values from the calls to functions crypto_aead_setauthsize or
> crypto_aead_setkey.  Fix this by setting err to the return of
> crypto_aead_setauthsize rather than or'ing in the return into the
> uninitialized variable
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
