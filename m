Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA88522961A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgGVKb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:31:58 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:43418 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726161AbgGVKb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:31:58 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5228620063;
        Wed, 22 Jul 2020 10:31:57 +0000 (UTC)
Received: from us4-mdac16-35.at1.mdlocal (unknown [10.110.49.219])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 50E586009B;
        Wed, 22 Jul 2020 10:31:57 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.7])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F123F220054;
        Wed, 22 Jul 2020 10:31:56 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B47F34C005B;
        Wed, 22 Jul 2020 10:31:56 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 11:31:51 +0100
Subject: Re: [PATCH net-next] efx: convert to new udp_tunnel infrastructure
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, <mhabets@solarflare.com>,
        <mslattery@solarflare.com>
References: <20200717235336.879264-1-kuba@kernel.org>
 <a97d3321-3fee-5217-59e4-e56bfbaff7a3@solarflare.com>
 <20200720102156.717e3e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ecc09a90-1946-fc6a-a5fd-5e0dfe11532d@solarflare.com>
 <20200721124811.3fb63afe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <0bca1a1a-52ed-a49d-ecca-246825a341fe@solarflare.com>
Date:   Wed, 22 Jul 2020 11:31:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200721124811.3fb63afe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25556.003
X-TM-AS-Result: No-1.935500-8.000000-10
X-TMASE-MatchedRID: sDm3xtR6Ud/mLzc6AOD8DfHkpkyUphL9Pw8st9LJ22852X8YwVUEWyKp
        gX8fFPKZQOcxSdTpDT+Rk6XtYogiau9c69BWUTGw0C1sQRfQzEHEQdG7H66TyHEqm8QYBtMOKHL
        gOVEUkvMh1yVAVy+b0LSYpytcbpuzMtn1lwWjFrXi+fTMx9KaNitss6PUa4/cD6GAt+UbooSj1C
        O4X0EqeXggXFAhtWiYlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.935500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25556.003
X-MDID: 1595413917-43bde8bMjHD1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/07/2020 20:48, Jakub Kicinski wrote:
> #define TUNNEL_ENCAP_UDP_PORT_ENTRY_INVALID 0xffff
> Can I add that in mcdi_pcol.h or better next to struct efx_udp_tunnel?
>
> mcdi_pcol.h looks generated.
It is generated, yeah.
So best add it with struct efx_udp_tunnel.

-ed
