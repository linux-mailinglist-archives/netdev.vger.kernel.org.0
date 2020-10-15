Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5C928F595
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389570AbgJOPLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:11:02 -0400
Received: from mx01-sz.bfs.de ([194.94.69.67]:38338 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388764AbgJOPLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 11:11:02 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2020 11:11:00 EDT
Received: from SRVEX01-SZ.bfs.intern (exchange-sz.bfs.de [10.129.90.31])
        by mx02-sz.bfs.de (Postfix) with ESMTPS id A058220403;
        Thu, 15 Oct 2020 17:04:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1602774286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Xuug+2hVFBm+B5UTc9CM6NcxF57zXPletFCWeaT4gw=;
        b=cCGN8umA+LSkB9Eby1Bah6kZIRkI2t76DUyaG6XoQp0hAuOROgfwHJfLSCKAH+yBVziGVf
        95DrTBeCqThRK0lCMby4VqmTF+0qPieg35O7Q3IgNDA1lOUoS7uaFr7NF7+rg3PtHrfU0j
        S8UWH28pY7QgnMU7qMOAj1xsFj7hJ58ijyswr778PtG80M3uQ5Mo9F+EBAleMKwrx6l+t7
        s7wwYa0zH92F/xPUc+8iBxmpnCrG3Z2syKYYKcF/BkK/jxq2k9T+wkoGXCrMx72EEm2/Rp
        MpKfmZ/1+lfenDuJxgsjAMJPKC82GXvzXQSFUTau1yfc0u5tLacUdgPzfQDbaw==
Received: from SRVEX01-SZ.bfs.intern (10.129.90.31) by SRVEX01-SZ.bfs.intern
 (10.129.90.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2106.2; Thu, 15 Oct
 2020 17:04:46 +0200
Received: from SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a]) by
 SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a%6]) with mapi id
 15.01.2106.002; Thu, 15 Oct 2020 17:04:46 +0200
From:   Walter Harms <wharms@bfs.de>
To:     Fedor Tokarev <ftokarev@gmail.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: AW: [PATCH] net: sunrpc: Fix 'snprintf' return value check in
 'do_xprt_debugfs'
Thread-Topic: [PATCH] net: sunrpc: Fix 'snprintf' return value check in
 'do_xprt_debugfs'
Thread-Index: AQHWovtnyQ5di/wyF0Kmy+Tq/adLsKmYwM+i
Date:   Thu, 15 Oct 2020 15:04:46 +0000
Message-ID: <b97379d3bf59487d8d0ca3bbf14ad0df@bfs.de>
References: <20201015135341.GA16343@laptop>
In-Reply-To: <20201015135341.GA16343@laptop>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.137.16.40]
x-tm-as-product-ver: SMEX-14.0.0.3031-8.6.1012-25728.000
x-tm-as-result: No-10--5.425900-5.000000
x-tmase-matchedrid: 1w4R1hu8EHXed0Ij9t5iQyEyJ8xFEVolPknazlXMVpV+SLLtNOiBhrLs
        vs6J0rHdg5UXYAmrRiPQVBnHbDgUs6krm8GLHGyo52zh+cq/0Ju62wuq1giw0x3RY4pGTCyHfjc
        dX7WMS/BFeoHCZIFQtCKkzMT7+4ooN9rojbjxBkwwwOrFPm3RDUpFpc3bJiMeEt/W/Pt5w8clC4
        sxsYCYIvc4XRSNAau6vsp8E6m7CmMdrB57CzPAJj8Ckw9b/GFeTJDl9FKHbrl2/QXA1+sfBZ4CI
        KY/Hg3AcmfM3DjaQLHEQdG7H66TyF82MXkEdQ77PZGkYTzNvZGv1nL/XchjCD2cE0BmbxnjEHAr
        QLGCQG/e9xXzfruQvg==
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
x-tmase-result: 10--5.425900-5.000000
x-tmase-version: SMEX-14.0.0.3031-8.6.1012-25728.000
x-tm-snts-smtp: CF9EB13A45BC0FE4DCB7889F4C01F5288A58F5C7E6C89D543D611277CA13CB362000:9
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-0.05
Authentication-Results: mx02-sz.bfs.de;
        none
X-Spamd-Result: default: False [-0.05 / 7.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         HAS_XOIP(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[11];
         NEURAL_HAM(-0.00)[-1.069];
         FREEMAIL_TO(0.00)[gmail.com,fieldses.org,oracle.com,netapp.com,hammerspace.com,davemloft.net,kernel.org];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         BAYES_HAM(-0.05)[60.08%]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if  xprt->debugfs->d_name.name can be what ever long
it is more clever to use kasprintf()
the some for link (no idea how many xprt als possible)

jm2c
 wh

________________________________________
Von: Fedor Tokarev [ftokarev@gmail.com]
Gesendet: Donnerstag, 15. Oktober 2020 15:59
An: bfields@fieldses.org; chuck.lever@oracle.com; anna.schumaker@netapp.com=
; trond.myklebust@hammerspace.com; davem@davemloft.net; kuba@kernel.org
Cc: linux-nfs@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.ke=
rnel.org; kernel-janitors@vger.kernel.org; ftokarev@gmail.com
Betreff: [PATCH] net: sunrpc: Fix 'snprintf' return value check in 'do_xprt=
_debugfs'

'snprintf' returns the number of characters which would have been written
if enough space had been available, excluding the terminating null byte.
Thus, the return value of 'sizeof(buf)' means that the last character
has been dropped.

Signed-off-by: Fedor Tokarev <ftokarev@gmail.com>
---
 net/sunrpc/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/debugfs.c b/net/sunrpc/debugfs.c
index fd9bca2..56029e3 100644
--- a/net/sunrpc/debugfs.c
+++ b/net/sunrpc/debugfs.c
@@ -128,13 +128,13 @@ static int do_xprt_debugfs(struct rpc_clnt *clnt, str=
uct rpc_xprt *xprt, void *n
                return 0;
        len =3D snprintf(name, sizeof(name), "../../rpc_xprt/%s",
                       xprt->debugfs->d_name.name);
-       if (len > sizeof(name))
+       if (len >=3D sizeof(name))
                return -1;
        if (*nump =3D=3D 0)
                strcpy(link, "xprt");
        else {
                len =3D snprintf(link, sizeof(link), "xprt%d", *nump);
-               if (len > sizeof(link))
+               if (len >=3D sizeof(link))
                        return -1;
        }
        debugfs_create_symlink(link, clnt->cl_debugfs, name);
--
2.7.4

