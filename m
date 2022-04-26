Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A482510B2F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 23:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355351AbiDZVZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 17:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbiDZVZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 17:25:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642471569C2;
        Tue, 26 Apr 2022 14:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01C95B82169;
        Tue, 26 Apr 2022 21:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72590C385A0;
        Tue, 26 Apr 2022 21:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651008111;
        bh=oQKIZeX0vjJRXISGY0Cj3XrlmDdDeH8MMA61IbImjZ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hC7PunJ/yupon2K+QiiyJvSRk/WqOKcxcYwnKo+ovJjuI0zDQ6z/gt0vHaZfgGKOr
         lLrWmTm2J+B/p6at3rW80e7iq8NjCiR6RgsENxdS3DH8v2ZDL/inBlimLK9EVGPiOL
         3FcjaFpCBGCd4ZPqPzERI9Wx+Oi548YCIjiIZyQQ7S4ZZ2bc1xfPuYej2uu5aY7ivp
         xhQ7QXoRHtcgXEK53bP7z1FzJdmiWFWtC4bFLGNLCfh7pblxotCHqMu03DDl/E6vGQ
         f5l2qwVBkm6BOEVsqfnnf7x1unAx0l2x01vLUA9GZnpXBZYurePW6HukW6Ti4q/63e
         wKD0QPch5biSw==
Date:   Tue, 26 Apr 2022 14:21:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Message-ID: <20220426142150.47b057a3@kernel.org>
In-Reply-To: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
References: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 15:32:53 -0400 Min Li wrote:
> Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY
> for gettime and settime exclusively

Does not build on 32 bit.

> -/*
> +/**
>   * Maximum absolute value for write phase offset in picoseconds
>   *
> + * @channel:  channel
> + * @delta_ns: delta in nanoseconds
> + *

Not a proper kdoc, first line must include struct name or function name.

Please wait 24h with reposting fixed version so other feedback has a
chance to come in.
