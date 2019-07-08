Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE1D61C17
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfGHJJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:09:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfGHJJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:09:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6893uBa041139;
        Mon, 8 Jul 2019 09:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=xBnTc52DNh0B6xUFwny0830lUIEUiPz7+JY1AzE6U20=;
 b=ylBClEPX8DzAbh+aMS2YEL7+DpfZblzXh3OoCm7PGCkZVFHU0xPKGQCYA1BWX0486QL+
 8VyfSI6aOxLlDaWCcUAVeWaQLUA5ZuAVRb13LfQrdUjyZVG5zNl/pSYZusSv4g6znx8M
 LYIXaBpO3FjyxLoMORspjaFmkG/QzV7H2WvbawGV6pdu6Ynj0Zn8FKGJ26EUp8pEGAja
 Gdhmg6fqxXfTCoB40WEBpAjMt5QtMgyi3u7DcErqLjt42kxDTVyyWr+R73/LrXgLSXxv
 2WmQnsLJ7ueCXBAGhaVl89UCKElUEpSgAgMS2GIu13P/LTTe8mffseF4meXK3AScF+TS 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tjkkpd7sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 09:09:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6898FMm070344;
        Mon, 8 Jul 2019 09:09:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tjgrtddd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 09:09:01 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6898w01003582;
        Mon, 8 Jul 2019 09:08:59 GMT
Received: from [10.182.69.170] (/10.182.69.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jul 2019 02:08:58 -0700
Subject: Re: [PATCH] r8169: add enable_aspm parameter
To:     AceLan Kao <acelan.kao@canonical.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190708063751.16234-1-acelan.kao@canonical.com>
From:   Yanjun Zhu <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <c480edb5-b47a-6af7-7c07-c2f39a96c9cc@oracle.com>
Date:   Mon, 8 Jul 2019 17:10:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708063751.16234-1-acelan.kao@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9311 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907080120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9311 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907080119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/8 14:37, AceLan Kao wrote:
> We have many commits in the driver which enable and then disable ASPM
> function over and over again.
>     commit b75bb8a5b755 ("r8169: disable ASPM again")
>     commit 0866cd15029b ("r8169: enable ASPM on RTL8106E")
>     commit 94235460f9ea ("r8169: Align ASPM/CLKREQ setting function with vendor driver")
>     commit aa1e7d2c31ef ("r8169: enable ASPM on RTL8168E-VL")
>     commit f37658da21aa ("r8169: align ASPM entry latency setting with vendor driver")
>     commit a99790bf5c7f ("r8169: Reinstate ASPM Support")
>     commit 671646c151d4 ("r8169: Don't disable ASPM in the driver")
>     commit 4521e1a94279 ("Revert "r8169: enable internal ASPM and clock request settings".")
>     commit d64ec841517a ("r8169: enable internal ASPM and clock request settings")
>
> This function is very important for production, and if we can't come out
> a solution to make both happy, I'd suggest we add a parameter in the
> driver to toggle it.


Perhaps sysctl is better?


>
> Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
> ---
>   drivers/net/ethernet/realtek/r8169.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index d06a61f00e78..f557cb36e2c6 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -702,10 +702,13 @@ struct rtl8169_private {
>   
>   typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
>   
> +static int enable_aspm;
>   MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
>   MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
>   module_param_named(debug, debug.msg_enable, int, 0);
>   MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 16=all)");
> +module_param(enable_aspm, int, 0);
> +MODULE_PARM_DESC(enable_aspm, "Enable ASPM support (0 = disable, 1 = enable");
>   MODULE_SOFTDEP("pre: realtek");
>   MODULE_LICENSE("GPL");
>   MODULE_FIRMWARE(FIRMWARE_8168D_1);
> @@ -7163,10 +7166,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	if (rc)
>   		return rc;
>   
> -	/* Disable ASPM completely as that cause random device stop working
> -	 * problems as well as full system hangs for some PCIe devices users.
> -	 */
> -	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
> +	if (!enable_aspm) {
> +		/* Disable ASPM completely as that cause random device stop working
> +		 * problems as well as full system hangs for some PCIe devices users.
> +		 */
> +		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
> +	}
>   
>   	/* enable device (incl. PCI PM wakeup and hotplug setup) */
>   	rc = pcim_enable_device(pdev);
