Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA2616B5F6
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgBXXpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:45:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40262 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgBXXpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:45:19 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7ADD61254327C;
        Mon, 24 Feb 2020 15:45:19 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:45:18 -0800 (PST)
Message-Id: <20200224.154518.1971160243343479579.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-02-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224184108.82737-1-johannes@sipsolutions.net>
References: <20200224184108.82737-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 15:45:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 24 Feb 2020 19:41:07 +0100

> And in addition, I also have a couple of fixes for net.
> 
> Please pull and let me know if there's any problem.

Also pulled, thanks Johannes.
