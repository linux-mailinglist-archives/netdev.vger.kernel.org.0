Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28DF99A575
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 04:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390084AbfHWC10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 22:27:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729716AbfHWC1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 22:27:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EEF17153ABADF;
        Thu, 22 Aug 2019 19:27:24 -0700 (PDT)
Date:   Thu, 22 Aug 2019 19:27:24 -0700 (PDT)
Message-Id: <20190822.192724.1052619848261339045.davem@davemloft.net>
To:     Justin.Lee1@Dell.com
Cc:     netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, sam@mendozajonas.com
Subject: Re: [PATCH] net/ncsi: Fix the payload copying for the request
 coming from Netlink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a94e5fa397a64ae3a676ec11ea09aaba@AUSX13MPS302.AMER.DELL.COM>
References: <a94e5fa397a64ae3a676ec11ea09aaba@AUSX13MPS302.AMER.DELL.COM>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 19:27:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <Justin.Lee1@Dell.com>
Date: Wed, 21 Aug 2019 21:24:52 +0000

> The request coming from Netlink should use the OEM generic handler.
> 
> The standard command handler expects payload in bytes/words/dwords
> but the actual payload is stored in data if the request is coming from Netlink.
> 
> Signed-off-by: Justin Lee <justin.lee1@dell.com>

Applied, thank you.
