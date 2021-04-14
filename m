Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D6135FBD8
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353478AbhDNTtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238322AbhDNTtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:49:08 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEFBC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 12:48:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C475C4D9BF274;
        Wed, 14 Apr 2021 12:48:45 -0700 (PDT)
Date:   Wed, 14 Apr 2021 12:48:41 -0700 (PDT)
Message-Id: <20210414.124841.1196513019940844903.davem@davemloft.net>
To:     ciorneiioana@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 0/5] dpaa2-switch: add tc hardware offload on
 ingress traffic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210414151728.amjvjgnqlejrujwr@skbuf>
References: <20210413132448.4141787-1-ciorneiioana@gmail.com>
        <20210414151728.amjvjgnqlejrujwr@skbuf>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 14 Apr 2021 12:48:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ciorneiioana@gmail.com>
Date: Wed, 14 Apr 2021 18:17:28 +0300

> This patch set is in the 'Accepted' state in patchwork but is nowhere to
> be found in the net-next tree.
> 
> Should I do something else or it was just not pushed yet?

It should be there now.

Thanks.
