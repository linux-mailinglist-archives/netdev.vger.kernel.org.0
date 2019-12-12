Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337CE11D626
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbfLLSrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:47:36 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45851 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730258AbfLLSrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:47:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 36169220DD;
        Thu, 12 Dec 2019 13:47:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 12 Dec 2019 13:47:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4mxdiD
        QsfZD57JRu05aHGqyvwaIJ8QTGQZI90Fgydd4=; b=VHyI13HrTGZaW29m3NPvPp
        QYnyqv1yxXQqfY7S65bQ1P8D+a1s4FBvXARJxdoqRT6NY+CPbtG/eXPNSmCJKB1j
        zNsUMC9OUmMu5gurOWxl0LffUQCVGXiRQwS4PzI94O+wQg8fO+7iqOcXfSnQQEuP
        sBpePNNhk/W7ijzo6LgE/eMwnB9WXP5N4/Xeh4CGNNFC4teXNPlbknopT1a1jxT6
        3hG5LfI/PFCFpBsVUFiYhgvF/vW82hrxy1B8mdR6X8UlH5iTTHp0Xy3wb/9zyZSz
        2KI8qoa58NKLLWkegCDzubVbobEKy8AQ4ndv+IcjQz7zOSwqA1MUBfjv5De1V/aQ
        ==
X-ME-Sender: <xms:RovyXZ6dENrjQfkLucsOxKRmsEP6eT-P-ZPKMwiAgDbz3aFKozescw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeljedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:RovyXW1RuBc_k0gpyJ1lKw9soDUrYUFgEc5x_pe8CbmPRlhSsFgR7A>
    <xmx:RovyXcC3H1mJIGrqiaLbU6gtBpFQjufXlvA30ApLoN8Wn7mwVeLGTA>
    <xmx:RovyXXERYLM9YddjfK8Ej4pT-UOGVWanW22NckQIjdV-Mc9mQWuaGA>
    <xmx:R4vyXYG8Kyhe1AtsLribXicv6vK9yVUXFm2oQfSWlH5DZzDnFItZnw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5ABE13060134;
        Thu, 12 Dec 2019 13:47:34 -0500 (EST)
Date:   Thu, 12 Dec 2019 20:47:32 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Yuval Avnery <yuvalav@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Message-ID: <20191212184732.GA570918@splinter>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
 <20191211095854.6cd860f1@cakuba.netronome.com>
 <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191211111537.416bf078@cakuba.netronome.com>
 <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191211142401.742189cf@cakuba.netronome.com>
 <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191211154952.50109494@cakuba.netronome.com>
 <AM6PR05MB51425B74E736C5D765356DC8C5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191212102517.602a8a5d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212102517.602a8a5d@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 10:25:17AM -0800, Jakub Kicinski wrote:
> I'd like to see netdevsim to also serve as sort of a reference model
> for device behaviour. Vendors who are not first to implement a feature
> always complain that there is no documentation on how things should
> work.

+1

I have a patch set that adds FIB offload implementation to netdevsim and
a gazillion of test cases that I share between netdevsim and mlxsw. Can
be used by more drivers when they land.

It's also very convenient for fuzzing now that syzkaller supports
netdevsim instances thanks to Jiri. I've been running syzkaller for a
few weeks now to test the FIB implementation.
