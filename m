Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6114A2B20
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfH2Xoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:44:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55366 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfH2Xog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:44:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8795A153BFAED;
        Thu, 29 Aug 2019 16:44:36 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:44:36 -0700 (PDT)
Message-Id: <20190829.164436.2240833341936181396.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-08-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190829150011.10512-1-johannes@sipsolutions.net>
References: <20190829150011.10512-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 16:44:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 29 Aug 2019 17:00:10 +0200

> We have just three more fixes now, and one of those is a driver fix
> because Kalle is on vacation and I'm covering for him in the meantime.
> 
> Please pull and let me know if there's any problem.

Ok, pulled, thanks.
