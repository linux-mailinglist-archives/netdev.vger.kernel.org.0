Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F87F14F6F8
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 08:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgBAHG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 02:06:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33582 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgBAHG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 02:06:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01174fQV018088;
        Sat, 1 Feb 2020 07:05:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=uiJGaMLFZVvXwZyroFZ4/qu4LRPqrTTslZdDJtxOnnk=;
 b=fEOh6n6Ra11M6uJ6U7XcI6bj+Z5xp2WpERWRq4za83Uf3cALH2z9LwXGSCw6iE4NvpJi
 EMzaYiBdI4yy2x2IZr+CjJPIx9iTGUVxVocd3XSKhKEmulR/gHWyDXYlGLr9dkaZ3Os9
 w2awzXDdhktG+YCwVdhbmy22jTytYPZ+cILQdLaDQWZ0yBFxe97B6EKy3C9KNRR/BFbH
 kM9fZQzdHq3pUAm5ofhuZpyYl0jKC2rSfKospkr8eR2e8MOddxfyMsFoWAbiG3EMg96u
 ARaAk8Ydzz2XqA0JSVmomZChSJwNFjKdqzzE3ckqyYtlEV8iQH0kMrFV+We+njGPocO/ Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xw0rtrkpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Feb 2020 07:05:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01174JBY179273;
        Sat, 1 Feb 2020 07:05:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xvxfg0xv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Feb 2020 07:05:59 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01175smg017720;
        Sat, 1 Feb 2020 07:05:57 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 Jan 2020 23:05:54 -0800
Date:   Sat, 1 Feb 2020 10:05:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Subject: Re: INFO: task hung in hashlimit_mt_check_common
Message-ID: <20200201070541.GJ1778@kadam>
References: <000000000000466b64059bcb3843@google.com>
 <20200126132352.8212-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126132352.8212-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9517 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=998
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002010049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9517 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002010049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I wonder if there is some automated way to accept test patches from the
mailing list.

regards,
dan carpenter

