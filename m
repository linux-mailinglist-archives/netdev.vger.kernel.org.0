Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9D8309621
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 16:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhA3PHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 10:07:53 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38911 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232142AbhA3O7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:59:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8587C5C0132;
        Sat, 30 Jan 2021 09:57:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 30 Jan 2021 09:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2ksLkb
        NGzWSsvmPHHU85P4JWIjMyu1DHKhI60yx0KXI=; b=Mr+lPT9Ptyn8MmGpxeIVRC
        6tMgQMZRszRkA76/26KtCN5suJ+yMcVQHu3qaVVtYRb2+Y9nokXrjz5qEK+9injn
        7kQXM//LOcn5gtKm9BnZYAFZ0iico1tKF5kLJriYwg9FAqgVqgS0BjJPDjZOvdAb
        a8kJ4+kCblQFsl33ThNTx0RtiR+FIdnHIZXxJT/MF8TAdje5r4Y/f7hwZTKGCHl8
        1jq/LnD9HRzQ9GffXOCaSuTUTw3yJk0wJO2o91CexxDUFCnFgp+kfRcnsBlSwYXE
        THDN2yq80KOG4gYWZwJzZECBONQ3zWi4e67Krim0eXbstgTgEusaCEwTHYAZjbSw
        ==
X-ME-Sender: <xms:5nMVYBZlLTXP6G_bRP0psq7TPzqY9wrWiAAyb7Nz_umZudZp4VU0-Q>
    <xme:5nMVYIbqY_mbwwoqyu6ruJ5kxMA2UuMERDdlz3UfLKNHqycEWo8XWI_3ClUFUP9AA
    XSG-2VLUoLbS20>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeegrddvvdelrdduheefrd
    eggeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehi
    ughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5nMVYD-XJ1Mek-3lTnkU4S-Skhk-AZ8qO63DKMvNHmeGQgdRuAzItA>
    <xmx:5nMVYPprtU7VvGYApr8TTRsXyYzfxU7HEtHZtwIf2jYaz_aj5xHPhQ>
    <xmx:5nMVYMpZ_RTCAEdBi-XeCIv1PX_6WEtRFopdae7fmNQBKT_BUBbwkA>
    <xmx:5nMVYBA8vMBk5a1ZSgHHC62wxhyWxs-sKNn6BK17lEtWr5N9qfl2Yw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B30824005B;
        Sat, 30 Jan 2021 09:57:41 -0500 (EST)
Date:   Sat, 30 Jan 2021 16:57:38 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>, simon.horman@netronome.com
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [PATCH net-next v2] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210130145738.GA3330615@shredder.lan>
References: <20210129102856.6225-1-simon.horman@netronome.com>
 <CAM_iQpVnd9s6rpNOSNLTBHzLH7BtKvdZmWMhZdFps8udfCyikQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVnd9s6rpNOSNLTBHzLH7BtKvdZmWMhZdFps8udfCyikQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 03:04:51PM -0800, Cong Wang wrote:
> On Fri, Jan 29, 2021 at 2:29 AM Simon Horman <simon.horman@netronome.com> wrote:

I didn't get v2 (didn't made it to the list), but I did leave feedback
on v1 [1]. Not sure if you got it or not given the recent issues.

[1] https://lore.kernel.org/netdev/20210128161933.GA3285394@shredder.lan/#t
