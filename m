Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7181051DB20
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 16:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442481AbiEFOzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 10:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442476AbiEFOzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 10:55:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF4C6A055;
        Fri,  6 May 2022 07:51:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C0E7B83667;
        Fri,  6 May 2022 14:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8A6C385A9;
        Fri,  6 May 2022 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651848691;
        bh=jIw32154qoc6CQkkY7vKJh16ULzNnht9HgoMWRoaS5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jgMBjBe6qccy7wsB/K4frewnFWBhdL35JVPrFFlsX+f9Tj7Ya7rWk+ilu6/5bJVq8
         Oc4hi3Tn1hZd+Kp/n4WETCHrBAusKVLvMX8odR5Zs/GRapwbMncuGLobdc44RggDeg
         5ysLxFDrwQZ2iILhsOwvAdAA1FGYrdJAMH3ap0BA=
Date:   Fri, 6 May 2022 16:51:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: Fix race condition on link status change
Message-ID: <YnU17/cVA0i3UStL@kroah.com>
References: <20220506060815.327382-1-francesco.dolcini@toradex.com>
 <20220506101031.GA417678@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506101031.GA417678@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 12:10:31PM +0200, Francesco Dolcini wrote:
> Hello,
> I have one question about the process of patch/fixes backporting
> to old stable kernel.
> 
> Assuming the following patch will be deemed correct and applied it will
> have to be eventually backported.
> 
> This patch will apply cleanly on v5.15+, but some work is needed to
> backport to v5.10 or older.
> 
> Should I send a patch for the older kernels once the fix is merged?
> Reading Documentation/process/stable-kernel-rules.rst it was not clear
> to me what to do in this "mixed" situations.

You will get an email from me if it does not apply to older kernels and
you can respond with the backported fix then.

thanks,

greg k-h
