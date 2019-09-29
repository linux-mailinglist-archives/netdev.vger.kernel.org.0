Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8552C1918
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 21:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbfI2TUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 15:20:47 -0400
Received: from mout.web.de ([212.227.17.12]:50381 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbfI2TUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Sep 2019 15:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569784836;
        bh=hE5ERmbJdatCfSZVx0wUmPXJyNmxDS4xNZkEs0yAy4I=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=OylRTe80p7QIzYDagDU+dsD3jVPW8SRXkpy+SuwjgSV4iHlk1SNTMp49edbuSNUad
         fAEXvLHjDfIuP/gawSvqlkQYOBoipWYRvfwITyw9e9kKh04nmbly9Bh5xa8zC7J/u6
         r7cZiZZYFgJhHyBfQAR+hXYk5cVtxACsLfjE7uDQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from minako.localnet ([95.91.225.206]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MfYrH-1iUQcC3yhP-00P4Bx; Sun, 29
 Sep 2019 21:20:36 +0200
From:   Jan Janssen <medhefgo@web.de>
To:     netdev@vger.kernel.org
Cc:     Vedang Patel <vedang.patel@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Regression: Network link not coming up after suspend/resume cycle
Date:   Sun, 29 Sep 2019 21:20:34 +0200
Message-ID: <71354431.m7NQiGp1Tu@minako>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:3nG8jZbhEarZEOb6uvjxODYcnlRE+Xe7dEJUZw5aqHmPXKIPatm
 hksPPKzWc/n6ykdcRaEXVMEfjMzi/g+iXvd3Ou8K26P2cbTwxZU4fPJ3GRIV6EtZEnV5ZM7
 zJHljGkafIq/qI9JN9Xxh33irWp/cdfEOYlEhaPdxPLt2Qbojnz0Rlvmap8LWU7SisihXJo
 PfqqkAPIbtiLNhcLWJUvw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:IXL7Xr8ZVac=:a0a5a1r5wujbsyhSinYyAp
 HTjz560Hk2Bdvj+Jnuwq3DdsXvWl6oWeXZaFW/6Vb7IuCIukCs8uZvU+1XIzSC9r/z7/4uWFo
 FLg0WGiBcYehs3zxOavi8KLVsOLjXwy42MSjbt0sd2oKfNpd3eoGFZda3dlTasC+tl42NxRrS
 i3VNEPE28KTggrYat2vwexixfeDpFRWxUEtDjEe1MH+d1BL9GqqSC7ybNO5gw4afgXc8bgLrA
 MkmU8rDUejXjcC1uYuC2AypJ1P3qvi3/dlhpJiOIRVrqhebSAFN9bxnyVw8eGG4Ml2+msD5Zu
 QFFNQS2AEPAsDzD8sVZvC/EYpQ3ImMRWlzWxflC/ixTZLNEIklbXXKvqKaqb6nHFKwRPjhfFo
 SEymTIVejyFoxvwiUCli9vk0IBxv3lFgB9lntuvNmgpw78y80LAxLaEWaaByc90RAenY9NT2K
 JIJBOnmEprwSvAtejIuJ3Of0ocQ5P1LVVCFgST7KsyMd82UPT51v26wIajtxIn+2CxO1anJ6+
 5Ok0i2nSFFJX67wCCCpnJbL4RARGpAHpXe9BLxWQdeKU6NNGIo78DCdkkG21Z2vM45nD1HngO
 tIPk1AEDOEuUrOMFKOl2I9SksdGpWP8/403FFNhNmWkBRk8NMaQ+pg2h/vYY6OdY7qzg0RbD3
 qTiWW9/F6z6Fog0te6AZ+XhOp2jA+z2LDyqrru+8/471hTJLkRnN7WChCityUjh0pFS1Jt5JE
 KpV2b5PsDLUXIMA/f6RWA7TGGXi1xBApLR7Q5spaumCIrm6IqHYSCLLD+WvFiNZ1/KjLEs+0u
 rFa28EnW4PXE8sgINbySUz+BhnLa+knlj87o3PpyJTnbV74nZaNYcUhFz0rsfyTcF+OyLThBW
 xWQv05AH8TFnebB/yFxUHCOND0Wf1cApHI6sjEZoc9Q7iMo2VtIxql2xQoqGSqO0H7Eu32sv8
 6NhZFOneWSI3tD1VvekLOmehnqJf507ocV3ISgrqQ5Sv4PhCLS8g/B4cBPkMXpRJnb7SuGZhr
 WgMuAmiR6LFHkXq37+DHP3ijGl0RWeYrpkZDGAiXyC/mSLkLfCmYqvlxsw+RflKLJRLU+8T7Y
 T4MDdjrHhYsJH/qpYMgpA09UvqNox12EugzuqhPEk+hy5ob6LvStxu/PwlSMQZbXcQSbvu75h
 /7Xx4xTnql6t6r9IacZvL4+0kT96GvIs12yFnHdZZ9gD1PPIz5KlNjBQaGewOKrC7CxnI9klf
 iarlW2MjCTLWCzwQhe3Kqluk3ilX93zoNDhT/uFKdShz8VhfmYFx0zlSbhyw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've been noticing lately that my network link sometimes does not go up
after a suspend resume cycle (roughly 1 or 2 out of 10 times). This also
sometimes happens with a fresh boot too. Doing a manual
"ip link set down/up" cycle resolves this issue.

I was able to bisect it to the commit below (or hope so) and also CCed
the maintainer for my driver too.

This is happening on a up-to-date Arch Linux system with a Intel I219-V.

Jan



7ede7b03484bbb035aa5be98c45a40cfabdc0738 is the first bad commit
commit 7ede7b03484bbb035aa5be98c45a40cfabdc0738
Author: Vedang Patel <vedang.patel@intel.com>
Date:   Tue Jun 25 15:07:18 2019 -0700

taprio: make clock reference conversions easier

Later in this series we will need to transform from
CLOCK_MONOTONIC (used in TCP) to the clock reference used in TAPRIO.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

net/sched/sch_taprio.c | 30 ++++++++++++++++++++++--------
1 file changed, 22 insertions(+), 8 deletions(-)



