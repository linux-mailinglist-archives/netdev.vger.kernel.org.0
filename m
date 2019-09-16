Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B98BB351B
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfIPHHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:07:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfIPHHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:07:43 -0400
Received: from localhost (unknown [85.119.46.8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 33CF615163DE1;
        Mon, 16 Sep 2019 00:07:41 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:07:40 +0200 (CEST)
Message-Id: <20190916.090740.552365470207565763.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qed: fix spelling mistake "fullill" -> "fulfill"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190913090759.3490-1-colin.king@canonical.com>
References: <20190913090759.3490-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 00:07:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 13 Sep 2019 10:07:59 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a DP_VERBOSE debug message. Fix it.
> (Using American English spelling as this is the most common way
> to spell this in the kernel).
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next
