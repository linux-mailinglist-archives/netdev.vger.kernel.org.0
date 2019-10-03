Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7D0C9801
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 07:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfJCFhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 01:37:55 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36703 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbfJCFhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 01:37:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 070CE21B8B;
        Thu,  3 Oct 2019 01:37:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 03 Oct 2019 01:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=d6dVBl
        3IySjFanmQ12RxlbMgrdbNKfui4NmOLRFxbik=; b=PZ0A47nFoOFMJJFz8kJ+2i
        bCbbZ7ZUDL2dwBuTKXTgNbjucsKummijUpCXVpZrdHS51vgh/ewc3UpHu1btHW3C
        k2ropvl3ouGY9OAZvR3OHUmlaWp0yKmazI0wBJVd3CTk525umtJkWpPAix9gYiGP
        af2lpo8oxAiToWK1EAwGzS4+iQTgaI00j+Lzv1kZFkw0XTKA++1ZI1x26bTf273U
        J7zFXicJcdvz04sxtHTVs/fleImHroToWq98GBN3uSVyPzhaJRcXz9UMwMBAQRXF
        xHtKBLhDZuGMn4x0h/ZTQ2XJY832+6jrEhSRS2mp1EWHW0vrBGfKe+IJh80aM3aA
        ==
X-ME-Sender: <xms:MYmVXUCjJ8_oiHR-_PSLW5fQHS0OU8xc5F9eAWKd17EWNoFhZfMQnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:MYmVXf1xebNRZ88sxCe30SMAjts1hldCjEfyCZRFGaAWKqeo4zYR_A>
    <xmx:MYmVXe2l0GgsT8W19HjKdU01jU9G4cE9NgX-_MNnpJUg5WmzI4b4mw>
    <xmx:MYmVXcCylSFtTWBESGu8JBT35b6Gb2Jqu3WFElFb1BsB9QMNW0nTMg>
    <xmx:MYmVXTFTOLWTy2SH7D1LQOaiSFB-WjBYezwsIiQ89Scny1-GCrrojg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9EEF8005B;
        Thu,  3 Oct 2019 01:37:52 -0400 (EDT)
Date:   Thu, 3 Oct 2019 08:37:50 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to
 routes
Message-ID: <20191003053750.GC4325@splinter>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
 <20191002182119.GF2279@nanopsycho>
 <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 08:34:22PM -0600, David Ahern wrote:
> On 10/2/19 12:21 PM, Jiri Pirko wrote:
> >>> This patch adds an "in hardware" indication to IPv4 routes, so that
> >>> users will have better visibility into the offload process. In the
> >>> future IPv6 will be extended with this indication as well.
> >>>
> >>> 'struct fib_alias' is extended with a new field that indicates if
> >>> the route resides in hardware or not. Note that the new field is added
> >>> in the 6 bytes hole and therefore the struct still fits in a single
> >>> cache line [1].
> >>>
> >>> Capable drivers are expected to invoke fib_alias_in_hw_{set,clear}()
> >>> with the route's key in order to set / clear the "in hardware
> >>> indication".
> >>>
> >>> The new indication is dumped to user space via a new flag (i.e.,
> >>> 'RTM_F_IN_HW') in the 'rtm_flags' field in the ancillary header.
> >>>
> >>
> >> nice series Ido. why not call this RTM_F_OFFLOAD to keep it consistent
> >> with the nexthop offload indication ?.
> > 
> > See the second paragraph of this description.
> 
> I read it multiple times. It does not explain why RTM_F_OFFLOAD is not
> used. Unless there is good reason RTM_F_OFFLOAD should be the name for
> consistency with all of the other OFFLOAD flags.

David, I'm not sure I understand the issue. You want the flag to be
called "RTM_F_OFFLOAD" to be consistent with "RTNH_F_OFFLOAD"? Are you
OK with iproute2 displaying it as "in_hw"? Displaying it as "offload" is
really wrong for the reasons I mentioned above. Host routes (for
example) do not offload anything from the kernel, they just reside in
hardware and trap packets...

The above is at least consistent with tc where we already have
"TCA_CLS_FLAGS_IN_HW".

> I realize rtm_flags is overloaded and the lower 8 bits contains RTNH_F
> flags, but that can be managed with good documentation - that RTNH_F
> is for the nexthop and RTM_F is for the prefix.

Are you talking about documenting the display strings in "ip-route" man
page or something else? If we stick with "offload" and "in_hw" then they
should probably be documented there to avoid confusion.
