Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFA09D837
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfHZV25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:28:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38520 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:28:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31CA415042890;
        Mon, 26 Aug 2019 14:28:54 -0700 (PDT)
Date:   Mon, 26 Aug 2019 14:28:53 -0700 (PDT)
Message-Id: <20190826.142853.2135315525185656171.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        boon.leong.ong@intel.com
Subject: Re: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
References: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Aug 2019 14:28:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


There is something wrong with the clock on the computer you are
posting these patches from, the date in these postings are in the
future by several hours.

This messes up the ordering of changes in patchwork and makes my life
miserable to a certain degree, so please fix this.

Thank you.
