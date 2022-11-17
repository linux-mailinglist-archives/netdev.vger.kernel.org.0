Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D3B62E5B1
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiKQUP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240319AbiKQUPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:15:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DF086A79;
        Thu, 17 Nov 2022 12:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JzBJRWys7hmBHBKeMNHEuFcI/VwS1xwfjIiorP4uTYQ=; b=I5gexTUtNpp0792tJirhroAPdn
        LnMo45jQ7mkAHFFcyA6HE0yjkw7HipcbfkBDgTe0k1ttwKEh3VpTZo4i3+iDh2NX+IXqk8TpuDeDj
        6EleMdhQ+R6Y8nhlcdPfJR6SNjMAufbctBtFkYLp8cAeKgAvjVt1LUX1PQJ1h0fuLFrE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovlHS-002j30-5F; Thu, 17 Nov 2022 21:14:38 +0100
Date:   Thu, 17 Nov 2022 21:14:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel.Machon@microchip.com
Cc:     luwei32@huawei.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Lars.Povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net-next] net: microchip: sparx5: remove useless code in
 sparx5_qos_init()
Message-ID: <Y3aWLiuC+e03awzx@lunn.ch>
References: <20221117145820.2898968-1-luwei32@huawei.com>
 <Y3ZF6gLy7hjW0KAx@DEN-LT-70577>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3ZF6gLy7hjW0KAx@DEN-LT-70577>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> sparx5_qos_init() will be expanded in later patch series, as new QoS
> features require new initializations - so this is actually somewhat
> intentional.

When do you expect such patches to land?

If it going to be soon, we can keep the code as it is. If it is going
to be a while, the bots are going to keep finding this and what to
remove it.

     Andrew
