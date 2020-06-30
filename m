Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0518E21003E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgF3Wyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgF3Wyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:54:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE3CC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:54:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15D39127BE225;
        Tue, 30 Jun 2020 15:54:36 -0700 (PDT)
Date:   Tue, 30 Jun 2020 15:54:35 -0700 (PDT)
Message-Id: <20200630.155435.865055112637817286.davem@davemloft.net>
To:     nirranjan@chelsio.com
Cc:     netdev@vger.kernel.org, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4vf: configure ports accessible by the VF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200629115513.537757-1-nirranjan@chelsio.com>
References: <20200629115513.537757-1-nirranjan@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 15:54:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nirranjan Kirubaharan <nirranjan@chelsio.com>
Date: Mon, 29 Jun 2020 17:25:13 +0530

> Find ports accessible by the VF, based on the index of the
> mac address stored for the VF in the adapter. If no mac address
> is stored for the VF, use the port mask provided by firmware.
> 
> Signed-off-by: Nirranjan Kirubaharan <nirranjan@chelsio.com>

Applied.
