Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EAB33D555
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhCPOBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:01:43 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46101 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235165AbhCPOBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:01:19 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E8E095C012F;
        Tue, 16 Mar 2021 10:01:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 10:01:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BwAI5R
        ov6PqPrUq9aKADvRJJeKYDlX+DIuU0Rux4q44=; b=dQcdvH+3pXLnHb4L88eN+K
        u4jdebECDnUoiKCGZEpkCmKo9Gu0AydZ+rHMpNuTQOPbWK89PuhITSN+exSn6rva
        MhrRqiWMoJ1KBNyNgOx17f4a76tfMUXu2xi9B03EO6XQsctKU0+YfRDtgf6yJ9gK
        xNSo6+h2FGEwJIJCC6HEiClG+wVi5AyEcYJG8N24Dei0h6tKcTilAIGquLIahSl2
        sZ9WWCgEmSLt+ykzwkmaKkgbKEiCm2ntXMRr/Pi4R0jnFXnepLoMVwKKL/hTCuGt
        3FsZpOkfSc2qY/0Ra+spEFCmzEzMJ9kMOO/kmZa/tPlMttYmfbt2EBBesloPXuJA
        ==
X-ME-Sender: <xms:LbpQYLh9SpfeHiuiU4D9s63fgYJcpNeaHD5R56GOwopf25jAG6a8yw>
    <xme:LbpQYIDzQBXMS0tg1vrkB8in8fbKX-bfTliSArTtc2H7CMrl-Tzm0k_HKrJFEqZNA
    jXek4kb27eRCZI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:LbpQYLEFzdh7YubFAKYuZVjqHhVKmbaSekaMFkZIStU0aDmK4sGRRg>
    <xmx:LbpQYITed4R_WnAeraEfLNJL-z_cFKLhboMkB0zsbecGK30f07iq_Q>
    <xmx:LbpQYIwa6O6A9lsyZHshwRVwFhuSXyBeBsN-LPVTr7ERBd_gUTTqbA>
    <xmx:LrpQYCtWmOLUw_vqssAdr2Pj_ZYc0E5t4-X9f7go51axoC05s9158Q>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5AD2E108006C;
        Tue, 16 Mar 2021 10:01:17 -0400 (EDT)
Date:   Tue, 16 Mar 2021 16:01:13 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 11/12] Documentation: networking: switchdev:
 clarify device driver behavior
Message-ID: <YFC6KV5OSVyCHmG2@shredder.lan>
References: <20210316112419.1304230-1-olteanv@gmail.com>
 <20210316112419.1304230-12-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316112419.1304230-12-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 01:24:18PM +0200, Vladimir Oltean wrote:
> +When the bridge has VLAN filtering enabled and a PVID is not configured on the
> +ingress port, untagged 802.1p tagged packets must be dropped. When the bridge

I think you meant "untagged and 802.1p tagged packets" ?

Looks good otherwise

> +has VLAN filtering enabled and a PVID exists on the ingress port, untagged and
> +priority-tagged packets must be accepted and forwarded according to the
> +bridge's port membership of the PVID VLAN. When the bridge has VLAN filtering
> +disabled, the presence/lack of a PVID should not influence the packet
> +forwarding decision.
