Return-Path: <netdev+bounces-1905-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 846776FF78E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:38:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 955351C210C4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2DC4693;
	Thu, 11 May 2023 16:38:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629FC656
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:38:48 +0000 (UTC)
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A83191;
	Thu, 11 May 2023 09:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=S5sSOihAPDoJskkXfQCZv8/1DF5rWBymy8J4UjuaQX8=;
	t=1683823126; x=1685032726; b=DSpsQh67pb7blGSs3PfgJFkcjn4CXX1C65xBWGZBr0xSGpB
	9iPo8EmwYzE3l0ttqUhH/LPt1twLpnOKo0rEcgHBuflpYjYDzaso5XFZQ6FWoyuXshUxgyEjzvvZX
	yg+v0teWzL9LuFurg09tRREj9knDaWFP0hT0EdhsuzacQIuv1TSV2LMAoKAQYa82aW1/fduP+Sbi/
	zXmD93WVNJXC0GgXJVWzUI15rdJMsz0el/Kb6na4LKXGmQcC8WWmyxO3EMkpeoC86ZptYZUbxcQlz
	GU9covqfnS1Kf+2HpQvIgNYYg1W7qb1uAEECGa2iNkpuiEXNMhgi+5TgY0ORvnGQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1px9JO-006YXk-35;
	Thu, 11 May 2023 18:38:39 +0200
Message-ID: <d505bf5bbcd0f13a37f9c8465667e355ce20bc26.camel@sipsolutions.net>
Subject: Re: [PATCH net] MAINTAINERS: exclude wireless drivers from netdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com, 
	kvalo@kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 11 May 2023 18:38:37 +0200
In-Reply-To: <20230511160310.979113-1-kuba@kernel.org>
References: <20230511160310.979113-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-05-11 at 09:03 -0700, Jakub Kicinski wrote:
> It seems that we mostly get netdev CCed on wireless patches
> which are written by people who don't know any better and
> CC everything that get_maintainers spits out. Rather than
> patches which indeed could benefit from general networking
> review.
>=20
> Marking them down in patchwork as Awaiting Upstream is
> a bit tedious.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: kvalo@kernel.org
> CC: johannes@sipsolutions.net
> CC: linux-wireless@vger.kernel.org
>=20
> Is this okay with everyone?
>=20

Yeah, makes sense.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Are you going to take it (since you marked it 'net')?

johannes

