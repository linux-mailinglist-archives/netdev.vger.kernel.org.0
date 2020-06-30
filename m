Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EA8210039
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgF3Wv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgF3Wv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:51:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8703C061755;
        Tue, 30 Jun 2020 15:51:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 11DD8127BE1B6;
        Tue, 30 Jun 2020 15:51:57 -0700 (PDT)
Date:   Tue, 30 Jun 2020 15:51:56 -0700 (PDT)
Message-Id: <20200630.155156.750535691940577187.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com,
        michal.kalderon@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] net: qed/qede: license cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200629110512.1812-1-alobakin@marvell.com>
References: <20200629110512.1812-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 15:51:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Mon, 29 Jun 2020 14:05:06 +0300

> QLogic QED drivers source code is dual licensed under
> GPL-2.0/BSD-3-Clause.
> 
> Correct already existing but wrong SPDX tags to match the actual
> license.
> Remove the license boilerplates and replace them with the correct
> SPDX tag.
> Update copyright years in all source files.

Series applied to net-next, thanks.
