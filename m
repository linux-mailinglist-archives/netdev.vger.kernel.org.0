Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717ED107698
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfKVRlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:41:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfKVRlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:41:39 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 601B01527D7E2;
        Fri, 22 Nov 2019 09:41:39 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:41:38 -0800 (PST)
Message-Id: <20191122.094138.2100384608720117372.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next next-2019-11-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191122130141.18186-1-johannes@sipsolutions.net>
References: <20191122130141.18186-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 09:41:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 22 Nov 2019 14:01:40 +0100

> Here's a final pull request for -next. I know I'm cutting it close, but
> the only interesting new thing here is AQL (airtime queue limits) which
> has been under discussion and heavy testing for quite a while, so I
> wanted to still get it in.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
