Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7667B20EDEE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgF3F7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:59:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34181 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbgF3F7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 01:59:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 51BCD5C016A;
        Tue, 30 Jun 2020 01:59:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 30 Jun 2020 01:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=peRz+r
        wIiA8iEw4w9pzWU8D07UDUI9db9FaheVcO+vs=; b=ndNLllk6R6i4t/ERu89QX2
        aALOm4VcTYpXlnROjxWmvP/ET60LHsx+eTw/TPE0ayXx9ZqhdXNSj9cddCOG1ZvK
        SJjWDOonEarh4jXGlhkqNr04ZeaTaXQuzK6X3jnmrdI0idlKSIcCgdYy5A4r3ss5
        yjfo/PLMRPulShpqXhlViwcHKxEYI6xw3UNB6Qby7oIR0UZJsZPyFwwr+i1kyMxH
        U5svlxc78e4j87+xx1xGft5zpqd85J7xarB3a+2/0RAhExEMdaEozApJZH6/R9Cw
        wPUgA3eRJ0Ge/qeGaSn2XTThpYIyikShbcCg2QltbCgQPME7VPmJCNd2jelrsleA
        ==
X-ME-Sender: <xms:1dT6XsURPJomiawN7anz8J-tDk3NZqSVoqg9vf68-C-0B2k8ABdnKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvddttddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppedutdelrdeiiedrudelrddufeefnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:1dT6XgmrHCN_xFAYqOC9Oj9VxmcwKlMc11WCy484YL4yWRSVV2oBMA>
    <xmx:1dT6XgZBiyY07srvyz08RaFIMvf0GiZC01cVuXN-SuJH7TibvSgURw>
    <xmx:1dT6XrV_IfDB33ZVSaRqAbpZH1Fr0Zp-iv2ri6iXBabSw9LS7uTvBw>
    <xmx:2NT6XnDBzua8I7JWZzXl1HMkpc684BBLOfwXjRSCKjUYMhfjx4mEiQ>
Received: from localhost (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6ED3E30600A7;
        Tue, 30 Jun 2020 01:59:48 -0400 (EDT)
Date:   Tue, 30 Jun 2020 08:59:45 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>, vadimp@mellanox.com
Cc:     Adrian Pop <popadrian1996@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for
 QSFP-DD transceivers
Message-ID: <20200630055945.GA378738@shredder>
References: <20200626144724.224372-1-idosch@idosch.org>
 <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch>
 <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
 <20200626190716.GG535869@lunn.ch>
 <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
 <20200627191648.GA245256@shredder>
 <CAL_jBfTKW_T-Pf2_shLm7N-ve_eg3G=nTD+6Fc3ZN4aHncm9YQ@mail.gmail.com>
 <20200628115557.GA273881@shredder>
 <20200630002159.GA597495@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630002159.GA597495@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 02:21:59AM +0200, Andrew Lunn wrote:
> I've no practice experience with modules other than plain old SFPs,
> 1G. And those have all sorts of errors, even basic things like the CRC
> are systematically incorrect because they are not recalculated after
> adding the serial number. We have had people trying to submit patches
> to ethtool to make it ignore bits so that it dumps more information,
> because the manufacturer failed to set the correct bits, etc.
> 
> Ido, Adrian, what is your experience with these QSFP-DD devices. Are
> they generally of better quality, the EEPROM can be trusted? Is there
> any form of compliance test.

Vadim, I know you tested with at least two different QSFP-DD modules,
can you please share your experience?

> 
> If we go down the path of using the discovery information, it means we
> have no way for user space to try to correct for when the information
> is incorrect. It cannot request specific pages. So maybe we should
> consider an alternative?
> 
> The netlink ethtool gives us more flexibility. How about we make a new
> API where user space can request any pages it want, and specify the
> size of the page. ethtool can start out by reading page 0. That should
> allow it to identify the basic class of device. It can then request
> additional pages as needed.

Just to make sure I understand, this also means adding a new API towards
drivers, right? So that they only read from HW the requested info.

> The nice thing about that is we don't need two parsers of the
> discovery information, one in user and second in kernel space. We
> don't need to guarantee these two parsers agree with each other, in
> order to correctly decode what the kernel sent to user space. And user
> space has the flexibility to work around known issues when
> manufactures get their EEPROM wrong.

Sounds sane to me... I know that in the past Vadim had to deal with
various faulty modules. Vadim, is this something we can support? What
happens if user space requests a page that does not exist? For example,
in the case of QSFP-DD, lets say we do not provide page 03h but user
space still wants it because it believes manufacturer did not set
correct bits.
