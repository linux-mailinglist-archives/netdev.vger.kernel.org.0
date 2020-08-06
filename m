Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CE623E1D7
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 21:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgHFTGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 15:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbgHFTGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 15:06:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7D2C061574;
        Thu,  6 Aug 2020 12:06:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E3F411DB3163;
        Thu,  6 Aug 2020 11:49:15 -0700 (PDT)
Date:   Thu, 06 Aug 2020 12:05:59 -0700 (PDT)
Message-Id: <20200806.120559.1126479491662284081.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com, kuba@kernel.org,
        tanhuazhong@huawei.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hns3: fix spelling mistake "could'nt" ->
 "couldn't"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200806114256.58845-1-colin.king@canonical.com>
References: <20200806114256.58845-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Aug 2020 11:49:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu,  6 Aug 2020 12:42:56 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a dev_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.
