Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EA341EF08
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhJAODL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 10:03:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52282 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbhJAODJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 10:03:09 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 203CA4D050C06;
        Fri,  1 Oct 2021 07:01:22 -0700 (PDT)
Date:   Fri, 01 Oct 2021 15:01:21 +0100 (BST)
Message-Id: <20211001.150121.833595483429151133.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, edumazet@google.com, weiwan@google.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211001.144046.309542880703739165.davem@davemloft.net>
References: <20211001161849.51b6deca@canb.auug.org.au>
        <20211001.144046.309542880703739165.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 01 Oct 2021 07:01:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 01 Oct 2021 14:40:46 +0100 (BST)

> I committed the sparc part into net-next today, thanks.

I put the rest into the tree now too, thank you.
