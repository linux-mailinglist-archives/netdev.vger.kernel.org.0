Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CF422740A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgGUApy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGUApx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:45:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F970C061794;
        Mon, 20 Jul 2020 17:45:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0489411E8EC15;
        Mon, 20 Jul 2020 17:29:07 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:45:52 -0700 (PDT)
Message-Id: <20200720.174552.1199692153657012436.davem@davemloft.net>
To:     hch@lst.de
Cc:     msalter@redhat.com, jacquiot.aurelien@gmail.com,
        ley.foon.tan@intel.com, arnd@arndb.de, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] arch, net: remove the last csum_partial_copy()
 leftovers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720113609.177259-1-hch@lst.de>
References: <20200720113609.177259-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:29:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Mon, 20 Jul 2020 13:36:09 +0200

> Most of the tree only uses and implements csum_partial_copy_nocheck,
> but the c6x and lib/checksum.c implement a csum_partial_copy that
> isn't used anywere except to define csum_partial_copy.  Get rid of
> this pointless alias.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'll apply this to net-next, thanks.
