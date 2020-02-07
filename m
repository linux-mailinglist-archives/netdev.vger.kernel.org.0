Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66253155D1B
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBGRnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:43:55 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40483 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727118AbgBGRnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:43:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 226C521E50;
        Fri,  7 Feb 2020 12:43:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 07 Feb 2020 12:43:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yapd7s
        BlFHvm1lQrhkhJ6hCTopXs0OXjUlmErfG8DoQ=; b=eIYnigTDB3izKhpVBIPQtX
        S04a7bVdpS4gZ7bub6PEO7Du4pr/+Cqn3b3Y+PNhpDGULyyusYi6qaUmp8KRmZA1
        BppxZwHDQyiv7BPfKuLv/JuNuw6ux3ZJHCIJgDhSorm5gMv9X4MiK4VoDr4xh6Fk
        uEbEJARi0U4l+8v6TmGPPgY/efa2Y6DDt4FvkNxA5Df9xN1+NEha3m1SyWbGwvew
        JwVZ5ZlUe2ysXmILPBqUzS0/gEd2BVtmY5S3BPVWm3z8ppTJetfXTNNVS0gFCra1
        LtdKMFHzHce4yar7SqPsEg2dtLmdfn5saVa1IIYgPmr48DN0aL50zd9KGdUUb/Ag
        ==
X-ME-Sender: <xms:2aE9XpDy74aWuP_3DPH-IB-hf_JQLdUZLKkoeXRmRj_oYdGzt7RECg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepjeelrd
    dukeefrddutdejrdduvddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:2qE9Xj2UgkbVeuWI7h0PawePXtCB7jeDwrokqCLrCxAG_IvR3pde8w>
    <xmx:2qE9XnX1AvQJGO1FZR-MeuDQGmqyFUnBqxztR14Ju04X05hG8Jv-ZQ>
    <xmx:2qE9XllAOSRn0BXEDNo_01EZ8OoAEe9mwrSSR1wj_d58jTGGBc9e5A>
    <xmx:2qE9Xodbe4aXrEzv72YSn__HnMpNDM9URyuiCRH_4SDjAITKAYMvmg>
Received: from localhost (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CD113060717;
        Fri,  7 Feb 2020 12:43:53 -0500 (EST)
Date:   Fri, 7 Feb 2020 19:43:50 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: VLAN retagging for packets switched between 2 certain ports
Message-ID: <20200207174350.GA129227@splinter>
References: <CA+h21hr4KsDCzEeLD5CtcdXMtY5pOoHGi7-Oig0-gmRKThG30A@mail.gmail.com>
 <CA+h21hpWknrGjyK0eRVFmx7a1WWRyCZJtFRgGzr3YyeL3y2gYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpWknrGjyK0eRVFmx7a1WWRyCZJtFRgGzr3YyeL3y2gYw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, Feb 06, 2020 at 11:32:52AM +0200, Vladimir Oltean wrote:
> On Thu, 6 Feb 2020 at 11:02, Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Hi netdev,
> >
> > I am interested in modeling the following classifier/action with tc filters:
> > - Match packets with VID N received on port A and going towards port B
> > - Replace VID with M
> >
> > Some hardware (DSA switch) I am working on supports this, so it would
> > be good if I could model this with tc in a way that can be offloaded.
> > In man tc-flower I found the following matches:
> >        indev ifname
> >               Match on incoming interface name. Obviously this makes
> > sense only for forwarded flows.  ifname is the name of an interface
> > which must exist at the time of tc invocation.
> >        vlan_id VID
> >               Match on vlan tag id.  VID is an unsigned 12bit value in
> > decimal format.
> >
> > And there is a generic "vlan" action (man tc-vlan) that supports the
> > "modify" command.
> >
> > Judging from this syntax, I would need to add a tc-flower rule on the
> > egress qdisc of swpB, with indev swpA and vlan_id N.
> > But what should I do if I need to do VLAN retagging towards the CPU
> > (where DSA does not give me a hook for attaching tc filters)?
> >
> > Thanks,
> > -Vladimir
> 
> While I don't want to influence the advice that I get, I tried to see
> this from the perspective of "what would a non-DSA device do?".
> So what I think would work for me is:
> - For VLAN retagging of autonomously forwarded flows (between 2
> front-panel ports) I can do the egress filter with indev that I
> mentioned above.
> - For VLAN retagging towards the CPU, I can just attach the filter to
> the ingress qdisc and not specify an indev at all. The idea being that
> this filter will match on locally terminated packets and not on all
> packets received on this port.
> Would this be confusing?

Yes. The correct way to handle this would be to add a netdev to
represent the CPU port (switch side) and add the filter on its egress
qdisc. In addition to your use case, this also allows us to solve other
use cases:

1. Control Plane Policing (COPP): Policing of traffic going to the CPU.
By installing relevant filters with police/drop actions.
2. Scheduling traffic towards the CPU: By appropriately configuring the
egress qdisc, just like for external ports.

I hope to introduce a netdev for the CPU port in mlxsw to solve the
first use case in the upcoming months.
