Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6772E1DF0ED
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgEVVNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731021AbgEVVNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:13:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3836DC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:13:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2CCE4126390D8;
        Fri, 22 May 2020 14:13:13 -0700 (PDT)
Date:   Fri, 22 May 2020 14:13:12 -0700 (PDT)
Message-Id: <20200522.141312.2295044886470007073.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        ndagan@amazon.com, shayagr@amazon.com, sameehj@amazon.com
Subject: Re: [PATCH V2 net-next 00/14] ENA features and cosmetic changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590138545-501-1-git-send-email-akiyano@amazon.com>
References: <1590138545-501-1-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 14:13:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Fri, 22 May 2020 12:08:51 +0300

> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Diff from V1 of this patchset:
> Removed error prints patch
> 
> This patchset includes:
> 1. new rx offset feature
> 2. reduction of the driver load time
> 3. multiple cosmetic changes to the code

Series applied, thanks.
