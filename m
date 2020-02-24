Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43EEE16B61A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgBXX7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:59:40 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:44101 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgBXX7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:59:40 -0500
Received: from kiste.fritz.box ([94.134.180.186]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N2VCb-1jYkPd1AaN-013x3E; Tue, 25 Feb 2020 00:59:30 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net-next 0/2] net/smc: improve peer ID in CLC decline
Date:   Tue, 25 Feb 2020 00:58:59 +0100
Message-Id: <20200224235901.304311-1-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:AMWT+5Ipvh1xDnUysvMRuW6la6gxzxiOiGioZ7hTVL2HNYLTPMx
 J9b4YwHeTzH5db1vIzzZIyhUdOZoyLmqy6bnrh4SizzRoidgEkqdXN7Ew+pKTFH3XQtuAAl
 9eQylePvtIn9yPgUjvRz2E6cZ3okLpFOGkYL+DCWKY1ND//PGvY8bURb8QfjJZ1QTyC79Mx
 Os2C44HLIfZwYY+rGBBmA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Mlzzsvl64t0=:oxTfo6w0Sz0nDRfscM6E7o
 evEEIwp0VWCW6+SnSwYZ1Pv7yP5RqkUDVCKrcoMzeFF9cAwlrb86FZe5EZ19OJxgxp+AkhGq4
 ax5AccUK3kwuU75mJMzsC7g5bW64I7wfw6y824FJHsVNaWuctVpO+8wX2o2NPWMvRhCYxoD6Q
 VVxK13Nl6v8Hzke1VBg2df4LDobQ2N4uB6li4Bv0orRx6ezHiLjPYQjRRDorKeW7CtiY0nVNI
 CuNZ95G0c55BistdlH8M2rlNs9IuWjiltzuuOIdD2xpMrvFzBcfZUImM6s2H40WIeZtPtXPBN
 o6TIduXWmqmde+X6LdM5JKoNw7wL7bxPPcfKTA5+/Dl9lsIzt0KKF96UPX5kde5Svi7rfZh/x
 MpCabdg6TSigJjzsAebYTOsaukwUubYfhVoGE2jkfVzbFvp7JltbWikgRlSU2Sx5D2GqN1yIA
 dvJ/Tvx8v7ZwMZ7gdUcO9v5osudfw0kw/NvqMhh94H0qoxqTSD2PDbC1pncnNMzLpmT3gZsd2
 58LbhDfr1v+ZP0pz+2eKnndLhY1mYcUph4+BjCyXAjF8jIuencVjYoLnpOwGPSHFMxLtqRfVj
 w4PJTFDfzSmupAGwj0el3brLfd5gUcAWRcl8hf8Gv68Px4l7CiGQq3ManVxeFc+6/Co139ORp
 1isAw+qd/voB3LvVeCo++AVDw8EQtkgpL+FVXYhPxioM6qeK5MB4OJsUH8fc3QSa2jTgzWhw+
 wTS5ftVHHiY/vOY+9UAjlDMsbNPGu8hF9LbsUjPKNdkeg8KpQVkSht0ES2IXQ9BtwHcXmXlFf
 hOU6IyWojrigu4tJyXhYx8G/fOSLDOHmtkv9gobgYZg+kA5gL+i2vZ0+gBzCAHnQcmvc2wn
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following two patches improve the peer ID in CLC decline messages if
RoCE devices are present in the host but no suitable device is found for
a connection. The first patch reworks the peer ID initialization. The
second patch contains the actual changes of the CLC decline messages.

Changes since the RFC version:
* split the patch into two parts
* removed zero assignment to global variable (thanks Leon)

Thanks to Leon Romanovsky and Karsten Graul for the feedback!

Hans Wippel (2):
  net/smc: rework peer ID handling
  net/smc: improve peer ID in CLC decline for SMC-R

 net/smc/smc_clc.c |  9 ++++++---
 net/smc/smc_ib.c  | 19 ++++++++++++-------
 net/smc/smc_ib.h  |  1 +
 3 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.25.1

