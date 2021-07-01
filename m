Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98CF3B8D7D
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 07:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhGAFtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 01:49:22 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:57009 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229777AbhGAFtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 01:49:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4F0523200914;
        Thu,  1 Jul 2021 01:46:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 01 Jul 2021 01:46:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2R5Ejh
        vo7xrZ1UcgrwCjSHU0obIANFpgAR/43OEHuRI=; b=So7uwteeBfZq8oFMkbv3VE
        3Yg3nxvJeVSlSKSuUFYQ99vyi2bmnVsQVAJOrFJpzhjwR6hzX4lCus1MMTlh4lK2
        G1SgO6NmaUCTLi057NQ9MbVL4fY7LGelcskp4r7FLLdsZkvEZnYSflrg8aTs/h4w
        DHmTuhqb6A1e+/QvWGz+uKQ3T0wMApnFqPhD93HU2xGLLXBZZEqWH15A0D2wSpaX
        cGJm7plxhxz8ITAYLsRmEWZgWQJcdkPeh18/wIUrtNcmFY/QdyojHYaczDe0WPzR
        bX/QVsiJfSW2sdL5VonjqFAJt/P78dNphiqW1kZQtI55CdIs6RBT2XNv286lrOwQ
        ==
X-ME-Sender: <xms:ylbdYLOdFbxpSsRgkZS2X_H_hqdFiQr2_HKVgzXUvFvGe0UFltkzzg>
    <xme:ylbdYF8T3WPxVmVve1GMzdA5--YJ14xapwNKUM1MYXVACQrVR-z1YGExOUXOHEgZt
    yRkDvoZ1QAHs8A>
X-ME-Received: <xmr:ylbdYKTxfFmxCT_HL5f7UTdV31EdU10eGUb5kc1VOewNaFW9eE8U-Ae-ox7Uf8pmJ6u6N4RFh1EhVaKoJ9ZA1NV30glI9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeihedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ylbdYPumX5uu9il_gNIDhcGn35DwZP7Rk99M5zzruhNLNXL4DPidoQ>
    <xmx:ylbdYDdfZ-38LklA5avrWDjLD2tGsOa20VD3RIxnzwDDVo6Od4RsIA>
    <xmx:ylbdYL2QKe6HrJ9g9GfiohjqCn2ziW1pdFIyRHG35K-8BausVUbSzw>
    <xmx:ylbdYK7vITnO-eFx1voJeB3S-ylq4cf-T4iVIa6cqZIr6O0YiAHysw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Jul 2021 01:46:49 -0400 (EDT)
Date:   Thu, 1 Jul 2021 08:46:46 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] selftests: forwarding: Test redirecting gre
 or ipip packets to Ethernet
Message-ID: <YN1Wxm0mOFFhbuTl@shredder>
References: <cover.1625056665.git.gnault@redhat.com>
 <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 02:51:38PM +0200, Guillaume Nault wrote:
> diff --git a/tools/testing/selftests/net/forwarding/topo_nschain_lib.sh b/tools/testing/selftests/net/forwarding/topo_nschain_lib.sh
> new file mode 100644
> index 000000000000..4c0bf2d7328a
> --- /dev/null
> +++ b/tools/testing/selftests/net/forwarding/topo_nschain_lib.sh
> @@ -0,0 +1,267 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# A chain of 4 nodes connected with veth pairs.
> +# Each node lives in its own network namespace.

Hi,

The tests under tools/testing/selftests/net/forwarding/ are meant to use
VRFs as lightweight namespaces. This allows us to run the tests on both
physical switches with loopback cables and veth pairs, thereby
validating both the hardware and software datapaths.

See tools/testing/selftests/net/forwarding/README

If the tests cannot be converted to VRFs, then I suggest moving them to
tools/testing/selftests/net/

> +# Each veth interface has an IPv4 and an IPv6 address. A host route provides
> +# connectivity to the adjacent node. This base network only allows nodes to
> +# communicate with their immediate neighbours.
> +#
> +# The two nodes at the extremities of the chain also have 4 host IPs on their
> +# loopback device:
> +#   * An IPv4 address, routed as is to the adjacent router.
> +#   * An IPv4 address, routed over MPLS to the adjacent router.
> +#   * An IPv6 address, routed as is to the adjacent router.
> +#   * An IPv6 address, routed over MPLS to the adjacent router.
> +#
> +# This topology doesn't define how RTA and RTB handle these packets: users of
> +# this script are responsible for the plumbing between RTA and RTB.
> +#
> +# As each veth connects two different namespaces, their MAC and IP addresses
> +# are defined depending on the local and remote namespaces. For example
> +# veth-h1-rta, which sits in H1 and links to RTA, has MAC address
> +# 00:00:5e:00:53:1a, IPv4 192.0.2.0x1a and IPv6 2001:db8::1a, where "1a" means
> +# that it's in H1 and links to RTA (the rest of each address is always built
> +# from a IANA documentation prefix).
> +#
> +# Routed addresses in H1 and H2 on the other hand encode the routing type (with
> +# or without MPLS encapsulation) and the namespace the address resides in. For
> +# example H2 has 198.51.100.2 and 2001:db8::1:2, that are routed as is through
> +# RTB. It also has 198.51.100.0x12 and 2001:db8::1:12, that are routed through
> +# RTB with MPLS encapsulation.
> +#
> +# For clarity, the prefixes used for host IPs are different from the ones used
> +# on the veths.
> +#
> +# The MPLS labels follow a similar principle: the first digit represents the
> +# IP version of the encapsulated packet ("4" for IPv4, "6" for IPv6), the
> +# second digit represents the destination host ("1" for H1, "2" for H2).
> +#
> +# +----------------------------------------------------+
> +# |                    Host 1 (H1)                     |
> +# |                                                    |
> +# |   lo                                               |
> +# |     198.51.100.1    (for plain IPv4)               |
> +# |     2001:db8::1:1   (for plain IPv6)               |
> +# |     198.51.100.0x11 (for IPv4 over MPLS, label 42) |
> +# |     2001:db8::1:11  (for IPv6 over MPLS, label 62) |
> +# |                                                    |
> +# | + veth-h1-rta                                      |
> +# | |   192.0.2.0x1a                                   |
> +# | |   2001:db8::1a                                   |
> +# +-|--------------------------------------------------+
> +#   |
> +# +-|--------------------+
> +# | |  Router A (RTA)    |
> +# | |                    |
> +# | + veth-rta-h1        |
> +# |     192.0.2.0xa1     |
> +# |     2001:db8::a1     |
> +# |                      |
> +# | + veth-rta-rtb       |
> +# | |   192.0.2.0xab     |
> +# | |   2001:db8::ab     |
> +# +-|--------------------+
> +#   |
> +# +-|--------------------+
> +# | |  Router B (RTB)    |
> +# | |                    |
> +# | + veth-rtb-rta       |
> +# |     192.0.2.0xba     |
> +# |     2001:db8::ba     |
> +# |                      |
> +# | + veth-rtb-h2        |
> +# | |   192.0.2.0xb2     |
> +# | |   2001:db8::b2     |
> +# +-|--------------------+
> +#   |
> +# +-|--------------------------------------------------+
> +# | |                  Host 2 (H2)                     |
> +# | |                                                  |
> +# | + veth-h2-rtb                                      |
> +# |     192.0.2.0x2b                                   |
> +# |     2001:db8::2b                                   |
> +# |                                                    |
> +# |   lo                                               |
> +# |     198.51.100.2    (for plain IPv4)               |
> +# |     2001:db8::1:2   (for plain IPv6)               |
> +# |     198.51.100.0x12 (for IPv4 over MPLS, label 41) |
> +# |     2001:db8::1:12  (for IPv6 over MPLS, label 61) |
> +# +----------------------------------------------------+
> +#
> +# This topology can be used for testing different routing or switching
> +# scenarios, as H1 and H2 are pre-configured for sending different kinds of
> +# packets (IPv4, IPv6, with or without MPLS encapsulation), which RTA and RTB
> +# can easily match and process according to the forwarding mechanism to test.
