Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1080B170FA3
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgB0E1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:27:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgB0E1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:27:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 852EC15B4787C;
        Wed, 26 Feb 2020 20:27:21 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:27:20 -0800 (PST)
Message-Id: <20200226.202720.1164916581862060065.davem@davemloft.net>
To:     ndev@hwipl.net
Cc:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] net/smc: improve peer ID in CLC decline
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225214122.335292-1-ndev@hwipl.net>
References: <20200225214122.335292-1-ndev@hwipl.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:27:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Wippel <ndev@hwipl.net>
Date: Tue, 25 Feb 2020 22:41:20 +0100

> The following two patches improve the peer ID in CLC decline messages if
> RoCE devices are present in the host but no suitable device is found for
> a connection. The first patch reworks the peer ID initialization. The
> second patch contains the actual changes of the CLC decline messages.
> 
> Changes v1 -> v2:
> * make smc_ib_is_valid_local_systemid() static in first patch
> * changed if in smc_clc_send_decline() to remove curly braces
> 
> Changes RFC -> v1:
> * split the patch into two parts
> * removed zero assignment to global variable (thanks Leon)
> 
> Thanks to Leon Romanovsky and Karsten Graul for the feedback!

Series applied, thank you.
