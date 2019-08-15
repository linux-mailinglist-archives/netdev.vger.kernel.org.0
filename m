Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACE78F6C6
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 00:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732747AbfHOWGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 18:06:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49750 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731599AbfHOWGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 18:06:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FM3VCk094140;
        Thu, 15 Aug 2019 22:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=grnXFtqO9q0UoP/PmJExNPh9Y4n2KrY3SsAsTHF9hdY=;
 b=e1BFTcjW9s3nrydozJKI6md2XYVyun65H0oO0jDGJrvyNC7dJG93jcOF5lsXaq03r+x2
 hMR0Hs/dseuIkeC6dvOXAZLQTZniyywRZlONE5XdCevEvxomHiQd+Zby3ZNlEurH+WRc
 vfV2R7UspJsT4pqLRUi/apDu0buDq0AvDg9t4P3q5RcqHxqQ+i9GWs2hzQkL9k/Dkxyp
 j9jAcLon9xmdLwn9WFOq+UUQXvExqtJ/k67SJEQn/vmj7RgxP+1tKyeH+XX2doR6JYsd
 XFAsTVuypgtYfqWh5eOkaSwgW3edCaXHOKhoOJhltU6UCWxU4//8S1Fv07J7RDnH0GVB UQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjqw851-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 22:06:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FM3WSk195485;
        Thu, 15 Aug 2019 22:06:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ucs88drwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 22:06:10 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7FM68TO019521;
        Thu, 15 Aug 2019 22:06:08 GMT
Received: from [10.211.55.26] (/10.211.55.26)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 15:06:08 -0700
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Chris Mason <clm@fb.com>,
        andy@groveronline.com
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Grover <andy.grover@oracle.com>,
        Chris Mason <chris.mason@oracle.com>
References: <20190816075312.64959223@canb.auug.org.au>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <8fd20efa-8e3d-eca2-8adf-897428a2f9ad@oracle.com>
Date:   Thu, 15 Aug 2019 15:06:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816075312.64959223@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908150207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Just added the e-mail addresses I found using a simple "google search",
in order to reach out to the original authors of these commits:
Chris Mason and Andy Grover.

I'm hoping they still remember their work from 7-8 years ago.

Thanks,

  Gerd

On 15/08/2019 14.53, Stephen Rothwell wrote:
> Hi all,
> 
> Commits
> 
>   11740ef44829 ("rds: check for excessive looping in rds_send_xmit")
>   65dedd7fe1f2 ("RDS: limit the number of times we loop in rds_send_xmit")
> 
> are missing a Signed-off-by from their authors.
> 
