Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F811DF2A9
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731319AbgEVXE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731172AbgEVXE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:04:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A025EC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 16:04:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 366111274E06B;
        Fri, 22 May 2020 16:04:27 -0700 (PDT)
Date:   Fri, 22 May 2020 16:04:26 -0700 (PDT)
Message-Id: <20200522.160426.840943094881933885.davem@davemloft.net>
To:     bharat@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, nirranjan@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: add adapter hotplug support for ULDs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521103429.18682-1-bharat@chelsio.com>
References: <20200521103429.18682-1-bharat@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:04:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>
Date: Thu, 21 May 2020 16:04:29 +0530

> Upon adapter hotplug, cxgb4 registers ULD devices for all the ULDs that
> are already loaded, ensuring that ULD's can enumerate the hotplugged
> adapter without reloading the ULD.
> 
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>

Applied, thanks.
