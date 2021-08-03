Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF9E3DEA2F
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhHCKAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:00:10 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50077 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234813AbhHCKAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 06:00:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7261032000E5;
        Tue,  3 Aug 2021 05:59:57 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Tue, 03 Aug 2021 05:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        stressinduktion.org; h=mime-version:message-id:in-reply-to
        :references:date:from:to:cc:subject:content-type
        :content-transfer-encoding; s=fm1; bh=7MOKSRsCMH6zaAuqEMxQ0nBzsk
        nZxPnxgUSZXXmE6pY=; b=BH1hGW63xEVTH006soeZzDp/hWzOKPGgVOK/mCWE1K
        kRNUMTXsQSrDZDkgmE3YE7V2F1RIET+WxGtEVVpNS7/U0xSrIA4cuR7X1SbVyJox
        4J/t90J18D3y+kszpaYwvsw/qGbRqaEqSD926xpDqEd869LYgmc3T6Fk10Jon9Hx
        vdS671wG+zc8pzAXB/oI4ujZBOzU+1nF2QrZSzRlqh/3i04w7ieQHnhwM8L+aFew
        1XvNRDbIkY72M8VWXo3xa+It3+5vUf30OCvAZ6ACneo6+viACuK8k7T+/wYwecWz
        f+QAEScupr/nJpu3IK8OLe9lzKrt0fc5QjhxY3n5Cb1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=7MOKSRsCMH6zaAuqEMxQ0nBzsknZxPnxgUSZXXmE6
        pY=; b=C9EfJTJdrsw9Kd8X9FeBdn+T8NizhLdGPQgTmpDUSKTfGIbvHCCfywbfw
        QAGw3a+9YbRYQ28FQgC/ZoDr1XCpR/dmDFcr0hsXQJiBSNgeHUMNFYmg/XgzGCE9
        CMw+HsrLC+lx2S/UXDWeeixVlPWhsDAzuCsYwmCSeLL2kuLwH+gLTdTNBMc9jh2m
        D39yBI+veEb5Bl+v28CxnZzKm8tHxuy8QD8bZyIm8WHsVq7ItkWfk7duvNAeEKw0
        7n3P+O6f9xWY84hD5R35HbYC4zA6pX/Ee1c+XAUMlzFjGiF7UL1+xFJzgwwsQ8Nf
        AHZjvGETZnOH4eulQoDRooC57Xy8A==
X-ME-Sender: <xms:mxMJYVQxYGnd8tUPcrwRxx9ykz5VPOnlwJ8ncS3W6LiLSqaswQL4kQ>
    <xme:mxMJYeyUrOPY67-x7BFzE02ZlywLuvfqxQSlzXtIrptsu8ryiBdsd9cwYAuRTEdlw
    TCMMO7Nyx-Mn1isOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrieeggddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdfjrghn
    nhgvshcuhfhrvgguvghrihgtucfuohifrgdfuceohhgrnhhnvghssehsthhrvghsshhinh
    guuhhkthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeevhfevteelkeefgeeftddv
    heejgffgjedvleetffeujeetjedvtdduteelvdetleenucffohhmrghinhepkhgvrhhnvg
    hlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhephhgrnhhnvghssehsthhrvghsshhinhguuhhkthhiohhnrdhorhhg
X-ME-Proxy: <xmx:mxMJYa3IN-esy407UU6ZOasSL6urjqJKF165VDRbIjtnaagiTimlFw>
    <xmx:mxMJYdBLa9tUlmmlQx7EmbcuFZy9IPFiM63LF3P4lQJwUvcg61FUCA>
    <xmx:mxMJYejrz1LAhddmtjibn9_UVSdciAzKgGITLIj_FtBUDFgpCAiznQ>
    <xmx:nRMJYSgyVRUFqTs7pDca3S95qDTOkISXPV3nAgWX1IsmcbNQlZqh_g>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 292DBA03DA9; Tue,  3 Aug 2021 05:59:55 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-548-g3a0b1fef7b-fm-20210802.001-g3a0b1fef
Mime-Version: 1.0
Message-Id: <3017d4a6-8f1b-4f8b-9c73-1121f0251fde@www.fastmail.com>
In-Reply-To: <6b4b7165-5438-df65-3a43-7dcb576dab93@huawei.com>
References: <20210622022138.23048-1-wangkefeng.wang@huawei.com>
 <6b4b7165-5438-df65-3a43-7dcb576dab93@huawei.com>
Date:   Tue, 03 Aug 2021 11:59:34 +0200
From:   "Hannes Frederic Sowa" <hannes@stressinduktion.org>
To:     "Kefeng Wang" <wangkefeng.wang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Daniel Borkmann" <daniel@iogearbox.net>,
        "David Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Minmin chen" <chenmingmin@huawei.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] once: Fix panic when module unload
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Aug 3, 2021, at 04:11, Kefeng Wang wrote:
> Hi ALL, I don't know who maintain the lib/once.c, add Greg and Andrew =
too,
>=20
> Hi David, I check the history, the lib/once.c is from net/core/utils.c=
=20
> since
>=20
> commit 46234253b9363894a254844a6550b4cc5f3edfe8
> Author: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Date:=C2=A0=C2=A0 Thu Oct 8 01:20:35 2015 +0200
>=20
>  =C2=A0=C2=A0=C2=A0 net: move net_get_random_once to lib
>=20
> This bug is found in our product test, we want to make sure that wheth=
er=20
> this solution
>=20
> is correct or not, so could David or any others help to review this pa=
tch.
>=20
> Many thinks.

Thanks for the patch.

I see that it got marked as not applicable for the net trees:
<https://patchwork.kernel.org/project/netdevbpf/patch/20210622022138.230=
48-1-wangkefeng.wang@huawei.com/>

Back then I added this code via the net/ tree thus I think it should get=

picked up nonetheless hopefully.

Regarding your patch, I think it mostly looks fine:

It might be worthwhile to increment the reference counter inside the
preempt disabled bracket in find_module_by_key (and thus also rename
that function to make this fact more clear).

The other option would be to use the macro DO_ONCE and always pass in
THIS_MODULE from there, increment its ref counter in once_disable_jump.
This might be more canonical.

Thanks and sorry for the delay,
Hannes
