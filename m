Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4A5D7C94
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfJOQ6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:58:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36926 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfJOQ6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:58:52 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACC4415039434;
        Tue, 15 Oct 2019 09:58:51 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:58:51 -0400 (EDT)
Message-Id: <20191015.125851.2305315548091261475.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: b44: remove redundant assignment to variable reg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011172232.14430-1-colin.king@canonical.com>
References: <20191011172232.14430-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 09:58:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 11 Oct 2019 18:22:32 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable reg is being assigned a value that is never read
> and is being re-assigned in the following for-loop. The
> assignment is redundant and hence can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
