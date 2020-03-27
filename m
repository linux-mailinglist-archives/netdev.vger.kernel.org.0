Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AA7194FA0
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgC0DSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:18:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0DSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:18:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48F5E15CE7614;
        Thu, 26 Mar 2020 20:18:21 -0700 (PDT)
Date:   Thu, 26 Mar 2020 20:18:20 -0700 (PDT)
Message-Id: <20200326.201820.622968412547982808.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, mstarovoitov@marvell.com,
        sd@queasysnail.net, antoine.tenart@bootlin.com
Subject: Re: [PATCH v2 net-next 00/17] net: atlantic: MACSec support for
 AQC devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325125246.987-1-irusskikh@marvell.com>
References: <20200325125246.987-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 20:18:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Wed, 25 Mar 2020 15:52:29 +0300

> This patchset introduces MACSec HW offloading support in
> Marvell(Aquantia) AQC atlantic driver.

Series applied, thanks.
