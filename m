Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD5821EC09
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGNJCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:02:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:46118 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbgGNJCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 05:02:16 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7244860061;
        Tue, 14 Jul 2020 09:02:15 +0000 (UTC)
Received: from us4-mdac16-7.ut7.mdlocal (unknown [10.7.65.75])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 697E42009A;
        Tue, 14 Jul 2020 09:02:15 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CE8011C0051;
        Tue, 14 Jul 2020 09:02:14 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6AAB94C0063;
        Tue, 14 Jul 2020 09:02:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 14 Jul
 2020 10:02:09 +0100
Subject: Re: [PATCH v2 net-next 04/16] sfc_ef100: skeleton EF100 PF driver
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
 <14ffb6fc-d5a2-ce62-c8e7-6cf6e164bf16@solarflare.com>
 <20200713160200.681db7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <88664bf2-a0c9-4cb1-b50c-2a5e592fe235@solarflare.com>
Date:   Tue, 14 Jul 2020 10:02:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200713160200.681db7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25540.003
X-TM-AS-Result: No-8.678200-8.000000-10
X-TMASE-MatchedRID: csPTYAMX1+HmLzc6AOD8DfHkpkyUphL9SeIjeghh/zPLwwwRZ45jJRBj
        Mu2MryPBPLa1JP0J/BnZe+wUej5wh2UlOh2o2oTO4h8r8l3l4eYO9z+P2gwiBRLf1vz7ecPHX0f
        XACjD+xM4njG6lOJes6hhqX8wpo7ehmayTFnN39a7B1QwzOcQD7tubiieweWuDO+DX+rUwfb+ez
        fog1uF01fYfu0J3jY1X7bicKxRIU1mIVC+RmEW7Wrz/G/ZSbVq+gtHj7OwNO0o13+LnQSKDI4R8
        ku3Af3zZYJ5eKRIyu37NGNoh2a803jE18NzuDeaVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.678200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25540.003
X-MDID: 1594717335-w4hEB2SiD3yH
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 00:02, Jakub Kicinski wrote:
> On Mon, 13 Jul 2020 12:32:16 +0100 Edward Cree wrote:
>> +MODULE_VERSION(EFX_DRIVER_VERSION);
> We got rid of driver versions upstream, no?
The sfc driver still has a MODULE_VERSION(), I just made this do
 the same.  Should I instead remove the one from sfc as well?
I assumed there was some reason why it hadn't been included in
 the versionectomy so far.

> +static void __exit ef100_exit_module(void)
> +{
> +	pr_info("Solarflare EF100 NET driver unloading\n");
> efx_destroy_reset_workqueue(); ?
Sounds like a good idea, yes.  Good catch.

> Please remove all the uint32_ts
OK.

Thanks for reviewing.
-ed
