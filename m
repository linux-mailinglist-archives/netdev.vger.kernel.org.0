Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE561222A7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 04:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfLQD0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 22:26:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59352 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfLQD0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 22:26:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 446CF1426D0FE;
        Mon, 16 Dec 2019 19:26:32 -0800 (PST)
Date:   Mon, 16 Dec 2019 19:26:31 -0800 (PST)
Message-Id: <20191216.192631.1193188042810156404.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-10-16
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191216093143.10808-1-johannes@sipsolutions.net>
References: <20191216093143.10808-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 19:26:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 16 Dec 2019 10:31:42 +0100

> I have just a handful of fixes, but the AQL one is important since
> it disables the code that causes the iwlwifi issues/warnings.
> 
> Please pull and let me know if there's any problem.

Ok, pulled, thanks!
