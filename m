Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4051727E1E4
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 08:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgI3G4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 02:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI3G4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 02:56:09 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21042C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 23:56:08 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id nw23so1213707ejb.4
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 23:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=seqWg6438avW/SyZJnQRajfGCr85wJolvYrN3kEylco=;
        b=raJc62wW7lnAdJ0Yowq4+HgZc9IrVQILbQqli+DYDdPfz7w+ah1AjvGDaRLQ+59Bgh
         nesacY9Ve8t10KDIG5aInit41WvuCLmRSSg4RNEjH0/3rupo+YILxwhp2P5EF2feR4FP
         46nN3sH0tiBhCNGvC2GzayoRD1mWkd/6iRBmClcEiLm6sPZwP8BVIh34wmy6Z6kFR7Pj
         ZA6Cmo7VblnLBFZTJiRzqZrYTFHV3oityEpqoopwKI6tD5j+yoDPYiatianSTVG2TYR0
         hjH2vo3/0iQGr1Uhw+8kMzzEwm2wGnBS5Yn0QLak830sbp0gF8kzSGxzEAV6i7X9Cefw
         6F6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=seqWg6438avW/SyZJnQRajfGCr85wJolvYrN3kEylco=;
        b=EkGPWSjAq3yQBCQ/LZukBs6HZpLE/1z/yYRks2msbh4gHjHgJaHesAlAKqsh4iQRfx
         n44FTwkywXNQtkd712/CViOfG3w95Masq2QKuvpAGOFSkp+P8ccMl79t1lFb6G3WRYAs
         fBL1P2MlX9A4AH42Nd4IMOoyigmkIhFHZw66lSc06L7w3MSCsB94aeU8DQi6HJZN3ZdJ
         qD1aipR458AQLW4J7XF4ZxgZg81tabFqdBmDafsOT+WwpolpwexSlpBIJGv6TnQLYnhT
         0NLxADpTWh508wpgC2tMwHbFoxDvO9lA5yB16aeF5DlJMjHnHS0MVMBf3JrJPgD21kMM
         Okpg==
X-Gm-Message-State: AOAM533noWYwU4Qhg+zYkMD0Sx02cdQpgFzmfXdOaHcx+KNDxgXGbEzd
        3iREI5MHQNdik1uORhV1ls/7NA==
X-Google-Smtp-Source: ABdhPJzeoYwAi0NZoFIvVNn3ZW68wsBnR7cQ6mXiuTceUIVN9jRIf8A5dHbHNbHhkSjgwaCRs7l8Bw==
X-Received: by 2002:a17:906:3e0c:: with SMTP id k12mr1338736eji.189.1601448966777;
        Tue, 29 Sep 2020 23:56:06 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id w15sm693255ejy.121.2020.09.29.23.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 23:56:06 -0700 (PDT)
Date:   Wed, 30 Sep 2020 08:56:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200930065604.GI8264@nanopsycho>
References: <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200928220507.olh77t464bqsc4ll@skbuf>
 <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
 <20200929110356.jnqoyy72bjer6psw@skbuf>
 <20200929130758.GF8264@nanopsycho>
 <20200929135700.GG3950513@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929135700.GG3950513@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 29, 2020 at 03:57:00PM CEST, andrew@lunn.ch wrote:
>On Tue, Sep 29, 2020 at 03:07:58PM +0200, Jiri Pirko wrote:
>> Tue, Sep 29, 2020 at 01:03:56PM CEST, vladimir.oltean@nxp.com wrote:
>> >On Mon, Sep 28, 2020 at 06:46:14PM -0700, Florian Fainelli wrote:
>> >> That makes sense to me as it would be confusing to suddenly show unused port
>> >> flavors after this patch series land. Andrew, Vladimir, does that work for
>> >> you as well?
>> >
>> >I have nothing to object against somebody adding a '--all' argument to
>> >devlink port commands.
>> 
>> How "unused" is a "flavour"? It seems to me more like a separate
>> attribute as port of any "flavour" may be potentially "unused". I don't
>> think we should mix these 2.
>
>Hi Jiri
>
>Current flavours are:
>
>enum devlink_port_flavour {
>        DEVLINK_PORT_FLAVOUR_PHYSICAL, /* Any kind of a port physically
>                                        * facing the user.
>                                        */
>        DEVLINK_PORT_FLAVOUR_CPU, /* CPU port */
>        DEVLINK_PORT_FLAVOUR_DSA, /* Distributed switch architecture
>                                   * interconnect port.
>                                   */
>        DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
>                                      * the PCI PF. It is an internal
>                                      * port that faces the PCI PF.
>                                      */
>        DEVLINK_PORT_FLAVOUR_PCI_VF, /* Represents eswitch port
>                                      * for the PCI VF. It is an internal
>                                      * port that faces the PCI VF.
>                                      */
>        DEVLINK_PORT_FLAVOUR_VIRTUAL, /* Any virtual port facing the user. */
>};
>
>A port in the DSA world is generally just a port on the switch. It is
>not limited in nature. It can be used as a PHYSICAL, or CPU, or a DSA
>port. We don't consider them as unused PHYISCAL ports, or unused CPU
>ports. They are just unused ports. Which is why i added an UNUSED
>flavour.

I get it. But I as I wrote previously, I wonder if used/unused should
not be another attribute. Then the flavour can be "undefined".

But, why do you want to show "unused" ports? Can the user do something
with them? What is the value in showing them?



>
>Now, it could be this world view is actually just a DSA world
>view. Maybe some ASICs have strict roles for their ports? They are not
>configurable? And then i could see it being an attribute? But that
>messes up the DSA world view :-(
>
>      Andrew
