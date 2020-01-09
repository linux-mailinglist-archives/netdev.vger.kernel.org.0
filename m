Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276F713503E
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgAIAEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:04:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50006 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgAIAEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:04:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCB1F15371C47;
        Wed,  8 Jan 2020 16:04:05 -0800 (PST)
Date:   Wed, 08 Jan 2020 16:04:05 -0800 (PST)
Message-Id: <20200108.160405.1403964084544750153.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     mkubecek@suse.cz, f.fainelli@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ethtool: potential NULL dereference in
 strset_prepare_data()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108054236.ult5qxiiwpw2wamk@kili.mountain>
References: <20200108054236.ult5qxiiwpw2wamk@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 16:04:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 8 Jan 2020 08:42:36 +0300

> Smatch complains that the NULL checking isn't done consistently:
> 
>     net/ethtool/strset.c:253 strset_prepare_data()
>     error: we previously assumed 'dev' could be null (see line 233)
> 
> It looks like there is a missing return on this path.
> 
> Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
