Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B967E22B5BF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgGWSdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:33:44 -0400
Received: from mout.gmx.net ([212.227.17.21]:54091 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgGWSdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 14:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1595529215;
        bh=WqI2zeg0gyGTNhzc3zhNoMP12NPlQ35txOC81iGNHZM=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=VLQoChat87qTS+buFu0sYNSqKbtxQ/8+rxwQ/kUYTXHiLM3FDh4L7gm3Y7dgcuvqT
         olna1EgSSsVB2MTqHFsCMIG5exci3ePwI/4ncMUi3OxrkSgRalgSG3e7A01yr4ROLy
         QoVii9YWFw3xQL9Z3UXGvT0jiMwTAK6DXHEdOjuI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([84.154.208.104]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mkpex-1kfkLB3VYF-00mKEu; Thu, 23
 Jul 2020 20:33:34 +0200
Date:   Thu, 23 Jul 2020 20:33:29 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] 8390: core cleanup
Message-ID: <20200723183329.GA5861@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:+zWVEHcQqKhDxMwEeCa+vVFCdOIrQY6+gSKPmbDc/8memt9NJt5
 BINrVyssA34X74Im2jTR9w2loyEA0nTCVITdaxaywc9LXRGizubc51mGzOxLVyx+a7nFVms
 9SuDI4nZgAkhNsu/pQ5L/LEllOC3I9vs9gJyDh0FJDmbEVm+ZWoUYMkwgOFBwbZFnHbOU6A
 38SgYTyDfZSVG6ItFfWjQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vX/M8sgy6fI=:vDqSiEAhc+rsDBBCs16mYp
 X1+w5opwH0ttrqRZqhjKLWqhsIKcxcNnPVKFBsx0l+k95P8FrtGAU/Na9SfLPKq+fYhe0MX/P
 LTmYSFTwfYmgy/KQohPOdFvaiv3PudmljxbZmexl/HIKmsBDq6q5YcI0RzdsAGrW4ljKPh8ay
 QfHeQLwptndR/InTWyk2FpGTxpaTqFTdjhlsjB3VwpLbQlZBnQJWe1z4NAk4wFMRiy7sxwVJO
 JxWEdIqMRHGi8Y1pY7bhzm6FjNVGXI7pjtLTp3JS+FExrfBRWCjh28wbzITqKMOZWZhksVwDq
 9epD/3gDcNlSOMQMcBmAgxHJ9LwDalRlAiUf6ZntJ7Jcp5Zk0qChi2tllKNiulFSbJdMDs2uB
 BoocL1uk0P4x9tPA8J/ppLarKl83Phnq1w9IylxjbX3i5dU3NdJZWNF7e3gc+IAGwUetSvY73
 AzQq1OEj/YHLs6tio0aBP27Lj2xCq0Epm4odgCTfumLsOU71ZyyfBAgymdI0+xD9xQBD3ujTK
 9AzDWRjLO5cSjBAaHbZFDgvCG647hp8NiO1X3dYpDsMZU4P5eb68SJjsAiypIzZDRnUPgSqIi
 5tLPaluM+zFsq9XKkxHN4Bd83J8u9P7ODtiQjTPEbcfsfiHs4rjefuRU0Lofy+C0N7No2XCL6
 t8a1/I+wU74NYcKDHKmU5cVpEs0mOnwStIf0lHkKWE+7G3KVeL7NBr6O1av52lLUpo9hA0ktn
 if2ScOBtAE5SgnjD35uY8ovX8ivwz1cYeGS/d8S8t78vNhnOJh9vFkI2wsCRUrV8Co6IO47Ev
 nLb3RD7zCQdQdugXGnbNW4bVNEkzaj3SwhRVC238lXOfY2Gx0i2vom2i1HzaPGqSHCCJGi7/A
 cXHo2VZwxV/XLPkba0GciXn8C6DSjRG6Ck7N1l5yI2BASuk+PSr6ukjE7g0hGzIGI8mOUnFr0
 N37LER9GdSmgBA5ITOGjROkMq5XPxlXLSjEH0PXPnO9Jc0WO937/ee6ymLAufvqUOynerSoho
 GBBg5GapOUyAE4BRK0y3L9RgC+8ws9HA9A8v24xRFTV5IZ8YJoXjDRfWL472uxsutRXoY6kwj
 XJfS9Umddm8yvHQjGvxHr9LytmgjyK9eU8J4EIb2lfgf59JI4WdVRamPd1vAOPx4lHw3l1d8a
 gAMtfjSebNxN21mCrt6z3EkQ/sc5q3E7Snefh+Q1OKICJvh3yTwYG3ASUl2BYfq4D2+BNORX0
 Tx7flcb4h6lteGj3w
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patchset is to do some cleanups
in lib8390.c and 8390.c.

While most cleanups fix simple checkpatch warnings,
pr_cont() usage was replaced by a more SMP-safe construct.

Other functional changes  include the removal of version-
printing in lib8390.c, so modules using lib8390.c do
not need a global version-string in order to compile
successfully.

Patches do compile and run flawless on 5.8.0-rc4 with
a RTL8029AS using ne2k-pci.

Armin Wolf (2):
  8390: Miscellaneous cleanups
  lib8390: Fix coding-style issues and remove verion printing

 drivers/net/ethernet/8390/8390.c    |  25 +-
 drivers/net/ethernet/8390/lib8390.c | 639 ++++++++++++++--------------
 2 files changed, 332 insertions(+), 332 deletions(-)

=2D-
2.20.1

