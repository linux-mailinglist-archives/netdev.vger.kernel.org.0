Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0818281E63
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgJBWdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBWdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:33:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40C8C0613D0;
        Fri,  2 Oct 2020 15:33:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA9E311E48C9B;
        Fri,  2 Oct 2020 15:16:52 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:33:39 -0700 (PDT)
Message-Id: <20201002.153339.1697375699643718752.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2020-10-02
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002101126.221601-1-johannes@sipsolutions.net>
References: <20201002101126.221601-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:16:52 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  2 Oct 2020 12:11:25 +0200

> Here's a - probably final - set of patches for net-next.
> Really the big thing is more complete S1G support, along
> with a small list of other things, see the tag message.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
