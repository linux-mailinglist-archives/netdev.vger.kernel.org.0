Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAF83803B9
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 08:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhENGn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 02:43:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34480 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhENGn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 02:43:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14E6YOoF099508;
        Fri, 14 May 2021 06:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=W3bzDXFQz9uNtboSy9MOqtcKgs9HaV7u3/tDYCiwO4Q=;
 b=ltvYtpetURH5LgOwEsy9JdP2pjV4s5Nrr77NNoUB5VI/AynxbsXMoOUtJPYbSFLk7oVy
 SxUQxUXRUkIlKveoeepymWTL1fj8H5gGJUvdokjyeXUlj5K1Ip54+roqHMv0n6JXHMbx
 R6LbLlk7HO+sjguQBoqKJlXieyrRcn9uZ1ONNIyUk3UQr/NbVD9fCRNtW2fyIyoB5tPe
 Wx8QzetlrbaGLKrfXKLjNxx98SydPSVpSPf60gwFMmGg1DRJhJ5BVmtzyZlkqAo4oRow
 Bmvjpi2AwKSV3YhAoHfUgbec2cDmZstUvMyJGvFQuf60zRx+xoGlBbClVWQgVA7nBvib zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38gpndbgjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 06:41:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14E6Yral169895;
        Fri, 14 May 2021 06:41:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38gppdf8qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 06:41:57 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14E6fuHb006885;
        Fri, 14 May 2021 06:41:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 38gppdf8pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 06:41:56 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14E6frAd005036;
        Fri, 14 May 2021 06:41:54 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 May 2021 23:41:53 -0700
Date:   Fri, 14 May 2021 09:41:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        syzbot <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: Re: [syzbot] WARNING in rtl8152_probe
Message-ID: <20210514064138.GA1955@kadam>
References: <0000000000009df1b605c21ecca8@google.com>
 <7de0296584334229917504da50a0ac38@realtek.com>
 <20210513142552.GA967812@rowland.harvard.edu>
 <bde8fc1229ec41e99ec77f112cc5ee01@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bde8fc1229ec41e99ec77f112cc5ee01@realtek.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: 4eeQtsi33mKVbNsYlebxot3PEDmnux1c
X-Proofpoint-GUID: 4eeQtsi33mKVbNsYlebxot3PEDmnux1c
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9983 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105140048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 02:58:00AM +0000, Hayes Wang wrote:
> Alan Stern <stern@rowland.harvard.edu>
> > Sent: Thursday, May 13, 2021 10:26 PM
> [...]
> > Syzbot doesn't test real devices.  It tests emulations, and the emulated
> > devices usually behave very strangely and in very peculiar and
> > unexpected ways, so as to trigger bugs in the kernel.  That's why the
> > USB devices you see in syzbot logs usually have bizarre descriptors.
> 
> Do you mean I have to debug for a device which doesn't exist?
> I don't understand why I must consider a fake device
> which provide unexpected USB descriptor deliberately?

Imagine you are at a conference and two people sit down next to you, one
on either side.  The one accidentally spills coffee on your lap.  The
other plugs in a USB device to your laptop.  Now you are infected with
spyware.

https://elie.net/blog/security/what-are-malicious-usb-keys-and-how-to-create-a-realistic-one/

regards,
dan carpenter

