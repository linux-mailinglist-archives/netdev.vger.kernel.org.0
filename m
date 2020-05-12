Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62671CF595
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 15:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbgELNXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 09:23:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:42620 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbgELNXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 09:23:12 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4E35B20055;
        Tue, 12 May 2020 13:23:12 +0000 (UTC)
Received: from us4-mdac16-9.at1.mdlocal (unknown [10.110.49.191])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4B8F1800A9;
        Tue, 12 May 2020 13:23:12 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.9])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CD7BC4004D;
        Tue, 12 May 2020 13:23:11 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8887E58005A;
        Tue, 12 May 2020 13:23:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 12 May
 2020 14:23:06 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/2] sfc: siena_check_caps fixups
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <fccfbce7-d9d8-97ad-991a-95f9333121d6@solarflare.com>
Date:   Tue, 12 May 2020 14:23:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25414.003
X-TM-AS-Result: No-2.074000-8.000000-10
X-TMASE-MatchedRID: yxMxR3EH7To32uiNuPEGTAVl6/nUmdU9BGwExtNOAA/az1ZmyRRNgSbn
        v6hNrKwsiItGLdqpiWVXHpcxaFNZCKH2g9syPs888Kg68su2wyF9LQinZ4QefL6qvLNjDYTwIq9
        5DjCZh0zpd+/rcvUW9gtuKBGekqUpnH7sbImOEBRekLa5edcWSN43kVrcMABCKHxDvwgGHvBqJD
        pwWI/UwUfLDd6JE5OdfObqGK9JplminaV/dK0aEhK3Vty8oXtk2SsLyY4gH4tVyvbTg/runA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.074000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25414.003
X-MDID: 1589289792-M3vLnTbyEthl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a bug and a build warning introduced in a recent refactor.

Edward Cree (2):
  sfc: actually wire up siena_check_caps()
  sfc: siena_check_caps() can be static

 drivers/net/ethernet/sfc/siena.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

