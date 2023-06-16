Return-Path: <netdev+bounces-11536-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77207733814
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BEB7280E4A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505BF1DCBC;
	Fri, 16 Jun 2023 18:26:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3528A1C774
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB3BC433C8;
	Fri, 16 Jun 2023 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686939997;
	bh=nPsZFlwn5qGnnVU4mxSlpErJ0FOZ69VUTXp5WTIuC7Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dBJa6Gf1pe3Eihsl4ZaN8VrLmScUFxZwGuV2ZDOmp6F9KJ3dYXVIRKfwbz9j1QhFZ
	 IrE5UcDmZ9etV2Ddyvc7rNVdbbzq0aTdG1gi95N+bmZX3cG5YzFJ8ur7w6r01WWDiz
	 Vow9rxVbGmYKumnttQ2cA/wjWvmSXocJY5q34gOPuO+CPEqXT9y1SsRJeRm5sRVzTV
	 iXSRL2sR5Z58Z474j7ntuzx349ZnGOsDpCoc/ILeWzmdzKHs6Azye/S7pODZcFxQL3
	 3tQvobbgT6Ff9M71w+no9xLAfcVoRzaSIggyqxHpSFQ9ETM2BCknLXFRnIGEXr20u0
	 nwzIK2nodxCFg==
Date: Fri, 16 Jun 2023 11:26:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, netdev@vger.kernel.org,
 rust-for-linux@vger.kernel.org, aliceryhl@google.com, andrew@lunn.ch
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <20230616112636.5b216a78@kernel.org>
In-Reply-To: <CANiq72mAHv8ozBsZ9-ax9kY8OfESFAc462CxrKNv0gC3r0=Xmg@mail.gmail.com>
References: <20230614230128.199724bd@kernel.org>
	<CANiq72nLV-BiXerGhhs+c6yeKk478vO_mKxMa=Za83=HbqQk-w@mail.gmail.com>
	<20230615191931.4e4751ac@kernel.org>
	<20230616.211821.1815408081024606989.ubuntu@gmail.com>
	<CANiq72mAHv8ozBsZ9-ax9kY8OfESFAc462CxrKNv0gC3r0=Xmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 15:23:01 +0200 Miguel Ojeda wrote:
> Not necessarily. It is true that, in general, the kernel does not
> want/accept duplicate implementations.
> 
> However, this is a bit of a special situation, and there may be some
> reasons to allow for it in a given subsystem. For instance:
> 
>   - The need to experiment with Rust.

Duplicated driver in a new language means nobody has a real incentive
to use it in production. That really mutes the signal we get out of the
experiment. At the same time IIUC building the Rust code is not trivial,
so IDK if we're ready to force people to use it. Ugh.

Do you have any idea how long it will take until one can 
 dnf install $rust
and have that be enough to be build a kernel (for the two major arches)?

