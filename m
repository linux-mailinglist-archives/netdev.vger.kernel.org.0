Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C3C27D9F2
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbgI2VYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgI2VYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:24:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C27C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 14:24:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 77D3A11E48E24;
        Tue, 29 Sep 2020 14:07:13 -0700 (PDT)
Date:   Tue, 29 Sep 2020 14:24:00 -0700 (PDT)
Message-Id: <20200929.142400.1950429484895348245.davem@davemloft.net>
To:     kevinbrace@gmx.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/4] via-rhine: Resume fix and other maintenance
 work
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929200943.3364-1-kevinbrace@gmx.com>
References: <20200929200943.3364-1-kevinbrace@gmx.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 14:07:13 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@gmx.com>
Date: Tue, 29 Sep 2020 13:09:39 -0700

> I use via-rhine based Ethernet regularly, and the Ethernet dying
> after resume was really annoying me.  I decided to take the
> matter into my own hands, and came up with a fix for the Ethernet
> disappearing after resume.  I will also want to take over the code
> maintenance work for via-rhine.  The patches apply to the latest
> code, but they should be backported to older kernels as well.

Series applied, thank you.
