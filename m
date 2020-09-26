Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B14279582
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgIZATi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgIZATi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:19:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AE6C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:19:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 252F313BA5217;
        Fri, 25 Sep 2020 17:02:50 -0700 (PDT)
Date:   Fri, 25 Sep 2020 17:19:36 -0700 (PDT)
Message-Id: <20200925.171936.1056795284957056658.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: atlantic: fix build when object tree is
 separate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925202735.3296-1-irusskikh@marvell.com>
References: <20200925202735.3296-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 17:02:50 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Fri, 25 Sep 2020 23:27:35 +0300

> Driver subfolder files refer parent folder includes in an
> absolute manner.
> 
> Makefile contains a -I for this, but apparently that does not
> work if object tree is separated.
> 
> Adding srctree to fix that.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Applied.
