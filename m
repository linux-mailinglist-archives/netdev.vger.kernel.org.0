Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7A81E4CF8
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391927AbgE0STj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388748AbgE0STj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:19:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8103EC08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:19:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F223B128B1EEA;
        Wed, 27 May 2020 11:19:38 -0700 (PDT)
Date:   Wed, 27 May 2020 11:19:38 -0700 (PDT)
Message-Id: <20200527.111938.1919025199084337813.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com, heinrich.kuhn@netronome.com
Subject: Re: [PATCH net] nfp: flower: fix used time of merge flow statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527074420.11232-1-simon.horman@netronome.com>
References: <20200527074420.11232-1-simon.horman@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:19:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>
Date: Wed, 27 May 2020 09:44:20 +0200

> From: Heinrich Kuhn <heinrich.kuhn@netronome.com>
> 
> Prior to this change the correct value for the used counter is calculated
> but not stored nor, therefore, propagated to user-space. In use-cases such
> as OVS use-case at least this results in active flows being removed from
> the hardware datapath. Which results in both unnecessary flow tear-down
> and setup, and packet processing on the host.
> 
> This patch addresses the problem by saving the calculated used value
> which allows the value to propagate to user-space.
> 
> Found by inspection.
> 
> Fixes: aa6ce2ea0c93 ("nfp: flower: support stats update for merge flows")
> Signed-off-by: Heinrich Kuhn <heinrich.kuhn@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

Applied and queued up for -stable, thanks.
