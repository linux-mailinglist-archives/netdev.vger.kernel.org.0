Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AA536377
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfFESmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:42:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfFESmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:42:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7CE51510A7A1;
        Wed,  5 Jun 2019 11:42:14 -0700 (PDT)
Date:   Wed, 05 Jun 2019 11:42:14 -0700 (PDT)
Message-Id: <20190605.114214.1563066009392498606.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] r8169: factor out firmware handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <58ea4445-954f-4a97-397f-5d681125b9bb@gmail.com>
References: <58ea4445-954f-4a97-397f-5d681125b9bb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 11:42:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 5 Jun 2019 07:59:02 +0200

> Let's factor out firmware handling into a separate source code file.
> This simplifies reading the code and makes clearer what the interface
> between driver and firmware handling is.
> 
> v2:
> - fix small whitespace issue in patch 2

Series applied, thanks Heiner.
