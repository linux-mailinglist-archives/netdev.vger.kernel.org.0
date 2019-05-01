Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0059510E67
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfEAVOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:14:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfEAVOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 17:14:02 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01763133E97C0;
        Wed,  1 May 2019 14:13:59 -0700 (PDT)
Date:   Wed, 01 May 2019 17:13:54 -0400 (EDT)
Message-Id: <20190501.171354.1527034483459886062.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        saeedm@mellanox.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 0/4] net: mvpp2: cls: Add classification
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
References: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 14:14:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Tue, 30 Apr 2019 15:14:25 +0200

> This series is a rework of the previously standalone patch adding
> classification support for mvpp2 :
 ...

Series applied, thanks.
