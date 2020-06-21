Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFC9202AE5
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 15:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbgFUN4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 09:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgFUN4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 09:56:39 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0EFC061794;
        Sun, 21 Jun 2020 06:56:39 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 51A05C01D; Sun, 21 Jun 2020 15:56:38 +0200 (CEST)
Date:   Sun, 21 Jun 2020 15:56:23 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Alexander Kapshuk <alexander.kapshuk@gmail.com>
Cc:     lucho@ionkov.net, ericvh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: Validate current->sighand in client.c
Message-ID: <20200621135623.GA20810@nautica>
References: <20200621084512.GA720@nautica>
 <20200621135312.78201-1-alexander.kapshuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200621135312.78201-1-alexander.kapshuk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Kapshuk wrote on Sun, Jun 21, 2020:
> Fix rcu not being dereferenced cleanly by using the task
> helpers (un)lock_task_sighand instead of spin_lock_irqsave and
> spin_unlock_irqrestore to ensure current->sighand is a valid pointer as
> suggested in the email referenced below.

Ack.
I'll take this once symbol issue is resolved ; thanks for your time.

-- 
Dominique
