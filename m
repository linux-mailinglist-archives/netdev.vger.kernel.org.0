Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF1A62F627
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242105AbiKRNcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242131AbiKRNcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:32:07 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D048C491
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 05:31:46 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 63084388;
        Fri, 18 Nov 2022 14:31:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1668778304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Lcc+QPv7UPjROB6hLpK2O2cnL5EejsCTYcbVDTHlrQ=;
        b=kKYftdxdKTY0MYVU9v3/2bZ1xKGZxOqcYz9D6eNn9531g0pMCsNysAooNBlI9ws4OHZL2t
        cuHLIgZ6HIvd4y7hrFE35QdWwZ6byRvEk5d46nx6yI6AAbIsbC3xpXH8yozAK9R4EzVwzM
        YqoPmQIfUcF8UOCxY3zHFf0Ca3ptM92ZzzJftCvn8wVNQ2jh7IUHJKqqcHGZQgLj1HToQr
        myfk/bBB2Y+S8qWOPIPM2CnTvqCNXH+XJhY6Mz0/5mUqrEyk7unDqe4p1jIeBOlgFzGNYD
        5H05vH66e/5xEk3kevRhn2ykWbkP1/8qmrpBu8layRTe8ehhJKfSP6d/7i1F/Q==
MIME-Version: 1.0
Date:   Fri, 18 Nov 2022 14:31:44 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, davem@davemloft.net,
        edumazet@google.com, f.fainelli@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, olteanv@gmail.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: dsa: sja1105: disallow C45 transactions on the
 BASE-TX MDIO bus
In-Reply-To: <Y3Y6ABTvfzHUDm2u@lunn.ch>
References: <Y3TldORKPxFUgqH/@lunn.ch>
 <20221117081105.771993-1-michael@walle.cc> <Y3Y6ABTvfzHUDm2u@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <805e2fc947acf1f3ced5435b2427867a@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-11-17 14:41, schrieb Andrew Lunn:
> On Thu, Nov 17, 2022 at 09:11:05AM +0100, Michael Walle wrote:
>> From: Andrew Lunn <andrew@lunn.ch>
>> 
>> > I have a bit rotting patchset which completely separates C22 and C45,
>> > i just spend too much time reviewing other code to get my own merged.
>> 
>> I'm still rebasing your patchset to the latest next as I still
>> need it as a base for my patches regarding the maxlinear/microchip phy
>> issue :)
> 
> Feel free to post it. Just add your own Signed-off-by: after mine.
> 
> I can probably help with some of the review comments. I think the
> biggest problem i had was some reviews wanted more cleanup, when i was
> trying to keep it KISS to reduce the likelihood of breakage.

I wasn't aware that some of the patches were already sent to the
LKML. I guess you refer to this:
https://lore.kernel.org/netdev/20220508153049.427227-1-andrew@lunn.ch/

-michael
