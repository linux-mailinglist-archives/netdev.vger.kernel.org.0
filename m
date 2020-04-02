Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BC119C372
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388209AbgDBOAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:00:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47038 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732584AbgDBOAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:00:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07C01128A1336;
        Thu,  2 Apr 2020 07:00:09 -0700 (PDT)
Date:   Thu, 02 Apr 2020 07:00:09 -0700 (PDT)
Message-Id: <20200402.070009.1187982331898546161.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/4] mptcp: various bugfixes and improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200402114454.8533-1-fw@strlen.de>
References: <20200402114454.8533-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 07:00:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu,  2 Apr 2020 13:44:50 +0200

> This series contains the following mptcp bug fixes:
> 
> 1. Fix crash on tcp fallback when userspace doesn't provide a 'struct
>    sockaddr' to accept().
> 2. Close mptcp socket only when all subflows have closed, not just the first.
> 3. avoid stream data corruption when we'd receive identical mapping at the
>     exact same time on multiple subflows.
> 4. Fix "fn parameter not described" kerneldoc warnings.

Series applied, thanks Florian.
