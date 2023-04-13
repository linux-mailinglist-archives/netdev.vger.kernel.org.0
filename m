Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B697D6E03AA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjDMB2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDMB2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F6B1712;
        Wed, 12 Apr 2023 18:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 049FC6199F;
        Thu, 13 Apr 2023 01:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962FEC4339B;
        Thu, 13 Apr 2023 01:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681349278;
        bh=/+lLsznPD4Tfw4KoH3ooUloROTizyNl4PVM3b6gcHWw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Peu8FDv+CWd5+eeGRnvpONwDk0gcBnaoXcxWnUhHKSK80WY1iuHKQDCfA9QLeIlwY
         9N+p47H2j2vpi4IZYjrvE7mxTWGfFQyoScTHmh1S/Pae3Ej6+686x/jEzN3gV0Ys+5
         0ZOuqdH7MIuGxR4xS3xt1pPYsZyMl/drB5r4H8Zz0rzONO47GFVTNFuN0XlkyQQxYX
         QDv5iIL+DfEfCNZgh/Ln9I81tL/UcI9g4HCXT1fEhU2VTFMBoH/XPzwY76snGOkyyc
         4hjnsMQmBntdO1ojJo7fi/5gc9SmaBaZnKGyuA34pFeZ5ATyPUkXZ/DKoody/NLwWI
         Odo3bv5peHCOA==
Date:   Wed, 12 Apr 2023 18:27:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <andrew@lunn.ch>, <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
Subject: Re: [net-next Patch v9 0/6] octeontx2-pf: HTB offload support
Message-ID: <20230412182756.6b1d28c6@kernel.org>
In-Reply-To: <20230411090359.5134-1-hkelam@marvell.com>
References: <20230411090359.5134-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 14:33:53 +0530 Hariprasad Kelam wrote:
> octeontx2 silicon and CN10K transmit interface consists of five
> transmit levels starting from MDQ, TL4 to TL1. Once packets are
> submitted to MDQ, hardware picks all active MDQs using strict
> priority, and MDQs having the same priority level are chosen using
> round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
> Each level contains an array of queues to support scheduling and
> shaping.


Looks like Jake's comments from v7 apply.

Jake, sorry for not cleaning up patchwork the bad series name has
fooled the bot.
