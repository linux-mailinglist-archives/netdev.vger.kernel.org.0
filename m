Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DDF256710
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgH2L0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:26:34 -0400
Received: from mout.gmx.net ([212.227.15.18]:54877 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgH2LYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1598700280;
        bh=34kqVbVFJqFATcQsHzSByqVWAiSZnLwmjxgkjyrsTIE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=CQV2lTY/L3x0JwX9WroLpJzScwyeLFGPqxBJqBnrHidGMGYeCuVtj9F0/nMovLCCn
         WSSNMlUYKq5ledAS8p6iBjS/8BtxvU+0y2YjKcfdECFow50LOVeDESmp6gPHGLesU0
         OQomRWsWsuZgV/cjFXqRCjcLkN2DZXwUYptd2YWw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([91.0.98.17]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MQMyZ-1jz6gI1C0f-00MNY1; Sat, 29
 Aug 2020 13:17:35 +0200
Date:   Sat, 29 Aug 2020 13:17:32 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH 0/2 v3 net-next] 8390: core cleanups
Message-ID: <20200829111701.GA9219@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:gktwn0vR+hZkEjejBCC0pnUKpraD9eIADNtBy+SSjnnspRkggzV
 7eeOEJtjia0uvBl5tiCRZHNKHUFzxB+oZ7MbElm0uuR5L513p6IIKNYfCRW0a8kNWaTA8Xp
 naWvHKDgHC0dvwSiBh4DPE3lHY9uxhTcRnWw4wAR+BKPb2Ni0qRRzc7y+PLnHe86kw+9OcB
 /p+LJc/ylMPkfrkVHM9fA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hFXYwWgBx4s=:lTpV2DUW72Iur3EdEIXp4Q
 KnKZXuKhil16MhAUfprmLt7GOnvYFJjCVDuLDH+77xB/nymDFwZZQIrBmRuO8/6cSFGmc/9TU
 TgZnEvTT125HRS1ANH3t8nCuoDMWagDsOm1yrlhjJEzvzHBQfWhal0ykxWJ7kjWT9gPNUbR6V
 WJUa/89FBghz6HFNEqYHNHi+8ZDHph2dsdtIwTbaXFDZABx7OE9wXKWBTU0nFsKHVCnKeqq5V
 W60bEAykjKZltB+xeh4Lch1q2f1G17MvCsO9kDE2cz6oZkQeFktQbJa+2V40vihUVzlE2ken8
 xNM/TE+iv5aXdQysJX2uadKPVNHEEjen1SP6vFhoycfDGxjuspXFIkL0WZwtsMsnN0ZPbrEkc
 kuzQCwgjWBBwVkYlBbgVLa9R6PcfoJjDHI1nuGOQmr1C+L8OZppJT9UcDKz5p1AN8PD5rNzsb
 n1F/I2bqW/oZtdHdf9ggLkhauY5SDGlQN8yxML9pCvNAohPwRc5hFRnals9wROkI/2t3fsTUM
 z1esbDnPAay5R3XwLWKJBQAesL/ZOE3oqYPfcSCkcSEALJy3eQWNjlCW00K00slmQ4HuSRKX/
 CuCAdl3+uqy5cTKKzbdrmEYIwYV+4nRmp2dgZ5QN7uG7/0sBXQcj1/E3m6Cej3kjntd0nai/7
 q7atLPR7hWXa/G78PqYbOGlS8aPoxj4zMv8yo7N0bTKrXYcpOL9Z7FqjG9Y6uq7oBfSuITlmf
 z+1PfjDWjntiIgnGtUAPnbJQxFoMXl/1ZOregtuE8rteC+k4HZMCBZvkxe5q/su1L6MrQo9YP
 J0HU6mtkvhDYiBXMcprvI6LoF4A49Tawx1e2Ag7/WEo6jts+mojU4m8l0K1EKIHcxeLdVfwQU
 qxSjMJ/7lJrDLGRhBx4R9bHSnA8cw41hKpnyTVg54oqrvqT31hjwmWtOGtGwOMcsuvHQ6jwBA
 U2tGNHVMITKJLlyhFv57BIN4hbMccp+g2azCQCw/4XImf4VI4pseTbuBRLzXnxlNyOpsVgTHp
 N7tm1x1DMd+6xspXUw7+/bXWbAPy3vmQscdpXNEqNIbqhOUWkNjRrJeqfYO5J8G1WFr4FYLLR
 kJ8AIHSu1hXsERQfz16/xeEO2KvjOVTONb4JRyW2P6D5FWd0+nOtzJWIPAKwDgy8bqHd8lJlB
 pT9qnvX1uvo3wnmk+ziY7LglV240mTLu1zvLlGgJUoI1Omrs2NUouk3+qLb9FNZXs9kVNWIY9
 U+o1hvkYDwbToolpK
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patchset is to do some
cleanups in lib8390.c and 8390.c.

While most changes are coding-style related,
pr_cont() usage in lib8390.c was replaced by
a more SMP-safe construct.

Other functional changes include the removal of
version-printing in lib8390.c so modules using lib8390.c
do not need a global version-string in order to compile
successfully.

Patches do compile and run flawless on 5.9.0-rc1 with
a RTL8029AS nic using ne2k-pci.

v3 changes:
- swap commits to not break buildability (sorry)
- move MODULE_LICENCE at the bottom and remove MODULE_VERSION in 8390.c

v2 changes:
- change "librarys" to "libraries" in 8390.c commit
- improve 8390.c commit
- prevent uneven whitespaces in error message (lib8390.c)
- do not destroy kernel doc comments in lib8390.c
- fix some typos in lib8390.c

Armin Wolf (2):
  lib8390: Fix coding-style issues and remove verion printing
  8390: Miscellaneous cleanups

 drivers/net/ethernet/8390/8390.c    |  21 +-
 drivers/net/ethernet/8390/lib8390.c | 590 ++++++++++++++--------------
 2 files changed, 308 insertions(+), 303 deletions(-)

=2D-
2.20.1

