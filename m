Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E076A5F47
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 04:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfICCV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 22:21:59 -0400
Received: from gateway31.websitewelcome.com ([192.185.143.234]:13065 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfICCV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 22:21:59 -0400
X-Greylist: delayed 1424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Sep 2019 22:21:58 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id E2DED67403
        for <netdev@vger.kernel.org>; Mon,  2 Sep 2019 20:58:13 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 4y5FisNWPdnCe4y5FiFCvP; Mon, 02 Sep 2019 20:58:13 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:Subject:From:References:To:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OEAz39q2GeHlD9LzyBMugnKZMP5SY59IjdAukdRjj6Q=; b=OoA1vQRuY0mK/LzecDKaoPNawd
        o1+xfBKRP8WNmW7i3ou1IATWDNQK9HtlM2XfZuom7RRB/0Q6IzqObRwkSFy1a+Dk5PHDisWzhD1r0
        n5AA1u2ZoDnELOYVDfhS2jFlVS3vjXVJMEcsqTFshqpIljFhSB7iwLZUJPdJcIeukybRMdaw/2oXU
        AadgaCxwYTMpSQCRiuPj/OAUJozsJkE2DLPgXgQMusXr5kSQV4U0PpCsxtaOFB3mLi2SguhbblqI7
        ISl2Db9YY9cWuL/bu12zZSZShi1b77E0ioqVvq3FYDgMdWIJLgGiRD/A4G7n05uvVB7GE8/uSbGe3
        HhWrUiGw==;
Received: from [189.152.216.116] (port=51256 helo=[192.168.43.131])
        by gator4166.hostgator.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1i4y5F-001U9x-GU; Mon, 02 Sep 2019 20:58:13 -0500
To:     Zhu Yanjun <yanjun.zhu@oracle.com>, santosh.shilimkar@oracle.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        gerd.rausch@oracle.com
References: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Openpgp: preference=signencrypt
Autocrypt: addr=gustavo@embeddedor.com; keydata=
 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
 VtSixD1uOgytAP7RWS474w==
Subject: Re: [PATCHv2 1/1] net: rds: add service level support in rds-info
Message-ID: <4422c894-4182-18ba-efa2-f86a1f14a3a6@embeddedor.com>
Date:   Mon, 2 Sep 2019 20:58:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.152.216.116
X-Source-L: No
X-Exim-ID: 1i4y5F-001U9x-GU
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.43.131]) [189.152.216.116]:51256
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 11
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 8/23/19 8:04 PM, Zhu Yanjun wrote:

[..]

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index ec05d91..45acab2 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -291,7 +291,7 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
>  				    void *buffer)
>  {
>  	struct rds_info_rdma_connection *iinfo = buffer;
> -	struct rds_ib_connection *ic;
> +	struct rds_ib_connection *ic = conn->c_transport_data;
>  
>  	/* We will only ever look at IB transports */
>  	if (conn->c_trans != &rds_ib_transport)
> @@ -301,15 +301,16 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
>  
>  	iinfo->src_addr = conn->c_laddr.s6_addr32[3];
>  	iinfo->dst_addr = conn->c_faddr.s6_addr32[3];
> -	iinfo->tos = conn->c_tos;
> +	if (ic) {

Is this null-check actually necessary? (see related comments below...)

> +		iinfo->tos = conn->c_tos;
> +		iinfo->sl = ic->i_sl;
> +	}
>  
>  	memset(&iinfo->src_gid, 0, sizeof(iinfo->src_gid));
>  	memset(&iinfo->dst_gid, 0, sizeof(iinfo->dst_gid));
>  	if (rds_conn_state(conn) == RDS_CONN_UP) {
>  		struct rds_ib_device *rds_ibdev;
>  
> -		ic = conn->c_transport_data;
> -
>  		rdma_read_gids(ic->i_cm_id, (union ib_gid *)&iinfo->src_gid,

Notice that *ic* is dereferenced here without null-checking it. More
comments below...

>  			       (union ib_gid *)&iinfo->dst_gid);
>  
> @@ -329,7 +330,7 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
>  				     void *buffer)
>  {
>  	struct rds6_info_rdma_connection *iinfo6 = buffer;
> -	struct rds_ib_connection *ic;
> +	struct rds_ib_connection *ic = conn->c_transport_data;
>  
>  	/* We will only ever look at IB transports */
>  	if (conn->c_trans != &rds_ib_transport)
> @@ -337,6 +338,10 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
>  
>  	iinfo6->src_addr = conn->c_laddr;
>  	iinfo6->dst_addr = conn->c_faddr;
> +	if (ic) {
> +		iinfo6->tos = conn->c_tos;
> +		iinfo6->sl = ic->i_sl;
> +	}
>  
>  	memset(&iinfo6->src_gid, 0, sizeof(iinfo6->src_gid));
>  	memset(&iinfo6->dst_gid, 0, sizeof(iinfo6->dst_gid));
> @@ -344,7 +349,6 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
>  	if (rds_conn_state(conn) == RDS_CONN_UP) {
>  		struct rds_ib_device *rds_ibdev;
>  
> -		ic = conn->c_transport_data;
>  		rdma_read_gids(ic->i_cm_id, (union ib_gid *)&iinfo6->src_gid,

Again, *ic* is being dereferenced here without a previous null-check.

>  			       (union ib_gid *)&iinfo6->dst_gid);
>  		rds_ibdev = ic->rds_ibdev;


--
Gustavo
