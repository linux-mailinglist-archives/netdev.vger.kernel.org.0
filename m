Return-Path: <netdev+bounces-7641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B79D720E8C
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 09:44:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD6E91C212A8
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61EDCBE63;
	Sat,  3 Jun 2023 07:44:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E4EA957
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D88C4339B
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685778243;
	bh=xYfWPnmqvmhHvjBtXOmu6oNPER75NycwsuL1memEjUU=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
	b=Vyoliw2rtxHkj8drtwr2CbCjbrkVI5kMP2LGsErsIjUcLXk2HSBwEsC6z49M0ur/W
	 aUNWbQwFXlDYvh9Cz8SvJdpoC67dvPwDRmkGeVL/I8QsLp5h3v5Zm0pdIoNZXmn4Zt
	 O5BMuwVO8LXA+kLHNaOOaOzR79BUwkva/WOdAdr5PllF4Mcz+UFfAYUsmB6vgcFXT7
	 su+3gg8QOc1UiTwJfUjUgaEnO7RiqWo/Op2v5e4a8JQ59Vh8KwmBMmf6vRh+36J9rW
	 nJHTclWEuC/q+dAwvpXP2SDFjBAyfJafEGYW0u33sXflfWQ4XfdZGX9o1DtZmo4HQj
	 P8H4ng2AOipgw==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailauth.nyi.internal (Postfix) with ESMTP id 7322E27C0054;
	Sat,  3 Jun 2023 03:44:02 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Sat, 03 Jun 2023 03:44:02 -0400
X-ME-Sender: <xms:Qu96ZA0pqZtnqGphoFeGRZVPx5ILpm6K3RwoszbvUDnniPX4u3GzUA>
    <xme:Qu96ZLFE2qf0ClmAR0uDNMJwbSjicLBSfKJBBjXpTrgkMAqaipR2SB4u9j4oB-4Jz
    NKXC628t75WO8Keeh0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelgedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugeskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpedvveeigfetudegveeiledvgfevuedvgfetgeefieeijeejffeggeeh
    udegtdevheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrrhhnugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidquddvkeehudej
    tddvgedqvdekjedttddvieegqdgrrhhnugeppehkvghrnhgvlhdrohhrghesrghrnhgusg
    druggv
X-ME-Proxy: <xmx:Qu96ZI6dMlrgIKMJ23iaCHCDOU9wgH-Q3XSFP19BPNFznHXf2SVCiA>
    <xmx:Qu96ZJ0V5ojqSw7QaVE3UFELP8zKS3Dqs9_aQ1SVmodQbDWDLq4A6w>
    <xmx:Qu96ZDEGYlA0YrufXnbvjWX_LYKIaoxPzHIlM2YyTK4Htn7PhFMYTg>
    <xmx:Qu96ZJNXHUsr1N6JexV0erV7vexxhRTo6Qrawa9bii-n1zi_S-EOvw>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 105D0B60086; Sat,  3 Jun 2023 03:44:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-447-ge2460e13b3-fm-20230525.001-ge2460e13
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <e9601db2-ff7d-4490-abd5-8d3c5946e108@app.fastmail.com>
In-Reply-To: <c7f88295-2e22-4100-b9c8-feb380b64359@app.fastmail.com>
References: <20230417205447.1800912-1-arnd@kernel.org>
 <87ttwnnrer.fsf@kernel.org>
 <504c5a7d-0bfd-4b1e-a7f0-65d072657e0a@app.fastmail.com>
 <87mt2eoopo.fsf@kernel.org>
 <c7f88295-2e22-4100-b9c8-feb380b64359@app.fastmail.com>
Date: Sat, 03 Jun 2023 09:43:35 +0200
From: "Arnd Bergmann" <arnd@kernel.org>
To: "Arnd Bergmann" <arnd@arndb.de>, "Kalle Valo" <kvalo@kernel.org>
Cc: Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: ath: work around false-positive stringop-overread
 warning
Content-Type: text/plain

On Mon, May 8, 2023, at 17:07, Arnd Bergmann wrote:
> On Mon, May 8, 2023, at 16:57, Kalle Valo wrote:
>> With older GCC versions from your page I don't have this problem. I'm
>> using Debian 10 still so so is my libc too old?
>
> (dropping most Cc)
>
> Indeed, thanks for the report, I forgot about that issue. I used
> to build the cross toolchains in an old Ubuntu 16.04 chroot to avoid
> that issue, and I linked all other dependencies statically.
>
> The gcc-13.1.0 builds are the first ones I did on an arm64 machine,
> so I had to create a new build environment and started out with
> just my normal Debian testing rootfs, which caused me enough issues
> to figure out first.
>
> I had previously experimented with linking statically against
> musl to avoid all other dependencies, but that ended up with
> slower binaries because the default memory allocator in musl
> doesn't work that well for gcc, and I never quite figured out
> how to pick a different memory allocator, or which one to use.
>
> I should probably just pick an older Debian release that is new
> enough to contain cross compilers for arm64 and x86 and then
> set up the same kind of chroot I had in before.

It took me a while, but now I have a working build setup
in a Debian Buster schroot with gcc-13 as the main compiler,
and I updated the gcc-13.1 binaries with those, as well as
uploading gcc-11.4 and gcc-12.3 build the same way.

I have only tested the binaries on arm64 Debian testing,
could you see if the new x86 builds work for you?

       Arnd

