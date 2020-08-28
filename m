Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80F1255B17
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 15:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgH1NTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 09:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbgH1NSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 09:18:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67551C06121B;
        Fri, 28 Aug 2020 06:18:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A105C12829728;
        Fri, 28 Aug 2020 06:01:22 -0700 (PDT)
Date:   Fri, 28 Aug 2020 06:18:08 -0700 (PDT)
Message-Id: <20200828.061808.1954452736022735069.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2020-08-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200828101238.18356-1-johannes@sipsolutions.net>
References: <20200828101238.18356-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Aug 2020 06:01:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2020 12:12:37 +0200

> Here also nothing stands out, though perhaps you'd be
> interested in the fact that we now use the new netlink
> range length validation for some binary attributes.

Awesome!

> Please pull and let me know if there's any problem.

Pulled, thanks.
