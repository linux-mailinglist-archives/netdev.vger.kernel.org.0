Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC10D4132B7
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 13:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhIULlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 07:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232115AbhIULls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 07:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96736115A;
        Tue, 21 Sep 2021 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632224420;
        bh=U5CruyhS2HsZTpcTta2Z+/TfdC5ERxNSC/UJutHMLK4=;
        h=In-Reply-To:References:Subject:Cc:To:From:Date:From;
        b=AbvFzTvvkLTF81FJPLjWj0NigTb2stzKcwGO5Qug/ufdbSaLkXsUmreoZhdFc59YD
         IRROiY6JFOlovOjGO2zvtTSK+3sqPKQ5sUHlLyT0/q8xx8BdESItTHRjvXgE+vW44X
         PSv43HKBLhIPozrhHbVO0vrj5LDnCTSmHDsSgCVTXy//PR+Zz3ow5s8x+fvOQV5guW
         GWuOvZp0NaeuJtSZu1FcSR1RK+jG4zkZ3n0teM5x8qLatjv10JrVbYKIjy2F1koKIF
         SRTjoqjOSQcJurNdCPdq16406x0Jhwv0aseJJZkY9en9yfkqy47g3tBHNr1tjgG2/O
         LE9tuD7MORq1w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAAxCcbsBTey=tSznn55BanA2H5PXitgfuC8DFg543nYjT0-igQ@mail.gmail.com>
References: <20210920153454.433252-1-atenart@kernel.org> <b3bee3ec-72c0-0cbf-d1ce-65796907812f@gmail.com> <CAAxCcbsrjvp=vP_0Nz+pYCVMDWSxnDAjdVXWYczNZfaAtc6kZw@mail.gmail.com> <CAAxCcbsBTey=tSznn55BanA2H5PXitgfuC8DFg543nYjT0-igQ@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: allow linking a VRF to an OVS bridge
Cc:     davem@davemloft.net, kuba@kernel.org, pshelar@ovn.org,
        dsahern@kernel.org, dev@openvswitch.org, netdev@vger.kernel.org,
        Eelco Chaudron <echaudro@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Luis Tomas Bolivar <ltomasbo@redhat.com>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <163222441764.4283.10232352821657503551@kwain>
Date:   Tue, 21 Sep 2021 13:40:17 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Quoting Luis Tomas Bolivar (2021-09-21 13:20:08)
>=20
> Follow up on this. I found the mistake I was making on the veth-pair
> addition configuration (ovs flow was setting the wrong mac address
> before sending the traffic through the veth device to the vrf). And it
> indeed works connecting the VRF to the OVS bridge by using a veth pair
> instead of directly plugin the VRF device as an OVS port.

Great! This means there is no need for this patch I believe, OVS bridge
is not different in the end.

Thanks,
Antoine
