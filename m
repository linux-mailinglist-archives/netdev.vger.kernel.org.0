Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34DE18A965
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgCRXoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:44:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32812 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgCRXoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:44:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE862155371FC;
        Wed, 18 Mar 2020 16:44:04 -0700 (PDT)
Date:   Wed, 18 Mar 2020 16:44:04 -0700 (PDT)
Message-Id: <20200318.164404.1810161482307162498.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, tom@herbertland.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] vxlan: check return value of gro_cells_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200318132809.27206-1-ap420073@gmail.com>
References: <20200318132809.27206-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 16:44:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Wed, 18 Mar 2020 13:28:09 +0000

> gro_cells_init() returns error if memory allocation is failed.
> But the vxlan module doesn't check the return value of gro_cells_init().
> 
> Fixes: 58ce31cca1ff ("vxlan: GRO support at tunnel layer")`
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thank you.
