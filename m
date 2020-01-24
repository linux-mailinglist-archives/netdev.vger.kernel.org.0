Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4C1147A23
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgAXJMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:12:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47310 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729575AbgAXJMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 04:12:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O98DT2182359;
        Fri, 24 Jan 2020 09:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8kvAOtCW6dIcRl85xkPmD0Dw0YMEA5UV2a/Xwj5qbos=;
 b=inKXSq39uT760lyxFhb/Iry+4rta4FHzI3rIkFJcgT/MeedI6PSK1qTO/1NcQQpaDowL
 VATKdMYWVTUaisa5YAEfMwA34wOsys953dhWE+3P0liveF2CeUPxqj0sr1nyQunxV4tM
 MK165yZqnlxc9uH9cuHMPA23gDSrghP0tHn47SowU+99fWdeaTxdgTCROqW6ukFNFMW/
 UpQR2c9imJKMeestcI+xjhP1fGZQdJhjT0Y9UgDyaCyrAFIQXdO5CoGg42Ez/DWMACfA
 fXxmbcO4d64SId4SaWbd8i99Tg8GXruXsjVdFJ6QtL2fr4fqdpQWbWUsyEnHSWseB0Cv JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyqqrbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 09:12:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O99IWp113807;
        Fri, 24 Jan 2020 09:12:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xqmwdtx51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 09:12:04 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O9Bs73023462;
        Fri, 24 Jan 2020 09:11:54 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jan 2020 01:11:53 -0800
Date:   Fri, 24 Jan 2020 12:11:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+b96275fd6ad891076ced@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_port_destroy
Message-ID: <20200124091144.GK1847@kadam>
References: <20200124085521.12504-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124085521.12504-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 04:55:21PM +0800, Hillf Danton wrote:
> Ensure four bytes and ask slab to do the rest.
> 
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -430,7 +430,7 @@ ip6addrptr(const struct sk_buff *skb, bo
>  static inline int
>  bitmap_bytes(u32 a, u32 b)
>  {
> -	return 4 * ((((b - a + 8) / 8) + 3) / 4);
> +	return 4 + (b - a) / 8;
>  }
>  

Thanks, but this was already fixed by:

https://lore.kernel.org/netfilter-devel/alpine.DEB.2.20.2001192203200.18095@blackhole.kfki.hu/

regards,
dan carpenter

