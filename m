Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460818C419
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 00:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfHMWJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 18:09:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58692 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfHMWJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 18:09:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DM9Kns083285;
        Tue, 13 Aug 2019 22:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=E5n9qqcxNJyeJ5Ga7pq0bv2ywnLC/5EpwlymN9lg0E4=;
 b=rhbpASWL0VjnkvkQju+VnzVEyryf5zeZ/PW4FvilL761DwyEaOoBf7mgA0EATDEOj6jS
 Iq7CNsjUz4a6N4rM0lmSF2jzhvZT8n+YgS4+28A593TWLmBoE2PP9uCZnuvKoeOpZ0Es
 wjVynHV19gLRomLCJSmR5n7KagNONCKwerupSWllVjyx6iOMDnOBfwgWsTNKkhWpO9Qb
 /dogdZFvk0MCfX7U3y1YwqOxt/xlo4yIwaQ7alRCD1QKXgeK4PJw7lV1WT01pNcyxW6A
 oSkPLyG+Yl7rc8H5ADzK73Du/9rp0qX3P/6LxgdrBZHxjsK13R/Fgc3xMQm1T6ZBNwkR aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbth3h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:09:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DM9GqX169365;
        Tue, 13 Aug 2019 22:09:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ubwrrv89s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 22:09:19 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DM9ITQ169631;
        Tue, 13 Aug 2019 22:09:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ubwrrv868-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:09:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DM97b6011462;
        Tue, 13 Aug 2019 22:09:07 GMT
Received: from [10.209.243.59] (/10.209.243.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 15:09:07 -0700
Subject: Re: [PATCH net-next 4/5] net/rds: Add a few missing rds_stat_names
 entries
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <9a93fcf5-720c-a771-0329-312a1499eda1@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <58326c0a-71cc-0e18-13ae-b47b369162e8@oracle.com>
Date:   Tue, 13 Aug 2019 15:09:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <9a93fcf5-720c-a771-0329-312a1499eda1@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 11:21 AM, Gerd Rausch wrote:
> Date: Thu, 11 Jul 2019 12:15:50 -0700
> 
> In a previous commit, fields were added to "struct rds_statistics"
> but array "rds_stat_names" was not updated accordingly.
> 
> Please note the inconsistent naming of the string representations
> that is done in the name of compatibility
> with the Oracle internal code-base.
> 
> s_recv_bytes_added_to_socket     -> "recv_bytes_added_to_sock"
> s_recv_bytes_removed_from_socket -> "recv_bytes_freed_fromsock"
> 
> Fixes: 192a798f5299 ("RDS: add stat for socket recv memory usage")
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar<santosh.shilimkar@oracle.com>

