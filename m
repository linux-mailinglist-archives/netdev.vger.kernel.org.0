Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3140160920
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgBQDnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:43:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:43:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 29C41157D1C6F;
        Sun, 16 Feb 2020 19:43:23 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:43:22 -0800 (PST)
Message-Id: <20200216.194322.567693639220142172.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH -net] net/sock.h: fix all kernel-doc warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f679d925-9645-51a5-53ba-f85d35bb8a24@infradead.org>
References: <f679d925-9645-51a5-53ba-f85d35bb8a24@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:43:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 15 Feb 2020 11:42:37 -0800

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix all kernel-doc warnings for <net/sock.h>.
> Fixes these warnings:
 ...
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks Randy.
