Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80C022F415
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbgG0PrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:47:23 -0400
Received: from mout.gmx.net ([212.227.17.22]:59767 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgG0PrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 11:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1595864841;
        bh=mN6GANnkf0eAnusNsrpKeRJ15wx8yxDIaswTKwVd64Y=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=QY2pES+4OMDronUjoYA0STHFs/a8MpHXbMgKOjieXMU+wbzEtnnVJ6psp9XlG+DFz
         NpFLkrQx7Ylb9DHNiFl1borzshDjYcgba64H9frYD7D8cCht3Zg0hALV6ri0Z9nNn9
         tCH+zIfEAeNrEtXMeaKxjXO21vkWUrUmcNrA4axM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from gmx.fr ([161.0.158.19]) by mail.gmx.com (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MplXp-1kaTNF3ift-00qDID; Mon, 27
 Jul 2020 17:47:21 +0200
Date:   Mon, 27 Jul 2020 11:47:15 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     netdev@vger.kernel.org
Subject: Broken link partner advertised reporting in ethtool
Message-ID: <20200727154715.GA1901@gmx.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:b/wItvzNk8M0IIwLiEXV+a3gzBMnY7EybQSvcx/eAMLIpF0FB0k
 AkQfMaHhryI36yBRJkFxSECuIN9O+pSfUV36+cc8aW02S+I1nMYaaKHigFZf0gOCEsjSSvO
 JIZm/U5cqHDcftV6hOsdVd5bcuWZtwSsaGsTXuKJvmG4Et6p6NTWduR7VsW+Yxg0UrXkkGV
 x/AbeshTpcTjKyUTBD1Sg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6hB9fgx7QIc=:tcEI30ma6VgI9gga7B72qF
 3GN+7MFyexeXXfCXiVz3akJfMhBu9ZSs6sL1R+XfW32CFu264eZ/3uTg5EYHP1tlClrnI3kDS
 6IuFOgZyvjYvNOu3yBWcA4IdemclOhafd+73HaPgUqkEQKa3T/X1UNu3EE6BpKD1S1/oFY9Lj
 zwIhQWFPIW8aq8k2EgArqMUiORMfhTZMNECV/vplJ7rCFSRyqE+oHj/LmfHGbcUcazm0lf13x
 zbbmvb+eznJ8/slycS4BqrigWLhw038syeiIIdKyF/q2LKB8+aAK72J86E1Q3gWmU8bsGe0O2
 89m7zD90CeyC1znxbASs3j+OBI+52gw89fsRaMandVbNU7l8ji6LJ9rUGGwat988Dk0sq33YR
 qbYs3xeNp0+jaEFdgw0sq9UJ20DA3WBt9kQN2ipY6XkTqKs5IiawN/42Ung/qRs1hSIi/40a3
 bC9WV/tpUsDdvOB1R/saZ/R4WQ1Zf7vQaHJfG348pBKG5X/vfwmyxEkoosW5vo143nh2dECA4
 UaEgsPS1h3DoiDFHOM0eXDLFeyiGH7hRGN5aksrxwfEcddMJRk4f2aL+FvPPT+dNoc3xMFYV7
 nrHohZwNrUtmZ5PwBZMefpFpuN5awWJbmBpI0P1kK/UKv8wqw4QpBQSW8eutFgL/UlzZLl0jg
 AjE+a3BW12mLk/Y9LQdNO6kezQEMcm75WVKujd/EUcoPxRXPJqpf4+R6wHkjXMHBY2ouFkZ6T
 lwel4BDLCB2N0w9ju9I7nFyB+d2MM6wUCqHH9ixee16BT4ClskfV9styU9cNtxKli32QHQkoI
 xWIWB1DEiDwy64mwVJiKbz+w+N8ns443hnNRvc6ZGEkVnxw3ypgufJUfpXDEbJia7ipYJVod3
 VPlUsvaWXGmoM9IAz5e24gsU1Z7DTkAdnRaLdPNy7tjA8YcFeXMmvRsu6iDRRTy+6FdijjRQg
 qPsBjYH5O8SLzp3Jua0pn/BrdmZZY4K54S9EVYl+vwsmmkoQ4bw5RMOXuWYCsPkq/h17nFgS2
 j4GFRC1+tzYnFDQEWdicpZBALXVptFvaG7QKLqgJ7Bjvgwu4OEfeRgC1bmwW6uQcupuFnCB/Y
 F5xKiqlYgcnlYztOzAux8PdGYiKI651ri3oXQoJ36wAZiAVSxPhP13BO/A6o9l0bPIrw7JtXs
 wFm4CCoGKzNYGX55DMFiSMuBJD6MppFqn2FpvooOHIdWxMekLfyvgs4liErRPKME7Tgh5H6Sa
 XilemjHvfoaZvMSFPlRcnK7G1GwC3/E9Dg76KQA==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

While having a discussion with Sasha from Intel. I noticed link partner
advertised support is broken in ethtool 5.7. Sasha hinted to me, the
new API that ethtool is using.

I see the actual cause in dump_peer_modes() in netlink/settings.c, that
the mask parameter is set to false for dump_link_modes, dump_pause and
bitset_get_bit.

Regards,
Jamie Gloudon
