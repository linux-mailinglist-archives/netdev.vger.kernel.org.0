Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B669362E6C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfGIC5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:57:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGIC5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:57:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0599E133E97B7;
        Mon,  8 Jul 2019 19:57:41 -0700 (PDT)
Date:   Mon, 08 Jul 2019 19:57:41 -0700 (PDT)
Message-Id: <20190708.195741.202712281331944867.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcroce@redhat.com, fw@strlen.de
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190709102728.70299ba8@canb.auug.org.au>
References: <20190702121357.65f9b0b4@canb.auug.org.au>
        <20190709102728.70299ba8@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 19:57:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 9 Jul 2019 10:27:28 +1000

> I am still getting this conflict (the commit ids may have changed).
> Just a reminder in case you think Linus may need to know.

I'm resolving this right now, thanks Stephen.
