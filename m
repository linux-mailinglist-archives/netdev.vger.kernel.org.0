Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864D36D912C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbjDFIHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbjDFIHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:07:48 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071346592;
        Thu,  6 Apr 2023 01:07:43 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3366DHAE013854;
        Thu, 6 Apr 2023 08:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=jJZpK+4LUoxPvabfOSLEoyNinN7S5mTg5CwsNL84xjw=;
 b=kjMe/+F1hIyFVsZ4CQ4oUcT4396yvvvQOup5kUw2Fuspq+FctwzusRsKtVLHnHymHIJO
 mPA3TrUFWzxnMVXV+nSNnVw1QQa9B4I49rKmlChHrWG8pqjf/Dr5s1oV1/xHWW0oSIMH
 N0Gpz1K5dcGIMZugzk9FggIXLjgDci5HLOCjbbdhpUPXtx7Ur17wwiLlrDtTUAn73YkC
 S+M4bQ4fYqq9dMLDkfGuUK/bcY/JrOGPCy6zSPF2tn4Xs+O+4cRYJqghvPQ5RSVi0UJL
 FqsdsEnXIk7yCyBqb1C7KW+87K9+nKac+QyFR94xFH++zdW8kHVDBF7MxOVB8P6v/8oN Tg== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3psmyx0nmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 08:07:30 +0000
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.45.79.139])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33687TA3003418
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Apr 2023 08:07:29 GMT
Received: from [10.216.2.94] (10.80.80.8) by nasanex01c.na.qualcomm.com
 (10.45.79.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Thu, 6 Apr 2023
 01:07:25 -0700
Message-ID: <62fb952e-ffb9-763c-4e4b-4601c017ad26@quicinc.com>
Date:   Thu, 6 Apr 2023 13:37:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: qrtr: correct types of trace event
 parameters
Content-Language: en-US
To:     Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Manivannan Sadhasivam <mani@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20230402-qrtr-trace-types-v1-1-92ad55008dd3@kernel.org>
From:   Mukesh Ojha <quic_mojha@quicinc.com>
In-Reply-To: <20230402-qrtr-trace-types-v1-1-92ad55008dd3@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: h48KRiHCC5-6Cb2kepEKb3Fo2hcERqYP
X-Proofpoint-ORIG-GUID: h48KRiHCC5-6Cb2kepEKb3Fo2hcERqYP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_03,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 adultscore=0 clxscore=1011 mlxlogscore=999
 bulkscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304060071
X-Spam-Status: No, score=-2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/3/2023 9:13 PM, Simon Horman wrote:
> The arguments passed to the trace events are of type unsigned int,
> however the signature of the events used __le32 parameters.
> 
> I may be missing the point here, but sparse flagged this and it
> does seem incorrect to me.
> 
>    net/qrtr/ns.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/qrtr.h):
>    ./include/trace/events/qrtr.h:11:1: warning: cast to restricted __le32
>    ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
>    ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
>    ... (a lot more similar warnings)
>    net/qrtr/ns.c:115:47:    expected restricted __le32 [usertype] service
>    net/qrtr/ns.c:115:47:    got unsigned int service
>    net/qrtr/ns.c:115:61: warning: incorrect type in argument 2 (different base types)
>    ... (a lot more similar warnings)
> 
> Fixes: dfddb54043f0 ("net: qrtr: Add tracepoint support")
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
> v1
> * Drop RFC designation
> * Add Fixes and Reviewed-by tags
> * Target at 'net-next' (not sure if that is correct)
> 
> RFC
> * Link: https://lore.kernel.org/r/20230402-qrtr-trace-types-v1-1-da062d368e74@kernel.org
> ---
>   include/trace/events/qrtr.h | 33 ++++++++++++++++++---------------
>   1 file changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/include/trace/events/qrtr.h b/include/trace/events/qrtr.h
> index b1de14c3bb93..441132c67133 100644
> --- a/include/trace/events/qrtr.h
> +++ b/include/trace/events/qrtr.h
> @@ -10,15 +10,16 @@
>   
>   TRACE_EVENT(qrtr_ns_service_announce_new,
>   
> -	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
> +	TP_PROTO(unsigned int service, unsigned int instance,
> +		 unsigned int node, unsigned int port),
>   
>   	TP_ARGS(service, instance, node, port),
>   
>   	TP_STRUCT__entry(
> -		__field(__le32, service)
> -		__field(__le32, instance)
> -		__field(__le32, node)
> -		__field(__le32, port)
> +		__field(unsigned int, service)
> +		__field(unsigned int, instance)
> +		__field(unsigned int, node)
> +		__field(unsigned int, port)
>   	),
>   
>   	TP_fast_assign(
> @@ -36,15 +37,16 @@ TRACE_EVENT(qrtr_ns_service_announce_new,
>   
>   TRACE_EVENT(qrtr_ns_service_announce_del,
>   
> -	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
> +	TP_PROTO(unsigned int service, unsigned int instance,
> +		 unsigned int node, unsigned int port),
>   
>   	TP_ARGS(service, instance, node, port),
>   
>   	TP_STRUCT__entry(
> -		__field(__le32, service)
> -		__field(__le32, instance)
> -		__field(__le32, node)
> -		__field(__le32, port)
> +		__field(unsigned int, service)
> +		__field(unsigned int, instance)
> +		__field(unsigned int, node)
> +		__field(unsigned int, port)
>   	),
>   
>   	TP_fast_assign(
> @@ -62,15 +64,16 @@ TRACE_EVENT(qrtr_ns_service_announce_del,
>   
>   TRACE_EVENT(qrtr_ns_server_add,
>   
> -	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
> +	TP_PROTO(unsigned int service, unsigned int instance,
> +		 unsigned int node, unsigned int port),
>   
>   	TP_ARGS(service, instance, node, port),
>   
>   	TP_STRUCT__entry(
> -		__field(__le32, service)
> -		__field(__le32, instance)
> -		__field(__le32, node)
> -		__field(__le32, port)
> +		__field(unsigned int, service)
> +		__field(unsigned int, instance)
> +		__field(unsigned int, node)
> +		__field(unsigned int, port)

Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

-- Mukesh

>   	),
>   
>   	TP_fast_assign(
> 
