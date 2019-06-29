Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DAB5AD0A
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfF2TTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:19:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39392 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfF2TTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:19:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3600614C6D1D9;
        Sat, 29 Jun 2019 12:19:09 -0700 (PDT)
Date:   Sat, 29 Jun 2019 12:19:06 -0700 (PDT)
Message-Id: <20190629.121906.887960024306396376.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] selftests: rtnetlink: skip ipsec offload tests if
 netdevsim isn't present
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627151242.5150-1-fw@strlen.de>
References: <20190627151242.5150-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 12:19:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu, 27 Jun 2019 17:12:42 +0200

> running the script on systems without netdevsim now prints:
> 
> SKIP: ipsec_offload can't load netdevsim
> 
> instead of error message & failed status.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Feel free to apply to -next, its not a bug fix per se.

Applied to net-next, thank you.
