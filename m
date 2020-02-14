Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E7A15DA71
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgBNPQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:16:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729434AbgBNPQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:16:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76A9015C42F11;
        Fri, 14 Feb 2020 07:16:30 -0800 (PST)
Date:   Fri, 14 Feb 2020 07:16:30 -0800 (PST)
Message-Id: <20200214.071630.1148227233348876871.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-02-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214091911.9516-1-johannes@sipsolutions.net>
References: <20200214091911.9516-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2020 07:16:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 14 Feb 2020 10:19:10 +0100

> Here's a new pull request, long delayed unfortunately, but it
> wasn't that many fixes and some are pretty recent too. See the
> description below, it's really various things all over that we
> discovered.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
