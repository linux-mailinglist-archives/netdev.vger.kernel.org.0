Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C0F14CEB6
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 17:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgA2Q6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 11:58:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34500 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgA2Q6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 11:58:44 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91B5414F0CEE3;
        Wed, 29 Jan 2020 08:58:43 -0800 (PST)
Date:   Tue, 28 Jan 2020 10:55:16 +0100 (CET)
Message-Id: <20200128.105516.623779977346226479.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] netem: change mailing list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200127144036.7395-1-stephen@networkplumber.org>
References: <20200127144036.7395-1-stephen@networkplumber.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 08:58:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Mon, 27 Jan 2020 06:40:36 -0800

> The old netem mailing list was inactive and recently was targeted by
> spammers. Switch to just using netdev mailing list which is where all
> the real change happens.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied, thanks.
