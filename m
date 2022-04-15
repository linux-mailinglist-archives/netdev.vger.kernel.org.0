Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7719B502BFE
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 16:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350924AbiDOOiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 10:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiDOOiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 10:38:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EEE41619;
        Fri, 15 Apr 2022 07:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5RyQgEC1HEfGTnmZF0JawQFMsn2Sbm5XUHT2q7t6y2U=; b=xTmF59vKdWU3OVIrzTm3k8yuGP
        TajKjIfn1rfAGjih4X2g8hsbNj1EP0kL6YDqnkF/sI2KY6UCw6GIV84WH1EInuNaZvdTyLcuh6lF5
        OairZIFgSrpSdZ/nfqOCPoH3qax3SJrGhP77EXQCoxsuOWzyzskEZhv7M3HAHetDRseU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nfN2m-00Fyrn-5W; Fri, 15 Apr 2022 16:35:28 +0200
Date:   Fri, 15 Apr 2022 16:35:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Message-ID: <YlmCsMk/GekmdewG@lunn.ch>
References: <20220411210406.21404-1-luizluca@gmail.com>
 <20220412105018.gjrswtwrgjyndev4@bang-olufsen.dk>
 <CAJq09z53MZ6g=+tfwRU-N5BV5GcPSB5n0=+zj-cXOegMrq6g=A@mail.gmail.com>
 <20220414014527.gex5tlufyj4hm5di@bang-olufsen.dk>
 <CAJq09z6KSQS+oGFw5ZXRcSH5nQ3zongn4Owu0hCjO=RZZmHf+w@mail.gmail.com>
 <20220414113718.ofhgzhsmvyuxd2l2@bang-olufsen.dk>
 <YlgmG3mLlRKef+sy@lunn.ch>
 <CAJq09z5hG7VkhkxdhVTUvA-dMJr6_ajkHYBZ6N2ROFXLz0gijQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z5hG7VkhkxdhVTUvA-dMJr6_ajkHYBZ6N2ROFXLz0gijQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Now, about dt-bindings, I don't know what is the best approach. As
> device-tree should not focus on Linux, it is strange to use a
> compatible "rtl8365mb" just because it is the Linux subdriver name and
> that name was just because it was the first device supported.

What you are trying to express is, how do you access the ID
register. There is no obvious One True Compatible string for that. So
just picking one switch name for that is O.K. There is nothing Linux
specific in that, FreeBSD or whatever can use the label as a clue
where to find the ID register.

> +      realtek,rtl8365mb:
> +        Use with models RTL8363NB, RTL8363NB-VB, RTL8363SC, RTL8363SC-VB,
> +        RTL8364NB, RTL8364NB-VB, RTL8365MB, RTL8366SC, RTL8367RB-VB, RTL8367S,
> +        RTL8367SB, RTL8370MB, RTL8310SR
> +      realtek,rtl8367rb:
> +        Use with models RTL8366RB, RTL8366S

So to me, this is fine. But i might add a bit more detail, that the
compatible is used by the driver to find the ID register, and the
driver then uses to ID register to decide how to drive the switch. The
problem i had with the mv88e6xxx binding was until i spelt this out in
the binding, people kept submitting patches adding new compatible
strings, rather than extend the documented list of switches supported
by a compatible.

       Andrew
