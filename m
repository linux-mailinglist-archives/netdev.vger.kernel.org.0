Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EDF144B81
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 06:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVFyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 00:54:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgAVFyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 00:54:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M5rvl1087261;
        Wed, 22 Jan 2020 05:53:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=e6pHO7NEB3W4WnE5j5+BYXSgYe4ZpmpURv9HvAXPRpU=;
 b=o5rFThfoiO98VhbQP3sPOxizJ0igXge2GQs5zmrRgcvg4+JcSuI6yG/s/yMrZzu+Alaa
 /mEkCbb5bOGV1k3inEoZW9ZL2322bUgXxgGIh4LLedo1jB7Sh9shraXlFyGk7ZDIgsB4
 1Yq1aTM1RfecFlhXA200lNA0CYyIdE3BtI+Tmmy2hNTo1Zq8mltiXR6YAw2WUIV6pflM
 mETKqkQdhUToY5clAokaWsSmp7g+69t3FzWOP7BL8X/JK7uGD48RiqcO9Bk3B4/g67uk
 rCi0fce4O3hftP64FV8GvBwJvig1dRLKpWVRk4zKvrcNxWtWve+g7V50+Kb8dlFlMRTB YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyq9fp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 05:53:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M5n6fP170077;
        Wed, 22 Jan 2020 05:53:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xnpejpf0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 05:53:23 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00M5rMD1006144;
        Wed, 22 Jan 2020 05:53:22 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 21:53:22 -0800
Date:   Wed, 22 Jan 2020 08:53:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     syzbot <syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in tracing_func_proto
Message-ID: <20200122055314.GD1847@kadam>
References: <0000000000001b2259059c654421@google.com>
 <20200121180255.1c98b54c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121180255.1c98b54c@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220052
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 06:02:55PM -0500, Steven Rostedt wrote:
> On Fri, 17 Jan 2020 23:47:11 -0800
> syzbot <syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    428cd523 sfc/ethtool_common: Make some function to static
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10483421e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
> > dashboard link: https://syzkaller.appspot.com/bug?extid=0c147ca7bd4352547635
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > 
> > Unfortunately, I don't have any reproducer for this crash yet.
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > Could not allocate percpu trace_printk buffer
> > WARNING: CPU: 1 PID: 11733 at kernel/trace/trace.c:3112 alloc_percpu_trace_buffer kernel/trace/trace.c:3112 [inline]
> > WARNING: CPU: 1 PID: 11733 at kernel/trace/trace.c:3112 trace_printk_init_buffers+0x5b/0x60 kernel/trace/trace.c:3126
> > Kernel panic - not syncing: panic_on_warn set ...
> 
> So it failed to allocate memory for the buffer (must be running low on
> memory, or allocated a really big buffer?), and that triggered a
> warning. As you have "panic_on_warn" set, the warning triggered the
> panic.
> 
> The only solution to this that I can see is to remove the WARN_ON and
> replace it with a pr_warn() message. There's a lot of WARN_ON()s in the
> kernel that need this conversion too, and I will postpone this change
> to that effort.
> 

I bet the syzbot folk have changed to lot of WARN_ON()s.  Maybe they
just comment them out on their local tree?

regards,
dan carpenter
