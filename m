Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DCFECAAD
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKAWAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:00:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfKAWAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:00:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C867151111BF;
        Fri,  1 Nov 2019 15:00:18 -0700 (PDT)
Date:   Fri, 01 Nov 2019 15:00:18 -0700 (PDT)
Message-Id: <20191101.150018.313957319302070947.davem@davemloft.net>
To:     yangchun@google.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        csully@google.com
Subject: Re: [PATCH net v3] gve: Fixes DMA synchronization.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101170956.261330-1-yangchun@google.com>
References: <20191101170956.261330-1-yangchun@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 15:00:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangchun Fu <yangchun@google.com>
Date: Fri,  1 Nov 2019 10:09:56 -0700

> Synces the DMA buffer properly in order for CPU and device to see
> the most up-to-data data.
> 
> Signed-off-by: Yangchun Fu <yangchun@google.com>
> Reviewed-by: Catherine Sullivan <csully@google.com>

Applied, thanks.
