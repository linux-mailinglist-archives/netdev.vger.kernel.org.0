Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFE3191A24
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgCXTkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgCXTkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 15:40:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B599420714;
        Tue, 24 Mar 2020 19:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585078819;
        bh=I+ePW0nru6Tw53B8JC1lGLGEq614UcNeE3ra5Buwg2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zFe05V7tlCMcosmLPppv7M8UN2MRm6kdbF4Ep486jkmJcHnBvE6Oj0o3pOp4rTp27
         wUocnH+raXKgIXuFZs5Jg20Zhhvyj05zwWyGpnNyApGmEwk6wbAHWJ7mMD78vWpyNT
         CdogY8CS0jnaueZziTzby8y/yy3SNVi77o5Z3d3w=
Date:   Tue, 24 Mar 2020 12:40:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 1/4] xdp: Support specifying expected
 existing program when attaching XDP
Message-ID: <20200324124016.17d39c42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <158507357313.6925.9859587430926258691.stgit@toke.dk>
References: <158507357205.6925.17804771242752938867.stgit@toke.dk>
        <158507357313.6925.9859587430926258691.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 19:12:53 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>=20
> While it is currently possible for userspace to specify that an existing
> XDP program should not be replaced when attaching to an interface, there =
is
> no mechanism to safely replace a specific XDP program with another.
>=20
> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_ID, which can =
be
> set along with IFLA_XDP_FD. If set, the kernel will check that the program
> currently loaded on the interface matches the expected one, and fail the
> operation if it does not. This corresponds to a 'cmpxchg' memory operatio=
n.
> Setting the new attribute with a negative value means that no program is
> expected to be attached, which corresponds to setting the UPDATE_IF_NOEXI=
ST
> flag.
>=20
> A new companion flag, XDP_FLAGS_EXPECT_ID, is also added to explicitly
> request checking of the EXPECTED_ID attribute. This is needed for userspa=
ce
> to discover whether the kernel supports the new attribute.
>=20
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
