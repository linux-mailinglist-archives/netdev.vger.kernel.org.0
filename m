Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7813D49339D
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 04:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351287AbiASD2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 22:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242776AbiASD2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 22:28:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C8EC061574;
        Tue, 18 Jan 2022 19:28:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D5E7B81892;
        Wed, 19 Jan 2022 03:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAE4C340E0;
        Wed, 19 Jan 2022 03:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642562885;
        bh=2MsAo9kYRAGOT7+lRBaSCth4s/uZCvxd2k5t2Ygxa7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dHkOfapkip8nSpAXApVIjOOf+S5ifR78JvTw/adGwjozBXjA/PY9jSGC8v2wHRZXr
         hTwuj+rdIOnTZo+ZigJ0cCxRBJ07ISfAv0+wKW7pQ3XxO2vzAe6TTiz6+e3SiBZVO+
         fzAsCRIznDhUnLCX40fv5JkiSqyjBtE+cqsYKcdUAHDOX7kIKFlJ1fmu52RO4OgKwy
         GXOqc5cxmEy/eimM+t5HAJrU/63jIcE6q2kIhgpVSbTbFFzIbgyH813mtywfbplP7m
         M17XjERCkvlV6bsY0mzDAFcoyBOhEQR8PTNymtNbNcaZJ5Cd6hh2K31pxBOz8D3Bfr
         uYJi0DDbMGpgQ==
Date:   Tue, 18 Jan 2022 19:28:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     chi.minghao@zte.com.cn, davem@davemloft.net, dsahern@gmail.com,
        dsahern@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, zealci@zte.com.cn
Subject: Re: [PATCH] net/ipv6: remove redundant err variable
Message-ID: <20220118192804.1032c172@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220119030003.929798-1-chi.minghao@zte.com.cn>
References: <20220112083942.391fd0d7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220119030003.929798-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 03:00:03 +0000 cgel.zte@gmail.com wrote:
> In the bot, I wrote a coccinelle rule myself to search for such problems,
> maybe use the rules to scan before submitting the patch.

Is it

scripts/coccinelle/misc/returnvar.cocci

? 

How many of such patches do you have pending?
