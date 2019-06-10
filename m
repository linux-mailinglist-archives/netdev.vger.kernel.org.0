Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBBA3BB1E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388212AbfFJRhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:37:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59212 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387643AbfFJRhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:37:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4740A15069DDB;
        Mon, 10 Jun 2019 10:37:51 -0700 (PDT)
Date:   Mon, 10 Jun 2019 10:37:48 -0700 (PDT)
Message-Id: <20190610.103748.964369358731083638.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH next 0/5] r8169: improve handling of chip-specific
 configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
References: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 10:37:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 10 Jun 2019 18:20:31 +0200

> This series improves and simplifies handling of chip-specific
> configuration.

Series applied.
