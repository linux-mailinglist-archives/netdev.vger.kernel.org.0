Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB9D15E05
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 09:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfEGHUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 03:20:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55158 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfEGHUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 03:20:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x477IcRt038826;
        Tue, 7 May 2019 07:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=gh8GNwW8JqZ8l33L2MV69qCHnkHRZFobSuIcGq9lqV0=;
 b=venWrvI6fSC2eMSfNzb1Q926sV0muoBDKBR3ySVP26vVAExTIWIj/ycLzEF/EaE3pNqL
 Kfq4LuQOdvXOcoDZftZDcr0lWu6s/OXW8rcNEMRsKmFu10eq0A2RxcHPxQZRdurDnbia
 sPzFCWXBkxCEdOcC6XKjHzJ1D2SbnFHv/xZbTFrXUbYg5cOiXU58sj/Ktn1SoxWO7iWy
 TyBigWKovcvi3Y+0JxZWlgT42tTA6LSEL+W0cfC1OiqNHYlaHtIoc3HgPd5X5tcG8Tz0
 QgGlPbQzzMWdzyax7siw69SR2Upn40agESX8RjEOCJNMiJhXgPMHcaT7VDRTjO4RJjZ5 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2s94bfu2n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 07:19:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x477JQw8151924;
        Tue, 7 May 2019 07:19:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2s9ayeqf76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 07:19:34 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x477JP0j007791;
        Tue, 7 May 2019 07:19:25 GMT
Received: from kadam (/105.53.239.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 May 2019 00:19:24 -0700
Date:   Tue, 7 May 2019 10:19:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        devel@driverdev.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 0/4] of_get_mac_address ERR_PTR fixes
Message-ID: <20190507071914.GJ2269@kadam>
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557177887-30446-1-git-send-email-ynezz@true.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905070048
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905070048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 11:24:43PM +0200, Petr Štetiar wrote:
> Hi,
> 
> this patch series is an attempt to fix the mess, I've somehow managed to
> introduce.
> 
> First patch in this series is defacto v5 of the previous 05/10 patch in the
> series, but since the v4 of this 05/10 patch wasn't picked up by the
> patchwork for some unknown reason, this patch wasn't applied with the other
> 9 patches in the series, so I'm resending it as a separate patch of this
> fixup series again.

I feel sort of ridiculous asking this over and over...  Maybe your spam
filter is eating my emails?

This bug was introduced in https://patchwork.ozlabs.org/patch/1094916/
"[v4,01/10] of_net: add NVMEM support to of_get_mac_address" but it
looks like no one applied it.

You're acting as if it *was* applied but you refuse to answer my
question who applied it and which to which tree so I can figure out what
went wrong.

I only see comments from last Friday that it shouldn't be applied...  I
also told you on Friday in a different thread that that patch shouldn't
be applied.  Breaking git bisect is a bug, and we never do that.  I'm
just very confused right now...  What I'm trying to do is figure out in
my head how this process failed so we can do better next time.

regards,
dan carpenter

