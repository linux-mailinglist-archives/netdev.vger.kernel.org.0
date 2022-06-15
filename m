Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C25A54C7FC
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 13:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347856AbiFOL4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 07:56:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45468 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347630AbiFOL4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 07:56:51 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D666E840E29C;
        Wed, 15 Jun 2022 04:56:47 -0700 (PDT)
Date:   Wed, 15 Jun 2022 12:56:42 +0100 (BST)
Message-Id: <20220615.125642.858758583076702866.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        soheil@google.com, weiwan@google.com, shakeelb@google.com,
        ncardwell@google.com, edumazet@google.com
Subject: Re: [PATCH v2 net-next 0/2] tcp: final (?) round of mem pressure
 fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20220614171734.1103875-1-eric.dumazet@gmail.com>
References: <20220614171734.1103875-1-eric.dumazet@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 15 Jun 2022 04:56:49 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 14 Jun 2022 10:17:32 -0700

> From: Eric Dumazet <edumazet@google.com>
> 
> While working on prior patch series (e10b02ee5b6c "Merge branch
> 'net-reduce-tcp_memory_allocated-inflation'"), I found that we
> could still have frozen TCP flows under memory pressure.
> 
> I thought we had solved this in 2015, but the fix was not complete.
> 
> v2: deal with zerocopy tx paths.

Does not apply cleanly to net, please respin.

Thank you.
