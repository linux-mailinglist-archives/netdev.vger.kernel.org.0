Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D887E35E3
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409468AbfJXOqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:46:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36342 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732092AbfJXOqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:46:09 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 66148140071;
        Thu, 24 Oct 2019 14:46:05 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 24 Oct 2019 15:46:00 +0100
Subject: Re: [PATCH net-next 2/6] sfc: perform XDP processing on received
 packets.
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
 <1c193147-d94a-111f-42d3-324c3e8b0282@solarflare.com>
 <20191023004501.4a78c300@carbon>
From:   Charles McLachlan <cmclachlan@solarflare.com>
Message-ID: <bdf2137e-808e-2607-0c65-e609741242c0@solarflare.com>
Date:   Thu, 24 Oct 2019 15:45:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191023004501.4a78c300@carbon>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24998.003
X-TM-AS-Result: No-2.712700-8.000000-10
X-TMASE-MatchedRID: fgYTp5XatxbmLzc6AOD8DfHkpkyUphL9Ap+UH372RZWy1n9NBPtzNWdC
        uMvHMJPk8OUA6T+rBZS85NPA3BnulKeOtM+NJ84fq5uw61JZjZCRk6XtYogiam+YnOq0coeP0C1
        sQRfQzEHEQdG7H66TyN+E/XGDLHcMc4z1GNf6xcIHbkCSwZ987yY1AzE/RLQ+zDU4EMqAzxiHL4
        /znrcJ3tQ17CngTb9OBKmZVgZCVnezGTWRXUlrxxtsJUxyzWNSVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.712700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24998.003
X-MDID: 1571928369-TTUxwAwogdOT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/10/2019 23:45, Jesper Dangaard Brouer wrote:

>> +	case XDP_REDIRECT:
>> +		rc = xdp_do_redirect(efx->net_dev, &xdp, xdp_prog);
>> +		if (rc) {
> 
> Can we call the 'rc' variable 'err' instead?
> And give it an unlikely().

Yes. Done in next version of the patch set.
