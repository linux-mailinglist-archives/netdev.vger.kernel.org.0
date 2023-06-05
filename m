Return-Path: <netdev+bounces-8197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4958B723152
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B30F71C20DAE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F293261D7;
	Mon,  5 Jun 2023 20:27:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAB71118D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 20:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AF7C433D2;
	Mon,  5 Jun 2023 20:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685996849;
	bh=i+PYEkJ06n1TcS7Wc1yTF0Ehkl8WlefWCxBby9xAljY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=o4CDvVXXqDcSu2XUOZKombkbMvTRzMoR8LcbFyk7coCZZFKe1HeO6OR2EYuGWQzwq
	 z3pVaWspr3is7fZ9g2kK/iy9kN30dpIqhGlyidiSdwk7ZogoQmiWJ3ZFz8iT7IW2l6
	 aByYsMAKKSPAl7ri3YDeqW4WZtpUwEK24oCBtAFIEhSEdYJMQ3qbAIREm4T2tNneNS
	 1Xa/Wv6xPwHkX9TgRBWLTsljEvbQ/6WCJRquVnLB+Wo+Xsy7H13/hHPBkkM4AaxwsV
	 OoTriIAQhOWcqXxuIbetdFRwn1D0JdrgJXy/kQjVYT022h1LBK4OxBFqCKj3b+ZqUB
	 eMbFzrADA2Gaw==
Date: Mon, 5 Jun 2023 13:27:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Ertman, David M" <david.m.ertman@intel.com>
Cc: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 00/10] Implement support for SRIOV + LAG
Message-ID: <20230605132728.022935ff@kernel.org>
In-Reply-To: <MW5PR11MB5811118836C780A1B0B4F9D6DD4DA@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
	<MW5PR11MB5811118836C780A1B0B4F9D6DD4DA@MW5PR11MB5811.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Jun 2023 19:12:59 +0000 Ertman, David M wrote:
> This got fat-fingered sent.  It still needed to be re-based on
> current tip-of-tree and is mislabeled as net instead of net-next.
>=20
> Will resend V3 in 24 hours =E2=98=B9
>=20
> Again, sorry for the thrash.

I figured - if there's no strong reason I wouldn't resend, tho.
People who are interested in reviewing can work on this version.

