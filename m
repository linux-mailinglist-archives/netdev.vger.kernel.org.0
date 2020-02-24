Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4B116B5E1
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgBXXld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:41:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40232 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgBXXld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:41:33 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20D7D1254326E;
        Mon, 24 Feb 2020 15:41:32 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:41:30 -0800 (PST)
Message-Id: <20200224.154130.736737265478402175.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     kuba@kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: qrtr: fix spelling mistake "serivce" ->
 "service"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224173553.386446-1-colin.king@canonical.com>
References: <20200224173553.386446-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 15:41:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon, 24 Feb 2020 17:35:53 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a pr_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
