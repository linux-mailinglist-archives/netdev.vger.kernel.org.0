Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77CBE182244
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 20:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbgCKT31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 15:29:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbgCKT31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 15:29:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C81811581AD2E;
        Wed, 11 Mar 2020 12:29:26 -0700 (PDT)
Date:   Wed, 11 Mar 2020 12:29:24 -0700 (PDT)
Message-Id: <20200311.122924.1599212065271140342.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-03-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311085355.8235-1-johannes@sipsolutions.net>
References: <20200311085355.8235-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 12:29:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 11 Mar 2020 09:53:54 +0100

> I have a few fixes still; please pull and let me know
> if there's any problem.

Pulled, thanks a lot.
