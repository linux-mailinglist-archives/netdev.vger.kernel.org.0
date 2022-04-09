Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36D4FA1FE
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 05:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiDIDks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 23:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiDIDkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 23:40:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64B41DA65
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 20:38:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7617BB82E30
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 03:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43DBC385A0;
        Sat,  9 Apr 2022 03:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649475519;
        bh=kv/fuUwiprDHbvilwdPNlSUYW1OUfP4QmcqEbMUiBb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b4zjqS/CSrEENvwWkcvZ+kt7oodbDPsgk4TB9XWuvIIJimX9dk+XJ1pxIY/rLzXIM
         /AM1g3t8mY2NxD5l0Sj2yYV09XA5xr25blXjjT5EvqtHvrIzfRVeVC/DkbrRIOjcgp
         vkH24d9/GJeX1QrEwFI9AWDoQeWMXoi77UlCPMTiBpzC6UldbhJn0u9hMNV/pwzjVo
         1flYPfWGUTnGItIMEOaME1rTI8yKdQfx/VYoKzyvcDokpZXEakAsSDoJxJEhiTDfvu
         jUgnttQavdLmfb48BnAhWdvcgv13v5rqakqWTO+9OkzW1KqWclNuS/p461Y877AapU
         9saPNYTlE33wg==
Date:   Fri, 8 Apr 2022 20:38:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next 3/5] netdevsim: Use dscp_t in struct
 nsim_fib4_rt
Message-ID: <20220408203837.44b6ae13@kernel.org>
In-Reply-To: <1f643c547fc22298afe21953492112de9b9df872.1649445279.git.gnault@redhat.com>
References: <cover.1649445279.git.gnault@redhat.com>
        <1f643c547fc22298afe21953492112de9b9df872.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Apr 2022 22:08:43 +0200 Guillaume Nault wrote:
> Use the new dscp_t type to replace the tos field of struct
> nsim_fib4_rt. This ensures ECN bits are ignored and makes it compatible
> with the dscp fields of struct fib_entry_notifier_info and struct
> fib_rt_info.
> 
> This also allows sparse to flag potential incorrect uses of DSCP and
> ECN bits.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
