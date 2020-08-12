Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D96242FE7
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 22:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgHLUMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 16:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgHLUMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 16:12:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB5BC061383;
        Wed, 12 Aug 2020 13:12:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8455E12852AE6;
        Wed, 12 Aug 2020 12:55:30 -0700 (PDT)
Date:   Wed, 12 Aug 2020 13:12:15 -0700 (PDT)
Message-Id: <20200812.131215.1747166244140307990.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes.berg@intel.com
Subject: Re: [PATCH] ipv4: tunnel: fix compilation on ARCH=um
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200812210852.dc434e0b40e9.I618f37993ea3ddb2bec31e9b54e4f4ae2f7b7a51@changeid>
References: <20200812210852.dc434e0b40e9.I618f37993ea3ddb2bec31e9b54e4f4ae2f7b7a51@changeid>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Aug 2020 12:55:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 12 Aug 2020 21:08:53 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> With certain configurations, a 64-bit ARCH=um errors
> out here with an unknown csum_ipv6_magic() function.
> Include the right header file to always have it.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied, thank you.
