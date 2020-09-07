Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336CA260521
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgIGTbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:31:19 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:37162 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726458AbgIGTbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 15:31:17 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C839660060;
        Mon,  7 Sep 2020 19:31:15 +0000 (UTC)
Received: from us4-mdac16-14.ut7.mdlocal (unknown [10.7.65.238])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C70BF2009A;
        Mon,  7 Sep 2020 19:31:15 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.39])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3C1041C004F;
        Mon,  7 Sep 2020 19:31:15 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CE46880062;
        Mon,  7 Sep 2020 19:31:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep 2020
 20:31:07 +0100
Subject: Re: [PATCH net-next 2/6] sfc: remove phy_op indirection
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
 <9cc76465-9c1c-ec10-846a-b58f16d0d083@solarflare.com>
 <20200907122230.47ccfd55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <5809ba4c-e2be-b3ab-7122-dee2241310d0@solarflare.com>
Date:   Mon, 7 Sep 2020 20:31:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200907122230.47ccfd55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25650.007
X-TM-AS-Result: No-2.188900-8.000000-10
X-TMASE-MatchedRID: y/2oPz6gbvjmLzc6AOD8DfHkpkyUphL9SeIjeghh/zNjLp8Cm8vwFwoe
        RRhCZWIBLFfLni0zZnfL769VRxHRCoG4RNjbpvLi2PArUpVkoPwCn5QffvZFlVLg/DMzZxvKLwQ
        y5lUiS3perIoY2WP5sBP+4hrT4NGjpm5FPBlNpd20YzRwENQzjWAW2j9VWc0l21KK0dlzZ7qIJy
        3R1O6IjglJUgkaXdtJ/47LjvLceo7epIYVZjxghQuLP4ROdWHVNV9S7O+u3KZvKvTUqBvLOmNok
        eyvFnLMhBw6OtDhVN4x6IfHPloL3r9ZdlL8eonalpYqKNmWxsHZs3HUcS/scCq2rl3dzGQ1xuXt
        BFSNU1hhVFrmn7FLArGF5NZcXfn/MpDgKpL7WIl5g3bkoPYwtCSyfXRk0vrN5RxVCfp8UG87DUu
        nlaKFaAAwHiCIHF30TWsi+6N5vHGigEHy7J4S6ylkreA5r24aYnCi5itk3iprD5+Qup1qU37cGd
        19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.188900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25650.007
X-MDID: 1599507075-Z2SzWEvxf1da
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/09/2020 20:22, Jakub Kicinski wrote:
> On Mon, 7 Sep 2020 17:14:34 +0100 Edward Cree wrote:
>>  drivers/net/ethernet/sfc/mcdi_port.c        | 593 +-------------------
>>  drivers/net/ethernet/sfc/mcdi_port_common.c | 560 ++++++++++++++++++
> Would you mind improving variable ordering and addressing checkpatch
> complaints while moving this code? The camel case and breaking up
> case statements warning can definitely be ignored, but there are others.
I'd prefer to do it as a separate follow-up patch, so that git tools
 can more reliably trace the history across the movement, per [1].
If the series needs respinning then I'll add it in v2, otherwise I'll
 post it standalone after this goes in.

-ed

[1]: https://yarchive.net/comp/linux/coding_style.html#16
