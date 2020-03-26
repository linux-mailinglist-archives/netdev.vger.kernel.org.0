Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571711946F7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgCZTDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:03:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52834 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgCZTDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:03:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D88CB15CBC317;
        Thu, 26 Mar 2020 12:03:54 -0700 (PDT)
Date:   Thu, 26 Mar 2020 12:03:54 -0700 (PDT)
Message-Id: <20200326.120354.775685947527082178.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-03-26
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326151725.117792-1-johannes@sipsolutions.net>
References: <20200326151725.117792-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 12:03:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 26 Mar 2020 16:17:24 +0100

> I don't know if you were planning to send another pull request to
> Linus,

I probably will.

> but at least if he doesn't release on Sunday then I still
> have a few security fixes - we (particularly Jouni) noticed that
> frames remaining in the queue may go out unencrypted when a client
> disconnects from a mac80211-based AP. We developed a few fixes for
> this, which I'm including here (with more description in the tag)
> along with a few small other fixes.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.

