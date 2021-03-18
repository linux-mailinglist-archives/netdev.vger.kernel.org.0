Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97827341494
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 06:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbhCSFOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 01:14:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40368 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbhCSFNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 01:13:18 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210319051317epoutp03e37bf4afb1fa87d69e5a569f5f3cb5c9~tpmWzZHDP0720407204epoutp03T
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 05:13:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210319051317epoutp03e37bf4afb1fa87d69e5a569f5f3cb5c9~tpmWzZHDP0720407204epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616130797;
        bh=73NrOPMEXgqUZiSrXbfRHAV0AA0fq2ANR5XzhB1ROKg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fz0ImgTaycyGXV8iDN9EQdP96FFKVIuSlvRG7KuDjrGWaPKLKTrqcy8HwoWULyxXv
         1G/GpWkdk4ZfdZgsmDfVSkyf1qHZU40w6K/6ptS+HSpNb2Xa+6Nn7JmE8Kw0TJakcx
         o09q0N+S2YtaS0It9luCfLh/c6BWwXQxVk+1nQ9o=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210319051313epcas5p16969d29a8473d8b48d70913ba8ba64d1~tpmT60UqD0459204592epcas5p12;
        Fri, 19 Mar 2021 05:13:13 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.EC.15682.9E234506; Fri, 19 Mar 2021 14:13:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210318112550epcas5p4ea94d6b6df15064aa2af53dc5c290e52~tbCW8D8WV1332913329epcas5p4B;
        Thu, 18 Mar 2021 11:25:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210318112550epsmtrp1f212014afccdfd5bbfc8c73f14f58b77~tbCW6gaX51933119331epsmtrp1Y;
        Thu, 18 Mar 2021 11:25:50 +0000 (GMT)
X-AuditID: b6c32a49-8d5ff70000013d42-77-605432e9cbc3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.48.08745.EB833506; Thu, 18 Mar 2021 20:25:50 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210318112549epsmtip102153460328aa62dc017e439092fa427~tbCVcdOaT1711217112epsmtip1C;
        Thu, 18 Mar 2021 11:25:48 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, pankaj.dubey@samsung.com, rcsekar@samsung.com,
        Pankaj Sharma <pankj.sharma@samsung.com>
Subject: [PATCH] MAINTAINERS: Update MCAN MMIO device driver maintainer
Date:   Thu, 18 Mar 2021 16:56:34 +0530
Message-Id: <20210318112634.31149-1-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsWy7bCmhu5Lo5AEg033TCzmnG9hsbiwrY/V
        YtX3qcwWl3fNYbNYv2gKi8WxBWIWi7Z+YbdY3nWf2WLWhR2sFkvv7WR14PLYsvImk8fHS7cZ
        PTat6mTz6P9r4NG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZz3atZS64wlpxfuUztgbGxyxd
        jJwcEgImEnenvAGyuTiEBHYzSlxq3wvlfAJyZq6Fcj4zSpy9eQXI4QBr2X+kCCK+i1Fibks7
        I4TTwiTxdsUHRpC5bAJ6EpfeT2YDsUUEQiWW9U5gBbGZBdYwShzd4gMySFjAXaJ3kjSIySKg
        KjHjNydIBa+ArcTr/uXMENfJS6zecIAZZLyEwDl2iea1vewQCReJV5NeM0HYwhKvjm+BiktJ
        vOxvg7KzJRbu7oe6uUKibYYwRNhe4sCVOWBhZgFNifW79CHCshJTT61jgjiST6L39xOo6bwS
        O+bB2GoSU5++Y4SwZSTuPNrMBmF7SKw4tIcVZKSQQKzE9I+lExhlZyEsWMDIuIpRMrWgODc9
        tdi0wDAvtVyvODG3uDQvXS85P3cTIzgpaHnuYLz74IPeIUYmDsZDjBIczEoivKZ5AQlCvCmJ
        lVWpRfnxRaU5qcWHGKU5WJTEeXcYPIgXEkhPLEnNTk0tSC2CyTJxcEo1MOmz/7ly4Ueg6JQV
        baeWHz7y//2Ox5MuJe/8OHuCQM0V/2vn7lyLy23Uv8tc2S/4d8XLsrWB3HaCrguP1CiXPi29
        0mJ0oHyjcEXlrWceJa65dflTY5YZqne72qzJZNtbq7KKx93+k4ZXB2uO0rbtDBvnSfguOcgx
        ZfvBplWLdr0w0re1O2ug4fI0QUbc4Mj91z8nLeq1LZK4lrNbPjv2vOaSk9+CXn9L2rfsi1Lx
        mjPVZg8ZmeOET9mIaG13/WVzYoux/MQ0lamfcxIiG/3Lb01bKynrcul7yAUfllnvnPVCDNda
        e++ZxHBy7p6jna+dLeyEGue9OJmUMTP/3KuKTR33fHXvnagPdbfs0Z74S06JpTgj0VCLuag4
        EQCK+rR0eQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42LZdlhJTnefRXCCwczv0hZzzrewWFzY1sdq
        ser7VGaLy7vmsFmsXzSFxeLYAjGLRVu/sFss77rPbDHrwg5Wi6X3drI6cHlsWXmTyePjpduM
        HptWdbJ59P818OjbsorR4/MmuQC2KC6blNSczLLUIn27BK6MZ7vWMhdcYa04v/IZWwPjY5Yu
        Rg4OCQETif1HiroYuTiEBHYwSnzqu84GEZeRWPy5uouRE8gUllj57zk7RE0Tk8Sp2ytYQRJs
        AnoSl95PZgOxRQTCJXZO6GICKWIW2MIocW/LJyaQQcIC7hK9k6RBTBYBVYkZvzlBynkFbCVe
        9y9nhpgvL7F6wwHmCYw8CxgZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBAeZltYO
        xj2rPugdYmTiYDzEKMHBrCTCa5oXkCDEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTE
        ktTs1NSC1CKYLBMHp1QDU6TO7/bf56zqduVIqqYfMpiTGpYgxSD00yE7wtbk/Fmn2sOP1k7K
        izneeEz7uPfNtM0TslfFssa+e/X009tpb6ympXvYp2y191jAf3vd+670EiXW9ELWqHX60x2t
        fnG9m87qu2zSvb8aTv9CxXh93cK8YtZMvL46+Mx5dtkZhgJlx1m4z75dfeTIzmV7jOvlPE+p
        B66vmCY7f7Vs8Nyvs97/bI/tE90dvGWyXNGdV1Lynq9PfQ5g3hnLHPFr8gnhWwcOdttd3/5y
        xpOE25nZLK7ntGSYC6N5tm4VihU80dT3+9htc7VHMQHzHkr+2Vgx7aI9y/mtmptrWuOTVzJW
        /eNJnzJRzOO1xOlVGzXfBCmxFGckGmoxFxUnAgA6ZISGoQIAAA==
X-CMS-MailID: 20210318112550epcas5p4ea94d6b6df15064aa2af53dc5c290e52
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210318112550epcas5p4ea94d6b6df15064aa2af53dc5c290e52
References: <CGME20210318112550epcas5p4ea94d6b6df15064aa2af53dc5c290e52@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update Chandrasekar Ramakrishnan as maintainer for mcan mmio device driver as I
will be moving to a different role.

Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a50a543e3c81..76db44337f6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10820,7 +10820,7 @@ F:	drivers/media/radio/radio-maxiradio*
 
 MCAN MMIO DEVICE DRIVER
 M:	Dan Murphy <dmurphy@ti.com>
-M:	Pankaj Sharma <pankj.sharma@samsung.com>
+M:	Chandrasekar Ramakrishnan <rcsekar@samsung.com>
 L:	linux-can@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
-- 
2.17.1

