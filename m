Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FAE4BC557
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbiBSE06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:26:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiBSE06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:26:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B0B643F
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 20:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B62B760A65
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 04:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC72C004E1;
        Sat, 19 Feb 2022 04:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645244798;
        bh=9tzVAdqhy4RE71XRu/2Zv6eYP//5FctrMFRKBCcyUt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cDsn5OYbBQ+8DMQLCBKHffCodTWPy2f6q9T5Dm2LsCtooAvth/yEBnnP+a1cbvDz4
         UZs3GjQcvE7bXjPYS5m7rZWP/hfq7dQYKILMCKzvb6/eUMFDos1u1ZUYRJ4iW2XAn7
         NyG91ZwrqoLPINSL1Z3MTRh3Ym7sfm8jay1qCwTr6gMXPcziHF5yqCcklC/4PA0Wub
         NFkcm/M+8metOMQHPktwFT2ivxXF8leA+uq+SHTTxrr+XokhpF3tnzXLo4tp0Lkj8I
         DfeR+qFnHY2U0dkY+m/RPnzjsdO+ck+/pxdulZx1tYFhpgpOmnpfknHGmV+phuK1fx
         hP/0mfUf0wsBg==
Date:   Fri, 18 Feb 2022 20:26:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Casper Andersson <casper@casan.se>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sparx5: Support offloading of bridge port
 flooding flags
Message-ID: <20220218202636.5f944493@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220218090127.vutf5qomnobcof4z@wse-c0155>
References: <20220217144534.sqntzdjltzvxslqo@wse-c0155>
        <20220217201830.51419e5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220218090127.vutf5qomnobcof4z@wse-c0155>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 09:01:30 +0000 Casper Andersson wrote:
> On 22/02/17 08:18, Jakub Kicinski wrote:
> > On Thu, 17 Feb 2022 14:45:38 +0000 Casper Andersson wrote:
> >
> > Can others see this patch? My email client apparently does not have
> > enough PGP support enabled. I'm worried I'm not the only one. That said
> > lore and patchwork seem to have gotten it just fine:
> >
> > https://lore.kernel.org/all/20220217144534.sqntzdjltzvxslqo@wse-c0155/
> > https://patchwork.kernel.org/project/netdevbpf/patch/20220217144534.sqntzdjltzvxslqo@wse-c0155/  
> 
> I apologize. This seems to be Protonmail's doing. When I look at the
> web interface for Protonmail I can see that you are the only recipient
> it says PGP encrypted for. This is probably because Protonmail will
> automatically encrypt when both ends use Protonmail. Though I do not see
> this indication on your reply. I tried switching to PGP/Inline instead
> of PGP/MIME for this message. I hope this works.  Otherwise, I can
> resubmit this patch using another email address. I did not find a way
> to disable the automatic encryption. Or if you have any other
> suggestions to get around this.

If I'm the only one who didn't get the plain text version - it's not 
a big deal.

Steen, can we get a review? 
