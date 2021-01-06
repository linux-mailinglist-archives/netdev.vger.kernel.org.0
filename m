Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ECB2EC2FF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbhAFSMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:12:02 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:49931 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbhAFSMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 13:12:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 92D885804F3;
        Wed,  6 Jan 2021 13:11:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 06 Jan 2021 13:11:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PjGRuV
        WfkTrQS/+FyazTGDq4ZiN+2N6M3csDhwVcyNQ=; b=Mi5+erzRS2pfTk8hrg6ALX
        EBAsjZ8JjyTWkpJVHQ4yr+NFtZR51RwU5Vfs6v3w6NNnHiYUT9MqSPDe8U6uD1M7
        SplYo9h72OeubOh3lgn+t/ajgsg1OfGvcic8Hti6VhBUTbzQJcxBQ6zdTn2OFxoR
        QmTl9uJzOMxvfYpUwO0gR3Ji2skDxj8WJKzEMt2OfQGAOtoZ/L8QCIlewRXUzoSh
        zeCzwlU2qEUdchWSJEdTm7ZjB61O6ElgwlepJZiefj/0OHKQDzfZQYdjIVspLlqa
        LJ59VEpXL/w//ptYNACB4ziaJgXr1PjxvPhEutTqLD5rlwjtg8XAKnqG9h/3MGgw
        ==
X-ME-Sender: <xms:Qf31X1GrYqfnNHlIKl4C7OBBn2JOIjI341HYJ6hvN7_ICUS6vOSnWg>
    <xme:Qf31X6XTj1-pf4ihMpwNwCvw-BOPc5xPCdzoZJSJVJeHMEQ9uh1UU9i2uSU7AfGwU
    UVJofdP3y8ODqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegtddgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Qf31X3Kz3xGx8jyCfjx4iVEiRG4ciBKW5JfrL_9NaVz__P-34XIQnQ>
    <xmx:Qf31X7E_cyU5N3CSQpi0W_et1Srfe2jAtxikW9ybuIUiFNNl4FY_KA>
    <xmx:Qf31X7Xouu6PhX9wQqnNgG55zacAq370MY1J1h0RV3-MFLE4EnrZtg>
    <xmx:RP31X6brozcJMINrRc-XxUOvIGvsxJ9ac8YYkvWLGZY1VkTi1mMW3g>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60C16240067;
        Wed,  6 Jan 2021 13:11:12 -0500 (EST)
Date:   Wed, 6 Jan 2021 20:11:10 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 10/10] net: switchdev: delete the transaction
 object
Message-ID: <20210106181110.GE1082997@shredder.lan>
References: <20210106131006.577312-1-olteanv@gmail.com>
 <20210106131006.577312-11-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106131006.577312-11-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 03:10:06PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Now that all users of struct switchdev_trans have been modified to do
> without it, we can remove this structure and the two helpers to determine
> the phase.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
