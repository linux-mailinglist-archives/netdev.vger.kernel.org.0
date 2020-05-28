Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3937D1E690F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391442AbgE1SI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391412AbgE1SI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:08:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBF0C08C5C6;
        Thu, 28 May 2020 11:08:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34CF71295A274;
        Thu, 28 May 2020 11:08:56 -0700 (PDT)
Date:   Thu, 28 May 2020 11:08:55 -0700 (PDT)
Message-Id: <20200528.110855.1734440342981569253.davem@davemloft.net>
To:     wu000273@umn.edu
Cc:     kjlu@umn.edu, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, sfeldma@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding: Fix reference count leak in
 bond_sysfs_slave_add.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528031029.11078-1-wu000273@umn.edu>
References: <20200528031029.11078-1-wu000273@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 11:08:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wu000273@umn.edu
Date: Wed, 27 May 2020 22:10:29 -0500

> From: Qiushi Wu <wu000273@umn.edu>
> 
> kobject_init_and_add() takes reference even when it fails.
> If this function returns an error, kobject_put() must be called to
> properly clean up the memory associated with the object. Previous
> commit "b8eb718348b8" fixed a similar problem.
> 
> Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>

Applied and queued up for -stable, thanks.
