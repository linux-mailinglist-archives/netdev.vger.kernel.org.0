Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CDA20E9DB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgF2X67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgF2X66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 19:58:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEBFC061755;
        Mon, 29 Jun 2020 16:58:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 392F6127B77E7;
        Mon, 29 Jun 2020 16:58:57 -0700 (PDT)
Date:   Mon, 29 Jun 2020 16:58:54 -0700 (PDT)
Message-Id: <20200629.165854.2191252805621997190.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-06-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200629142718.31257-1-johannes@sipsolutions.net>
References: <20200629142718.31257-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 16:58:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 29 Jun 2020 16:27:17 +0200

> We've got a couple of fixes here, and I took the liberty to include a
> small code cleanup of some really stupid code, and a patch that adds
> new AKM suites so we can use them in the drivers more easily.
> 
> Please pull and let me know if there's any problem.

Looks good, pulled, thanks!
