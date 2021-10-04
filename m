Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1B2420D8F
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbhJDNQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:16:21 -0400
Received: from mx4.uni-regensburg.de ([194.94.157.149]:49464 "EHLO
        mx4.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbhJDNOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 09:14:21 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2021 09:14:20 EDT
Received: from mx4.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 571F26000056
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 15:06:33 +0200 (CEST)
Received: from smtp1.uni-regensburg.de (smtp1.uni-regensburg.de [194.94.157.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "smtp.uni-regensburg.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by mx4.uni-regensburg.de (Postfix) with ESMTPS id 383CC600004E
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 15:06:33 +0200 (CEST)
From:   "Andreas K. Huettel" <andreas.huettel@ur.de>
To:     netdev@vger.kernel.org
Subject: Intel I350 regression 5.10 -> 5.14 ("The NVM Checksum Is Not Valid")  [8086:1521]
Date:   Mon, 04 Oct 2021 15:06:31 +0200
Message-ID: <1823864.tdWV9SEqCh@kailua>
Organization: Universitaet Regensburg
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2106358.irdbgypaU6"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2106358.irdbgypaU6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: "Andreas K. Huettel" <andreas.huettel@ur.de>
To: netdev@vger.kernel.org
Subject: Intel I350 regression 5.10 -> 5.14 ("The NVM Checksum Is Not Valid")  [8086:1521]
Date: Mon, 04 Oct 2021 15:06:31 +0200
Message-ID: <1823864.tdWV9SEqCh@kailua>
Organization: Universitaet Regensburg

Dear all, 

I hope this is the right place to ask, if not please advise me where to go.

I have a new Dell machine with both an Intel on-board ethernet controller 
([8086:15f9]) and an additional 2-port extension card ([8086:1521]). 

The second adaptor, a "DeLock PCIe 2xGBit", worked fine as far as I could 
see with Linux 5.10.59, but fails to initialize with Linux 5.14.9.

dilfridge ~ # lspci -nn
[...]
01:00.0 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev ff)
01:00.1 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev ff)
[...]

dilfridge ~ # dmesg|grep igb
[    2.069286] igb: Intel(R) Gigabit Ethernet Network Driver
[    2.069288] igb: Copyright (c) 2007-2014 Intel Corporation.
[    2.069305] igb 0000:01:00.0: can't change power state from D3cold to D0 (config space inaccessible)
[    2.069624] igb 0000:01:00.0 0000:01:00.0 (uninitialized): PCIe link lost
[    2.386659] igb 0000:01:00.0: PHY reset is blocked due to SOL/IDER session.
[    4.115500] igb 0000:01:00.0: The NVM Checksum Is Not Valid
[    4.133807] igb: probe of 0000:01:00.0 failed with error -5
[    4.133820] igb 0000:01:00.1: can't change power state from D3cold to D0 (config space inaccessible)
[    4.134072] igb 0000:01:00.1 0000:01:00.1 (uninitialized): PCIe link lost
[    4.451602] igb 0000:01:00.1: PHY reset is blocked due to SOL/IDER session.
[    6.180123] igb 0000:01:00.1: The NVM Checksum Is Not Valid
[    6.188631] igb: probe of 0000:01:00.1 failed with error -5

Any advice on how to proceed? Willing to test patches and provide additional debug info.

Thanks,
Andreas

-- 
PD Dr. Andreas K. Huettel
Institute for Experimental and Applied Physics
University of Regensburg
93040 Regensburg
Germany

tel. +49 151 241 67748 (mobile)
tel. +49 941 943 1618 (office)
e-mail andreas.huettel@ur.de
http://www.akhuettel.de/
http://www.physik.uni-r.de/forschung/huettel/
--nextPart2106358.irdbgypaU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQKTBAABCgB9FiEE6W4INB9YeKX6Qpi1TEn3nlTQogYFAmFa/FdfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldEU5
NkUwODM0MUY1ODc4QTVGQTQyOThCNTRDNDlGNzlFNTREMEEyMDYACgkQTEn3nlTQ
ogaCRhAAt5c37Fz+F5EMCfZPmWvKHLHyd2MuS8YmsMnnY+HOH5Vq4VArhJckDAOX
s+Z5PjcWl+PjDw+UlbOtKZJ58hangOV/rXg1ungicFl1e3Epg+uKqw2WYLwf3L3g
5Dyac9Mwy6rkrtpj0a0zxqRVhQBjmaaXWJGNJzLwGmn6piclgtt7m5llm1buunU2
cszkRNmTFemi3c5guVl7jqYjsXR5R7X93i0uHKqH36n0HovEZMaudnbW9O/Dh7Kz
SDpnfwBsi8x1rsuibJ1ejszkx09qmfRHPhs7OfF+a039RJH77nr/OFAuF9/et1Hh
V8jg2TgYL3zLiTcuj8/Sb7Lm2n+OMZBEIQCDl/WTpPRzQuRQWE97oUtFEtxtzW61
BDMMNNuhhfvZPgsJmHLmEcu6O91ncrDOxFJAkSlDh7o5ANGF99X2nsv1peZS98Da
VkiKJGJ/HX2zWLBr5TyrnpQ1jdj5Yeq25dVzoNIUSUjwntALtglg9Vb+OxeBDFFz
4xSS/VjfNwkRCSohnj5Wb7viZfAqxASWtkywrQ08Jsxz6G4Io4Xufik4iHzgWtqM
FD3lE+Khc3xc/NEtei6+yvUVjm9WcUSML/YfbPULzXYmFzLQPRNo4IQScBR4dVfE
Ac2Je+DLQCGCcNzhdAh8oFz/zwGQrIwRbwW9+ypYxs7VfcGyayM=
=5402
-----END PGP SIGNATURE-----

--nextPart2106358.irdbgypaU6--



