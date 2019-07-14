Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F18367CB4
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 04:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfGNC3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 22:29:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46492 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbfGNC3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 22:29:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02DF4140518B3;
        Sat, 13 Jul 2019 19:29:43 -0700 (PDT)
Date:   Sat, 13 Jul 2019 19:29:42 -0700 (PDT)
Message-Id: <20190713.192942.828708488562409691.davem@davemloft.net>
To:     vincent@bernat.ch
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [net-next] bonding: add documentation for peer_notif_delay
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190713143527.27562-1-vincent@bernat.ch>
References: <20190713143527.27562-1-vincent@bernat.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jul 2019 19:29:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Bernat <vincent@bernat.ch>
Date: Sat, 13 Jul 2019 16:35:27 +0200

> Ability to tweak the interval between peer notifications has been
> added in 07a4ddec3ce9 ("bonding: add an option to specify a delay
> between peer notifications") but the documentation was not updated.
> 
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>

Applied.
