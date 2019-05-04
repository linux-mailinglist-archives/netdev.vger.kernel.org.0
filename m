Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C79581379B
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 07:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfEDFmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 01:42:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEDFmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 01:42:09 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A46AE14D99A92;
        Fri,  3 May 2019 22:42:05 -0700 (PDT)
Date:   Sat, 04 May 2019 01:42:02 -0400 (EDT)
Message-Id: <20190504.014202.2301329130632974027.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/8] netlink policy export and recursive validation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503092501.10275-1-johannes@sipsolutions.net>
References: <20190503092501.10275-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 22:42:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  3 May 2019 11:24:53 +0200

> Here's (finally, sorry) the respin with the range/range_signed assignment
> fixed up.
> 
> I've now included the validation recursion protection so it's clear that
> it applies on top of the other patches only.

Series applied, thanks.
