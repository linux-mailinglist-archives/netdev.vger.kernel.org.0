Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB672581C1
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgHaT3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgHaT3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:29:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BEFC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:29:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E73281288D834;
        Mon, 31 Aug 2020 12:12:18 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:29:04 -0700 (PDT)
Message-Id: <20200831.122904.1733665771627459300.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] sfc: clean up some W=1 build warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
References: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:12:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Fri, 28 Aug 2020 18:48:25 +0100

> A collection of minor fixes to issues flagged up by W=1.
> After this series, the only remaining warnings in the sfc driver are
>  some 'member missing in kerneldoc' warnings from ptp.c.
> Tested by building on x86_64 and running 'ethtool -p' on an EF10 NIC;
>  there was no error, but I couldn't observe the actual LED as I'm
>  working remotely.
> 
> [ Incidentally, ethtool_phys_id()'s behaviour on an error return
>   looks strange ― if I'm reading it right, it will break out of the
>   inner loop but not the outer one, and eventually return the rc
>   from the last run of the inner loop.  Is this intended? ]

Series applied, thanks.
