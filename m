Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FF656298E
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiGAD1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiGAD1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:27:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2D05C9F9
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 20:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 990ACB82B46
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 03:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEDDC341C6;
        Fri,  1 Jul 2022 03:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656646027;
        bh=YzPdqhezWViEdthvg0QRt4wmsEGJ40LIGQrdVBby1PM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ijbNvwyuV8xMPF1lQfNdsfCEZTs6pp1aBtgx63bUwGpI+/xltSwQpGP4g3j/2fBq1
         l3mVAdRG65lztUaMBBv0302hBgBf4VVYDq0R9sRAUrtJ9RpJOlVQqNJf6BrGVKeNtp
         0qhRvCdqe0AYfo51IzNR8siw7VncmoD5Pk1BQagdJFTfKbo+YI+04A1ljK+FYICtsu
         DbdAzZ89xRTBtQawQFvYSIQ8Sjurjvpf3tEu+XKAOMAgcsaRG3C8rweJdaNBFCsUa1
         2wTvFblsoPW7CLoK7pAjIT64Je65JfFEfybmUgCfuOZqAs8ceKTbkToN15XX8hjwc0
         9DDbbXS8SaImw==
Date:   Thu, 30 Jun 2022 20:27:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] ip6mr: implement RTM_GETROUTE for single
 entry
Message-ID: <20220630202706.33555ad2@kernel.org>
In-Reply-To: <20220630133051.41685-1-equinox@diac24.net>
References: <20220630133051.41685-1-equinox@diac24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 15:30:49 +0200 David Lamparter wrote:
> The IPv6 multicast routing code implements RTM_GETROUTE, but only for a
> dump request.  Retrieving a single MFC entry is not currently possible
> via netlink.
> 
> While most of the data here can also be retrieved with SIOCGETSGCNT_IN6,
> the lastused / RTA_EXPIRES is not included in the ioctl result (and we
> need it in FRR.)
> 
> => Implement single-entry RTM_GETROUTE by copying and adapting the IPv4  
> code.
> 
> Tested against FRRouting's (work-in-progress) IPv6 PIM implementation.

You must CC maintainers (./scripts/get_maintainer.pl). With the patch
volume on netdev and constant trouble with gmail the chances of people
missing a submission are just too high. Please repost.
