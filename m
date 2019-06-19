Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BAF4C2C4
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfFSVLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:11:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfFSVLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:11:39 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27B14146D3929;
        Wed, 19 Jun 2019 14:11:39 -0700 (PDT)
Date:   Wed, 19 Jun 2019 17:11:25 -0400 (EDT)
Message-Id: <20190619.171125.1161107128318684639.davem@davemloft.net>
To:     ldir@darbyshire-bryant.me.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sched: act_ctinfo: tidy UAPI definition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619174109.55695-1-ldir@darbyshire-bryant.me.uk>
References: <20190619174109.55695-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 14:11:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Date: Wed, 19 Jun 2019 18:41:10 +0100

> Remove some enums from the UAPI definition that were only used
> internally and are NOT part of the UAPI.
> 
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Yeah, this is definitely the right thing to do.

Applied, thanks.
