Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D40117952
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 14:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbfEHMWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 08:22:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46886 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfEHMWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 08:22:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48CJBEV086953;
        Wed, 8 May 2019 12:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Vy0vJPC+R/qK4BTy9W8k2EK+1DkuBwwYmX4Im7RV/1I=;
 b=rwrtMH5vFY76MnriFuwWJRty7cv6d48ndLvoH9qa0iSpe18cQhaRn84K+EEAZ1el4f/y
 JYXzNPHiRG6Um3c2LeXmrh0vIUgokB68rrApoaQDWIhQiq3xdWk5gSEBW5t2CsNm+NQD
 vMj6o0elaMb6F0MU58KC4FWtRSn89CRe22TBfRL7zCGITD8/HSnJoDvmL6xh8b//HGVN
 0/+i+9yb5Er16ot7xGaUWYdgVLnSKYTBDh5U+VgaaiAGanyy3YqtlO3+pRPaxxQxAHqK
 Taf9LSC6aD/fmeyve7zi016PT3fCR2HgfwqDVjH/4iBaBbfLBHPj+ptzQwZZXQN8uHEa Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2s94b63etg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 12:20:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48CJL8V107697;
        Wed, 8 May 2019 12:20:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2s94ag20en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 12:20:30 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x48CKNew007185;
        Wed, 8 May 2019 12:20:24 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 May 2019 05:20:22 -0700
Date:   Wed, 8 May 2019 15:20:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, alsa-devel@alsa-project.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH 09/16] mmc: sdhci-xenon: use new match_string()
 helper/macro
Message-ID: <20190508122010.GC21059@kadam>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190508112842.11654-11-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508112842.11654-11-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=644
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905080079
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=665 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905080079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 02:28:35PM +0300, Alexandru Ardelean wrote:
> -static const char * const phy_types[] = {
> -	"emmc 5.0 phy",
> -	"emmc 5.1 phy"
> -};
> -
>  enum xenon_phy_type_enum {
>  	EMMC_5_0_PHY,
>  	EMMC_5_1_PHY,
>  	NR_PHY_TYPES

There is no need for NR_PHY_TYPES now so you could remove that as well.

regards,
dan carpenter

