Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7A51E9A8C
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 23:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgEaVdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 17:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbgEaVdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 17:33:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F51CC061A0E;
        Sun, 31 May 2020 14:33:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34C2412801DEF;
        Sun, 31 May 2020 14:33:14 -0700 (PDT)
Date:   Sun, 31 May 2020 14:33:13 -0700 (PDT)
Message-Id: <20200531.143313.1930144718493807689.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2020-05-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200531095321.18991-1-johannes@sipsolutions.net>
References: <20200531095321.18991-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 31 May 2020 14:33:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 31 May 2020 11:53:20 +0200

> My apologies that this comes so late, it took me much longer than
> I had anticipated to pull together the 6 GHz changes between the
> overlaps that Qualcomm and we at Intel had, since we both had much
> of this implemented, though with a bit different focus (AP/mesh
> vs. client). But I think it's now fine, although I left out the
> scanning for now since we're still discussing the userspace API.
> 
> Other than that, nothing really big, you can see the tag message
> below.
> 
> Please pull and let me know if there's any problem.

No worries, pulled, thanks Johannes.
