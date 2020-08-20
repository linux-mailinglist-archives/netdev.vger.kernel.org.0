Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D1724C237
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgHTPaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbgHTP36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 11:29:58 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4D2C061385;
        Thu, 20 Aug 2020 08:29:57 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id g1so493128oop.11;
        Thu, 20 Aug 2020 08:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/yqtf65S11ELAIVx4R8BLKLmTH1tLbD9UCR/sZvZEKk=;
        b=jAREpFEfMNb5oMhUoixf9Jrq/aReeZ/sSfs28vPtfXPSYU1MYT+K+Nde2CULpqkNpj
         THiYVv2o6OD/4P7lv1orzBjsicb0qiPftVJoPHBDYui8yt0j8Mv3yn58S6D5xhoJXqg7
         8/JVclUjjbAhwYPUJVQ4Wqx0s3YQSB0qpgbWVUOxQsGYEIlLZyeGWkkdUTeH/bWm+SMm
         7n+ebZZ+8HiU3VOPBvJr387CbM111pee6L5SV2vKj/z4Ho1KVcpF7ZUpU3x3JZMyvory
         aDtb/RKXr4WVLql96R1kjBQzp8NNdxcart33YdGOqn4vo+LbH1AgMh82C/c3ZrVpRD9k
         PFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/yqtf65S11ELAIVx4R8BLKLmTH1tLbD9UCR/sZvZEKk=;
        b=TP4AUBnKe8wUtEp4lmIPH0vyJ+XUckJs652cR+QnRzQIH0Te75iNLGHFLRGy+yqJ2i
         MaxRIbGVUtt4Gy0i9njgoCuLlKeIFGQTVAK8V99S1l7Y4PJ8XAcHglKcxh82Xqb4V+PH
         M49oD4X3FQnzV9N3yR97AXIXvyIC6XX9QlEvVC1O+W0j4hVTcb5xyyYU7nSiI0uXAg6s
         SgN8Ga+U332+38L4Y4tPG7ccek4L+37aWqh5rmwl7rOTYrLl4hYjyXEgz1hDqf8OWAHR
         5BrxINvBNOhenbDjXaxNmbq96WdmyY2pAI7T2klAAqScV2S6UHneUbrBjRY1INT2MU8C
         y4Ew==
X-Gm-Message-State: AOAM532w6/DwuT4mHfCalTp7Hv+ZvU6wgcOrZk6Dd5LmQiHvUCnGh6P0
        JhPLuj1Oo81St/FFKxNWX3lV68+8EsJ6PI4iw+Q=
X-Google-Smtp-Source: ABdhPJxWEBD7BQ8Ieo+CZJgYeO9KHw8pYzlife4uFB1RQS86vDTUEY2rg1dPJWpT9qsuSO51bDK9tpHPXb1spqDhOQo=
X-Received: by 2002:a4a:4594:: with SMTP id y142mr2797689ooa.24.1597937396316;
 Thu, 20 Aug 2020 08:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1597729692.git.landen.chao@mediatek.com>
 <e980fda45e0fb478f55e72765643bb641f352c65.1597729692.git.landen.chao@mediatek.com>
 <20200818160901.GF2330298@lunn.ch> <1597830248.31846.78.camel@mtksdccf07> <20200819234613.Horde.oQiJhMCnUINwnQP-5_MyHh-@www.vdorst.com>
In-Reply-To: <20200819234613.Horde.oQiJhMCnUINwnQP-5_MyHh-@www.vdorst.com>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Thu, 20 Aug 2020 23:29:45 +0800
Message-ID: <CAJsYDVJM3A_5Fpp8ube-gOi-Nn-itf0MW6ePL0wM16_k67+x6g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/7] net: dsa: mt7530: Add the support of
 MT7531 switch
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Cc:     Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        vivien.didelot@savoirfairelinux.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sean Wang <Sean.Wang@mediatek.com>, frank-w@public-files.de,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Thu, Aug 20, 2020 at 7:55 AM Ren=C3=A9 van Dorst <opensource@vdorst.com>=
 wrote:
>
> With the current mainline code [1], the dsa code tries to detect how the =
MAC5
> is used. All the three modes are supported. MAC5 -> PHY0, MAC5 ->
> PHY4, MAC5 ->
> EXTERNAL PHY and MAC5 to external MAC.
>
> When MAC5 is a DSA port it skips settings the delay settings. See [2].
>
> Maybe you can use a similar concept.

Current detection relies on an incorrect assumption that mt753x switch
is always used with mtk_eth_soc. It's a really hacky solution to use
dt properties that don't belong to this switch at all and I think this
approach should not be followed further by future code.
The usage of mac5 should be explicitly defined as a dt property
under mt753x node.
--=20
Regards,
Chuanhong Guo
