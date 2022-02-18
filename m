Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D8B4BB4D3
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 10:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiBRJB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 04:01:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbiBRJBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 04:01:54 -0500
X-Greylist: delayed 65747 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Feb 2022 01:01:35 PST
Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41B950E0A
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 01:01:35 -0800 (PST)
Date:   Fri, 18 Feb 2022 09:01:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casan.se;
        s=protonmail; t=1645174892;
        bh=CnbsTehi8nazSv20dhwSQWYGp8iAxKP40Cn8QqJLrxA=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=i9Vso3HCvMGtdaUnmCyCgc9LXW83JL47IQ/Lv46wbGNPUMovXSyrcmqo0Tr91Dj+5
         qtmQlcPWWYdYv3KLF+WIyzVWiujGv9N29Txa2LsiuyOxIVl3YqaJDAi5ZLWJjlXTae
         1Yfg+vHWMg3FHrMk7DKVS/pIbQstGc/0VHLclNY2FWqQo/LDYvNYGLOf1qX4wh0U5G
         qnGK8QPTPlV7OsloKrnr8bRfspHlL1SsSvBr6Oh4fZ+pVHwa8l7v7K1aOP/UE/tLE5
         v7nSuTv6jFiJQQtCBr/mAMNF5yraOlcH0Nsb/OVcB0uBleLWl0PpNWLA0wzDT/a2Wn
         3cNTxwjaa7Sjw==
To:     Jakub Kicinski <kuba@kernel.org>
From:   Casper Andersson <casper@casan.se>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Reply-To: Casper Andersson <casper@casan.se>
Subject: Re: [PATCH net-next] net: sparx5: Support offloading of bridge port flooding flags
Message-ID: <20220218090127.vutf5qomnobcof4z@wse-c0155>
In-Reply-To: <20220217201830.51419e5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220217144534.sqntzdjltzvxslqo@wse-c0155> <20220217201830.51419e5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/02/17 08:18, Jakub Kicinski wrote:
> On Thu, 17 Feb 2022 14:45:38 +0000 Casper Andersson wrote:
>
> Can others see this patch? My email client apparently does not have
> enough PGP support enabled. I'm worried I'm not the only one. That said
> lore and patchwork seem to have gotten it just fine:
>
> https://lore.kernel.org/all/20220217144534.sqntzdjltzvxslqo@wse-c0155/
> https://patchwork.kernel.org/project/netdevbpf/patch/20220217144534.sqntz=
djltzvxslqo@wse-c0155/

I apologize. This seems to be Protonmail's doing. When I look at the
web interface for Protonmail I can see that you are the only recipient
it says PGP encrypted for. This is probably because Protonmail will
automatically encrypt when both ends use Protonmail. Though I do not see
this indication on your reply. I tried switching to PGP/Inline instead
of PGP/MIME for this message. I hope this works.  Otherwise, I can
resubmit this patch using another email address. I did not find a way
to disable the automatic encryption. Or if you have any other
suggestions to get around this.

