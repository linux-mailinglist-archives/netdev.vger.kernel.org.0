Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E817F64E6B1
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 05:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiLPEbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 23:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiLPEa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 23:30:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D39E17881;
        Thu, 15 Dec 2022 20:30:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C36061FEB;
        Fri, 16 Dec 2022 04:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7C4C433EF;
        Fri, 16 Dec 2022 04:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671165055;
        bh=gwyCTB08Gn6gRja4qlC4hHeIYntHJ9ClMmeHFRxvnEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QjjJaonI2XnNgVOtCGD5OKn6MNsLuEYpkrX20Y0cyQbmXH2FWcUo3sX/QQGitE3FA
         P+qIcfXCFGV/la3GkpCIzCQnLL7Xc0HrmxrqhaMOPEST1XEi1RQZMrFBlyRtGUZ5ma
         ELz2Y0ZbNSK8hxN0qwx0k/y99IXi6AivSnefXTvI5hLCaIh1Lj+WVQy6O0bT1t7Mn0
         VIsjmI5i9jZ2xXCyYDlNgIV+cODM3xa+Bmi42Ls44re2rdRhvxnR7xSC1KoesFVJpI
         11Sho503YNu9pCAADXpYrI1RkEl9hGD3wfg/205CFGUN5ACSLC1baabOtm9X9scTmj
         0vji8O21UIqjw==
Date:   Thu, 15 Dec 2022 20:30:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RESEND PATCH v5 net-next 2/2] net: phy: micrel: Fix warn:
 passing zero to PTR_ERR
Message-ID: <20221215203053.1e4562d6@kernel.org>
In-Reply-To: <c2040e16d69d251f1a0690f0805388817aba8ab7.camel@gmail.com>
References: <20221214092524.21399-1-Divya.Koppera@microchip.com>
        <20221214092524.21399-3-Divya.Koppera@microchip.com>
        <c2040e16d69d251f1a0690f0805388817aba8ab7.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Dec 2022 07:58:57 -0800 Alexander H Duyck wrote:
> Looks good to me. You may need to resubmit once net-next opens.

And please drop the Fixes tags when reposting. Both patches look
like placating static analysis tools but there's not real issue.
