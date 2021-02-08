Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14297312B82
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhBHINq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Feb 2021 03:13:46 -0500
Received: from esa1.mentor.iphmx.com ([68.232.129.153]:8652 "EHLO
        esa1.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBHINo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:13:44 -0500
IronPort-SDR: Ka3GUUgU76rZQtMCh0L0Ls/QYp3K4MXKKEnh9E1K2Fgt6jw/Amuc4QIXeIZny0KzXn+r6WydNW
 rBpIxtEhmi4jUckaSdh9o224uQwk9GnbneiT/5Qt+hif78ywoL1MZV+B2u3LLW7Gn+bi0xaAcB
 nW0NoSyhfARuO9gjdGcq2loqJ79tGEcQfnyLh57knqp/V/Ayego9bh+oq3En1Dbx2zmNufjLkk
 NyaIGroLKhbmmmKFTu6eSAAab2YxQng+jli8xUPHe9RH+R6RsXiVwK2YL8n+x/wiveMDPQyUdp
 LUM=
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="60166716"
Received: from orw-gwy-01-in.mentorg.com ([192.94.38.165])
  by esa1.mentor.iphmx.com with ESMTP; 08 Feb 2021 00:12:33 -0800
IronPort-SDR: wZoiGYejQl4gJmJzRlT1e/hSBaiaj/8OfO1arvJdMMAVLH0C2arOKFFAmSwWXjc+tNiV+4Pdyi
 I2OeyNiFEA014B9poEZmZ9+zenKoDl2u0pMK5wWVYNmeRB2o55QzwO9mE9XsERKiTo6XpjKH/G
 UyysReWQ2ZcCIi1ANEHVnDoh6SF/byZzRFCnvrlMH8LdWDW099a3PrPAD5DFVYVMFZK/X/xJKm
 ZsjfmTa6RELIjfnVX9HA2aknLgJiq1qql+erIdxRSVrH4Een8cMAdfN6JjUBiUDZbkGi0YFOgT
 D1o=
From:   "Schmid, Carsten" <Carsten_Schmid@mentor.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Where is this patch buried?
Thread-Topic: Where is this patch buried?
Thread-Index: AQHW/fIkZ019VAXYJE+A3ji1EQtU3A==
Date:   Mon, 8 Feb 2021 08:12:29 +0000
Message-ID: <7953a4158fd14aabbcfbad8365231961@SVR-IES-MBX-03.mgc.mentorg.com>
Accept-Language: de-DE, en-IE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [137.202.0.90]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

in kernel 4.14 i have seen a NULL pointer deref in
[65064.613465] RIP: 0010:ip_route_output_key_hash_rcu+0x755/0x850
(i have a core dump and detailed analysis)

That looks like this patch could have prevented it:

https://www.spinics.net/lists/stable-commits/msg133055.html

this one was queued for 4.14, but i can't find it in git tree?
Any idea who/what buried this one?

In 4.19 it is present.

Because our customer uses 4.14 (going to 4.14.212 in a few days) i kindly want to ask why this patch hasn't entered 4.14.

Best regards
Carsten
-----------------
Mentor Graphics (Deutschland) GmbH, Arnulfstrasse 201, 80634 München Registergericht München HRB 106955, Geschäftsführer: Thomas Heurung, Frank Thürauf
