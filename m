Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422D137B38
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbfFFRhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:37:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbfFFRhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:37:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2EA214DD4FA7;
        Thu,  6 Jun 2019 10:37:46 -0700 (PDT)
Date:   Thu, 06 Jun 2019 10:37:46 -0700 (PDT)
Message-Id: <20190606.103746.997228853760442672.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] ipv6: fix spelling mistake: "wtih" -> "with"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606084039.6265-1-colin.king@canonical.com>
References: <20190606084039.6265-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 10:37:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu,  6 Jun 2019 09:40:39 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a NL_SET_ERR_MSG message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
