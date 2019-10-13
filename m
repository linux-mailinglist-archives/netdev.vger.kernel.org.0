Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8CAD5753
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbfJMS3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 14:29:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42802 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfJMS3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 14:29:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31006146DA17E;
        Sun, 13 Oct 2019 11:29:38 -0700 (PDT)
Date:   Sun, 13 Oct 2019 11:29:37 -0700 (PDT)
Message-Id: <20191013.112937.1593993262080277258.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next next-2019-10-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011085736.15772-1-johannes@sipsolutions.net>
References: <20191011085736.15772-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 11:29:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 11 Oct 2019 10:57:35 +0200

> Let me try to be a bit "maintainer-of-the-day agnostic" ;-)
> 
> I'll be going on vacation, but figured I'd at least get this
> stuff out. As usual, I ran the hwsim tests from wpa_s/hostapd
> and all looks fine, compilation also was OK.
> 
> Kalle has agreed to help cover when I'm on vacation (though
> I'm home next week, so if there's any fallout I'll deal with
> it then), so if there's something urgent he may include some
> stack changes in his trees or ask you to or apply a patch.

This is fine, thanks for the heads up.

> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
