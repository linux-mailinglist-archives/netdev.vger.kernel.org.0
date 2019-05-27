Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76DAC2B966
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 19:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfE0RYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 13:24:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59876 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbfE0RYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 13:24:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 406C412666375;
        Mon, 27 May 2019 10:24:37 -0700 (PDT)
Date:   Mon, 27 May 2019 10:24:36 -0700 (PDT)
Message-Id: <20190527.102436.1505356983678740433.davem@davemloft.net>
To:     Igor.Russkikh@aquantia.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/4] net: aquantia: tx clean budget logic error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ba532713-7ca6-6497-8c18-31c418d41ee5@aquantia.com>
References: <f659b94aff7f57a4592d89d797060d24f22a1bb9.1558777421.git.igor.russkikh@aquantia.com>
        <20190526.221556.885075788672387642.davem@davemloft.net>
        <ba532713-7ca6-6497-8c18-31c418d41ee5@aquantia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 May 2019 10:24:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>
Date: Mon, 27 May 2019 09:57:18 +0000

> This is not about introducing tx clean budget, but about fixing a bug.
> 
> tx clean budget logic is present in majority of the drivers as I see,
> including igb,ixgbe,mlx5.
> 
> I see it as a logical action to limit the time driver spends in napi_poll
> under napi budget.

Ok, series applied, thank you.
