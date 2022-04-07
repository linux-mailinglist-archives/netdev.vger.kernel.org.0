Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC7D4F84B8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345674AbiDGQTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345659AbiDGQTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:19:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7531E6F84
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WHtWvCcHvMLeywzN7JpkaBHNxci5M6pW3QAKDubNUGw=; b=Vt9fOuMQ+XZbc1Hg8cG7dALhQZ
        zyOkOodipJYPS5Z/dlC8f3jNyytKuS9+aspqiSNcVkXYf3fugvOsBfH9hPY0cmvfdD9cgiWL8BRB9
        6QCmblGe82BXRSoImz17zfNgs+NN9TxRJ068pbLuF2u3zO0/8qn0Dm7S8ZCaMcv6Y0j4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncUVT-00Efe5-Gp; Thu, 07 Apr 2022 17:57:11 +0200
Date:   Thu, 7 Apr 2022 17:57:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 00/14] MediaTek SoC flow offload improvements +
 wireless support
Message-ID: <Yk8J1xjbClhuAdBG@lunn.ch>
References: <20220405195755.10817-1-nbd@nbd.name>
 <164925181755.19554.1627872315624407424.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164925181755.19554.1627872315624407424.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 01:30:17PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Tue,  5 Apr 2022 21:57:41 +0200 you wrote:
> > This series contains the following improvements to mediatek ethernet flow
> > offload support:
> > 
> > - support dma-coherent on ethernet to improve performance
> > - add ipv6 offload support
> > - rework hardware flow table entry handling to improve dealing with hash
> >   collisions and competing flows
> > - support creating offload entries from user space
> > - support creating offload entries with just source/destination mac address,
> >   vlan and output device information
> > - add driver changes for supporting the Wireless Ethernet Dispatch core,
> >   which can be used to offload flows from ethernet to MT7915 PCIe WLAN
> >   devices

Hi David

It seems very early to merge this. The discussion of if the files are
even in the right places has not even finished. And Arnd seems to not
want parts of this in his subsystem. And there are some major
architecture issues which need discussing...

I think you should revert this.

  Andrew
