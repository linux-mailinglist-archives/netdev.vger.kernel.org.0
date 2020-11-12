Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365D32B083F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgKLPSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:18:12 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.184]:33904 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728346AbgKLPSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:18:12 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 81C5D2017C;
        Thu, 12 Nov 2020 15:18:11 +0000 (UTC)
Received: from us4-mdac16-35.at1.mdlocal (unknown [10.110.49.219])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7E6CB800A4;
        Thu, 12 Nov 2020 15:18:11 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 22D5240077;
        Thu, 12 Nov 2020 15:18:11 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D54BAB8007D;
        Thu, 12 Nov 2020 15:18:10 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Nov
 2020 15:18:05 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/3] sfc: further EF100 encap TSO features
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Message-ID: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
Date:   Thu, 12 Nov 2020 15:18:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25782.003
X-TM-AS-Result: No-0.226700-8.000000-10
X-TMASE-MatchedRID: oFxBp2LP3lJcobUo5TVGLZyebS/i2xjjeXZz1at5bOyKZevPTDsNRnm9
        jhiEIiBu69jBcp8HI69TvVffeIwvQwUcfW/oedmqnFVnNmvv47t9LQinZ4QefL6qvLNjDYTwIq9
        5DjCZh0zCLNfu05PakAtuKBGekqUpUfEQFBqv0mfJytu04wf4mTw26Plqfeis8J6hg1ytSasPDq
        r9fqhWDfjByMwJNP5aDp0EsJxQCJYSCelt9Y535ytXpY4hI7YpnT0wA41NFzXtfQ1SPvnqTJqVX
        UXjGsjz2F+vBZls4K+yaqc7gc0b5ehxodtyrclRwL6SxPpr1/I=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.226700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25782.003
X-MDID: 1605194291-7-C976dcfl-V
X-PPE-DISP: 1605194291;7-C976dcfl-V
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for GRE and GRE_CSUM TSO on EF100 NICs, as
 well as improving the handling of UDP tunnel TSO.

Edward Cree (3):
  sfc: extend bitfield macros to 19 fields
  sfc: correctly support non-partial GSO_UDP_TUNNEL_CSUM on EF100
  sfc: support GRE TSO on EF100

 drivers/net/ethernet/sfc/bitfield.h  | 26 +++++++++++++++++++++-----
 drivers/net/ethernet/sfc/ef100_nic.c |  8 ++++++--
 drivers/net/ethernet/sfc/ef100_tx.c  | 12 ++++++++++--
 3 files changed, 37 insertions(+), 9 deletions(-)

