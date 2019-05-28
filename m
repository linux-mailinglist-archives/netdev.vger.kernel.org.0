Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044E42CE34
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfE1SGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:06:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfE1SF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:05:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F92A12D6C857;
        Tue, 28 May 2019 11:05:59 -0700 (PDT)
Date:   Tue, 28 May 2019 11:05:58 -0700 (PDT)
Message-Id: <20190528.110558.1330628926671013610.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     thomas.petazzoni@bootlin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: mvneta: Fix err code path of probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527185513.04aca133@xhacker.debian>
References: <20190527185513.04aca133@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 11:05:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Mon, 27 May 2019 11:04:17 +0000

> Fix below issues in err code path of probe:
> 1. we don't need to unregister_netdev() because the netdev isn't
> registered.
> 2. when register_netdev() fails, we also need to destroy bm pool for
> HWBM case.
> 
> Fixes: dc35a10f68d3 ("net: mvneta: bm: add support for hardware buffer management")
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Applied and queued up for -stable.
