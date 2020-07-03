Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2B221400D
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 21:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgGCTgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 15:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgGCTgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 15:36:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A50C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 12:36:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62F48154A1DC6;
        Fri,  3 Jul 2020 12:36:44 -0700 (PDT)
Date:   Fri, 03 Jul 2020 12:36:43 -0700 (PDT)
Message-Id: <20200703.123643.1767755006389224836.davem@davemloft.net>
To:     dan-netdev@drown.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/xen-netfront: add kernel TX timestamps
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703062234.GA31682@vps3.drown.org>
References: <20200703062234.GA31682@vps3.drown.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jul 2020 12:36:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Drown <dan-netdev@drown.org>
Date: Fri, 3 Jul 2020 01:22:34 -0500

> This adds kernel TX timestamps to the xen-netfront driver.  Tested with chrony
> on an AWS EC2 instance.
> 
> Signed-off-by: Daniel Drown <dan-netdev@drown.org>

Applied, thanks.
