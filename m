Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69581859D8
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgCODuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:50:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35192 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgCODuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:50:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1889815B75158;
        Sat, 14 Mar 2020 20:50:50 -0700 (PDT)
Date:   Sat, 14 Mar 2020 20:50:49 -0700 (PDT)
Message-Id: <20200314.205049.1940049994054721362.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, zorik@amazon.com, sameehj@amazon.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ena: ethtool: clean up minor indentation issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312140522.1125768-1-colin.king@canonical.com>
References: <20200312140522.1125768-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 20:50:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 12 Mar 2020 14:05:22 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a statement that is indented incorrectly, remove a space.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next, thanks.
