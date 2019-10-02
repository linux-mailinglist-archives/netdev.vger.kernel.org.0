Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317C8C8D77
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfJBPz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:55:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfJBPz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:55:56 -0400
Received: from localhost (unknown [172.58.43.221])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B32E14DE97D2;
        Wed,  2 Oct 2019 08:55:55 -0700 (PDT)
Date:   Wed, 02 Oct 2019 11:55:52 -0400 (EDT)
Message-Id: <20191002.115552.1377983850191556234.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/5] ionic: driver updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001030326.29623-1-snelson@pensando.io>
References: <20191001030326.29623-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 08:55:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 30 Sep 2019 20:03:21 -0700

> These patches are a few updates to clean up some code
> issues and add an ethtool feature.
> 
> v3: drop the Fixes tags as they really aren't fixing bugs
>     simplify ionic_lif_quiesce() as no return is necessary
> 
> v2: add cover letter
>     edit a couple of patch descriptions for clarity
>       and add Fixes: tags

Series applied.
