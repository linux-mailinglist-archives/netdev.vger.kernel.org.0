Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BC9217F8A
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 08:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgGHG2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 02:28:07 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:21500 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgGHG2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 02:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594189684;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=LwXOm3GoiiFAy2Z6IFkCQlwukVhqgk5eWn+uep+4q5Y=;
        b=SFCsqc1gbyqrRBW5bBl51DIoLJfvGpjBDaBQtlzt6FLMJyKNBLaH3rdL2PNPsyLoFq
        2uqld+v/QjgCK0LBof+DylHAkYdtytqu1zbDfT1/jaEsad+oUp2hhDpeWInvdygZPIxB
        7vl3P6mh96fp47PZHNfdWhlTCtyCYQ0t/cPYE33mRu20tEyznWQmcl3dGQN+Gefmhb7y
        54UfFdOp7a/2fQ/EDriPVnbfVVrXEgGkhBalWnvKu/DCTFY+aFPWqIUm/G5VI1FdQGHE
        FQpMJiIMnRatOXoS04LkfVvhuZkHmvJjC790Ley69cJebyuwcRYv0hQxGRi1dwiAEZCH
        w0rA==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhSI1Vi9hdbute3wuvmUTfEdg9AyQ=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:15f9:f3ba:c3bc:6875]
        by smtp.strato.de (RZmta 46.10.5 AUTH)
        with ESMTPSA id 60686ew686P0qMX
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 8 Jul 2020 08:25:00 +0200 (CEST)
Subject: Re: FSL P5020/P5040: DPAA Ethernet issue with the latest Git kernel
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     mad skateman <madskateman@gmail.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        Darren Stevens <darren@stevens-zone.net>
References: <AM6PR04MB3976584920CFDC269D859DBBEC660@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <4E3069C3-B777-4460-A781-84214C4539DA@xenosoft.de>
 <AM6PR04MB3976996912A9342D7BB7C1FFEC670@AM6PR04MB3976.eurprd04.prod.outlook.com>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <a81e9b59-ef64-d503-68a1-caf2f99fbbb6@xenosoft.de>
Date:   Wed, 8 Jul 2020 08:25:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM6PR04MB3976996912A9342D7BB7C1FFEC670@AM6PR04MB3976.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 July 2020 at 08:03 am, Madalin Bucur (OSS) wrote:
>> From: Christian Zigotzky <chzigotzky@xenosoft.de>
>> Sent: Tuesday, July 7, 2020 9:26 PM
>> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
>> Cc: mad skateman <madskateman@gmail.com>; Camelia Alexandra Groza <camelia.groza@nxp.com>;
>> linuxppc-dev@ozlabs.org; netdev@vger.kernel.org; R.T.Dickinson <rtd2@xtra.co.nz>;
>> Darren Stevens <darren@stevens-zone.net>
>> Subject: Re: FSL P5020/P5040: DPAA Ethernet issue with the latest Git kernel
>>
>>
>> On 7. Jul 2020, at 17:53, Madalin Bucur (OSS) <mailto:madalin.bucur@oss.nxp.com> wrote:
>> Was DPAA functional before commit A?
>> How about after commit A and before commit B?
>> The DPAA Ethernet works from  the kernel 5.6-rc4 [1] till the Git kernel from the
>> 11 of June [2]. It doesn’t work since the commit “fix bitmap_parse” [3].
>> [1] https://forum.hyperion-entertainment.com/viewtopic.php?p=49936#p49936
>> [2] https://forum.hyperion-entertainment.com/viewtopic.php?p=50848#p50848
>> [3] https://forum.hyperion-entertainment.com/viewtopic.php?p=50980#p50980
> Hi,
>
> can you please try to disable the network manager (see [1]), then boot with
> the latest kernel, that does not work, and setup the interfaces manually?
>
> Madalin
>
> [1] https://help.ubuntu.com/community/NetworkManager#Stopping_and_Disabling_NetworkManager
>
@Skateman
I will compile the latest Git kernel after the 17th. Could you please 
test it without the NetworkManager?

Thanks
