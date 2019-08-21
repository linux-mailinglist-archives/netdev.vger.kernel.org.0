Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E52D98507
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbfHUUBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:01:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32904 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729958AbfHUUBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 16:01:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8F0014C2211D;
        Wed, 21 Aug 2019 13:01:38 -0700 (PDT)
Date:   Wed, 21 Aug 2019 13:01:38 -0700 (PDT)
Message-Id: <20190821.130138.1422749854427592829.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-08-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821100005.13393-1-johannes@sipsolutions.net>
References: <20190821100005.13393-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 13:01:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 21 Aug 2019 12:00:03 +0200

> I have here for you a few fixes; three, to be specific. Nothing that
> warrants real discussion or urgency though.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
