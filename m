Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E8E39EC1A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhFHCdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhFHCdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:33:35 -0400
Received: from frotz.zork.net (frotz.zork.net [IPv6:2600:3c00:e000:35f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40461C061574
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 19:31:43 -0700 (PDT)
Received: by frotz.zork.net (Postfix, from userid 1008)
        id C34091198A; Tue,  8 Jun 2021 02:31:41 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 frotz.zork.net C34091198A
Date:   Mon, 7 Jun 2021 19:31:41 -0700
From:   Seth David Schoen <schoen@loyalty.org>
To:     13145886936@163.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: Re: [PATCH] net: appletalk: fix some mistakes in grammar
Message-ID: <20210608023141.GP2193875@frotz.zork.net>
Mail-Followup-To: Seth David Schoen <schoen@loyalty.org>,
        13145886936@163.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
References: <20210608022546.7587-1-13145886936@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608022546.7587-1-13145886936@163.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

13145886936@163.com writes:

>   * Ergo, before the AppleTalk module can be removed, all AppleTalk
> - * sockets be closed from user space.
> + * sockets should be closed from user space.
>   */

This is a good correction, but in the other case

>  		/*
>  		 * Phase 1 is fine on LocalTalk but we don't do
> -		 * EtherTalk phase 1. Anyone wanting to add it go ahead.
> +		 * EtherTalk phase 1. Anyone wanting to add it goes ahead.

"go ahead" is meant as an imperative (like "If you want to add EtherTalk
phase 1 support, please go ahead [and do so]"), not an indicative (like
"If you want to add EtherTalk phase 1 support, you are adding it").  It
is an invitation addressed to future developers.

Addressing unspecified people directly in the second person with "anyone"
is a little unusual, but is grammatically acceptable (more usually with a
comma).  Anyone reading this, you now understand this point.
