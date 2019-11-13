Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB523FA795
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfKMDu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:50:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54472 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbfKMDu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:50:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45553154FFFE0;
        Tue, 12 Nov 2019 19:50:58 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:50:57 -0800 (PST)
Message-Id: <20191112.195057.522550661453260702.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v3] dpaa2-eth: free already allocated channels on
 probe defer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573575712-1366-1-git-send-email-ioana.ciornei@nxp.com>
References: <1573575712-1366-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:50:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Tue, 12 Nov 2019 18:21:52 +0200

> The setup_dpio() function tries to allocate a number of channels equal
> to the number of CPUs online. When there are not enough DPCON objects
> already probed, the function will return EPROBE_DEFER. When this
> happens, the already allocated channels are not freed. This results in
> the incapacity of properly probing the next time around.
> Fix this by freeing the channels on the error path.
> 
> Fixes: d7f5a9d89a55 ("dpaa2-eth: defer probe on object allocate")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied and queued up for -stable, thanks.
