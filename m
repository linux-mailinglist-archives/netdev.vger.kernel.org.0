Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C3A1D9DD7
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgESRXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:23:45 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58988 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729001AbgESRXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:23:45 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D941A600D2;
        Tue, 19 May 2020 17:23:44 +0000 (UTC)
Received: from us4-mdac16-2.ut7.mdlocal (unknown [10.7.65.70])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D27818009E;
        Tue, 19 May 2020 17:23:44 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5E5BC8007D;
        Tue, 19 May 2020 17:23:44 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DF2E7940082;
        Tue, 19 May 2020 17:23:43 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 19 May
 2020 18:23:37 +0100
Subject: Re: [PATCH net-next v2] net: flow_offload: simplify hw stats check
 handling
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jiri@resnulli.us>,
        <kuba@kernel.org>
References: <cf0d731d-cb34-accd-ff40-6be013dd9972@solarflare.com>
 <20200519171923.GA16785@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <6013b7ce-48c9-7169-c945-01b2226638e4@solarflare.com>
Date:   Tue, 19 May 2020 18:23:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200519171923.GA16785@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25428.003
X-TM-AS-Result: No-1.220000-8.000000-10
X-TMASE-MatchedRID: ZrceL/U8jXS8rRvefcjeTR4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYM9D
        pMi+I1Ym8ydRWL0NTPHqUwd4lb5Mcr9ZdlL8eonaTHDUEwHVLSvZs3HUcS/scCq2rl3dzGQ1Tqn
        Dptwtjb26kkZW1xVl7ef62hHIOGcWriLQt3YbHpV5jSbKjce+xoVyAlz5A0zC7xsmi8libwVi6n
        HReNJA8sM4VWYqoYnham2pp47lr+A=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.220000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25428.003
X-MDID: 1589909024-lSgCi_GOg0sB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2020 18:19, Pablo Neira Ayuso wrote:
> This is breaking netfilter again. 
Still waiting for you to explain what this "breaks".  AFAICT the
 new DONT_CARE has exactly the same effect that the old DONT_CARE
 did, so as long as netfilter is using DONT_CARE rather than (say)
 a hard-coded 0, it should be fine.
