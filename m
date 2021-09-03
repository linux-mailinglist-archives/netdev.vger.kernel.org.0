Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B43400854
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350772AbhICX0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244436AbhICX0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 19:26:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B2A160FDC;
        Fri,  3 Sep 2021 23:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630711546;
        bh=2hug832GJVtzrYvTvTp/Z6fnqDv0J6Tt1NOdriwux7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aHy1L04+CSr5H32nt2zgsUjRjyqzOE7W8gQiSpgka29Lmvhm8F1SbdZWD4iNo85JX
         NjfP5AWptaLs7k3GirxkdcZ1hbrx6hKOj1HHZlehV4tUXrBYLcVULrbCQU9d6joeTc
         1N7s7xZeg1MwycD5Nto+GXknCHypR17NHwW3seSClnlfoYCwzY9DEAy0LiuVNkF9FV
         +E4u3Gpj1tRVSxEIAFbJ8bVKccx+Rohswc1uMJes5QJggoH+uWiIdGjR5x67+SuE7f
         +hnPX8vPzcsBJdNksAr78KLib47itPGA5Xi275XUuYAfmqHViG5+O7ePopIi2kNNtB
         KuOlnPKWVfWnw==
Date:   Fri, 3 Sep 2021 16:25:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toms Atteka <cpp.code.lv@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: openvswitch: IPv6: Add IPv6 extension
 header support
Message-ID: <20210903162545.6e12b15c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210903205332.707905-1-cpp.code.lv@gmail.com>
References: <20210903205332.707905-1-cpp.code.lv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Sep 2021 13:53:32 -0700 Toms Atteka wrote:
> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> packets can be filtered using ipv6_ext flag.
>=20
> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>

net/openvswitch/flow.c:268:6: warning: no previous prototype for =E2=80=98g=
et_ipv6_ext_hdrs=E2=80=99 [-Wmissing-prototypes]
  268 | void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh, u16=
 *ext_hdrs)
      |      ^~~~~~~~~~~~~~~~~
net/openvswitch/flow.c:268:6: warning: symbol 'get_ipv6_ext_hdrs' was not d=
eclared. Should it be static?
net/openvswitch/flow.c:243: warning: This comment starts with '/**', but is=
n't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Parses packet and sets IPv6 extension header flags.


Also please CC appropriate maintainers on your submissions
(scripts/get_maintainers is a good guide) and besides that:


# Form letter - net-next is closed

We have already sent the networking pull request for 5.15
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.15-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
