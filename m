Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3245822F971
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgG0TsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgG0TsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:48:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8B6C061794;
        Mon, 27 Jul 2020 12:48:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 952AE12777700;
        Mon, 27 Jul 2020 12:31:21 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:48:05 -0700 (PDT)
Message-Id: <20200727.124805.2057195688758273552.davem@davemloft.net>
To:     schalla@marvell.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, schandran@marvell.com,
        pathreya@marvell.com, sgoutham@marvell.com
Subject: Re: [PATCH 2/4] drivers: crypto: add support for OCTEONTX2 CPT
 engine
From:   David Miller <davem@davemloft.net>
In-Reply-To: <BYAPR18MB2821DDBE4F651E423791C422A0720@BYAPR18MB2821.namprd18.prod.outlook.com>
References: <1595596084-29809-3-git-send-email-schalla@marvell.com>
        <20200724.201457.2120372254880301593.davem@davemloft.net>
        <BYAPR18MB2821DDBE4F651E423791C422A0720@BYAPR18MB2821.namprd18.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 12:31:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>
Date: Mon, 27 Jul 2020 14:12:46 +0000

> On our test setup, the build is always successful, as we are adding
> "af/" subdirectory in ccflags list ([PATCH 4/4] crypto: marvell:
> enable OcteonTX2 cpt options for build).

A patch series must be fully bisectable, the tree must build properly
at every step of the way.
