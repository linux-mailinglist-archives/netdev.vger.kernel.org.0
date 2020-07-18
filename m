Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43A72247E2
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgGRBsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbgGRBsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:48:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DA8C0619D2;
        Fri, 17 Jul 2020 18:48:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BACA11E45914;
        Fri, 17 Jul 2020 18:48:36 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:48:35 -0700 (PDT)
Message-Id: <20200717.184835.133398423508608262.davem@davemloft.net>
To:     mark.einon@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: et131x: Remove redundant register read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717132135.361267-1-mark.einon@gmail.com>
References: <20200717132135.361267-1-mark.einon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:48:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Einon <mark.einon@gmail.com>
Date: Fri, 17 Jul 2020 14:21:35 +0100

> Following the removal of an unused variable assignment (remove
> unused variable 'pm_csr') the associated register read can also go,
> as the read also occurs in the subsequent et1310_in_phy_coma()
> call.
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>

Applied to net-next.
