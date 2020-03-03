Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6117F1785FF
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 23:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgCCW4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 17:56:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbgCCW4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 17:56:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F015715A0DD51;
        Tue,  3 Mar 2020 14:56:03 -0800 (PST)
Date:   Tue, 03 Mar 2020 14:56:03 -0800 (PST)
Message-Id: <20200303.145603.153230929931919209.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeontx2-af: fix spelling mistake "backpessure" ->
 "backpressure"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303075437.6704-1-colin.king@canonical.com>
References: <20200303075437.6704-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 14:56:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue,  3 Mar 2020 07:54:37 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a dev_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Please specify the appropriate target tree in your patch submissions,
this patch only applies to net-next because that's the only place
where the octeontx2-af changes exist that you are changing.

Applied, thank you.
