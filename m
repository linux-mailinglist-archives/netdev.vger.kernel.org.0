Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686B55A657
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfF1VhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:37:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1VhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:37:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE26C13CB3060;
        Fri, 28 Jun 2019 14:37:00 -0700 (PDT)
Date:   Fri, 28 Jun 2019 14:37:00 -0700 (PDT)
Message-Id: <20190628.143700.1074650648292410737.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, fw@strlen.de, jhs@mojatatu.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/2] Track recursive calls in TC act_mirred
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 14:37:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Mon, 24 Jun 2019 23:13:34 +0100

> These patches aim to prevent act_mirred causing stack overflow events from
> recursively calling packet xmit or receive functions. Such events can
> occur with poor TC configuration that causes packets to travel in loops
> within the system.
> 
> Florian Westphal advises that a recursion crash and packets looping are
> separate issues and should be treated as such. David Miller futher points
> out that pcpu counters cannot track the precise skb context required to
> detect loops. Hence these patches are not aimed at detecting packet loops,
> rather, preventing stack flows arising from such loops.

Series applied, thanks.
