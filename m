Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C8C182924
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbgCLGez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:34:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56266 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387958AbgCLGey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:34:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E93E14DD3183;
        Wed, 11 Mar 2020 23:34:53 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:34:52 -0700 (PDT)
Message-Id: <20200311.233452.1721783439276979858.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] soc: qcom: ipa: fix spelling mistake "cahces" ->
 "caches"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311091613.75613-1-colin.king@canonical.com>
References: <20200311091613.75613-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:34:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed, 11 Mar 2020 09:16:13 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a dev_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
