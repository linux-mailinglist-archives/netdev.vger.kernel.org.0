Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FC726665F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgIKR0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:26:46 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33250 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726306AbgIKR0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:26:38 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4B05D60097;
        Fri, 11 Sep 2020 17:26:38 +0000 (UTC)
Received: from us4-mdac16-21.ut7.mdlocal (unknown [10.7.65.245])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4949F8009E;
        Fri, 11 Sep 2020 17:26:38 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D41C928004D;
        Fri, 11 Sep 2020 17:26:37 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 89A18940089;
        Fri, 11 Sep 2020 17:26:37 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 18:26:32 +0100
Subject: Re: [RFC PATCH net-next v1 11/11] drivers/net/ethernet: clean up
 mis-targeted comments
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
 <20200911012337.14015-12-jesse.brandeburg@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <227d2fe4-ddf8-89c9-b80b-142674c2cca0@solarflare.com>
Date:   Fri, 11 Sep 2020 18:26:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200911012337.14015-12-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-3.714600-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E/mLzc6AOD8DfHkpkyUphL91JP9NndNOkUda1Vk3RqxOIO3
        X3IJL/YZ0JwSV7ipDfUsMgTZd2lCt0ohWBZ4QV+6qJSK+HSPY+/pVMb1xnESMgWqvFWg3Xg6Tup
        AS3DN87IeQ2V1bj+6xusaujhTG8awkrMo37I6x/4J6xTeI+I0LAZyESFXAljf4Vo4xoaXBy+1U5
        6R2ZaElQ0mmbOIq98WoHy2Fsp5cv5jDV//SvkH3kz7FUUjXG1jNW8jQhzoALUrxUs8Nw/2foRqG
        PInK2mOFOow+ChHTLNftuJwrFEhTY2j49Ftap9Ero1URZJFbJsCr1CPevXiUuLYJrD1X9Z+1GHp
        OH8+3EeqITbnPRiwj0JfV3B+/RErwM16T6UwC99QpRvUskPZiLmNpuXp+tR+mg6zWDb9bUyFcgJ
        c+QNMwu8bJovJYm8FYupx0XjSQPLDOFVmKqGJ4bPn3tFon6UK
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.714600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599845198-ywl0bJXEWIi0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/09/2020 02:23, Jesse Brandeburg wrote:
> As part of the W=1 cleanups for ethernet, a million [1] driver comments
> had to be cleaned up to get the W=1 compilation to succeed. This
> change finally makes the drivers/net/ethernet tree compile with
> W=1 set on the command line.
>
> [1] - ok it wasn't quite a million, but it felt like it.
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>
> ---
> @@ -263,6 +268,7 @@ struct efx_ptp_timeset {
>   * @nic_ts_enabled: Flag indicating if NIC generated TS events are handled
>   * @txbuf: Buffer for use when transmitting (PTP) packets to MC (avoids
>   *         allocations in main data path).
> + * @MC_CMD_PTP_IN_TRANSMIT_LENMAX: hack to get W=1 to compile
I think I'd rather have a bogus warning than bogus kerneldocto suppress it;
 please drop this line (and encourage toolchain folks to figure out how to
 get kerneldoc to ignore macros it can't understand).
Apart from that, the sfc and sfc/falcon parts LGTM.

-ed
