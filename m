Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB374645D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfFNQhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:37:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfFNQhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 12:37:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B63214C61511;
        Fri, 14 Jun 2019 09:37:14 -0700 (PDT)
Date:   Fri, 14 Jun 2019 09:37:14 -0700 (PDT)
Message-Id: <20190614.093714.1289579552092737954.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-06-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614135042.28352-1-johannes@sipsolutions.net>
References: <20190614135042.28352-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 09:37:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 14 Jun 2019 15:50:41 +0200

> Here's a round of fixes for the current tree, things are all over
> and the only really important thing is the TDLS and MFP fix, both
> of which allow a security bypass in MFP.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks a lot.
