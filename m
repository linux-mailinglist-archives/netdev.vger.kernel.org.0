Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4971C266A66
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgIKV4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:56:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59428 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725847AbgIKV4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:56:04 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3866160094;
        Fri, 11 Sep 2020 21:56:04 +0000 (UTC)
Received: from us4-mdac16-49.ut7.mdlocal (unknown [10.7.66.16])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 37C068009B;
        Fri, 11 Sep 2020 21:56:04 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.40])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C0806280066;
        Fri, 11 Sep 2020 21:56:03 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6CD96BC0076;
        Fri, 11 Sep 2020 21:56:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 22:55:58 +0100
Subject: Re: [RFC PATCH net-next v1 11/11] drivers/net/ethernet: clean up
 mis-targeted comments
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
 <20200911012337.14015-12-jesse.brandeburg@intel.com>
 <227d2fe4-ddf8-89c9-b80b-142674c2cca0@solarflare.com>
 <20200911144207.00005619@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e2e637ae-8cda-c9a4-91ce-93dbd475fc0c@solarflare.com>
Date:   Fri, 11 Sep 2020 22:55:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200911144207.00005619@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-3.934400-8.000000-10
X-TMASE-MatchedRID: VPleTT1nwdTmLzc6AOD8DfHkpkyUphL9ekMgTOQbVFsZSz1vvG+0mjGE
        TFerrMsjdmjn29714VMa7iGxrZ1cFjPpmmeZK64q4h8r8l3l4eZXLrDwmXJ6bwQsw9A3PIlL0HC
        C1wXiE/J1C0eA/+ELkLyoNIcZ8C1BHJosEA366STlAR4uQ+nossHWhOU1PTVYdz3bnI4leYVxbj
        2K9xHJ+OfOVcxjDhcwIC0OoeD/hCbQLWxBF9DMQcRB0bsfrpPInxMyeYT53RnUvuI6DlMU3vWBK
        +akkoq4N7J9wpCyXYjV5wLYuJQTvYCxQx/QhvMkBcD5rV409SHT2My6xGU4Bqmrf9FYIKdJ/xqW
        /R9x9c7UNewp4E2/TgSpmVYGQlZ3sxk1kV1Ja8cbbCVMcs1jUlZca9RSYo/b
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.934400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599861364-TiHtXqQNxaDD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/09/2020 22:42, Jesse Brandeburg wrote:
> Thanks Ed, I think I might just remove the /** on that function then
> (removing it from kdoc processing)
I dunno, that means
a) kerneldoc won't generate html for this struct
b) new additions to the struct without corresponding kerneldoc won't
   generate warnings
 both of which are not ideal outcomes.
I realise there's value in having totally warning-clean code, but in
 this case I think this one warning, even though it's indicating a
 toolchain problem rather than a codebase problem, should better stay
 (if only to put pressure on the toolchain to fix it).
Otherwise, when and if the toolchain is fixed, what's the chance we'll
 remember to put the /** back?

That's just my opinion, though; I won't block patches that disagree.

-ed
