Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5664C6D46A
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391220AbfGRTJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:09:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54378 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRTJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 15:09:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 253931527DFBA;
        Thu, 18 Jul 2019 12:09:11 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:09:10 -0700 (PDT)
Message-Id: <20190718.120910.1323935732125670131.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     tariqt@mellanox.com, netdev@vger.kernel.org, eranbe@mellanox.com,
        saeedm@mellanox.com, moshe@mellanox.com
Subject: Re: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190718100847.52d6314b@cakuba.netronome.com>
References: <20190717104141.37333cc9@cakuba.netronome.com>
        <1b27ca27-fd33-2e2c-a4c0-ba8878a940db@mellanox.com>
        <20190718100847.52d6314b@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 12:09:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu, 18 Jul 2019 10:08:47 -0700

> Yes, certainly. It's documentation and renaming a stat before it makes
> it into an official release.

Agreed.
