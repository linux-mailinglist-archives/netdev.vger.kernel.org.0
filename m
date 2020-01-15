Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2145413C080
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgAOMMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54984 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730407AbgAOMMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 07:12:34 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DB96159D139C;
        Wed, 15 Jan 2020 04:12:32 -0800 (PST)
Date:   Wed, 15 Jan 2020 04:12:27 -0800 (PST)
Message-Id: <20200115.041227.1501138300501649995.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-01-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115100333.40963-1-johannes@sipsolutions.net>
References: <20200115100333.40963-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jan 2020 04:12:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 15 Jan 2020 11:03:32 +0100

> Here's a small set of fixes for the current cycle still. Most
> issues are actually older and tagged with appropriate Fixes
> etc.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
