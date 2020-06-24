Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB2B206A96
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388794AbgFXD1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgFXD1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:27:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6687FC061573;
        Tue, 23 Jun 2020 20:27:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8E7C1298630D;
        Tue, 23 Jun 2020 20:27:47 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:27:47 -0700 (PDT)
Message-Id: <20200623.202747.548424486214848564.davem@davemloft.net>
To:     gaurav1086@gmail.com
Cc:     kuba@kernel.org, dsahern@gmail.com, David.Laight@ACULAB.COM,
        gnault@redhat.com, liuhangbin@gmail.com,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net/decnet] dn_route_rcv: remove redundant dev null
 check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623034133.32589-1-gaurav1086@gmail.com>
References: <20200623034133.32589-1-gaurav1086@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:27:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Date: Mon, 22 Jun 2020 23:41:19 -0400

> dev cannot be NULL here since its already being accessed
> before. Remove the redundant null check.
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Applied.
