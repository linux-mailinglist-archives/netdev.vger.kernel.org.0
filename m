Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0DC6D5AA4
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 10:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbjDDIU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 04:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbjDDIUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 04:20:23 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10DF1A4;
        Tue,  4 Apr 2023 01:20:22 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3345usVj014799;
        Tue, 4 Apr 2023 08:20:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=X3b5qJIOalorokOS7twAewMeNT3gtn3t8Ss3x3cQbCI=;
 b=dcYu+YeXALGc4IXslie6D1Tb0e/70WP9UtTO0hnWEaacdD9ORIewfoz9Jo3yLhVIoVNx
 4q8BonxC9msmCKa2nBUq75OCFnMogGj1cVwpiUi1OSjqoDA0s/wMaQ1K9HdG087yJGjO
 0oHjqcbYh5tzlIRBc9MzlVKCxqJ93Ujsbf7o5wwDYlea6OwlqM5LkqZQzO2TXBptmDBO
 B3DGE8JkOlVAXo6mw3SMWcjhLgXLIdr5DaLpGGQTtshDl8pE5Z2rAkVQ3H0Wtj64LtKn
 +AYJGcz6YOmRNJNcD5wXFS2yLhOCJjHhFfxj/PZEp+nyPFUCCHDZBaRQZ2QETaRwwAWW WA== 
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pqw36tr9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:20:19 +0000
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.45.79.139])
        by NASANPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3348KIUt021098
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 4 Apr 2023 08:20:18 GMT
Received: from [10.214.66.81] (10.80.80.8) by nasanex01c.na.qualcomm.com
 (10.45.79.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Tue, 4 Apr 2023
 01:20:15 -0700
Message-ID: <ed690550-3256-f889-c18f-2182d4b904cc@quicinc.com>
Date:   Tue, 4 Apr 2023 13:50:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC] net: qrtr: correct types of trace event parameters
Content-Language: en-US
To:     Simon Horman <horms@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
CC:     <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20230402-qrtr-trace-types-v1-1-da062d368e74@kernel.org>
From:   Mukesh Ojha <quic_mojha@quicinc.com>
In-Reply-To: <20230402-qrtr-trace-types-v1-1-da062d368e74@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 4uNhI53zH0IIxZvyxYztqfPi_ilI_20V
X-Proofpoint-GUID: 4uNhI53zH0IIxZvyxYztqfPi_ilI_20V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 phishscore=0 clxscore=1011 malwarescore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040077
X-Spam-Status: No, score=-2.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/2023 4:45 PM, Simon Horman wrote:
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
> Signed-off-by: Simon Horman <horms@kernel.org>
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
>   	),
>   
>   	TP_fast_assign(

LGTM.

Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>

--Mukesh

> 
