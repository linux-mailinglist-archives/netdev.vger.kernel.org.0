Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC27126387E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgIIVa1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Sep 2020 17:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730154AbgIIVaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:30:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F34C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 14:30:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4865C1298AC2F;
        Wed,  9 Sep 2020 14:13:38 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:30:23 -0700 (PDT)
Message-Id: <20200909.143023.1623265548583167138.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
From:   David Miller <davem@davemloft.net>
In-Reply-To: <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
References: <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
        <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 14:13:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Wed, 9 Sep 2020 10:58:19 -0700

> I'm suggesting that this implementation using the existing devlink
> logging services should suffice until someone can design, implement,
> and get accepted a different bit of plumbing.  Unfortunately, that's
> not a job that I can get to right now.

Sorry, this is not how we operate.

If you do things that way you will have to support the "temporary"
solution forever in order to not break user facing interfaces.

That misses the whole point of doing it properly.
