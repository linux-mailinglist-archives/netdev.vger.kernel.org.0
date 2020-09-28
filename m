Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167C927B83B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgI1Xdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgI1Xdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:33:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE374C0613E4;
        Mon, 28 Sep 2020 15:17:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFCC011E3E4F6;
        Mon, 28 Sep 2020 15:00:47 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:17:34 -0700 (PDT)
Message-Id: <20200928.151734.25122613961401605.davem@davemloft.net>
To:     hch@lst.de
Cc:     viro@zeniv.linux.org.uk, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] fs: remove ->sendpage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200926070049.11513-1-hch@lst.de>
References: <20200926070049.11513-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 15:00:48 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Sat, 26 Sep 2020 09:00:49 +0200

> ->sendpage is only called from generic_splice_sendpage.  The only user of
> generic_splice_sendpage is socket_file_ops, which is also the only
> instance that actually implements ->sendpage.  Remove the ->sendpage file
> operation and just open code the logic in the socket code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David S. Miller <davem@davemloft.net>
