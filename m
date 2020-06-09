Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3313D1F44D0
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 20:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388430AbgFISIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 14:08:40 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:50580 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731294AbgFISIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 14:08:36 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F2C0B20093;
        Tue,  9 Jun 2020 18:08:33 +0000 (UTC)
Received: from us4-mdac16-21.at1.mdlocal (unknown [10.110.49.203])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F03EA6009B;
        Tue,  9 Jun 2020 18:08:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.106])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 88AD022007A;
        Tue,  9 Jun 2020 18:08:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 27A57B4007C;
        Tue,  9 Jun 2020 18:08:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Jun 2020
 19:08:25 +0100
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
To:     Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jim Cromie <jim.cromie@gmail.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-2-stanimir.varbanov@linaro.org>
 <20200609111615.GD780233@kroah.com>
 <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
 <727b31a0-543b-3dc5-aa91-0d78dc77df9c@solarflare.com>
 <2b291c34e10b3b3d9d6e01f8201ec0942e39575f.camel@perches.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e91223b2-3b31-6564-00c9-bda9a2aeffe5@solarflare.com>
Date:   Tue, 9 Jun 2020 19:08:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <2b291c34e10b3b3d9d6e01f8201ec0942e39575f.camel@perches.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25470.003
X-TM-AS-Result: No-10.210900-8.000000-10
X-TMASE-MatchedRID: 7ySqCuYCpfjsYbGmK/WYxvZvT2zYoYOwC/ExpXrHizyMUViaYYbK3JYv
        /wbpWcIKq5ewd0UPS9hdKS1gReph0aH2g9syPs88A9lly13c/gEg/CIfleX9D0hcmj54ab4UNP+
        2kwiBPOV5DzCqPSy3yOKHzP0BuUCDNyl1nd9CIt2DGx/OQ1GV8hFMgtPIAD6i+gtHj7OwNO2Ohz
        Oa6g8KrdL6UoKG2HjArEiGVSydaXgrmmLgt5BrqsqcASyOtFdbnkXNoeOrXbw=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.210900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25470.003
X-MDID: 1591726113-WCvvrqNr18jp
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/06/2020 18:56, Joe Perches wrote:
> These are _not_ netif_<level> control flags. Some are though.
> For instance:
>
> $ git grep "MODULE_PARM.*\bdebug\b" drivers/net | head -10
> [...]
>
> These are all level/class output controls.
TIL, thanks!  I should have looked deeperrather than assuming
 they were all like ours.

Though judging just by that grep output, it also looks like
 quite a lot of those won't fit into 5 groups either, so some
 rethink may still be needed...

-ed
