Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DFA119F9
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfEBNUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:20:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51562 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfEBNUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 09:20:55 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A68A6148C8ABC;
        Thu,  2 May 2019 06:20:53 -0700 (PDT)
Date:   Thu, 02 May 2019 09:20:50 -0400 (EDT)
Message-Id: <20190502.092050.513888935196732274.davem@davemloft.net>
To:     esben@geanix.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, yuehaibing@huawei.com,
        yang.wei9@zte.com.cn, mcgrof@kernel.org
Subject: Re: [PATCH] net: ll_temac: Fix typo bug for 32-bit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502064406.12608-1-esben@geanix.com>
References: <20190502064406.12608-1-esben@geanix.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 May 2019 06:20:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>
Date: Thu,  2 May 2019 08:43:43 +0200

> Fixes: d84aec42151b ("net: ll_temac: Fix support for 64-bit platforms")
> 
> Signed-off-by: Esben Haabendal <esben@geanix.com>

Applied.
