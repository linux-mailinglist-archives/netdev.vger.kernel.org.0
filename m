Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6D91904B5
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgCXEz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:55:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56414 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXEzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:55:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20C771579A562;
        Mon, 23 Mar 2020 21:55:55 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:55:54 -0700 (PDT)
Message-Id: <20200323.215554.773168641508251799.davem@davemloft.net>
To:     vadym.kochan@plvision.eu
Cc:     shuah@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] selftests/net/forwarding: add Makefile to install tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200323142404.28830-1-vadym.kochan@plvision.eu>
References: <20200323142404.28830-1-vadym.kochan@plvision.eu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:55:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>
Date: Mon, 23 Mar 2020 16:24:04 +0200

> Add missing Makefile for net/forwarding tests and include it to
> the targets list, otherwise forwarding tests are not installed
> in case of cross-compilation.
> 
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>

Applied, thanks.
