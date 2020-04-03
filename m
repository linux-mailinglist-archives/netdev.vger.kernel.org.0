Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6137A19CE04
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 03:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390275AbgDCBAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 21:00:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388961AbgDCBAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 21:00:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 617C012757482;
        Thu,  2 Apr 2020 18:00:21 -0700 (PDT)
Date:   Thu, 02 Apr 2020 18:00:20 -0700 (PDT)
Message-Id: <20200402.180020.506846856059927664.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     jiri@mellanox.com, idosch@mellanox.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: spectrum_trap: fix unintention integer
 overflow on left shift
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200402144851.565983-1-colin.king@canonical.com>
References: <20200402144851.565983-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 18:00:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu,  2 Apr 2020 15:48:51 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Shifting the integer value 1 is evaluated using 32-bit
> arithmetic and then used in an expression that expects a 64-bit
> value, so there is potentially an integer overflow. Fix this
> by using the BIT_ULL macro to perform the shift and avoid the
> overflow.
> 
> Addresses-Coverity: ("Unintentional integer overflow")
> Fixes: 13f2e64b94ea ("mlxsw: spectrum_trap: Add devlink-trap policer support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.
