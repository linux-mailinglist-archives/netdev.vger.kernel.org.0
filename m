Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D52A2840EE
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbgJEUeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:34:23 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49288 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727247AbgJEUeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:34:23 -0400
IronPort-SDR: ihMSyewfRL9luudDC+9vDZHhEVBpEWTNrdDGXUlfAKcuikrh5SU5ytr6Kj514FZGLbZ8zX3bIz
 ABebCD6lVt1cNwZvpOvCxYZD2SkEHszMs/Uq59nIO62JatTzWPLJ+BAWLAdGwU98Devv6+mEKy
 afar4kwG2BrOckgVwd6iTud5CojRW/xeSM0j/36numqk+6sWjhwd+zNyN0BHXB4VOgPhVOFLVd
 ZdhtvYFdPYIn4zK9t3i87X7cbW5M0wUq88w/1v9ckwfurOADl3aXa3cRKcaMYfFd969fqAEC9a
 Y9o=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AkkwERB1Men8rXO44smDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsesSL/zxwZ3uMQTl6Ol3ixeRBMOHsq0C17Cd6vu5EUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCe/bL9oIxi6swrdutQYjId/N6081g?=
 =?us-ascii?q?bHrnxUdupM2GhmP0iTnxHy5sex+J5s7SFdsO8/+sBDTKv3Yb02QaRXAzo6PW?=
 =?us-ascii?q?814tbrtQTYQguU+nQcSGQWnQFWDAXD8Rr3Q43+sir+tup6xSmaIcj7Rq06VD?=
 =?us-ascii?q?i+86tmTgLjhSEaPDA77W7XkNR9gqJFrhy8qRJxwInab46aOvdlYq/QfskXSX?=
 =?us-ascii?q?ZbU8pNSyBMBJ63YYsVD+oGOOZVt4nzqEEVohu/HwasAv7kxD9ShnDowKI1zf?=
 =?us-ascii?q?4hEQDa0wwjAtkDt3rUo8/uO6ccSu2116rIzDXFb/xIxTfx8pPHfQ44rPyKQL?=
 =?us-ascii?q?l/ftbfx1M1GAPZklWft5blPzWN2+oDsGWW6+puWOOvhmI5pQx/oiWiytsxho?=
 =?us-ascii?q?XVh48bxV/K+Dh3zYsrONC1SEx2bMCrHpdMuS+UOI97TMMiTW12vCs3zKANt5?=
 =?us-ascii?q?2jfCUSzJkr2gTTZ+GEfoSW+B7vSeecLDdiiH54eb+ygQu5/1K6xe3mTMa01U?=
 =?us-ascii?q?5Hri9CktbRqH8AzwfT6s2bSvtl+UehxCqP2xjT6u5aJUA0krLWK5omwrEsjJ?=
 =?us-ascii?q?UTtUTDHijtmEXqlqOWckIk9fSy5OTjf7rmoZqcOJV1igH4Kqgum8q/DvokMg?=
 =?us-ascii?q?UWW2WX5P6w2KDg8EHnWrlGk/w7n6nDvJzHJMkXvqu5DBVU0oYn5Ra/FTCm0N?=
 =?us-ascii?q?EAkHkJNl1KYxyHgpPyO1HNIPH4C+mwg0i2nDhw2f/KJqfhDYnVLnjfjLfheq?=
 =?us-ascii?q?5w5FNGxwot099f4olZBawbL/LtREDxsdjYDhg3Mwyo2ernDsty1p8GU2KVHq?=
 =?us-ascii?q?CZKL/SsUOP5u83IOmMeZQatyzmJvgm+fHul3k5lkEZfaWz2psXcn+4FOx8I0?=
 =?us-ascii?q?qFeXrsnssBEWASswo4UuPqlECNXiBNZ3upQaI86S80CJi8AYfAWI+tmrqB0z?=
 =?us-ascii?q?m/HpFMYWBGEF+MG2/yd4qYQ/cMdD6SIsh5nzwcT7euUIsh1Ra1uQ/81bVnMu?=
 =?us-ascii?q?TU+iwctZL/ytd1/ffflRYo9Tx7F86dyX2CT3lonmMUQD87xKR/rlZzyleEy6?=
 =?us-ascii?q?h4jOJXGMdc5/NPTwc6MJncz+p5C9DpQA7Bec2JSFm+SNW8HT4xVs4xw8MJY0?=
 =?us-ascii?q?tlANWikg7M3ySkA7ALkbyHHp808qbG0HjqPMZy1WzG1LU6glk9XMRAKXCmhq?=
 =?us-ascii?q?hh+AjPHYLGj0KZl6Oyf6QGwCHN7HuDzXaJvExAUA5/T7/FUmsBaUvMsdT0/U?=
 =?us-ascii?q?zCT7ioCbs6NQtB09SOJbFSatLzi1VJXu3vONPEY2K+gWu/HwuIzKuWbIX2Y2?=
 =?us-ascii?q?UdwDndCE8cngAL5naGNRYxBiO7rGLEFzFuEkzvY0X2/el5snO7QVc+zxuWYE?=
 =?us-ascii?q?15y7q15hkViOSBRPwNwLIJoyAhqy1qE1a7wdLWENSBpwt9fKpAYdMx+lBH1X?=
 =?us-ascii?q?jWtwZlJJyvM7hihkICcwRwp07v1xJ3Cp5AkcgksXMqzgtyJLmc0FNAcTOYwJ?=
 =?us-ascii?q?/xNqTWKmnq4hCiarTa2lbE0NaZ4q0P8ug3q03/vAG1EUov63Zn08RU0nua+J?=
 =?us-ascii?q?rKEBEfUZfqUkop7RR6prfaYjMn64zOyXJgK7O0siLa0dIzGOQl0gqgf8tYMK?=
 =?us-ascii?q?6cGg/9CdYVB8a1JewxmFiobhQEM/5O9KIuJMypaajO5Kn+MO9+kTeOgW1Z7Y?=
 =?us-ascii?q?V51UyQsSxxVqqA3IsPytmb0xGBWjO6i02u9ojxlJxIaC86AGWy027nCZRXa6?=
 =?us-ascii?q?k0epwEWkm0JMji6Nx0hpfrE1BC+VKuHVIN24f9dxOYYXTm3hxW2FhRq3Hxyn?=
 =?us-ascii?q?jw9CB9jzx89vnX5yfJ2em3LBc=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AsDADggntf/xCltltgHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFHgUgCgRyCUY4eklaKWYUxgXwLAQEBAQEBAQEBNQECBAEBhEq?=
 =?us-ascii?q?COyY7Aw0CAwEBAQMCBQEBBgEBAQEBAQUEAYYPRYI3IoNSASMjgT+DOIJYKap?=
 =?us-ascii?q?KhBCFC4FCgTgBiDGFGoFBP4RfijQEt02CcYMThGuSVA8ioR8tkmeiPAKBZU0?=
 =?us-ascii?q?gGIMlTxkNnGhCZwIGCgEBAwlXAT0BjTIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2AsDADggntf/xCltltgHAEBAQEBAQcBARIBAQQEAQFHg?=
 =?us-ascii?q?UgCgRyCUY4eklaKWYUxgXwLAQEBAQEBAQEBNQECBAEBhEqCOyY7Aw0CAwEBA?=
 =?us-ascii?q?QMCBQEBBgEBAQEBAQUEAYYPRYI3IoNSASMjgT+DOIJYKapKhBCFC4FCgTgBi?=
 =?us-ascii?q?DGFGoFBP4RfijQEt02CcYMThGuSVA8ioR8tkmeiPAKBZU0gGIMlTxkNnGhCZ?=
 =?us-ascii?q?wIGCgEBAwlXAT0BjTIBAQ?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:34:20 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        pshelar@ovn.org, dev@openvswitch.org, yoshfuji@linux-ipv6.org,
        kuznet@ms2.inr.ac.ru, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/9 net-next] drivers/net: add sw_netstats_rx_add helper
Date:   Mon,  5 Oct 2020 22:33:57 +0200
Message-Id: <20201005203357.55076-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small patchset creates netstats addition dev_sw_netstats_rx_add()
based on dev_lstats_add() and replaces some open coding
in both drivers/net and net branches.

Fabian Frederick (9):
  net: netdevice.h: sw_netstats_rx_add helper
  vxlan: use dev_sw_netstats_rx_add()
  geneve: use dev_sw_netstats_rx_add()
  bareudp: use dev_sw_netstats_rx_add()
  gtp: use dev_sw_netstats_rx_add()
  ipv6: use dev_sw_netstats_rx_add()
  xfrm: use dev_sw_netstats_rx_add()
  net: openvswitch: use dev_sw_netstats_rx_add()
  ipv4: use dev_sw_netstats_rx_add()

 drivers/net/bareudp.c                | 11 +++--------
 drivers/net/geneve.c                 | 11 +++--------
 drivers/net/gtp.c                    |  8 +-------
 drivers/net/vxlan.c                  |  8 +-------
 include/linux/netdevice.h            | 11 +++++++++++
 net/ipv4/ip_tunnel.c                 |  8 +-------
 net/ipv4/ip_vti.c                    |  9 +--------
 net/ipv6/ip6_vti.c                   |  8 +-------
 net/openvswitch/vport-internal_dev.c |  8 +-------
 net/xfrm/xfrm_interface.c            |  9 +--------
 10 files changed, 24 insertions(+), 67 deletions(-)

-- 
2.28.0

