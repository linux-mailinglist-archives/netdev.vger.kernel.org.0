Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B9422D9EA
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 22:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgGYU5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 16:57:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgGYU5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 16:57:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PKpTMt031644;
        Sat, 25 Jul 2020 20:57:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=c/tTjfAoYR2u5Pr1+bu/2No2loWgjwb232GxlPbMfwA=;
 b=Aeg99tkxe9p/CgP2LtKuzjlFzS+5xvoc1ug+IYmSRvr6VnfG/CvVNWLHeFSflLrK+BAq
 Y9QHw+JnH39NQ+B6px0Arc/PSxDg2nNS/Xd84Imll18CyzVbIIAbxsACpSoKLCdjkRQu
 B+4HHQ09LTPzPgezdors8rgQPWfqqhRfRqfdC9D7RBV+MPiAxEwFfqzhdluItL1wtmg8
 Ei8ZRb/BP2ssBRzDctywVBHqL7Ffap+Mvkkqa9TNd5hA2yjgaelhqoQhxECA2e4wFYHR
 of5ukM0IDtCYgThJFSxCwLC8/+nAX3JCk0Kz3Ujvx2xuSSAnNg2ZoEQCFfndBG1XpzoX Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32gcpksm5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 20:57:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PKqX0Z009119;
        Sat, 25 Jul 2020 20:57:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32gasf3nwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 20:57:16 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06PKv1dA029834;
        Sat, 25 Jul 2020 20:57:04 GMT
Received: from dhcp-10-159-253-11.vpn.oracle.com (/10.159.253.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 13:57:01 -0700
Subject: Re: [RESEND PATCH] ARM: dts: keystone-k2g-evm: fix rgmii phy-mode for
 ksz9031 phy
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "arm@kernel.org" <arm@kernel.org>, Olof Johansson <olof@lixom.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20200724214221.28125-1-grygorii.strashko@ti.com>
 <a91d2bad-b794-fe07-679a-e5096aa5ace8@oracle.com>
 <CAK8P3a3N70PbotC18K-SG9+XgfApHNZyCYvUgOyfrxrP55zSEw@mail.gmail.com>
From:   "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <feaa8f63-319a-1c3a-fcdd-804e74bbc8ec@oracle.com>
Date:   Sat, 25 Jul 2020 13:56:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3N70PbotC18K-SG9+XgfApHNZyCYvUgOyfrxrP55zSEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=3 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/20 12:57 AM, Arnd Bergmann wrote:
> On Fri, Jul 24, 2020 at 11:57 PM santosh.shilimkar@oracle.com
> <santosh.shilimkar@oracle.com> wrote:
>> On 7/24/20 2:42 PM, Grygorii Strashko wrote:
>>> Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
>>> KSZ9031 PHY") the networking is broken on keystone-k2g-evm board.
>>>
>>> The above board have phy-mode = "rgmii-id" and it is worked before because
>>> KSZ9031 PHY started with default RGMII internal delays configuration (TX
>>> off, RX on 1.2 ns) and MAC provided TX delay by default.
>>> After above commit, the KSZ9031 PHY starts handling phy mode properly and
>>> enables both RX and TX delays, as result networking is become broken.
>>>
>>> Fix it by switching to phy-mode = "rgmii-rxid" to reflect previous
>>> behavior.
>>>
>>> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>> Cc: Philippe Schenker <philippe.schenker@toradex.com>
>>> Fixes: bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> ---
>>> Fix for one more broken TI board with KSZ9031 PHY.
>> Can you please apply this patch to your v5.8 fixes branch and send it
>> upstream ? Without the fix K2G EVM board is broken with v5.8.
>>
>> Am hoping you can pick this up with pull request since it just one
>> patch.
> 
> I've applied it now, but would point out that it's generally better if you could
> forward the patch to soc@kernel.org with your Signed-off-by if you come
> across a similar patch again. That way it ends up in patchwork, and we
> are more likely to pick it up quickly.
> 
Will do next time. Thanks for picking it up.
Regards,
Santosh
