Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3EFE159E88
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 02:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgBLBKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 20:10:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbgBLBKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 20:10:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4196A151A1888;
        Tue, 11 Feb 2020 17:10:42 -0800 (PST)
Date:   Tue, 11 Feb 2020 17:10:41 -0800 (PST)
Message-Id: <20200211.171041.2215562351652728356.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V2 net 00/12] Bug fixes for ENA Ethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200211151751.29718-1-sameehj@amazon.com>
References: <20200211151751.29718-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Feb 2020 17:10:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Tue, 11 Feb 2020 15:17:39 +0000

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> Difference from V1:
> * Started using netdev_rss_key_fill()
> * Dropped superflous changes that are not related to bug fixes as
>   requested by Jakub

Series applied, thank you.
