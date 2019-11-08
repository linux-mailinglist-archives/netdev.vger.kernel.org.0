Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694BCF6174
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfKIUaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:30:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53668 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfKIU3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:29:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4726514746C51;
        Sat,  9 Nov 2019 12:29:34 -0800 (PST)
Date:   Fri, 08 Nov 2019 11:37:13 -0800 (PST)
Message-Id: <20191108.113713.787196845271459836.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next next-2019-11-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108123738.17359-1-johannes@sipsolutions.net>
References: <20191108123738.17359-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 Nov 2019 12:29:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  8 Nov 2019 13:37:36 +0100

> Here are a couple of more things for net-next. Nothing
> really that relevant, but I figured I'd flush my queue
> now and get some preparatory patches in for 5.5 still.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
