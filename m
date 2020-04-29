Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082F41BE6F9
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgD2TLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2TLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:11:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F741C03C1AE;
        Wed, 29 Apr 2020 12:11:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D92C91210A3E3;
        Wed, 29 Apr 2020 12:11:03 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:11:03 -0700 (PDT)
Message-Id: <20200429.121103.1627116280946095444.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, ordex@autistici.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/7] netlink validation improvements/refactoring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429134843.42224-1-johannes@sipsolutions.net>
References: <20200429134843.42224-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 12:11:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 29 Apr 2020 15:48:36 +0200

> Sorry - again, I got distracted/interrupted before I could send this.
> I made this a little more than a year ago, and then forgot it. Antonio
> asked me something a couple of weeks ago, and that reminded me of this
> so I'm finally sending it out now (rebased & adjusted).
> 
> Basically this just does some refactoring & improvements for range
> validation, leading up to a patch to expose the policy to userspace,
> which I'll send separately as RFC for now.

Please fix the pt->min/pt->max WARN_ON() vs. range pointer issue that
Jakub pointed out.

Otherwise this series looks good.
