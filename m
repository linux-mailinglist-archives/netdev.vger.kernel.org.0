Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9CE2A1AA6
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 22:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgJaVMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 17:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgJaVMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 17:12:54 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0BBC206E9;
        Sat, 31 Oct 2020 21:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604178774;
        bh=O0zZE71jaQQVKJcpkWVn5+kqfmDOAZoBLv2C4aM1hJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U8nU3aVRjifpWFtgecdGp4AsQlhzS47rLGv0/3tsJ1i1nEQlHfV5RkTYktL9dGEz6
         qcphWPW3w/B2jYu5i+4RcoXGhr0Oz6f/NP7V4QXEcLd0C3aicNN825yN5b3De82cUh
         AbXzULLm324zUZPwGJ3QymIPJk3CYjfwSesa/Ffs=
Date:   Sat, 31 Oct 2020 14:12:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Georg Kohmann <geokohma@cisco.com>
Subject: Re: [PATCHv6 net 0/2] IPv6: reply ICMP error if fragment doesn't
 contain all headers
Message-ID: <20201031141252.25da81fd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027123313.3717941-1-liuhangbin@gmail.com>
References: <20201027022833.3697522-1-liuhangbin@gmail.com>
        <20201027123313.3717941-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 20:33:11 +0800 Hangbin Liu wrote:
> When our Engineer run latest IPv6 Core Conformance test, test v6LC.1.3.6:
> First Fragment Doesn=E2=80=99t Contain All Headers[1] failed. The test pu=
rpose is to
> verify that the node(Linux for example) should properly process IPv6 pack=
ets
> that don=E2=80=99t include all the headers through the Upper-Layer header.
>=20
> Based on RFC 8200, Section 4.5 Fragment Header
>=20
>   -  If the first fragment does not include all headers through an
>      Upper-Layer header, then that fragment should be discarded and
>      an ICMP Parameter Problem, Code 3, message should be sent to
>      the source of the fragment, with the Pointer field set to zero.
>=20
> The first patch add a definition for ICMPv6 Parameter Problem, code 3.
> The second patch add a check for the 1st fragment packet to make sure
> Upper-Layer header exist.

Applied, thank you!
