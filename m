Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CFA2F2731
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 05:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbhALEjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 23:39:45 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49889 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729988AbhALEjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 23:39:44 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 36A175C01D0;
        Mon, 11 Jan 2021 23:38:58 -0500 (EST)
Received: from imap2 ([10.202.2.52])
  by compute2.internal (MEProxy); Mon, 11 Jan 2021 23:38:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=4HfYX1xajuMdg1coxOKoe6H1ospBFa15xxW0t2ghm
        40=; b=G1xEaYV8Uv4Fc1v7yd+eVS+7LwkwCZG1rpiJVEtGEenX4/Vf3+UCKAR6h
        MoSCugniV37JhBEnPRwR7cAy5a8z3gawS2CKI+q/HN0lunI4JvjSbUjDEJxvY3jF
        QGQLPoN53HcE357WrTilL6jeC6NWa2bdnItWujgV0t8/j4qY5PRVhto+DhKLo69c
        vwjFNiUmghsmS6uX69wlCnslGusN1z7MxRAVP1WCk5z2QR6/+e0HiwQmvN1nfVEQ
        5je9UGgq8BTfQ1Tn0siB/9JVCohX3JVT9aF/L3tKezLhjhP3J5e5k8HqHxRbx4R7
        xm3k2rGt+ot1v4PUbzJVo6t5iQ7hw==
X-ME-Sender: <xms:4Cf9XyIRhFpCzxlVVYRYq9_MjPyxyAvviCtE24CdhFYgck-JBRbIiA>
    <xme:4Cf9X6Lz7cAxvZ1NU2mW-lFKxiKK88HjnZ4j6kesIAL-nJPbMjYVX5PwachWQWeF9
    eVQMzg2q1-fjK7zaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgfgsehtqhertderreejnecuhfhrohhmpedfvehh
    rghrlhhivgcuufhomhgvrhhvihhllhgvfdcuoegthhgrrhhlihgvsegthhgrrhhlihgvrd
    gsiieqnecuggftrfgrthhtvghrnhepteduheegkedviefhvdelveegkefgudfhfffgudet
    feeljeevgfdvuddtueeftdefnecuffhomhgrihhnpehsphhinhhitghsrdhnvghtnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghhrghrlhhi
    vgestghhrghrlhhivgdrsgii
X-ME-Proxy: <xmx:4Cf9Xyug7Pq1yStn2TyPjV3jgWBKQGeTasLmaPhmroreoqRyQ4CPCg>
    <xmx:4Cf9X3ZALqXYoqmn-rGPXZvZ72OhWMuvVFMehw39G9zBTocIErEazg>
    <xmx:4Cf9X5Y6p9-pqW7FvZTDdZSS8buR7HsdKTwEE7iiZ9G1AYdNW3ZqSg>
    <xmx:4if9X9HNU_WPlwcueEAXgQm8OhfP3Osq2qagBeKzJAMxoKXuy0yxGg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CE5BAE00C7; Mon, 11 Jan 2021 23:38:56 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-45-g4839256-fm-20210104.001-g48392560
Mime-Version: 1.0
Message-Id: <2e591053-05f4-4dc2-81bc-4d3320b75930@www.fastmail.com>
In-Reply-To: <ee57b0ed-89e2-675e-b080-0059c181a2be@redhat.com>
References: <20210109024950.4043819-1-charlie@charlie.bz>
 <ee57b0ed-89e2-675e-b080-0059c181a2be@redhat.com>
Date:   Tue, 12 Jan 2021 15:38:36 +1100
From:   "Charlie Somerville" <charlie@charlie.bz>
To:     "Jason Wang" <jasowang@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mst@redhat.com
Cc:     netdev@vger.kernel.org, "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 0/2] Introduce XDP_FLAGS_NO_TX flag
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021, at 14:03, Jason Wang wrote:
>=20
> On 2021/1/9 =E4=B8=8A=E5=8D=8810:49, Charlie Somerville wrote:
> > This patch series introduces a new flag XDP_FLAGS_NO_TX which preven=
ts
> > the allocation of additional send queues for XDP programs.
>=20
>=20
> This part I don't understand. Is such flag a must? I think the answer =
is=20
> probably not.
>=20
> Why not simply do:
>=20
> 1) if we had sufficient TX queues, use dedicated TX queues for XDP_TX
> 2) if we don't, simple synchronize through spin_lock[1]
>=20
> Thanks
>=20
> [1] https://www.spinics.net/lists/bpf/msg32587.html

The patch from Xuan Zhuo looks like a much better approach. I am happy t=
o close this out in favour of that one! Thanks for the link.
