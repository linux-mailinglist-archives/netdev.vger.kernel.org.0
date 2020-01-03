Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288DD12F611
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 10:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgACJ2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 04:28:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgACJ2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 04:28:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0039OHtG168169;
        Fri, 3 Jan 2020 09:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=55Sdflq6CCBRAEIAmvKQYMAyn61XPUnwtABoljVNW78=;
 b=NkL5319kGrZJXDz1md0RsG7/t7Nmn1HzGWA9iHp2MwFynQqM0IIteKp8ZLJjPmUI5rcc
 LBDMBtwo/+nA36BAD+u+aPeDJOrXpv+hJU/0k7GcS36+oBxr4znYMciaddCqeyzKX+Yg
 55JN46+eaArqhR/8m7hUMafbG5PxofcGJXfPP9zEkzWxEjaL/xwZiUMAJnxCHusHRNJ9
 A0yCPlzfM/DSktZS1z77RS66ODJ3uBi2QlbLgxG2Bvzi+m/k5ywXN7njcIWYs3GiKoB7
 VHtNtSvlqbiC7hpTgI4YxB8JgWJaTnpIxjrz2BU9k6hcWdo/A7pE/8hGk9ZNQ5n1+VGx 1Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftuh5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 09:27:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0039ORRY177272;
        Fri, 3 Jan 2020 09:27:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x8guwd7a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 09:27:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0039RsGe005579;
        Fri, 3 Jan 2020 09:27:54 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 01:27:53 -0800
Date:   Fri, 3 Jan 2020 12:27:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 25/55] staging: wfx: fix name of struct
 hif_req_start_scan_alt
Message-ID: <20200103092744.GC3911@kadam>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
 <20191216170302.29543-26-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216170302.29543-26-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030089
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 05:03:46PM +0000, Jérôme Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> The original name did not make any sense.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/hif_api_cmd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wfx/hif_api_cmd.h b/drivers/staging/wfx/hif_api_cmd.h
> index 3e77fbe3d5ff..4ce3bb51cf04 100644
> --- a/drivers/staging/wfx/hif_api_cmd.h
> +++ b/drivers/staging/wfx/hif_api_cmd.h
> @@ -188,7 +188,7 @@ struct hif_req_start_scan {
>  	u8    ssid_and_channel_lists[];
>  } __packed;
>  
> -struct hif_start_scan_req_cstnbssid_body {
> +struct hif_req_start_scan_alt {
>  	u8    band;
>  	struct hif_scan_type scan_type;
>  	struct hif_scan_flags scan_flags;

Why not just delete this if it isn't used?

regards,
dan carpenter

