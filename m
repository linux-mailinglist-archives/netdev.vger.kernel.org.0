Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E20067CB1
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 04:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfGNCYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 22:24:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbfGNCYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 22:24:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A50C14051857;
        Sat, 13 Jul 2019 19:24:37 -0700 (PDT)
Date:   Sat, 13 Jul 2019 19:24:36 -0700 (PDT)
Message-Id: <20190713.192436.2234678611629105750.davem@davemloft.net>
To:     rosenp@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net-next: ag71xx: Add missing header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190713020921.18202-1-rosenp@gmail.com>
References: <20190713020921.18202-1-rosenp@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jul 2019 19:24:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 12 Jul 2019 19:09:20 -0700

> ag71xx uses devm_ioremap_nocache. This fixes usage of an implicit function
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

This is a bug fix and should target 'net'.
