Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC724BB76
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfFSO26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:28:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfFSO26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 10:28:58 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3287152474A2;
        Wed, 19 Jun 2019 07:28:57 -0700 (PDT)
Date:   Wed, 19 Jun 2019 10:28:56 -0400 (EDT)
Message-Id: <20190619.102856.1934195744157627483.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     jaswinder.singh@linaro.org, netdev@vger.kernel.org,
        ard.biesheuvel@linaro.org, masahisa.kojima@linaro.org
Subject: Re: [net-next, PATCH 1/2, v2] net: netsec: initialize tx ring on
 ndo_open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560938641-16778-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1560938641-16778-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 07:28:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Wed, 19 Jun 2019 13:04:00 +0300

> Since we changed the Tx ring handling and now depends on bit31 to figure
> out the owner of the descriptor, we should initialize this every time
> the device goes down-up instead of doing it once on driver init. If the
> value is not correctly initialized the device won't have any available
> descriptors
> 
> Changes since v1:
> - Typo fixes
> 
> Fixes: 35e07d234739 ("net: socionext: remove mmio reads on Tx")
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Applied, please do not put an empty line between the Fixes and other
tags.  Keep all the tags together in one group.

Thanks.
