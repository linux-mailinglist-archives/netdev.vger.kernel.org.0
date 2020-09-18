Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060B3270863
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIRVgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgIRVgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:36:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE50C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 14:36:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6889F159F1C7A;
        Fri, 18 Sep 2020 14:19:28 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:36:14 -0700 (PDT)
Message-Id: <20200918.143614.1053288936732805868.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, ioana.ciornei@nxp.com,
        ruxandra.radulescu@nxp.com
Subject: Re: [v2] dpaa2-eth: fix a build warning in dpmac.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918092225.21967-1-yangbo.lu@nxp.com>
References: <20200918092225.21967-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:19:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Fri, 18 Sep 2020 17:22:25 +0800

> Fix below sparse warning in dpmac.c.
> warning: cast to restricted __le64
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Applied.
