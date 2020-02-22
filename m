Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706D2168F10
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 14:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgBVNUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 08:20:00 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:37605 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgBVNUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 08:20:00 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 76409230E1;
        Sat, 22 Feb 2020 14:19:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582377597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PflziWWXiKohVr7J/dPsgitwa5siLhHLOsrVLro5scE=;
        b=pbjwEldcNAGilr2/TDnDGnXIvqKiZgrPi0/vQHx7dcls5Gp/xYMX4nW2wQZ4IKY2cYV5XR
        VrwTjzlTOgDJ3uXQuWUWo0YeLBokBJ6+9vs/9zRj28a6yj4bZXKlYc6uhtizwrC9BDcsso
        ax63FT5E9w/xVSPK/P0LRTf+PglPByQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 22 Feb 2020 14:19:57 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 net-next/devicetree 4/5] arm64: dts: fsl: ls1028a: add
 node for Felix switch
In-Reply-To: <CA+h21hpCBjo18zHc-SvMj5Y=C+e=rna5MUgp7SW1u0btma+wfg@mail.gmail.com>
References: <20200219151259.14273-5-olteanv@gmail.com>
 <20200222113829.32431-1-michael@walle.cc>
 <CA+h21hpCBjo18zHc-SvMj5Y=C+e=rna5MUgp7SW1u0btma+wfg@mail.gmail.com>
Message-ID: <c02160323fafd2ec621561e7e527de45@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: /
X-Spam-Status: No, score=-0.10
X-Rspamd-Server: web
X-Spam-Score: -0.10
X-Rspamd-Queue-Id: 76409230E1
X-Spamd-Result: default: False [-0.10 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         DBL_PROHIBIT(0.00)[0.0.0.0:email,0.0.0.4:email];
         RCPT_COUNT_SEVEN(0.00)[11];
         NEURAL_HAM(-0.00)[-0.674];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[lunn.ch,davemloft.net,vger.kernel.org,gmail.com,arm.com,kernel.org];
         MID_RHS_MATCH_FROM(0.00)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Am 2020-02-22 13:25, schrieb Vladimir Oltean:
> Hi Michael,
> 
> On Sat, 22 Feb 2020 at 13:38, Michael Walle <michael@walle.cc> wrote:
>> 
>> Hi,
>> 
> 
>> > +
>> > +                     enetc_port2: ethernet@0,2 {
>> > +                             compatible = "fsl,enetc";
>> > +                             reg = <0x000200 0 0 0 0>;
>> > +                             phy-mode = "gmii";
>> Can we disable this port by default in this dtsi? As mentioned in the 
>> other
>> mail, I'd prefer to have all ports disabled because it doesn't make 
>> sense
>> to have this port while having all the external ports disabled.
>> 
> 
> Ok. What would you want to happen with the "ethernet" property? Do you
> want the board dts to set that too?

That's something I've also thought about. And now that you've mention
this, I think it makes more sense to have that in the board too. Because
if you have the freedom to use either eno2/swp4 or eno3/swp5, then if I
choose the second one I'd have to delete the ethernet property from the
first, correct? I actually thought about adding the ethernet property
to both; but (1) I don't know if that is even possible (given that one
is always disabled) and (2) if one want to use the second port as an
additional link to the switch you'd have to remove the ethernet property
on that port. correct?


>> > +                                     /* Internal port with DSA tagging */
>> > +                                     mscc_felix_port4: port@4 {
>> > +                                             reg = <4>;
>> > +                                             phy-mode = "internal";
>> > +                                             ethernet = <&enetc_port2>;
>> Likewise, I'd prefer to have this disabled.
>> 
> 
> Ok.
> 
>> > +                     enetc_port3: ethernet@0,6 {
>> > +                             compatible = "fsl,enetc";
>> > +                             reg = <0x000600 0 0 0 0>;
>> > +                             status = "disabled";
>> > +                             phy-mode = "gmii";
>> shouldn't the status be after the phy-mode property?
> 
> Why?

I thought that would be a rule. I just had a quick look on some other 
device
trees before and they all has the status property as the last property 
(before
any subnodes). I might be mistaken. If so, you could do it for 
consistency
reasons ;) all status property in the ls1028a.dtsi are the last ones.

-michael
