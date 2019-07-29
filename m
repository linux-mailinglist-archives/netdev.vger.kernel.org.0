Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2C478A51
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 13:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387644AbfG2LTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 07:19:04 -0400
Received: from de-out1.bosch-org.com ([139.15.230.186]:42622 "EHLO
        de-out1.bosch-org.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387576AbfG2LTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 07:19:04 -0400
X-Greylist: delayed 4267 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 07:19:03 EDT
Received: from fe0vm1650.rbesz01.com (unknown [139.15.230.188])
        by si0vms0216.rbdmz01.com (Postfix) with ESMTPS id 45xxyt2TKdz1XLG7Q;
        Mon, 29 Jul 2019 13:19:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=escrypt.com;
        s=key1-intmail; t=1564399142;
        bh=b69hpWt00mKwqXSGYZ/AyETIvAw/cFN7S7wBPDfpquo=; l=10;
        h=From:Subject:From:Reply-To:Sender;
        b=cDW+mXzgg33OdIRkXnYnmjufZQaGUObQrwglCQMDurjMdjKFapze5M15YLlmtgTEu
         gqa0oCTeffYBRJ5smCbDh+/MWVAGXNHgFiregA4EFEHfseUdoF+9cnLcwgRxL+ax+f
         sFKtN310ENddh76g7bigKn+UVy5/AnR6dCsF+5AU=
Received: from fe0vm1740.rbesz01.com (unknown [10.58.172.176])
        by fe0vm1650.rbesz01.com (Postfix) with ESMTPS id 45xxyt0n0Vz1QY;
        Mon, 29 Jul 2019 13:19:02 +0200 (CEST)
X-AuditID: 0a3aad14-cf7ff700000027e4-8d-5d3ed625fded
Received: from fe0vm1651.rbesz01.com ( [10.58.173.29])
        (using TLS with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by fe0vm1740.rbesz01.com (SMG Outbound) with SMTP id 20.44.10212.526DE3D5; Mon, 29 Jul 2019 13:19:01 +0200 (CEST)
Received: from FE-MBX2038.de.bosch.com (fe-mbx2038.de.bosch.com [10.3.231.48])
        by fe0vm1651.rbesz01.com (Postfix) with ESMTPS id 45xxyr6zjGzvkB;
        Mon, 29 Jul 2019 13:19:00 +0200 (CEST)
Received: from FE-MBX2038.de.bosch.com (10.3.231.48) by
 FE-MBX2038.de.bosch.com (10.3.231.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 29 Jul 2019 13:19:00 +0200
Received: from FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2]) by
 FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2%2]) with mapi id
 15.01.1713.008; Mon, 29 Jul 2019 13:19:00 +0200
From:   "FIXED-TERM Buecheler Konstantin (ETAS-SEC/ECT-Mu)" 
        <fixed-term.Konstantin.Buecheler@escrypt.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "dmurphy@ti.com" <dmurphy@ti.com>
Subject: tcan4x5x on a Raspberry Pi
Thread-Topic: tcan4x5x on a Raspberry Pi
Thread-Index: AdVF/c5mwtK0bcvDSY+DXrUhyfKmYQ==
Date:   Mon, 29 Jul 2019 11:19:00 +0000
Message-ID: <845ea24f71b74b42821c7fce20bc0476@escrypt.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.23.200.63]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA21SYUxbZRTltqV7a/bs49GOSye4PF3ihkPALTaAjBgT2R/FuMQ5rVrGo63S
        FvtaBsxsLLpZYQT84dYR13XYadI4hI4NQusYXZB1kCy6DUlk01goFIRsbgIKFvtoWfvDfyfn
        3HPufed9hJC2EgpCZzCzJoO6khFLRJL88xnbt4wUqXLGzmYpG4e6kpWuhS+Eyh8cG4uFJYOj
        3YKSB+7MUsE+SWE5W6mrZk3PFr0n0donZ6GqXVDjPdUorocZaACCQGoH2o6UNMB6gqZsApys
        39wAkgj2ADadCwiiwixgv18fFS4DfnneCbwgpnT4+YWW1SEZVYUt0ydFPBZSW3B+ZiCZx6nU
        kzg0cU8cnXka5zp+EfGLZVQ2Dt/W8bQoMj7ov7IaQ1L5GDh6cR2PgcrAjo4bwmhkGrqDC6uR
        SFHo9EZ5pOQYCoRj/Gacu9obO+EZdHj+FEdxFn59dkYYzU9B/6lxUQvIWxNiWxMsrQmW1gSL
        A0QukFewOdX63Od35GSbyliuLic3e79R74boX5H1wJKvwgcCAnywkxAwcvLCSqGKfqzMWF6r
        VXPad02WSpZjFOTFDKWKTn1Ec5YyvY7jdEaDD5AQMjKyiylQ0WS5uraONRmjNh9sIkRMGqkh
        Xn2bpjRqM/sBy1axpjW1gCAYJDNvFqnoFBOrYWsqdJXmNZnJICEpKYnemKgkrhUQ633wHLEh
        slt1KxJBclVqPafTxOzpUTu9xsat12E30RI63SYk+gfsbUJaZDAaWEUamcSnUPy81mJ4dIfi
        cXJqPF9FyxOEeNY0BIEAJpWs5c0bIo8+fgGS3XxpKTEybspzRzz84136fgzwpDcMODo9KMWp
        8E0pWp33KPzM256Hi79dysOw7ZIS7c6+F3Dxj44XcdQxV4L2u579aHO7NBjuWdbh/cC193Fq
        6bQeB8aDNTi2EPwIV76yH8KVf4ebALsm+s8ALp9xtwH2NVmdgNceftILOO7v8Uaw23YFsPl6
        ux/wL2twGNDTNT8CuPjtjTuA1t/9k4B279EQTEe6FkS69kpXuzarzf/TdYyNf6qiHqqlodeO
        bSp9qL2zjIfYb37SlcuuLjbfKt2TXDi5N7048/VQ77atlsOZszsP1x4/4f3nre6Xet/4W9p5
        0GU5dvn29jrTXu7juy/vKWHETxVPvKIXpP/o+rQx675raJ0nvOsd74PO4z8fOGg81/dht7zn
        u+bdb+7buuuJXwccnbKRA4GF+SMFjIjTqnO3CU2c+j9rJVv6mwQAAA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,=20

I am currently working on a project where I am trying to use the tcan4550 c=
hip with a Raspberry PI 3B.
I am struggling to create a working device tree overlay file for the Raspbe=
rry Pi.
Has anyone here tried this already? I would appreciate any help.=20

Thanks,
Konstantin

