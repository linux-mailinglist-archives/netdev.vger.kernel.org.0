Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1E36E8CC
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 12:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbhD2KdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 06:33:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48482 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbhD2KdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 06:33:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TANiqD037446;
        Thu, 29 Apr 2021 10:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=107xJILZ/k3vJceB87TBegFi0U6lLFQ35yB8nmmNbSM=;
 b=vXB3z3UCrHexzBve64hdefEitFT9HVa9/y+2Pm0wjajsB7vIFPANdgeRxQKsbhSfHCYs
 ME6um/dw8xYoFD8e2fbjUMvIxBg/r5l97nUzpMnx7PWVAIfbi4/R4JIDBSOOOEY36hdg
 JmIgZBOVZu/RqSC3I2ncWRVe/p8mC7sT+tBaD0lwaz+DYjFXiP2vLozQ04YxLWBPn9HA
 0HXFNyOecRU+g9pDmnQal2D7XfeE2ViyEBTpV1ehLgbBztXoeKm5D64o7DHWFkiWIWKr
 93+uGu+rMkaYxYOG0G3i81QUXGG2fOA+3Akv0Xql592+MT9dbg7z49iHvGF1qj6ZUedN 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 385ahbuw3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 10:32:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TAQe8w064375;
        Thu, 29 Apr 2021 10:32:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 384w3w2msg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 10:32:12 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13TAWBFL088524;
        Thu, 29 Apr 2021 10:32:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 384w3w2mrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 10:32:11 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13TAW7U4021477;
        Thu, 29 Apr 2021 10:32:07 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Apr 2021 03:32:07 -0700
Date:   Thu, 29 Apr 2021 13:31:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
Message-ID: <20210429103158.GA1981@kadam>
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
 <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
 <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
 <1032428026.331.1618814178946.JavaMail.www@wwinf2229>
 <40c21bfe-e304-230d-b319-b98063347b8b@acm.org>
 <20210422122419.GF2047089@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210422122419.GF2047089@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: vMjc6YA3PuELYm8M01byc768l2ZGob5M
X-Proofpoint-ORIG-GUID: vMjc6YA3PuELYm8M01byc768l2ZGob5M
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 09:24:19AM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 19, 2021 at 01:02:34PM -0700, Bart Van Assche wrote:
> > On 4/18/21 11:36 PM, Marion et Christophe JAILLET wrote:
> > > The list in To: is the one given by get_maintainer.pl. Usualy, I only
> > > put the ML in Cc: I've run the script on the 2 patches of the serie
> > > and merged the 2 lists. Everyone is in the To: of the cover letter
> > > and of the 2 patches.
> > > 
> > > If Théo is "Tejun Heo" (  (maintainer:WORKQUEUE) ), he is already in
> > > the To: line.
> > Linus wants to see a "Cc: ${maintainer}" tag in patches that he receives
> > from a maintainer and that modify another subsystem than the subsystem
> > maintained by that maintainer.
> 
> Really? Do you remember a lore link for this?
> 
> Generally I've been junking the CC lines (vs Andrew at the other
> extreme that often has 10's of CC lines)

Of course this patch has already been NAKed but it wasn't clear to me
whose git tree it would have gone through.  Surely if it were going
through your tree you would have required an Acked-by: from Tejun and
the CC: line would not be required.  It would only be required if you
can't get a maintainer to respond.

regards,
dan carpenter

