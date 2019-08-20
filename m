Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7470F9694C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbfHTTWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:22:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730088AbfHTTWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:22:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C83B146D0CE8;
        Tue, 20 Aug 2019 12:22:35 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:22:34 -0700 (PDT)
Message-Id: <20190820.122234.1290995026664280862.davem@davemloft.net>
To:     christian.herber@nxp.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/1] Add BASE-T1 PHY support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819151940.27756-1-christian.herber@nxp.com>
References: <20190819151940.27756-1-christian.herber@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 12:22:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Herber <christian.herber@nxp.com>
Date: Mon, 19 Aug 2019 15:19:52 +0000

> v1 patchset can be found here: https://lkml.org/lkml/2019/8/15/626

Please expand and clarify your commit messages as requested by Heiner
in his feedback to v1.
