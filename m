Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E17A92E605
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfE2U0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:26:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41276 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2U0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:26:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A9F914A68A01;
        Wed, 29 May 2019 13:26:00 -0700 (PDT)
Date:   Wed, 29 May 2019 13:26:00 -0700 (PDT)
Message-Id: <20190529.132600.834772691456137212.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] qed: fix spelling mistake "inculde" -> "include"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528065217.7311-1-colin.king@canonical.com>
References: <20190528065217.7311-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 13:26:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue, 28 May 2019 07:52:17 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a DP_INFO message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
