Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264EF98515
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbfHUUCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:02:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32932 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbfHUUCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 16:02:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBED114C24B2E;
        Wed, 21 Aug 2019 13:02:53 -0700 (PDT)
Date:   Wed, 21 Aug 2019 13:02:53 -0700 (PDT)
Message-Id: <20190821.130253.834805401167967434.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2019-08-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821100424.13682-1-johannes@sipsolutions.net>
References: <20190821100424.13682-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 13:02:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 21 Aug 2019 12:04:23 +0200

> For -next, we have more changes, but as described in the tag
> they really just fall into a few groups of changes :-)
> 
> Please pull and let me know if there's any problem.

Also pulled, thanks.
