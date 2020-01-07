Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C162133542
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgAGVwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:52:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgAGVwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:52:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A72C315A1760C;
        Tue,  7 Jan 2020 13:52:49 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:52:49 -0800 (PST)
Message-Id: <20200107.135249.2010540602729806790.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     ralf@linux-mips.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rose: remove redundant assignment to variable
 failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107152415.106353-1-colin.king@canonical.com>
References: <20200107152415.106353-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:52:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue,  7 Jan 2020 15:24:15 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable failed is being assigned a value that is never read, the
> following goto statement jumps to the end of the function and variable
> failed is not referenced at all.  Remove the redundant assignment.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
