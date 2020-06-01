Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EBF1EAF76
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgFATGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgFATGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:06:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206F5C03E96B
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 12:06:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78E44120477C4;
        Mon,  1 Jun 2020 12:06:47 -0700 (PDT)
Date:   Mon, 01 Jun 2020 12:06:46 -0700 (PDT)
Message-Id: <20200601.120646.1392473357718105274.davem@davemloft.net>
To:     roopa@cumulusnetworks.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH net-next] vxlan: fix dereference of nexthop group in
 nexthop update path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590902240-10290-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590902240-10290-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 12:06:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>
Date: Sat, 30 May 2020 22:17:20 -0700

> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> fix dereference of nexthop group in fdb nexthop group
> update validation path.
> 
> Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Suggested-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>

Applied, thank you.
