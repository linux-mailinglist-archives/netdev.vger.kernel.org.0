Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8433B94C
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391121AbfFJQXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:23:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389322AbfFJQXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:23:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E19F15051BC6;
        Mon, 10 Jun 2019 09:23:01 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:23:00 -0700 (PDT)
Message-Id: <20190610.092300.1686623862696326754.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        yuric@marvell.com
Subject: Re: [PATCH net 1/2] net: mvpp2: prs: Fix parser range for VID
 filtering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610135008.8077-1-maxime.chevallier@bootlin.com>
References: <20190610135008.8077-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 09:23:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please start providing proper header postings with each and every patch
series, explaining at a high level what the patch series is doing, how
it is doing it, and why it is doing it that way.

Thanks.
