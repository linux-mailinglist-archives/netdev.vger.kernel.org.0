Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3959A6483C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfGJOXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:23:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58094 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfGJOXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:23:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AE8ohT052124;
        Wed, 10 Jul 2019 14:23:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dtCx9kPKlWl7TVw9ZN9HgEFlVu9eDM2Gv2B8JAnylbk=;
 b=Hso+EbjS3NYIWtaYqmCa79dbrZrI8s44Qu5KnghqXB9NzGNPcoYZXEGdw74cEV5nCJpz
 ji+UYVDiNJ8Tw84dfTLHcmSj66slQ2JKWW9RtK8w2JAy03tVvn4kqhfCrQPZiN7DhRIe
 yYEfozGER6VDD113khNXE2kH3sz3DvzfyNEkt3aErLcCaB3S5YjA+3ZHBJ+DokZVm9wI
 9dlkdk2OEkR0EjOpxdknCjBBKmqFnYFjdk+PLDlqL4souYwftH7SsOyllNAJCC9y0Iav
 zuWqu1MGkqr4ITl0/iliuxktyrpohrloXfgMMRKmakXIbut8aS4ixTwukodpxCcGHCNC vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tjk2tthaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 14:23:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AENGhP175677;
        Wed, 10 Jul 2019 14:23:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tmmh3jm70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 14:23:26 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6AENPJW008275;
        Wed, 10 Jul 2019 14:23:25 GMT
Received: from [10.182.69.170] (/10.182.69.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jul 2019 07:23:25 -0700
Subject: Re: [net][PATCH 3/5] rds: Accept peer connection reject messages due
 to incompatible version
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, davem@davemloft.net
References: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
 <1562736764-31752-4-git-send-email-santosh.shilimkar@oracle.com>
From:   Yanjun Zhu <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <f945be07-cc11-75c5-7a0b-2953fc1a29e1@oracle.com>
Date:   Wed, 10 Jul 2019 22:24:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562736764-31752-4-git-send-email-santosh.shilimkar@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/10 13:32, Santosh Shilimkar wrote:
> From: Gerd Rausch <gerd.rausch@oracle.com>
>
> Prior to
> commit d021fabf525ff ("rds: rdma: add consumer reject")
>
> function "rds_rdma_cm_event_handler_cmn" would always honor a rejected
> connection attempt by issuing a "rds_conn_drop".
>
> The commit mentioned above added a "break", eliminating
> the "fallthrough" case and made the "rds_conn_drop" rather conditional:
>
> Now it only happens if a "consumer defined" reject (i.e. "rdma_reject")
> carries an integer-value of "1" inside "private_data":
>
>    if (!conn)
>      break;
>      err = (int *)rdma_consumer_reject_data(cm_id, event, &len);
>      if (!err || (err && ((*err) == RDS_RDMA_REJ_INCOMPAT))) {
>        pr_warn("RDS/RDMA: conn <%pI6c, %pI6c> rejected, dropping connection\n",
>                &conn->c_laddr, &conn->c_faddr);
>                conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
>                rds_conn_drop(conn);
>      }
>      rdsdebug("Connection rejected: %s\n",
>               rdma_reject_msg(cm_id, event->status));
>      break;
>      /* FALLTHROUGH */
> A number of issues are worth mentioning here:
>     #1) Previous versions of the RDS code simply rejected a connection
>         by calling "rdma_reject(cm_id, NULL, 0);"
>         So the value of the payload in "private_data" will not be "1",
>         but "0".
>
>     #2) Now the code has become dependent on host byte order and sizing.
>         If one peer is big-endian, the other is little-endian,
>         or there's a difference in sizeof(int) (e.g. ILP64 vs LP64),
>         the *err check does not work as intended.
>
>     #3) There is no check for "len" to see if the data behind *err is even valid.
>         Luckily, it appears that the "rdma_reject(cm_id, NULL, 0)" will always
>         carry 148 bytes of zeroized payload.
>         But that should probably not be relied upon here.
>
>     #4) With the added "break;",
>         we might as well drop the misleading "/* FALLTHROUGH */" comment.
>
> This commit does _not_ address issue #2, as the sender would have to
> agree on a byte order as well.
>
> Here is the sequence of messages in this observed error-scenario:
>     Host-A is pre-QoS changes (excluding the commit mentioned above)
>     Host-B is post-QoS changes (including the commit mentioned above)
>
>     #1 Host-B
>        issues a connection request via function "rds_conn_path_transition"
>        connection state transitions to "RDS_CONN_CONNECTING"
>
>     #2 Host-A
>        rejects the incompatible connection request (from #1)
>        It does so by calling "rdma_reject(cm_id, NULL, 0);"
>
>     #3 Host-B
>        receives an "RDMA_CM_EVENT_REJECTED" event (from #2)
>        But since the code is changed in the way described above,
>        it won't drop the connection here, simply because "*err == 0".
>
>     #4 Host-A
>        issues a connection request
>
>     #5 Host-B
>        receives an "RDMA_CM_EVENT_CONNECT_REQUEST" event
>        and ends up calling "rds_ib_cm_handle_connect".
>        But since the state is already in "RDS_CONN_CONNECTING"
>        (as of #1) it will end up issuing a "rdma_reject" without
>        dropping the connection:
>           if (rds_conn_state(conn) == RDS_CONN_CONNECTING) {
>               /* Wait and see - our connect may still be succeeding */
>               rds_ib_stats_inc(s_ib_connect_raced);
>           }
>           goto out;
>
>     #6 Host-A
>        receives an "RDMA_CM_EVENT_REJECTED" event (from #5),
>        drops the connection and tries again (goto #4) until it gives up.
>
> Tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Thanks

Zhu Yanjun

> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> ---
>   net/rds/rdma_transport.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index 46bce83..9db455d 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -112,7 +112,9 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>   		if (!conn)
>   			break;
>   		err = (int *)rdma_consumer_reject_data(cm_id, event, &len);
> -		if (!err || (err && ((*err) == RDS_RDMA_REJ_INCOMPAT))) {
> +		if (!err ||
> +		    (err && len >= sizeof(*err) &&
> +		     ((*err) <= RDS_RDMA_REJ_INCOMPAT))) {
>   			pr_warn("RDS/RDMA: conn <%pI6c, %pI6c> rejected, dropping connection\n",
>   				&conn->c_laddr, &conn->c_faddr);
>   			conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
> @@ -122,7 +124,6 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>   		rdsdebug("Connection rejected: %s\n",
>   			 rdma_reject_msg(cm_id, event->status));
>   		break;
> -		/* FALLTHROUGH */
>   	case RDMA_CM_EVENT_ADDR_ERROR:
>   	case RDMA_CM_EVENT_ROUTE_ERROR:
>   	case RDMA_CM_EVENT_CONNECT_ERROR:
