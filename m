Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0570166AB0
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgBTXC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:02:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59984 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgBTXC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:02:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0286A15BCCC5F;
        Thu, 20 Feb 2020 15:02:56 -0800 (PST)
Date:   Thu, 20 Feb 2020 15:02:56 -0800 (PST)
Message-Id: <20200220.150256.1985568981833050465.davem@davemloft.net>
To:     rkir@google.com
Cc:     kuba@kernel.org, rammuthiah@google.com, adelva@google.com,
        lfy@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: disable BRIDGE_NETFILTER by default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219214006.175275-1-rkir@google.com>
References: <20200219214006.175275-1-rkir@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 15:02:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: rkir@google.com
Date: Wed, 19 Feb 2020 13:40:06 -0800

> From: Roman Kiryanov <rkir@google.com>
> 
> The description says 'If unsure, say N.' but
> the module is built as M by default (once
> the dependencies are satisfied).
> 
> When the module is selected (Y or M), it enables
> NETFILTER_FAMILY_BRIDGE and SKB_EXTENSIONS
> which alter kernel internal structures.
> 
> We (Android Studio Emulator) currently do not
> use this module and think this it is more consistent
> to have it disabled by default as opposite to
> disabling it explicitly to prevent enabling
> NETFILTER_FAMILY_BRIDGE and SKB_EXTENSIONS.
> 
> Signed-off-by: Roman Kiryanov <rkir@google.com>

Applied.
