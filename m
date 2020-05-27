Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3251E4D08
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389129AbgE0SXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387581AbgE0SXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:23:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78536C08C5C1;
        Wed, 27 May 2020 11:23:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7DB0128B1F1F;
        Wed, 27 May 2020 11:23:50 -0700 (PDT)
Date:   Wed, 27 May 2020 11:23:49 -0700 (PDT)
Message-Id: <20200527.112349.724631175356044481.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     jiri@mellanox.com, idosch@mellanox.com, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2][net-next] mlxsw: spectrum_router: remove redundant
 initialization of pointer br_dev 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527081555.124615-1-colin.king@canonical.com>
References: <20200527081555.124615-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:23:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed, 27 May 2020 09:15:55 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer br_dev is being initialized with a value that is never read
> and is being updated with a new value later on. The initialization
> is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
