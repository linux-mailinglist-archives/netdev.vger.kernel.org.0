Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141F558E7B2
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiHJHQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiHJHQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:16:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB0661D47;
        Wed, 10 Aug 2022 00:16:12 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E57805C5BF;
        Wed, 10 Aug 2022 07:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660115765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yJL4pi5S/TmjZAok31bc0Z8QfFsWJJKqEQ0zmfkOlkA=;
        b=nZJEO+cfxzqo4I2UMnc435uh1ZBy76f+YjRfdPqYxlUOEInOF2OUV9wBIqw+UB4nW3JGJH
        EWzq8YOGb8OJo4nB+vGqPo4DivcAbxd/0jeBH6JPtJqB2sZ25EKzuoO1wLOLdjvFu///8+
        DHZgi+IJliAeqBiG2MnLYpvoc+iJfyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660115765;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yJL4pi5S/TmjZAok31bc0Z8QfFsWJJKqEQ0zmfkOlkA=;
        b=qIByOLEQ/yX7cRdwe9+p+AnYY26sKm50aJ/xXfDvLr8ES/9KNNp/BXmIe2QzZdpYklA1Jh
        55olvsyfWQELSBCw==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9279A2C227;
        Wed, 10 Aug 2022 07:16:04 +0000 (UTC)
Date:   Wed, 10 Aug 2022 09:16:03 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <20220810071603.GR17705@kitsune.suse.cz>
References: <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
 <b1b33912-8898-f42d-5f30-0ca050fccf9a@seco.com>
 <20220809214207.bd4o7yzloi4npzf7@pali>
 <2083d6d6-eecf-d651-6f4f-87769cd3d60d@seco.com>
 <20220809224535.ymzzt6a4v756liwj@pali>
 <CAJ+vNU2xBthJHoD_-tPysycXZMchnXoMUBndLg4XCPrHOvgsDA@mail.gmail.com>
 <YvMF1JW3RzRbOhlx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvMF1JW3RzRbOhlx@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 03:11:48AM +0200, Andrew Lunn wrote:
> > Is something like the following really that crazy of an idea?
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index e0878a500aa9..a679c74a63c6 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -1151,6 +1151,15 @@ static int dev_alloc_name_ns(struct net *net,
> >         int ret;
> > 
> >         BUG_ON(!net);
> > +#ifdef CONFIG_OF
> > +       if (dev->dev.parent && dev->dev.parent->of_node) {
> > +               const char *name =
> > of_get_property(dev->dev.parent->of_node, "label", NULL);
> > +               if (name) {
> > +                       strlcpy(dev->name, name, IFNAMSIZ);
> > +                       return 0;
> > +               }
> > +       }
> > +#endif
> >         ret = __dev_alloc_name(net, name, buf);
> >         if (ret >= 0)
> >                 strlcpy(dev->name, buf, IFNAMSIZ);
> > 
> > I still like using the index from aliases/ethernet* instead as there
> > is a precedence for that in other Linux drivers as well as U-Boot
> 
> I guess you are new to the netdev list :-)
> 
> This is one of those FAQ sort of things, discussed every
> year. Anything like this is always NACKed. I don't see why this time
> should be any different.
> 
> DSA is somewhat special because it is very old. It comes from before
> the times of DT. Its DT binding was proposed relatively earl in DT
> times, and would be rejected in modern days. But the rules of ABI mean
> the label property will be valid forever. But i very much doubt it
> will spread to interfaces in general.

And if this is a FAQ maybe you can point to a summary (perhaps in
previous mail discusssion) that explains how to provide stable interface
names for Ethernet devices on a DT based platform?

On x86 there is a name derived from the device location in the bus
topology which may be somewhat stable but it is not clear that it
cannot change, and there is an optional BIOS provided table that can
asssign meaningful names to the interfaces.

What are the equivalents for DT?

Thanks

Michal
