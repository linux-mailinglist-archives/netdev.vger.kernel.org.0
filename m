Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CBB1894DD
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgCREZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:25:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgCREZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:25:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CF1C148774F2;
        Tue, 17 Mar 2020 21:25:15 -0700 (PDT)
Date:   Tue, 17 Mar 2020 21:25:14 -0700 (PDT)
Message-Id: <20200317.212514.1237883632644130736.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        ndagan@amazon.com, shayagr@amazon.com, sameehj@amazon.com
Subject: Re: [PATCH V2 net 0/4] ENA driver bug fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584428802-440-1-git-send-email-akiyano@amazon.com>
References: <1584428802-440-1-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Mar 2020 21:25:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Tue, 17 Mar 2020 09:06:38 +0200

> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> ENA driver bug fixes

Series applied, thank you.
