Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFD814C924
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgA2K6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:58:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59282 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgA2K6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 05:58:36 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF9CD15C05722;
        Wed, 29 Jan 2020 02:58:33 -0800 (PST)
Date:   Wed, 29 Jan 2020 11:58:32 +0100 (CET)
Message-Id: <20200129.115832.596615028862997775.davem@davemloft.net>
To:     joe@perches.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sch_choke: Use kvcalloc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8f13c6144a9bd42a1bc5e281d77fb4bc53043e96.camel@perches.com>
References: <8f13c6144a9bd42a1bc5e281d77fb4bc53043e96.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 02:58:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 28 Jan 2020 11:12:03 -0800

> Convert the use of kvmalloc_array with __GFP_ZERO to
> the equivalent kvcalloc.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
