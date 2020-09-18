Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD40726EA33
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIRA7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIRA7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 20:59:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C0DC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 17:59:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D88B6136821DD;
        Thu, 17 Sep 2020 17:43:00 -0700 (PDT)
Date:   Thu, 17 Sep 2020 17:59:47 -0700 (PDT)
Message-Id: <20200917.175947.615928423271910921.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net] nfp: use correct define to return NONE fec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917175257.592636-1-kuba@kernel.org>
References: <20200917175257.592636-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 17:43:01 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 17 Sep 2020 10:52:57 -0700

> struct ethtool_fecparam carries bitmasks not bit numbers.
> We want to return 1 (NONE), not 0.
> 
> Fixes: 0d0870938337 ("nfp: implement ethtool FEC mode settings")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied and queued up for -stable, thanks.
