Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E21645F4F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 17:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLGQyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 11:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiLGQx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 11:53:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4777761755;
        Wed,  7 Dec 2022 08:53:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E193761B00;
        Wed,  7 Dec 2022 16:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2B8C433C1;
        Wed,  7 Dec 2022 16:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670432036;
        bh=YcRVQii9ZsxDcJbAKwxvX3D6KPuwOh3l/4wLOGYgwDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=icz0KAvi2zy9CLPwzPrSksMu+tYU7xEWRUYa587UyT6TVIyG2boR3Poj/FZWHrjAY
         xRUY3D24NFSU+nIQSqbU9CvIdx/KFU1asLutSIskldQ7szFV3nVVQD7/5LJ8RXvh/j
         7JYxnXuYS7a92jV9z5QBLwVgQRHGrHrUOvxJi9JxjKF8qUpYg60WOm8bL4zXaGPAqJ
         MiU4s1hgUycVPCcP/wx0w83KEiVtdHwwfuubV0RQYW75HFRxBiec3dNUaAznmHCkuj
         kgBpuSP+WSSJRJVzzkgrP/Sw9GzQCODu78eUF4iFrY/HBgSVHSF+iP5axDyM2mi+18
         UCAVZ152d3JQA==
Date:   Wed, 7 Dec 2022 08:53:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>
Subject: Re: [PATCH v2] MAINTAINERS: Update maintainer for Marvell Prestera
 Ethernet Switch driver
Message-ID: <20221207085354.6cab0e98@kernel.org>
In-Reply-To: <dc9fb975-6258-0473-3ed9-58d3a74e501a@plvision.eu>
References: <20221128093934.1631570-1-vadym.kochan@plvision.eu>
        <20221129211405.7d6de0d5@kernel.org>
        <96e3d5fc-ab8c-2344-3266-3b73664499f1@plvision.eu>
        <20221201131744.6e94c5f7@kernel.org>
        <dc9fb975-6258-0473-3ed9-58d3a74e501a@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Dec 2022 14:36:02 +0200 Taras Chornyi wrote:
> So we will drop this patch and create a new one with changing my email=20
> to PLVision one.

Hah, I was so proud of my nice and polite email, and yet this is all
the engagement we get.. :)  Oh, well =F0=9F=A4=B7=EF=B8=8F
