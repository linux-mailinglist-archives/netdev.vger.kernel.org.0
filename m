Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315F11E3379
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 01:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392307AbgEZXIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 19:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389565AbgEZXIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 19:08:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB5DC061A0F;
        Tue, 26 May 2020 16:08:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A08F120F5281;
        Tue, 26 May 2020 16:08:49 -0700 (PDT)
Date:   Tue, 26 May 2020 16:08:48 -0700 (PDT)
Message-Id: <20200526.160848.605477862674053167.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526201023.GA26232@salvia>
References: <20200525215420.2290-1-pablo@netfilter.org>
        <20200525.182901.536565434439717149.davem@davemloft.net>
        <20200526201023.GA26232@salvia>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 16:08:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 26 May 2020 22:10:23 +0200

> If it's still possible, it would be good to toss this pull request.
> 
> Otherwise, I will send another pull request to address the kbuild
> reports.

Unfortunately I pushed it out already, please send me follow-ups.

Thanks.
