Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5F8233CB1
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgGaAsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730888AbgGaAsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:48:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A12EC061574;
        Thu, 30 Jul 2020 17:48:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DEB1126C49E9;
        Thu, 30 Jul 2020 17:31:17 -0700 (PDT)
Date:   Thu, 30 Jul 2020 17:48:02 -0700 (PDT)
Message-Id: <20200730.174802.993249892220514817.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-07-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730150836.66554-1-johannes@sipsolutions.net>
References: <20200730150836.66554-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 17:31:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 30 Jul 2020 17:08:35 +0200

> It's been a while, sorry. I have a few more fix that'd be nice
> to get in, though I don't think they affect a majority of users.
> 
> Please pull and let me know if there's any problem.

No worries, we're all busy, pulled.

Thank you.
