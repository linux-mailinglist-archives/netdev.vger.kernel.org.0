Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFD11904C9
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgCXFML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:12:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXFMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 01:12:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DBDC158187FA;
        Mon, 23 Mar 2020 22:12:10 -0700 (PDT)
Date:   Mon, 23 Mar 2020 22:12:09 -0700 (PDT)
Message-Id: <20200323.221209.855923507330319907.davem@davemloft.net>
To:     mageelog@gmail.com
Cc:     dave@thedillows.org, netdev@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] net: typhoon: Add required whitespace after keywords
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200323213110.urobtmwfw6q6e3hc@edge-z.localdomain>
References: <20200323213110.urobtmwfw6q6e3hc@edge-z.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 22:12:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Logan Magee <mageelog@gmail.com>
Date: Mon, 23 Mar 2020 13:31:10 -0800

> checkpatch found a lack of appropriate whitespace after certain keywords
> as per the style guide. Add it in.
> 
> Signed-off-by: Logan Magee <mageelog@gmail.com>

Applied, thanks.
