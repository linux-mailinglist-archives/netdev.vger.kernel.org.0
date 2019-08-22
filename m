Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C139A2E4
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbfHVW3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:29:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49696 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfHVW3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:29:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7452815393F45;
        Thu, 22 Aug 2019 15:29:00 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:28:57 -0700 (PDT)
Message-Id: <20190822.152857.1388207414767202364.davem@davemloft.net>
To:     casey@schaufler-ca.com
Cc:     fw@strlen.de, paul@paul-moore.com, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e2e22b41-2aa1-6a52-107d-e4efd9dcacf4@schaufler-ca.com>
References: <32646e98-2ed6-a63a-5589-fefd57e85f66@schaufler-ca.com>
        <20190822.141845.217313560870249775.davem@davemloft.net>
        <e2e22b41-2aa1-6a52-107d-e4efd9dcacf4@schaufler-ca.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 15:29:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>
Date: Thu, 22 Aug 2019 14:59:37 -0700

> Sure, you *can* do that, but it would be insane to do so.

We look up the neighbour table entries on every single packet we
transmit from the kernel in the same exact way.

And it was exactly to get rid of a pointer in a data structure.
