Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2701457214
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhKSPvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:51:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55110 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhKSPvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 10:51:10 -0500
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D436C4D2DC50F;
        Fri, 19 Nov 2021 07:48:07 -0800 (PST)
Date:   Fri, 19 Nov 2021 15:48:06 +0000 (GMT)
Message-Id: <20211119.154806.2146025344002956731.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net-next 0/2] net: annotate accesses to
 dev->gso_max_{size|segs}
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211119154332.4110795-1-eric.dumazet@gmail.com>
References: <20211119154332.4110795-1-eric.dumazet@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 19 Nov 2021 07:48:08 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 19 Nov 2021 07:43:30 -0800

> From: Eric Dumazet <edumazet@google.com>
> 
> Generalize use of netif_set_gso_max_{size|segs} helpers and document
> lockless reads from sk_setup_caps()

Acked-by: David S. Miller <davem@davemloft.net>
