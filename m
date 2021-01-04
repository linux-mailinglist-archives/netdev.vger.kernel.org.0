Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60682E950D
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 13:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbhADMkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 07:40:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53710 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbhADMkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 07:40:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104CTEac009645;
        Mon, 4 Jan 2021 12:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=311J7ExI17gI4E01/u3Bz6RjSFkpttIOT+rLdcKkQwc=;
 b=qD2/elOPYPjjaJhRBlc7+Kl0h8NbOaq5OPsLAWyn65Ah0259MVmBDfqn3CUPGT3Eb3Eq
 ewE8KyAyR98grt1w91m5JJmBJjPwtxJmNNWrasHTo0eCOSRSH2Pi1/DFjzxiDkHL9FH2
 xT9bViZ5o/wtDJ9CPcnhXkJAT46/nx9owxfGWLOXVWWYTLuKfpnRMCwpCpnV5rZABbpn
 IadSuKkVDjZQFzeiyWsd0EwAYl8eGGsK/3NgpORs5vIPoXNHFPaiMgBnirjFU2TfN4Go
 FRkj8BRbzb6Cey5FsA3Rg1jTx6+GGuk0UgkB1X5uY+sRR50jtY9oYF+UxfgvDvmG5Kl7 IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35tgskm2ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 12:39:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104CW9gW017461;
        Mon, 4 Jan 2021 12:39:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35uxnr2xp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 12:39:29 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 104CdSn7026032;
        Mon, 4 Jan 2021 12:39:28 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 04:39:27 -0800
Date:   Mon, 4 Jan 2021 15:38:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v3 09/24] wfx: add hwio.c/hwio.h
Message-ID: <20210104123857.GO2809@kadam>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
 <87lfdp98rw.fsf@codeaurora.org>
 <X+IQRct0Zsm87H4+@kroah.com>
 <4279510.LvFx2qVVIh@pc-42>
 <20210104123410.GN2809@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104123410.GN2809@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9853 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9853 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Of course, Smatch didn't trigger any warnings in the wfx driver.  I need
to try re-write this check to use the cross function database so
function pointers are handled.

regards,
dan carpenter

