Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6EA284C59
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgJFNO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFNO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:14:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C63C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 06:14:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35EFF127C78E4;
        Tue,  6 Oct 2020 05:57:41 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:14:28 -0700 (PDT)
Message-Id: <20201006.061428.1204898099870944497.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH net-next] net: always dump full packets with skb_dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201005144838.851988-1-vladimir.oltean@nxp.com>
References: <20201005144838.851988-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 05:57:41 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon,  5 Oct 2020 17:48:38 +0300

> Currently skb_dump has a restriction to only dump full packet for the
> first 5 socket buffers, then only headers will be printed. Remove this
> arbitrary and confusing restriction, which is only documented vaguely
> ("up to") in the comments above the prototype.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thank you.
