Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C300138462
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 02:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731841AbgALBDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 20:03:09 -0500
Received: from mail3-bck.iservicesmail.com ([217.130.24.85]:3410 "EHLO
        mail3-bck.iservicesmail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731834AbgALBDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 20:03:09 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jan 2020 20:03:09 EST
IronPort-SDR: dxxvVOYyOcVsovLNIewHetc5OYP5NqBuMTgA9Pb0VbXrs2eFuTjMxVgghQgUFDWIpr1BEYBfbI
 s+QapMA2gu2g==
IronPort-PHdr: =?us-ascii?q?9a23=3AfFQP9xXMER1OACvNTWURAGxcsb/V8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYbBOPt8tkgFKBZ4jH8fUM07OQ7/m7HzZev93b7zgrS99lb1?=
 =?us-ascii?q?c9k8IYnggtUoauKHbQC7rUVRE8B9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUh?=
 =?us-ascii?q?rwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9IRmrowjdrNcajIpjJ6o+1B?=
 =?us-ascii?q?fEoGZDdvhLy29vOV+dhQv36N2q/J5k/SRQuvYh+NBFXK7nYak2TqFWASo/PW?=
 =?us-ascii?q?wt68LlqRfMTQ2U5nsBSWoWiQZHAxLE7B7hQJj8tDbxu/dn1ymbOc32Sq00WS?=
 =?us-ascii?q?in4qx2RhLklDsLOjgk+23RjcB+kb5Urwikpx1/2oLZfoaVNOBmfqPaZ9MVX3?=
 =?us-ascii?q?ZBUdhIWyNfBIOwdpcCD/YdPelCs4b9p0UBrR6gCgmqGOPj0yFHhnnv0aM91O?=
 =?us-ascii?q?QhFx/J3Qw5E90QtnTfsdH5OakOXeypyaXFyyjIYfFL1jfn8IXGfBAvoeuSU7?=
 =?us-ascii?q?xzbMTexlUgGQzeg1WMq4HqIy+Z2vgRv2SF6edrSOKhi3QgqwF0ujWh3Nkjip?=
 =?us-ascii?q?XXiYIP11vL9SJ5wIA6JdalT0N7ecCrEIdOuCGAOYp2RcUiQ25ztSY60b0Joo?=
 =?us-ascii?q?K0cDIWx5Qgwh7TcfyHc4uR7x/lSe2fIi94iWp7dL6ihRu+61Wsx+PgWsWuzl?=
 =?us-ascii?q?pHoTBJn9fMu30Lyhfd8NKISuFn8UekwTuP0gfT5fxaLk0sjqrbLoIhwqY3lp?=
 =?us-ascii?q?oOrUTPBi/2l1vyjK+Rbkgk//Kn6+XjYrX8uJCcM5N4hw7kPqQwncywHP43Mg?=
 =?us-ascii?q?YJX2id5+uwzqPs/VbhTLVLiP05jLXZvYjEKcgGpKO1GRJZ34g/5xqlETur38?=
 =?us-ascii?q?4UkHcHIV5dfRKIlYnpO1XAIPDiCve/hkyhkC91yPDaILLhGJvMLn/FkLfuZr?=
 =?us-ascii?q?t961VcxxEvwtxF+51UDbQBLOjzWk/yrNDYFAM2MxSow+b7D9VwzoUeVnyTAq?=
 =?us-ascii?q?CELqzSr0SF5vwgI+aSfo8ZojX9JOY/5/7ok3A5nUURfa6z3ZsYOziEGaFgLl?=
 =?us-ascii?q?mVbGTEnNgMCyEJsxA4Qeisj0eNAgRef3KjY6Vp3jwnBZjuMoDFScj5mLGd0T?=
 =?us-ascii?q?2kGZtZZntMAVCPOXjtfoSAHfwLbXTBDNVml2k8WKSsUcce0heh/FvixqZqNP?=
 =?us-ascii?q?XT/CIwtYnp355+4OiVlRJkpm88NNiUz2zYFjI8pWgPXTJjh/gnrA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HVAQBBbhpelyMYgtlMGBoBAQEBAQE?=
 =?us-ascii?q?BAQEDAQEBAREBAQECAgEBAQGBaAQBAQEBCwEBGwQBgSmBTVIgEpNQgU0fg0O?=
 =?us-ascii?q?LY4EAgx4VhgcUDIFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQE?=
 =?us-ascii?q?FBAEBAhABAQEBAQYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVO?=
 =?us-ascii?q?DBIJLAQEznX0BjQQNDQKFHYJJBAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ?=
 =?us-ascii?q?/ARIBbIJIglkEjUISIYEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAO?=
 =?us-ascii?q?EToF9ozdXdAGBHnEzGoImGoEgTxgNiBuOLUCBFhACT4xbgjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2HVAQBBbhpelyMYgtlMGBoBAQEBAQEBAQEDAQEBAREBA?=
 =?us-ascii?q?QECAgEBAQGBaAQBAQEBCwEBGwQBgSmBTVIgEpNQgU0fg0OLY4EAgx4VhgcUD?=
 =?us-ascii?q?IFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQEFBAEBAhABAQEBA?=
 =?us-ascii?q?QYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVODBIJLAQEznX0Bj?=
 =?us-ascii?q?QQNDQKFHYJJBAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ/ARIBbIJIglkEj?=
 =?us-ascii?q?UISIYEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAOEToF9ozdXdAGBH?=
 =?us-ascii?q?nEzGoImGoEgTxgNiBuOLUCBFhACT4xbgjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,423,1571695200"; 
   d="scan'208";a="323075711"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 12 Jan 2020 01:58:06 +0100
Received: (qmail 17755 invoked from network); 11 Jan 2020 23:38:47 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <netdev@vger.kernel.org>; 11 Jan 2020 23:38:47 -0000
Date:   Sun, 12 Jan 2020 00:38:46 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghsbchk@gmail.com>
To:     netdev@vger.kernel.org
Message-ID: <12059069.157065.1578785927301.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

