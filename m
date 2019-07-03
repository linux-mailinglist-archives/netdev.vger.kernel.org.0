Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA6E5EB8E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfGCS0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:26:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCS0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 14:26:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA2D7140D2988;
        Wed,  3 Jul 2019 11:26:53 -0700 (PDT)
Date:   Wed, 03 Jul 2019 11:26:53 -0700 (PDT)
Message-Id: <20190703.112653.2236170497032808093.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: don't warn in inet diag when IPV6 is disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702222021.28899-1-stephen@networkplumber.org>
References: <20190702222021.28899-1-stephen@networkplumber.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 11:26:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Tue,  2 Jul 2019 15:20:21 -0700

> If IPV6 was disabled, then ss command would cause a kernel warning
> because the command was attempting to dump IPV6 socket information.
> The fix is to just remove the warning.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202249
> Fixes: 432490f9d455 ("net: ip, diag -- Add diag interface for raw sockets")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied, thanks.
