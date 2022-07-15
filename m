Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051F957678F
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiGOThv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGOThs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:37:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1372599DE;
        Fri, 15 Jul 2022 12:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63DB8B82DFC;
        Fri, 15 Jul 2022 19:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6E3C34115;
        Fri, 15 Jul 2022 19:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657913865;
        bh=pQeC61oCW4TCk5zK0NUBRTJ+5ZqDV+FqvjopnaocqQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hz9VAhnsU2VhzPXPRjQf5IHGRah/cVdTcp8YRKVPslTSljExRhtCMwc7UAk/MNNmU
         frrUoqJfSmpzW3hWJBBXFx8qNWrfO4ZHWdOh3/uLBMZlalNpBqHep8Pyfl4L1Xt6zM
         GAF71ZN+mDmXAcVVxupBo2jR97mVU17liwOD32EksKRaHMNDZw+LMrKcH7xHwxxMxk
         Ifo3D2MH8fIuAdOpsl2vR+V/mdmi5VyfnJYd2aF9gnXgtavHPHkIQgZ+hpCD6OOoYB
         bfF6k8FNoqKvkkET/Bs4v6WYRzsGQmTdmZCkWmSFsIk5WVwRSZsQSYBahw/kzqUU/Q
         sWSSwkdMSELHg==
Date:   Fri, 15 Jul 2022 12:37:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: dsa: qca8k: move driver to qca dir
Message-ID: <20220715123743.419537e7@kernel.org>
In-Reply-To: <62d12418.1c69fb81.90737.3a8e@mx.google.com>
References: <20220713205350.18357-1-ansuelsmth@gmail.com>
        <20220714220354.795c8992@kernel.org>
        <62d12418.1c69fb81.90737.3a8e@mx.google.com>
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

On Fri, 15 Jul 2022 03:57:46 +0200 Christian Marangi wrote:
> > Does the split mean that this code will move again?
> > If so perhaps better to put this patch in the series 
> > that does the split? We're ~2 weeks away from the merge 
> > window so we don't want to end up moving the same code
> > twice in two consecutive releases.  
> 
> What to you mean with "will move again"?
>  
> The code will be split to qca8k-common.c and qca8k-8xxx.c
> And later qca8k-ipq4019.c will be proposed. 
> 
> So the files will all stay in qca/ dir.
> 
> Or should I just propose the move and the code split in one series?

Yup that's what I prefer.

> Tell me what do you prefer.
