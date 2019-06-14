Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C703B4678F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfFNS1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:27:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNS1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 14:27:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0021F14D9843B;
        Fri, 14 Jun 2019 11:27:53 -0700 (PDT)
Date:   Fri, 14 Jun 2019 11:27:51 -0700 (PDT)
Message-Id: <20190614.112751.1673452008439319869.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2019-06-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614141638.30018-1-johannes@sipsolutions.net>
References: <20190614141638.30018-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 11:27:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 14 Jun 2019 16:16:37 +0200

> And ... here's a -next pull request. Nothing really major here,
> see more details below.
> 
> Please pull and let me know if there's any problem.

Pulled and build testing, thank you.
