Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2510C251F56
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 20:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgHYSwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 14:52:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40660 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYSwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 14:52:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PIntf8024544;
        Tue, 25 Aug 2020 18:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=N+bWCRmm5cglEkwEYiQgv401BjgCSew4F5R23I6Kb7Q=;
 b=h/qTdSf1DmOBSTsHKM+8AoNy54ri/8LIsRdJ6iirVW5bylQASj6c1w3/WXMRahJfyvJP
 eXHVgX8d0gUTXa6XGMV2BU9qGpASM+4OWsbj3Rwr3e/T8tTeKcSsY831AmETfPZP9Vec
 y6BtDBPcUQWMaRujAhm0CRoqnzc7iexo9BCrXV4fcCVduOHir5BvQ6my1ybu3Gf6GQuk
 dzeuioI8p8UbJG8Q2NiOTQXSRp4GFZ5/F0N8fDdtQNe0w4KTTb4qA4A/3/JtKoKzm3E+
 sAJEnwqx1wTl8dkQheJbWPPee9DJQHSFJ4OVqheXTXi3qchLTsj6Or+Y8btK2vc3fkeo pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 333dbrvab8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 18:52:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PIinZ0060339;
        Tue, 25 Aug 2020 18:52:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 333r9k89k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 18:52:01 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07PIq0cS003071;
        Tue, 25 Aug 2020 18:52:00 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Aug 2020 11:51:59 -0700
Date:   Tue, 25 Aug 2020 21:51:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaloyan Nikolov <konik98@gmail.com>
Subject: Re: [PATCH net] mwifiex: Increase AES key storage size to 256 bits
Message-ID: <20200825185151.GV5493@kadam>
References: <20200825153829.38043-1-luzmaximilian@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825153829.38043-1-luzmaximilian@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008250141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 05:38:29PM +0200, Maximilian Luz wrote:
> Following commit e18696786548 ("mwifiex: Prevent memory corruption
> handling keys") the mwifiex driver fails to authenticate with certain
> networks, specifically networks with 256 bit keys, and repeatedly asks
> for the password. The kernel log repeats the following lines (id and
> bssid redacted):
> 
>     mwifiex_pcie 0000:01:00.0: info: trying to associate to '<id>' bssid <bssid>
>     mwifiex_pcie 0000:01:00.0: info: associated to bssid <bssid> successfully
>     mwifiex_pcie 0000:01:00.0: crypto keys added
>     mwifiex_pcie 0000:01:00.0: info: successfully disconnected from <bssid>: reason code 3
> 
> Tracking down this problem lead to the overflow check introduced by the
> aforementioned commit into mwifiex_ret_802_11_key_material_v2(). This
> check fails on networks with 256 bit keys due to the current storage
> size for AES keys in struct mwifiex_aes_param being only 128 bit.
> 
> To fix this issue, increase the storage size for AES keys to 256 bit.
> 
> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
> Reported-by: Kaloyan Nikolov <konik98@gmail.com>
> Tested-by: Kaloyan Nikolov <konik98@gmail.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/fw.h          | 2 +-
>  drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
> index 8047e307892e3..d9f8bdbc817b2 100644
> --- a/drivers/net/wireless/marvell/mwifiex/fw.h
> +++ b/drivers/net/wireless/marvell/mwifiex/fw.h
> @@ -954,7 +954,7 @@ struct mwifiex_tkip_param {
>  struct mwifiex_aes_param {
>  	u8 pn[WPA_PN_SIZE];
>  	__le16 key_len;
> -	u8 key[WLAN_KEY_LEN_CCMP];
> +	u8 key[WLAN_KEY_LEN_CCMP_256];
>  } __packed;
>  
>  struct mwifiex_wapi_param {
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> index 962d8bfe6f101..119ccacd1fcc4 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> @@ -619,7 +619,7 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
>  	key_v2 = &resp->params.key_material_v2;
>  
>  	len = le16_to_cpu(key_v2->key_param_set.key_params.aes.key_len);
> -	if (len > WLAN_KEY_LEN_CCMP)
> +	if (len > sizeof(key_v2->key_param_set.key_params.aes.key))
>  		return -EINVAL;
>  
>  	if (le16_to_cpu(key_v2->action) == HostCmd_ACT_GEN_SET) {
> @@ -635,7 +635,7 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
>  		return 0;
>  
>  	memset(priv->aes_key_v2.key_param_set.key_params.aes.key, 0,
> -	       WLAN_KEY_LEN_CCMP);
> +	       sizeof(key_v2->key_param_set.key_params.aes.key));
>  	priv->aes_key_v2.key_param_set.key_params.aes.key_len =
>  				cpu_to_le16(len);
>  	memcpy(priv->aes_key_v2.key_param_set.key_params.aes.key,

It's good to get the sizes correct.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

I sort of feel like the code was broken before I added the bounds
checking but it's also okay if the Fixes tag points to my change as
well just to make backporting easier.

Fixes: e18696786548 ("mwifiex: Prevent memory corruption handling keys")

Another question would be if it would be better to move the bounds
check after the "if (key_v2->key_param_set.key_type != KEY_TYPE_ID_AES)"
check?  Do we care if the length is invalid on the other paths?

regards,
dan carpenter
