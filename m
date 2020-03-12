Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC3A183CCB
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCLWvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:51:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36134 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgCLWvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:51:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8C6115842635;
        Thu, 12 Mar 2020 15:51:13 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:51:13 -0700 (PDT)
Message-Id: <20200312.155113.707852640601289044.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: systemport: fix index check to avoid an array out
 of bounds access
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312150430.1136618-1-colin.king@canonical.com>
References: <20200312150430.1136618-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:51:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 12 Mar 2020 15:04:30 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the bounds check on index is off by one and can lead to
> an out of bounds access on array priv->filters_loc when index is
> RXCHK_BRCM_TAG_MAX.
> 
> Fixes: bb9051a2b230 ("net: systemport: Add support for WAKE_FILTER")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied and queued up for -stable, thanks.
