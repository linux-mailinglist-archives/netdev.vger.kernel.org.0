Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FF57AFAC
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbfG3RUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:20:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbfG3RUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 13:20:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 885E412652D89;
        Tue, 30 Jul 2019 10:20:31 -0700 (PDT)
Date:   Tue, 30 Jul 2019 10:20:30 -0700 (PDT)
Message-Id: <20190730.102030.2109749179893397150.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     petrm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][net-next][V2] mlxsw: spectrum_ptp: fix duplicated
 check on orig_egr_types
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730114752.24133-1-colin.king@canonical.com>
References: <20190730114752.24133-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 10:20:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue, 30 Jul 2019 12:47:52 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently are duplicated checks on orig_egr_types which are
> redundant, I believe this is a typo and should actually be
> orig_ing_types || orig_egr_types instead of the expression
> orig_egr_types || orig_egr_types.  Fix these.
> 
> Addresses-Coverity: ("Same on both sides")
> Fixes: c6b36bdd04b5 ("mlxsw: spectrum_ptp: Increase parsing depth when PTP is enabled")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net.
