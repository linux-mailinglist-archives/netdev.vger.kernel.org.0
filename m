Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352051C467F
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgEDS6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDS6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:58:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A39C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:58:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23DA9120F5281;
        Mon,  4 May 2020 11:58:53 -0700 (PDT)
Date:   Mon, 04 May 2020 11:58:52 -0700 (PDT)
Message-Id: <20200504.115852.202206873409474672.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     jiri@resnulli.us, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v4 0/3] devlink: kernel region snapshot id
 allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501164042.1430604-1-kuba@kernel.org>
References: <20200501164042.1430604-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:58:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri,  1 May 2020 09:40:39 -0700

> currently users have to find a free snapshot id to pass
> to the kernel when they are requesting a snapshot to be
> taken.
> 
> This set extends the kernel so it can allocate the id
> on its own and send it back to user space in a response.

Series applied, thanks Jakub.
