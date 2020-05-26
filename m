Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E707E1E18FB
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 03:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388360AbgEZBSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 21:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbgEZBSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 21:18:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ED9C061A0E;
        Mon, 25 May 2020 18:18:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 82ED1127AB6DB;
        Mon, 25 May 2020 18:18:53 -0700 (PDT)
Date:   Mon, 25 May 2020 18:18:52 -0700 (PDT)
Message-Id: <20200525.181852.1092670398238988532.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-05-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525141547.40538-1-johannes@sipsolutions.net>
References: <20200525141547.40538-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 18:18:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 25 May 2020 16:15:46 +0200

> We have a couple more fixes, all of them seem sort of older issues
> that surfaced now.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
