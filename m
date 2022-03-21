Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157AC4E27B6
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347865AbiCUNgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347958AbiCUNgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:36:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBD242A0F
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 06:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647869698; x=1679405698;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dSI9dDXqbTo3D+fepbW8RzD8l2OGz/FhmWlBICLA6IA=;
  b=xWegLPIkTRTy8m2E6Wt/tuZqMhg1/UHSAkdIk7lzmDimelsiSTvd/U7Y
   pCnG6wFcIKexsTltI2EOS7YrS40oxaup7DnrKUZX8aPb/N4gl7mhBpp+N
   TutGHjl+FOd8uyr9ewP87mpO9z+GZxS0KXoY86JG+5lofEcyYI+uZl/JJ
   ki7V2bf+V3QhcGOLxXSozJ9emZSU88Oll+pu+/TgdeCJ0KlfqAz17YLMG
   qQIUBHU8duNGuafvbn0CArgsGytKFDjxzPJhf6pU3Mh11S8zSvjmwthGN
   9kj/sF9tAjgK6h5YN9+G16ESf+mnNOR++DhvN4wiFfoU+HOgMn44EL+b5
   w==;
X-IronPort-AV: E=Sophos;i="5.90,198,1643698800"; 
   d="scan'208";a="166518473"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 06:34:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 06:34:57 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 06:34:56 -0700
Message-ID: <2c3b730d91c8a39e3e6131237ff1274dbd4b9cbb.camel@microchip.com>
Subject: Re: [PATCH net-next 0/2] net: sparx5: Add multicast support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Date:   Mon, 21 Mar 2022 14:33:34 +0100
In-Reply-To: <164786941368.23699.3039977702070639823.git-patchwork-notify@kernel.org>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
         <164786941368.23699.3039977702070639823.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

That must be a mistake.

I have just added some comments to the series, and I have not had more than a few hours to look at
it, so I do not think that you have given this enough time to mature.

BR
Steen

On Mon, 2022-03-21 at 13:30 +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Mon, 21 Mar 2022 11:14:44 +0100 you wrote:
> > Add multicast support to Sparx5.
> > 
> > --
> > I apologies, I accidentally forgot to add the netdev
> > mailing list the first time I sent this. Here it comes
> > to netdev as well.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net-next,1/2] net: sparx5: Add arbiter for managing PGID table
>     https://git.kernel.org/netdev/net-next/c/af9b45d08eb4
>   - [net-next,2/2] net: sparx5: Add mdb handlers
>     https://git.kernel.org/netdev/net-next/c/3bacfccdcb2d
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 

