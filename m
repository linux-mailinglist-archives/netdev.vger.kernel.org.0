Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91BA59CD3E
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbiHWAhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiHWAhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:37:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173024B4AE
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 17:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0AB561440
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA07EC433D6;
        Tue, 23 Aug 2022 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661215019;
        bh=DBfq1xh1CU+XTWY7iyTe7xCqqxhjlChR9Ly6QdsRIkg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MtCvZb30HOeKdRrBTA6gPl6fpf4DrYQyMAbwibqYpurszJ1BcWnBjV7BpZSeyNs8W
         3VtMWLEOoGLlWdDdiBKRZ5vfX3PHZ+psGf99uhaHc3gEqqDMpMimDkeXguj4ApAf/N
         b76PuAqjsayUbTPrXPOEGD7Pib4conbls+RSqDGbQKyU28pHbALYfrSoYVwJTNUQ5C
         YqpLzMhmTcf/sJbkWr/keOMoL1zBSwEsikEuW9oQ3VcpKVvrlu+5KkPj0dIWasgGS7
         f6IhJkLgWtzwCvnZXun87Jy/TPObSAeWOZLgahl1ifhZgFwKAabWq+hjLGJ2ZnvBb1
         7/FD3wG7IgMvQ==
Date:   Mon, 22 Aug 2022 17:36:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?SmFyb3PFgmF3IEvFgm9wb3Rlaw==?= <jkl@interduo.pl>
Cc:     netdev@vger.kernel.org
Subject: Re: Network interface - allow to set kernel default qlen value
Message-ID: <20220822173658.47598987@kernel.org>
In-Reply-To: <6cb185cf-d278-9fde-40c9-12b24332afc8@interduo.pl>
References: <6cb185cf-d278-9fde-40c9-12b24332afc8@interduo.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 10:41:40 +0200 Jaros=C5=82aw K=C5=82opotek wrote:
> Welcome netdev's,
> is it possible to set in kernel default (for example by sysctl) value of=
=20
> qlen parameter for network interfaces?
>=20
> I try to search: sysctl -a | grep qlen | grep default
> and didn't find anything.
>=20
> Now for setting the qlen - we use scripts in /etc/network/interface.
>=20
> This is not so important thing - but could be improved. What do You=20
> think about it?

What type of network interfaces are we talking about here?
Physical Ethernet links?
