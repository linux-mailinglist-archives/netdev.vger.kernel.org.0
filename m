Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C5C206AD0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388706AbgFXD4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388393AbgFXD4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:56:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC59C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 20:56:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3070B12988109;
        Tue, 23 Jun 2020 20:56:02 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:56:01 -0700 (PDT)
Message-Id: <20200623.205601.1166410993198166087.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next 0/2] cxgb4: fix more warnings reported by
 sparse
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:56:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Wed, 24 Jun 2020 02:03:21 +0530

> Patch 1 ensures all callers take on-chip memory lock when flashing
> PHY firmware to fix lock context imbalance warnings.
> 
> Patch 2 moves all static arrays in header file to respective C file
> in device dump collection path.

Series applied, thank you.
