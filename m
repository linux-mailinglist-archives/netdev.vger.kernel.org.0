Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FEEC3E30
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfJARJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:09:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50144 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfJARJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:09:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 47F47154F0CBC;
        Tue,  1 Oct 2019 10:09:18 -0700 (PDT)
Date:   Tue, 01 Oct 2019 10:09:17 -0700 (PDT)
Message-Id: <20191001.100917.832784405457426902.davem@davemloft.net>
To:     vasundhara-v.volam@broadcom.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@mellanox.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH v2 net] devlink: Fix error handling in param and
 info_get dumpit cb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569824541-5603-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1569824541-5603-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 10:09:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date: Mon, 30 Sep 2019 11:52:21 +0530

> If any of the param or info_get op returns error, dumpit cb is
> skipping to dump remaining params or info_get ops for all the
> drivers.
> 
> Fix to not return if any of the param/info_get op returns error
> as not supported and continue to dump remaining information.
> 
> v2: Modify the patch to return error, except for params/info_get
> op that return -EOPNOTSUPP as suggested by Andrew Lunn. Also, modify
> commit message to reflect the same.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Applied, thanks.
