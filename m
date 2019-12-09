Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D720111794E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfLIW2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:28:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36492 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfLIW2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:28:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D934615492867;
        Mon,  9 Dec 2019 14:28:46 -0800 (PST)
Date:   Mon, 09 Dec 2019 14:28:46 -0800 (PST)
Message-Id: <20191209.142846.388476377747170130.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2][RESEND] qed: remove redundant assignments to rc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209131607.71580-1-colin.king@canonical.com>
References: <20191209131607.71580-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 14:28:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon,  9 Dec 2019 13:16:07 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable rc is assigned with a value that is never read and
> it is re-assigned a new value later on.  The assignment is redundant
> and can be removed.  Clean up multiple occurrances of this pattern.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks Colin.
