Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F6AE5865
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 05:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfJZDxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 23:53:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfJZDxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 23:53:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0698914B7F8B1;
        Fri, 25 Oct 2019 20:53:01 -0700 (PDT)
Date:   Fri, 25 Oct 2019 20:53:01 -0700 (PDT)
Message-Id: <20191025.205301.961579907291940118.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/6] ionic updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024004900.6561-1-snelson@pensando.io>
References: <20191024004900.6561-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 20:53:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Wed, 23 Oct 2019 17:48:54 -0700

> These are a few of the driver updates we've been working on internally.
> These clean up a few mismatched struct comments, add checking for dead
> firmware, fix an initialization bug, and change the Rx buffer management.
> 
> These are based on net-next v5.4-rc3-709-g985fd98ab5cc.
> 
> 
> v2: clear napi->skb in the error case in ionic_rx_frags()

Series applied.
