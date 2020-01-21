Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D7E1439DC
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgAUJxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:53:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728797AbgAUJxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:53:05 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0CA315BD0EED;
        Tue, 21 Jan 2020 01:53:03 -0800 (PST)
Date:   Tue, 21 Jan 2020 10:53:02 +0100 (CET)
Message-Id: <20200121.105302.655426383133999678.davem@davemloft.net>
To:     tblodt@icloud.com
Cc:     netdev@vger.kernel.org, trivial@kernel.org, edumazet@google.com
Subject: Re: [PATCH] tcp: remove redundant assigment to snd_cwnd
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200120221053.1001033-1-tblodt@icloud.com>
References: <20200120221053.1001033-1-tblodt@icloud.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 01:53:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Theodore Dubois <tblodt@icloud.com>
Date: Mon, 20 Jan 2020 14:10:53 -0800

> Not sure how this got in here. git blame says the second assignment was
> added in 3a9a57f6, but that commit also removed the first assignment.
> 
> Signed-off-by: Theodore Dubois <tblodt@icloud.com>

Applied, thank you.
