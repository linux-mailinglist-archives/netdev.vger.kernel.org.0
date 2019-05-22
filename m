Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF90B26AA9
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfEVTOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:14:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60566 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728674AbfEVTOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:14:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BECB514FFA583;
        Wed, 22 May 2019 12:14:51 -0700 (PDT)
Date:   Wed, 22 May 2019 12:14:51 -0700 (PDT)
Message-Id: <20190522.121451.712557703691236298.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     isdn@linux-pingi.de, joe@perches.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] mISDN: Fix indenting in dsp_cmx.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190521094256.GA11899@mwanda>
References: <20190521094256.GA11899@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 12:14:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 21 May 2019 12:42:56 +0300

> We used a script to indent this code back in 2012, but I guess it got
> confused by the ifdefs and added some extra tabs.  This patch removes
> them.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
