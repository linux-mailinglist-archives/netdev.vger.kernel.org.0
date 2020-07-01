Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE07E21018A
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGABe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 21:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgGABez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 21:34:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205E1C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 18:34:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93F80128107DA;
        Tue, 30 Jun 2020 18:34:54 -0700 (PDT)
Date:   Tue, 30 Jun 2020 18:34:53 -0700 (PDT)
Message-Id: <20200630.183453.143291686606112222.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v3 0/3] cxgb4: add mirror action support for
 TC-MATCHALL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1593521119.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593521119.git.rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 18:34:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Tue, 30 Jun 2020 18:41:27 +0530

> This series of patches add support to mirror all ingress traffic
> for TC-MATCHALL ingress offload.
> 
> Patch 1 adds support to dynamically create a mirror Virtual Interface
> (VI) that accepts all mirror ingress traffic when mirror action is
> set in TC-MATCHALL offload.
> 
> Patch 2 adds support to allocate mirror Rxqs and setup RSS for the
> mirror VI.
> 
> Patch 3 adds support to replicate all the main VI configuration to
> mirror VI. This includes replicating MTU, promiscuous mode,
> all-multicast mode, and enabled netdev Rx feature offloads.
 ...

Series applied to net-next, thanks.
