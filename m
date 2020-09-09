Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996582625BF
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIIDPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIIDPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:15:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503EDC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 20:15:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7086611E3E4C3;
        Tue,  8 Sep 2020 19:58:49 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:15:35 -0700 (PDT)
Message-Id: <20200908.201535.1942728184998947496.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sfc: coding style cleanups in
 mcdi_port_common.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f0b8cbd8-ef52-a23a-2dca-41443203d2f1@solarflare.com>
References: <f0b8cbd8-ef52-a23a-2dca-41443203d2f1@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:58:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Tue, 8 Sep 2020 20:22:19 +0100

> The code recently moved into this file contained a number of coding style
>  issues, about which checkpatch and xmastree complained.  Fix them.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied, thanks Edward.
