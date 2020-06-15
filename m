Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A4C1FA0DA
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgFOT7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgFOT7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:59:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3BFC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 12:59:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94E80120ED49A;
        Mon, 15 Jun 2020 12:59:11 -0700 (PDT)
Date:   Mon, 15 Jun 2020 12:59:10 -0700 (PDT)
Message-Id: <20200615.125910.1450781729702549672.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com
Subject: Re: [PATCH net] net/rds: NULL pointer de-reference in
 rds_ib_add_one()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592206825-3303-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1592206825-3303-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 12:59:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Mon, 15 Jun 2020 00:40:25 -0700

> The parent field of a struct device may be NULL.  The macro
> ibdev_to_node() should check for that.
> 
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

Applied, thank you.
