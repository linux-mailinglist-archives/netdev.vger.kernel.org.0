Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F4F17831D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbgCCT0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:26:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729689AbgCCT0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 14:26:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52B9E2072D;
        Tue,  3 Mar 2020 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583263580;
        bh=F/b4AG6jVGrBM8vjamPApblBQcr5ZQmZJjEHx/qDebE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aJu+EpZndGJ0kPef7g0Vc7lrI0A+DAiB3hLh2Jse4ASpBAZ1C/v10IJtogltUMR9P
         iBy/a6lq1/4eQI4w4DneldNpcr8ZlUDeEQLFWyB9fnVoe/mTaJ0Pmw/GqJfKEnGYSG
         2GsFktGrcCROxD4zEIcEkx42783srYjxpzLoxfTM=
Date:   Tue, 3 Mar 2020 11:26:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <mlxsw@mellanox.com>,
        <netfilter-devel@vger.kernel.org>
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200303112617.02efb256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9478af72-189f-740e-5a6d-608670e5b734@solarflare.com>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-2-jiri@resnulli.us>
        <20200229192947.oaclokcpn4fjbhzr@salvia>
        <20200301084443.GQ26061@nanopsycho>
        <20200302132016.trhysqfkojgx2snt@salvia>
        <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
        <20200302192437.wtge3ze775thigzp@salvia>
        <20200302121852.50a4fccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200302214659.v4zm2whrv4qjz3pe@salvia>
        <20200302144928.0aca19a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9478af72-189f-740e-5a6d-608670e5b734@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 18:55:54 +0000 Edward Cree wrote:
> > Also neither proposal addresses the problem of reporting _different_
> > counter values at different stages in the pipeline, i.e. moving from
> > stats per flow to per action. But nobody seems to be willing to work=20
> > on that. =20
> For the record, I produced a patch series[1] to support that, but it
> =C2=A0wasn't acceptable because none of the in-tree drivers implemented t=
he
> =C2=A0facility.=C2=A0 My hope is that we'll be upstreaming our new driver=
 Real
> =C2=A0Soon Now=E2=84=A2, at which point I'll rebase and repost those chan=
ges.

Sorry, I wasn't completely fair :) Looking forward :)

> Alternatively if any other vendor wants to support it in their driver
> =C2=A0they could use those patches as a base.

