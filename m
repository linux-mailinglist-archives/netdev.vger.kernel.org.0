Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2CA19902A
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 11:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731512AbgCaJJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 05:09:44 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:51023 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731369AbgCaJJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 05:09:43 -0400
IronPort-SDR: sZB/W3tX2EDNQIDG5CobiUoShToM0PuH8HJmpWULERpmgYPZ8+UaMGWL+b6t98wAYzEUtQDAq/
 1eSwGjkW5bpN7ipa/cExrMcyHCEn4QtAibrfBoC6aT9D/JFZXCY9eY7i3KwwDkR8KtBmTcYNjG
 qkd+rK8faIgwKALGdqKaZcw7CoBUii40SnJLoQAoeKvy9ZO+TyEgtIldlz9Ti7/1f19JVO/+kw
 c8VWOIrv7rIVB2UnZuSD0X06b/+/CXD8zulySRHvD1Nn0q5om+OpXQ/3V9aQBnFakg210a3og0
 C0Q=
X-IronPort-AV: E=Sophos;i="5.72,327,1580770800"; 
   d="scan'208";a="11620744"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 31 Mar 2020 11:09:41 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 31 Mar 2020 11:09:41 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 31 Mar 2020 11:09:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1585645781; x=1617181781;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AmNQ70x+U90ksL+IF0QKz+uIkUgY48xR+6uNMkj/fdc=;
  b=hQvltprAy/j1rGp1rMrdTZlvZEFXSS2U/QgOJYKn3JIr4HGGsCbEqm/e
   th+E9wxdkGijsprbo/4idy/1ujvsVdBTKEZ5wawX+8pahMq0+hskGngtI
   a7IPrmdhG7f0m7DZwA+cz9s9I+KlkrKPDOVEv4blt0YVlLhQlZJJOlrF5
   jPC2cgrWHdXG7b5ghfhhLkHMS/gga86/SnHUhHe1Ptrc5DSY4zBdKbC5x
   o19t6TsB9m25USCPdocyFqBDh4StyJk6pPT3jeSZCGXpo2S5ry1lqy/mY
   LfirnNm0mm0wJwbIi5f1Oo0PIyhr+hBwtjS2M2DAn5ObHAqocIIZfxWEy
   g==;
IronPort-SDR: BNIMxixaKYbDbaNh/qECj2bdl5U81jLwJ28F61hn/AKoqlxNFn8XZ6uA3Y2g+Md3D3flcA54+w
 NTKCoH4ywraeauwofQxJd71PozGlxaKy7cSw0wLYgQqGJJhOtGzNjZWcLB+DyJtx/vWs2yEXtU
 UsB8kEhOewiLKe1y7ppmassKMADNTUgBpnS6IM6+9F6Hh51xgOinshRXhVH4OiBKVpaM2gXgnE
 gFvI8tjeRDItH2Aa2ah4tbF0EtVHuOuVbzOyu9/iMdIpmy28mbIw8iLMKa/U05NoalZVNy0uQc
 110=
X-IronPort-AV: E=Sophos;i="5.72,327,1580770800"; 
   d="scan'208";a="11620743"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 31 Mar 2020 11:09:41 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id ACE69280065;
        Tue, 31 Mar 2020 11:09:46 +0200 (CEST)
Message-ID: <a796bf7cfb1f72a888522050320624546950c281.camel@ew.tq-group.com>
Subject: Re: (EXT) Re: [PATCH net-next 1/4] net: dsa: allow switch drivers
 to override default slave PHY addresses
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Date:   Tue, 31 Mar 2020 11:09:32 +0200
In-Reply-To: <6a306ad4-c029-03a3-7a1c-0fdadc13d386@gmail.com>
References: <20200330135345.4361-1-matthias.schiffer@ew.tq-group.com>
         <6a306ad4-c029-03a3-7a1c-0fdadc13d386@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-03-30 at 20:04 -0700, Florian Fainelli wrote:
> 
> On 3/30/2020 6:53 AM, Matthias Schiffer wrote:
> > Avoid having to define a PHY for every physical port when PHY
> > addresses
> > are fixed, but port index != PHY address.
> > 
> > Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com
> > >
> 
> You could do this much more elegantly by doing this with Device Tree
> and
> specifying the built-in PHYs to be hanging off the switch's internal
> MDIO bus and specifying the port to PHY address mapping, you would
> only
> patch #4 then.

This does work indeed, but it seems we have different ideas on
elegance.

I'm not happy about the fact that an implementor needs to study the
switch manual in great detail to find out about things like the PHY
address offsets when the driver could just to the right thing by
default. Requiring this only for some switch configurations, while
others work fine with the defaults, doesn't make this any less
confusing (I'd even argue that it would be better if there weren't any
default PHY and IRQ mappings for the switch ports, but I also
understand that this can't easily be removed at this point...)

In particular when PHY IRQ support is desired (not implemented on the
PHY driver side for this switch yet; not sure if my current project
will require it), indices are easy to get wrong - which might not be
noticed as long as there is no PHY driver with IRQ support for the port
PHYs, potentially breaking existing Device Trees with future kernel
updates. For this reason, I think at least patch #2 should be
considered even if #1 and #3 are rejected.

Kind regards,
Matthias

