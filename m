Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE095A869B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiHaTSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiHaTSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:18:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A9FDA3E5;
        Wed, 31 Aug 2022 12:18:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32D93B822A8;
        Wed, 31 Aug 2022 19:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908DAC433D6;
        Wed, 31 Aug 2022 19:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661973521;
        bh=lw0bo/aZdnQkaSTwIVjalMQkB0iCNZeNMZ8fT7exdk4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VS2Q1eXxkLF++1IUNqg4fZY4nP38EWxOhGf97KAha/GumvwszW8XHileui+WDkvo3
         0pAGsb2z/lDku3W9YkC3b5edKmUYuXhTbFNYjN4DVe4PnAaXl4To/EScClstO7ZzrX
         LUFIe60ZeyL0l5rmYMJR5uoo9CxZKqWW/XpyLCIXXInbWfSuQO2BsDLaAxXGh3qpyR
         W6uzF3YuG+sSdAz7gbMyYiMgk+mhjaM0Jdebpr/JIki5qyvEKOP7mXpcHiBHlHr3+v
         h9s61ssLLv9xtwQUfzquK49N62Evr1Kw6TlRFRiytvx3fGOldwogBp7qu0UggTo/RO
         13PuHYTv4V4/Q==
Date:   Wed, 31 Aug 2022 12:18:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QW5kcsOp?= Apitzsch <git@apitzsch.eu>
Cc:     Aaron Ma <aaron.ma@canonical.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8152: Add MAC passthrough support for Lenovo Travel
 Hub
Message-ID: <20220831121840.293837df@kernel.org>
In-Reply-To: <20220827184729.15121-1-git@apitzsch.eu>
References: <20220827184729.15121-1-git@apitzsch.eu>
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

On Sat, 27 Aug 2022 20:47:29 +0200 Andr=C3=A9 Apitzsch wrote:
> The Lenovo USB-C Travel Hub supports MAC passthrough.
>=20
> Signed-off-by: Andr=C3=A9 Apitzsch <git@apitzsch.eu>

Which tree did you base this patch on?

Please rebase on top of net-next [1] and repost with [PATCH net-next] in
the subject.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
