Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29CCC16B5EF
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgBXXoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:44:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgBXXoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:44:01 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FBA612543277;
        Mon, 24 Feb 2020 15:44:00 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:42:26 -0800 (PST)
Message-Id: <20200224.154226.1751093497782245534.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next next-2020-02-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224183442.82066-1-johannes@sipsolutions.net>
References: <20200224183442.82066-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 15:44:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 24 Feb 2020 19:34:41 +0100

> Some new updates - initial beacon protection support and TID
> configuration are the interesting parts, but need drivers to
> fill in, so that'll come from Kalle later :)
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
