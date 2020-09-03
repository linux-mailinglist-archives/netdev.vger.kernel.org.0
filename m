Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5D325C91A
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgICTHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgICTHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:07:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA9CC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 12:07:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E9B515C818C9;
        Thu,  3 Sep 2020 11:51:05 -0700 (PDT)
Date:   Thu, 03 Sep 2020 12:07:50 -0700 (PDT)
Message-Id: <20200903.120750.628973385343034465.davem@davemloft.net>
To:     pbarker@konsulko.com
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] Minor improvements to b53 dmesg output
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200903112621.379037-1-pbarker@konsulko.com>
References: <20200903112621.379037-1-pbarker@konsulko.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 11:51:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Barker <pbarker@konsulko.com>
Date: Thu,  3 Sep 2020 12:26:19 +0100

> These changes were made while debugging the b53 driver for use on a
> custom board. They've been runtime tested on a patched 4.14.y kernel
> which supports this board as well as build tested with 5.9-rc3. The
> changes are straightforward enough that I think this testing is
> sufficient but let me know if further testing is required.
> 
> Unfortunately I don't have a board to hand which boots with a more
> recent kernel and has a switch supported by the b53 driver. I'd still
> like to upstream these patches if possible though.

Series applied to net-next, thanks.
