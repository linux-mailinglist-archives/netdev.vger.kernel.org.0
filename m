Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F07723A891
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgHCOd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:33:56 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41062 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbgHCOd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:33:56 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 416F6200A7;
        Mon,  3 Aug 2020 14:33:55 +0000 (UTC)
Received: from us4-mdac16-35.at1.mdlocal (unknown [10.110.49.219])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3FD84800A4;
        Mon,  3 Aug 2020 14:33:55 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DF34940079;
        Mon,  3 Aug 2020 14:33:54 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9B0E2B80090;
        Mon,  3 Aug 2020 14:33:54 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 Aug 2020
 15:33:49 +0100
Subject: Re: [PATCH v2 net-next 03/11] sfc_ef100: read Design Parameters at
 probe time
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
 <48b1fedf-0863-8fab-7f7a-e2df6946b764@solarflare.com>
 <20200731131857.41b0f32a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <9d248f15-2315-9598-9647-c9b25ab54b94@solarflare.com>
Date:   Mon, 3 Aug 2020 15:33:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200731131857.41b0f32a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25580.005
X-TM-AS-Result: No-0.238200-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfvmLzc6AOD8DfHkpkyUphL9amDMhjMSdnm8YDH/UBNnm7FI
        kGknrWQ+Sqdra4WWujxFyhOsaJuHkJmvObnpEDjc5venhychcY1caNB/u5yQqx3RY4pGTCyH7dO
        T/i6WMcVjsp8LfdCTZ8ruOiI7nDntZAwUx7OZYhj9xyC38S1f/TQAl7cHmp8GK8VLPDcP9n47I2
        rILImqcX8LS3VGNSyK/eOk6Sk4CgTlEGqnTqgLR7zgL/eLACDEfS0Ip2eEHnxlgn288nW9IN5/H
        gWYxplM5MIx11wv+COujVRFkkVsm26HChZGFGVmGwP1UsrPzSK4Oe1N7HfRW0N6QixcYyqykAj7
        JgTsrRWS04f34BgrDWAbf1d/FZIbkT+vof6J73Cs6XBn4etEvIVyAlz5A0zC7xsmi8libwVi6nH
        ReNJA8sM4VWYqoYnhs+fe0WifpQo=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.238200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25580.005
X-MDID: 1596465235-OVB-pWS9b1yz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/07/2020 21:18, Jakub Kicinski wrote:
> On Fri, 31 Jul 2020 13:58:35 +0100 Edward Cree wrote:
>> +	default:
>> +		/* Host interface says "Drivers should ignore design parameters
>> +		 * that they do not recognise."
>> +		 */
>> +		netif_info(efx, probe, efx->net_dev,
>> +			   "Ignoring unrecognised design parameter %u\n",
>> +			   reader->type);
> Is this really important enough to spam the logs with?
Well, it implies your NIC (FPGA image) is newer than your driver,
 and saying things the driver doesn't understand; I feel like that
 should be recorded somewhere.
Maybe this should be a netif_dbg() instead?  (Or is this a subtle
 way of telling me "you should implement devlink health"?)
> Should you warn if the TLV stream ends half-way through an entry?
Fair point, yes we should.

-ed
