Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0534FC7C
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfFWPh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:37:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:37:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7BEEE152F693D;
        Sun, 23 Jun 2019 08:37:25 -0700 (PDT)
Date:   Sun, 23 Jun 2019 08:37:24 -0700 (PDT)
Message-Id: <20190623.083724.172652862205625872.davem@davemloft.net>
To:     venza@brownhat.org
Cc:     joe@perches.com, sergej.benilov@googlemail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sis900: increment revision number
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7038d64e-0d3c-6b13-04fd-b614efbf5162@brownhat.org>
References: <20190623074707.6348-1-sergej.benilov@googlemail.com>
        <8eb161f4757cc55d7138bf5d30014e8fb8e38a0d.camel@perches.com>
        <7038d64e-0d3c-6b13-04fd-b614efbf5162@brownhat.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 08:37:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Venzano <venza@brownhat.org>
Date: Sun, 23 Jun 2019 11:13:28 +0200

> Hello,
> 
> I think it is good to know just by looking at the sources that the
> driver is still kept up-to-date, so I am in favor of this patch.

I absolutely, strongly, disagree.

These are pointless.
