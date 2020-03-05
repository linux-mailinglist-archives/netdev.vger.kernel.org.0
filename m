Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7996817A865
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgCEPBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:01:18 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50821 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbgCEPBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 10:01:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DA8AC2241C;
        Thu,  5 Mar 2020 10:01:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Mar 2020 10:01:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+DeXsw
        il40YIVs1J0/sih2u3eHdfb9FN+gx7TY4Aqzs=; b=g5rhbu4NYzRgkBKXiUm9jc
        HjSUz1IJVrtHXo310LfJsM27A9295V6a32TVfust7uqueePGLlh8dwl/K+xCmEnO
        2sa8xtJ1rhAfLXXRoLzyHfhfCeaLjGIQvPywYwvDoDrG9MlmhLWc9ocdOy/haqbV
        aREQFhZQhotKzU/LjHWnfZZTdCNVJjIUXVA3Tf/EzIdWveBuFY74q9RmkDCvp1at
        5xj3NVIaDj9dFqtiCa7J0neKVeyFjYJYRPJSBRBmQIaJJ98Ko7r+Rc0K0JsDZrqv
        yoHY08VJXuv7tbdvYRe60yP9j1p4hitQPrEo+mkArvCwIwHjWmirmO9Nkxu5qXqQ
        ==
X-ME-Sender: <xms:PBRhXuBHVOGyzuq34MXwLexNc8isKu7ejjN2CP_tz9xhDVRkc5bjUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddutddgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PBRhXh9BwtudCWQlax5lRh2Du3NdpVSBcguW8cieAQpoc4QJ16e9eA>
    <xmx:PBRhXoPqeLv_fhidAUgyP-1J8RVKvCFwDDms-RVJbeuYwXNGT_lReQ>
    <xmx:PBRhXvLo-zdm-Bia_JEwNeb2D4fZdekvfgllZoUpXXhafXturfD70g>
    <xmx:PBRhXrDSdbFYlvpnyxCq9tR31otmmRDol-SjrOKGSMdlH4jZ2x0jZA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A840D3280064;
        Thu,  5 Mar 2020 10:01:15 -0500 (EST)
Date:   Thu, 5 Mar 2020 17:01:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [RFC net-next 0/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200305150114.GB132852@splinter>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225163025.9430-1-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 04:30:52PM +0000, Vadym Kochan wrote:
> Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> wireless SMB deployment.

It seems that this device has enough ports to loopback to each other in
order to create meaningful topologies. Therefore, I suggest running
relevant existing tests under tools/testing/selftests/net/forwarding/
and contributing new ones. See tools/testing/selftests/net/forwarding/README
for details.

One problem you will run into is that your netdev notifier only allows
bridge uppers and will therefore veto VRF uppers, which is a
prerequisite. However, since you don't support L3 offload, then all
routed traffic should reach the CPU anyway and therefore VRF uppers can
be allowed.
