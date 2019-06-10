Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE163B921
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403883AbfFJQNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:13:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388850AbfFJQNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:13:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A28015051245;
        Mon, 10 Jun 2019 09:13:34 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:13:33 -0700 (PDT)
Message-Id: <20190610.091333.934616032295696444.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, ymarkman@marvell.com,
        mw@semihalf.com
Subject: Re: [PATCH net-next 0/3] net: mvpp2: Add extra ethtool stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610085529.16803-1-maxime.chevallier@bootlin.com>
References: <20190610085529.16803-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 09:13:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Mon, 10 Jun 2019 10:55:26 +0200

> This series adds support for more ethtool counters in PPv2 :
>  - Per port counters, including one indicating the classifier drops
>  - Per RXQ and per TXQ counters
> 
> The first 2 patches perform some light rework and renaming, and the 3rd
> adds the extra counters.

Series applied, thanks.
