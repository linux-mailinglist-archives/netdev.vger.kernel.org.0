Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C21B1EA827
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 19:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgFARIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 13:08:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41674 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFARIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 13:08:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051H8Nop021991;
        Mon, 1 Jun 2020 17:08:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rW/vixdOKIhDeBp+EUAywPZVYPFaGU5tDxCG/HyrZlg=;
 b=pFQ8ylCZx5wu+4rYuYO8C7JpfGpfC1mxrsO3SoO8kAueWMWJaorG3HjuzjRiXm77oygE
 oi722IkIVYONt9YRM+jqLuTUmM18e5JiVkKNPpRPMcgCoZitM6oMs7x9tNR3Eie/GL5d
 oIks4q2gAQXR+rDt+HWSCx2HG/3hHe+rocHwS+tJMKysstqrKestqVG4qVsN9zkX+X2k
 L5gmlG/GaNGLDJEGVTTFymNXXnixqrvQguIZxqzl8raXlxsN41Aky28Hr71CtjpidHv8
 H+u3yTVVi4i9LG5YY3LPkc2q+4HorE3FSNV3BGEIJeJt0QneY0sllgdsGfdSBgMVNkxa nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31bfekytcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 01 Jun 2020 17:08:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051H3FSt073584;
        Mon, 1 Jun 2020 17:08:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31c1dvtxa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jun 2020 17:08:46 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 051H8jTh011560;
        Mon, 1 Jun 2020 17:08:45 GMT
Received: from [10.159.235.19] (/10.159.235.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 10:08:45 -0700
Subject: Re: [PATCH net-next] rds: transport module should be auto loaded when
 transport is set
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
References: <20200527081742.25718-1-rao.shoaib@oracle.com>
 <20200531100833.GI66309@unreal>
From:   Rao Shoaib <rao.shoaib@oracle.com>
Message-ID: <c2631a65-c4f9-2913-8a24-08a2de5ac1d3@oracle.com>
Date:   Mon, 1 Jun 2020 10:08:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200531100833.GI66309@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006010126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1011
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006010127
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/31/20 3:08 AM, Leon Romanovsky wrote:
> On Wed, May 27, 2020 at 01:17:42AM -0700, rao.shoaib@oracle.com wrote:
>> From: Rao Shoaib <rao.shoaib@oracle.com>
>>
>> This enhancement auto loads transport module when the transport
>> is set via SO_RDS_TRANSPORT socket option.
>>
>> Orabug: 31032127
> I think that it is internal to Oracle and should not be in the commit
> message.
>
> Thanks

There are logs that have internals bug numbers mentioned in them. I do 
agree with you and will take the bug number out.

Thanks for the comment.

Shoaib

