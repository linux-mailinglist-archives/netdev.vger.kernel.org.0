Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861A02B0FCE
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgKLVJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:09:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgKLVJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 16:09:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACKxMal039461;
        Thu, 12 Nov 2020 21:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=H8qmn33DAOyPUU+UPzakrJmRS2/H4caDjOFFiP09JEg=;
 b=n1B38Z0KhmS0xy/IRr/Mg74SnR3iBCdsCg0NGiBa4pc4ohJhJp5fDtflOPuMLlE3UiuO
 JXwLD64YpU5Mcs/PhUOe3U6y1HVnHHAeUpcOAVWgI7qZdLf6j+dBvPtD9lRXdsHceUNb
 atptN2kMHyXMA/sZf59fHkwjLuANxY5XxGXgU5COD24wB2MJ5VFqmvye34Jd+Vjo1N2F
 FrVL8SA8X7+O/ue1k2AP8v1ZZ1rAGKvMUcBqCZ+SntKN0cC7YEG9S5duHTIBJMfhpTf1
 zYGtqTCiRqfFvHPQfc95AOaSVZMEaYk8coAWTiqr6W1b9JAJCwBEaph07h5TUPv2w5ue 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72ewuw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 21:09:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACL12w9064044;
        Thu, 12 Nov 2020 21:09:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34p5g3nv78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 21:09:34 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ACL9X5c018877;
        Thu, 12 Nov 2020 21:09:33 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 13:09:33 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20201112210747.GK9243@fieldses.org>
Date:   Thu, 12 Nov 2020 16:09:32 -0500
Cc:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-afs@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <7BD0DE04-7D80-4C0B-AF59-3588762A0EFC@oracle.com>
References: <22138FE2-9E79-4E24-99FC-74A35651B0C1@oracle.com>
 <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <2380561.1605195776@warthog.procyon.org.uk>
 <2422487.1605200046@warthog.procyon.org.uk>
 <20201112210747.GK9243@fieldses.org>
To:     Bruce Fields <bfields@fieldses.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=932 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=950 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 4:07 PM, Bruce Fields <bfields@fieldses.org> wrote:
> 
> On Thu, Nov 12, 2020 at 04:54:06PM +0000, David Howells wrote:
>> Chuck Lever <chuck.lever@oracle.com> wrote:
>> 
>>> Really? My understanding of the Linux kernel SUNRPC implementation is
>>> that it uses asynchronous, even for small data items. Maybe I'm using
>>> the terminology incorrectly.
>> 
>> Seems to be synchronous, at least in its use of skcipher:
> 
> Yes, it's all synchronous.  The only cases where we defer and revisit a
> request is when we need to do upcalls to userspace.
> 
> (And those upcalls mostly come after we're done with unwrapping and
> verifying a request, so now I'm sort of curious exactly what Chuck was
> seeing.)

I vaguely recall that setting CRYPTO_TFM_REQ_MAY_SLEEP allows the
crypto API to sleep and defer completion.


--
Chuck Lever



