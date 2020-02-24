Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C1F16B02E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgBXTVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:21:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36996 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgBXTVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:21:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDF64120ED555;
        Mon, 24 Feb 2020 11:21:43 -0800 (PST)
Date:   Mon, 24 Feb 2020 11:21:43 -0800 (PST)
Message-Id: <20200224.112143.2283025986833354811.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        tanhuazhong@huawei.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] net: hns3: remove redundant initialization of
 pointer 'client'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224192022.407524-1-colin.king@canonical.com>
References: <20200224192022.407524-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 11:21:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon, 24 Feb 2020 19:20:22 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer 'client' is being initialized with a value that is never
> read, it is being updated later on. The initialization is redundant
> and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> 
> V2: use reverse christmas tree ordering of local variables

Applied to net-next, thanks Colin.
