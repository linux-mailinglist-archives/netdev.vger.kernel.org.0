Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0ACF26A17D
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 11:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIOJGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 05:06:12 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54850 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbgIOJGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 05:06:09 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F3C8460080;
        Tue, 15 Sep 2020 09:06:08 +0000 (UTC)
Received: from us4-mdac16-13.ut7.mdlocal (unknown [10.7.65.237])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F25B72009A;
        Tue, 15 Sep 2020 09:06:08 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8F18C1C0052;
        Tue, 15 Sep 2020 09:06:08 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 39E9CB40060;
        Tue, 15 Sep 2020 09:06:08 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Sep
 2020 10:06:03 +0100
Subject: Re: [PATCH net-next v2 09/10] sfc: fix kdoc warning
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
 <20200915014455.1232507-10-jesse.brandeburg@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <aaa15cdb-179b-bca7-6d41-4a861aaa3470@solarflare.com>
Date:   Tue, 15 Sep 2020 10:05:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200915014455.1232507-10-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25666.003
X-TM-AS-Result: No-6.372600-8.000000-10
X-TMASE-MatchedRID: zGP2F0O7j/vmLzc6AOD8DfHkpkyUphL9AQ8mtiWx//oKQo6lRC5cFSv1
        E0/IJGO+8XVI39JCRnSjfNAVYAJRAuvV11lepJ0adhnFihmbnwUO9z+P2gwiBTuwTDpX8ii0e/p
        wbu325erffZepmMNvHVY40rXt0Xcr+IYlG6Z6vA09oFMnLLzjBToSfZud5+GgUuD8MzNnG8pFyI
        +e6WbBknvak7WQi+a7vEmXEq243oS/WXZS/HqJ2paWKijZlsbB2bNx1HEv7HAqtq5d3cxkNWgS/
        DSnw/xUE0bja0DYkh8opw2Dnel5ogn2Sj6IO9etfdaEyt4HPuI=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.372600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25666.003
X-MDID: 1600160769-fQ2g6Zp_xvXI
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2020 02:44, Jesse Brandeburg wrote:
> kernel-doc script as used by W=1, is confused by the macro
> usage inside the header describing the efx_ptp_data struct.
>
> drivers/net/ethernet/sfc/ptp.c:345: warning: Function parameter or member 'MC_CMD_PTP_IN_TRANSMIT_LENMAX' not described in 'efx_ptp_data'
>
> After some discussion on the list, break this patch out to
> a separate one, and fix the issue through a creative
> macro declaration.
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Edward Cree <ecree@solarflare.com>
I still don't love it, but it'll do, so have an
Acked-by: Edward Cree <ecree@solarflare.com>

(But please make sure whoever maintains scripts/kernel-doc knows that
 it's breaking on a reasonable construct and forcing the code to be
 _less_ self-documenting than it otherwise could be.)
