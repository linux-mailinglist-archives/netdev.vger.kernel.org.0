Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18C4105AFE
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfKUURj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:17:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUURj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:17:39 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 08A051504816E;
        Thu, 21 Nov 2019 12:17:39 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:17:38 -0800 (PST)
Message-Id: <20191121.121738.1892792993494919439.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     sunil.kovvuri@gmail.com, netdev@vger.kernel.org,
        sgoutham@marvell.com
Subject: Re: [PATCH v3 16/16] Documentation: net: octeontx2: Add RVU HW and
 drivers overview.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121112335.7c2916d8@cakuba.netronome.com>
References: <20191121104316.1bd09fcb@cakuba.netronome.com>
        <CA+sq2Cfv25A0RW4h_KXi=74g=F61o=KPXyEH7HMisxx1tp8PeA@mail.gmail.com>
        <20191121112335.7c2916d8@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 12:17:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu, 21 Nov 2019 11:23:35 -0800

> Well you didn't bother to upstream it until now. You're just pushing
> admin parts of your DPDK solution. Can you honestly be surprised the
> upstream netdev community doesn't like that?

I agree with Jakub, this is a serious problem and the whole premise of
the code being upstreamed is not acceptable.

I'm going to look really strictly at octeon submissions from this point
forward, as I'm really disappointed in what is going on here.

I will have to see explicit explanations clearly showing how upstream
usage of the driver will be done, no DPDK only stuff, no SDK only
situations, none of that.  It's simply unacceptable.
