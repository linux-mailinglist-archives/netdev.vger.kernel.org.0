Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2329A183319
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 15:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgCLOaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 10:30:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgCLOaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 10:30:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEOXTS128041;
        Thu, 12 Mar 2020 14:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=e+tMMkMgf3MCOE4jrlZHK/XcEXUQhd/9T6GE0jTowew=;
 b=o8Alk+mrQWZE8S7fatgSRg4N395IURruMp/rnqUbD7lN7gw14Tp2R/fiFPyhlFtpa2dB
 6v4Tgi3LzhY9ChxapZjjrBvOaWcf25Qlx0pN3gO4+M8NgMzBARbLPU+vqX7PA5VdEC7m
 6nylhNiI1dNn2kbYNekgTqhHw7Ve5nooMcPt9q2Wz91nsgm3l1/3WvQjHytIDDxewpiQ
 5mdJfypHevWQfS+uiUA8fsB0xHoSo6rB/R2dzcl2HBGca8u1v0SjmUDos6zjDMJ9cs1n
 c5iHKGShTRppZY4fyo6AexU32EIPKPqGBRkew/EazuI4yta+ou30cZ6bw/uUVcr1Elwg BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ym31uswt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:30:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEM679063104;
        Thu, 12 Mar 2020 14:30:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2yqgvd1pgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:30:26 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CEUPjE018237;
        Thu, 12 Mar 2020 14:30:25 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 07:30:24 -0700
Date:   Thu, 12 Mar 2020 17:30:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 3/5] staging: wfx: make warning about pending frame less
 scary
Message-ID: <20200312143019.GN11561@kadam>
References: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
 <20200310101356.182818-4-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200310101356.182818-4-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 11:13:54AM +0100, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Removing station while some traffic is in progress may happen.
> 

You're doing this in every commit where you start the commit message in
the subject and then just keep writing.  Take a look at your patch in
this URL.  Try to find the subject.

https://marc.info/?l=linux-driver-devel&m=158383526527951&w=2

The subject is far separated from the body of the commit message.  I
normally read the patch first, then I read the commit message and I
don't read the subject at all.  Or sometimes I only read the subject.

https://www.designershumor.com/2019/09/30/you-will-read-this-first-meme/

So it really helps me if the commit message restates the subject.  The
truth is that I don't really even like the advice that Josh wrote in
the howto about patch descriptions.  I normally start by explaining the
problem then how I solved it.  But I try not to be a pedant, so long as
I can understand the problem and the patch that's fine.  So how I would
write this commit message is:

    The warning message about releasing a station while Tx is in
    progress will trigger a stack trace, possibly a reboot depending
    on the configuration, and a syzbot email.  It's not necessarily
    a big deal that transmission is still in process so let's make the
    warning less scary.

> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/sta.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> index 03d0f224ffdb..010e13bcd33e 100644
> --- a/drivers/staging/wfx/sta.c
> +++ b/drivers/staging/wfx/sta.c
> @@ -605,7 +605,9 @@ int wfx_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(sta_priv->buffered); i++)
> -		WARN(sta_priv->buffered[i], "release station while Tx is in progress");
> +		if (sta_priv->buffered[i])
> +			dev_warn(wvif->wdev->dev, "release station while %d pending frame on queue %d",
> +				 sta_priv->buffered[i], i);

Why print a warning message at all if this is a normal situation?  Just
delete the whole thing.

regards,
dan carpenter

