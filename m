Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 386D1184E8D
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgCMSXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:23:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgCMSXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:23:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A931159D3372;
        Fri, 13 Mar 2020 11:23:50 -0700 (PDT)
Date:   Fri, 13 Mar 2020 11:23:49 -0700 (PDT)
Message-Id: <20200313.112349.681637573895674969.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     kuba@kernel.org, mkubecek@suse.cz, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] ethtool: fix spelling mistake "exceeeds" ->
 "exceeds"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313112534.76626-1-colin.king@canonical.com>
References: <20200313112534.76626-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 11:23:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 13 Mar 2020 11:25:34 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are a couple of spelling mistakes in NL_SET_ERR_MSG_ATTR messages.
> Fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks Colin.
