Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B57D26685C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 20:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgIKSnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 14:43:39 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47532 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbgIKSnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 14:43:37 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B735920052;
        Fri, 11 Sep 2020 18:43:35 +0000 (UTC)
Received: from us4-mdac16-22.at1.mdlocal (unknown [10.110.49.204])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A5BCC800A7;
        Fri, 11 Sep 2020 18:43:35 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4B290100078;
        Fri, 11 Sep 2020 18:43:35 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0D083B8005D;
        Fri, 11 Sep 2020 18:43:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 19:43:30 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/3] sfc: misc cleanups
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
Date:   Fri, 11 Sep 2020 19:43:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-2.048100-8.000000-10
X-TMASE-MatchedRID: v9dsqOyxT7exkAvjLLYiNRIRh9wkXSlFRiPTMMc/MmkTLunq7Jxcvanw
        Hgc6fuMkis7Mz++lgcRTvVffeIwvQwUcfW/oedmqnFVnNmvv47t9LQinZ4QefL6qvLNjDYTwIq9
        5DjCZh0zCLNfu05PakAtuKBGekqUpbGVEmIfjf3sbsO2JXCiXB2MqFffNiGuHWASUl8B+/phwzD
        tYE5kjFUITY8cIIS1JfObqGK9JplminaV/dK0aEhK3Vty8oXtkps2YVnJpfNg=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.048100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599849815-UUA-pNJYKZsJ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up a few nits I noticed while working on TXQ stuff.

Edward Cree (3):
  sfc: remove duplicate call to efx_init_channels from EF100 probe
  sfc: remove spurious unreachable return statement
  sfc: cleanups around efx_alloc_channel

 drivers/net/ethernet/sfc/ef100_nic.c    | 4 ----
 drivers/net/ethernet/sfc/ef100_tx.c     | 1 -
 drivers/net/ethernet/sfc/efx_channels.c | 5 ++---
 drivers/net/ethernet/sfc/efx_channels.h | 2 --
 4 files changed, 2 insertions(+), 10 deletions(-)

