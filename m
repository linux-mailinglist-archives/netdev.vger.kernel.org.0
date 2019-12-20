Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA46128098
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTQYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:24:35 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:53106 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727181AbfLTQYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:24:34 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EF4BB34006A;
        Fri, 20 Dec 2019 16:24:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 20 Dec
 2019 16:24:28 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 0/2] sfc: fix bugs introduced by XDP patches
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <83c50994-18de-1d8f-67ce-b2322d226338@solarflare.com>
Date:   Fri, 20 Dec 2019 16:24:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25114.003
X-TM-AS-Result: No-0.537900-8.000000-10
X-TMASE-MatchedRID: MS5rc/rqO2w5NXlWWXBFjsnUT+eskUQPV447DNvw38b2u2oLJUFmGIWh
        cBEymmAr8XVI39JCRnSjfNAVYAJRAinqwKmU0oYznFVnNmvv47t9LQinZ4QefL6qvLNjDYTwxbG
        vmM9nj5NQSFbL1bvQAXnN0DN7HnFmW5LB7PV5+OBj3jcwKV3vYSJIBoXPfnNXa4IDfe01uhmj2q
        jlYX+7qlrMCKBXF1d6I2VNggMWJCP4LggrmsRgvTwNB+BE7PnlftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.537900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25114.003
X-MDID: 1576859074-zJ1E9mjcN2oG
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two fixes for bugs introduced by the XDP support in the sfc driver.

Charles McLachlan (1):
  sfc: Include XDP packet headroom in buffer step size.

Edward Cree (1):
  sfc: fix channel allocation with brute force

 drivers/net/ethernet/sfc/efx.c        | 37 +++++++++++++--------------
 drivers/net/ethernet/sfc/net_driver.h |  4 +--
 drivers/net/ethernet/sfc/rx.c         | 14 +++++-----
 3 files changed, 26 insertions(+), 29 deletions(-)

