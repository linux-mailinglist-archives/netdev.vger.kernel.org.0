Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4727A3047B
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfE3WB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:01:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfE3WB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:01:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21C4614D9FAAB;
        Thu, 30 May 2019 15:01:27 -0700 (PDT)
Date:   Thu, 30 May 2019 15:01:26 -0700 (PDT)
Message-Id: <20190530.150126.2269605953017441351.davem@davemloft.net>
To:     michal.kalderon@marvell.com
Cc:     ariel.elior@marvell.com, netdev@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH net-next] qed: Fix static checker warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190530122040.19842-1-michal.kalderon@marvell.com>
References: <20190530122040.19842-1-michal.kalderon@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 15:01:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Thu, 30 May 2019 15:20:40 +0300

> In some cases abs_ppfid could be printed without being initialized.
> 
> Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for offload protocols")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Applied.
