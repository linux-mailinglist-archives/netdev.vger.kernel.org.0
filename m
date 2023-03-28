Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745E76CC154
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjC1Nqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjC1Nqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:46:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744E2A24F;
        Tue, 28 Mar 2023 06:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=0hN/CU8aZOETFIw+gJgS4+iXt8aaOblr5a1fb5YDdL0=; b=pK
        Vn6G9yngtMYbIzhclRcHbRES4WA91FGz+Rc7bX+HP4dsa951oo6ynxwSBMYlWYVAMJxvbfp4iYaZb
        dbprX4wmZjU72Bc6DQYMWA/AcYc8dSaYnU+v28dQGvmDptQY5M9btiIGUgJ4ECS3PqbgXyZoBe7ql
        ciwS19C8amnB+B8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ph9e3-008ePr-4w; Tue, 28 Mar 2023 15:45:51 +0200
Date:   Tue, 28 Mar 2023 15:45:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gustav Ekelund <gustaek@axis.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        Gustav Ekelund <gustav.ekelund@axis.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@axis.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Reset mv88e6393x watchdog
 register
Message-ID: <be2b5084-9cab-4cc7-ba50-a53dd71dfea5@lunn.ch>
References: <20230328115511.400145-1-gustav.ekelund@axis.com>
 <20230328120604.zawfeskqs4yhlze6@kandell>
 <9ba1722a-8dd7-4d6d-bade-b4c702c8387f@lunn.ch>
 <20230328124754.oscahd3wtod6vkfy@kandell>
 <c92234f1-099b-29a0-f093-c54c046d304a@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c92234f1-099b-29a0-f093-c54c046d304a@axis.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 03:34:03PM +0200, Gustav Ekelund wrote:

> 1) Marvell has confirmed that 6393x (Amethyst) differs from 6390 (Peridot)
> with quote: “I tried this on my board and see G2 offset 0x1B index 12 bit 0
> does not clear, I also tried doing a SWReset and the bit is still 1. I did
> try the same on a Peridot board and it clears as advertised.”
> 
> 2) Marvell are not aware of any other stuck bits, but has confirmed that the
> WD event bits are not cleared on SW reset which is indeed contradictory to
> what the data sheet suggests.

Hi Gustav

Please expand the commit message with a summary of this
information. It answers the questions both Marek and i have been
asking, so deserves to be in the commit message.

	Andrew
