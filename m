Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE0D533E16
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 15:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244481AbiEYNmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 09:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244480AbiEYNmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 09:42:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBC360D86;
        Wed, 25 May 2022 06:42:47 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PC27jb024305;
        Wed, 25 May 2022 13:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ESDy53ENcNiKqV4jgxQ7XXslgw9ISbYsnAu0XUwNlDo=;
 b=hLLXHFHRGCSwy051J964BK+xKBg+oM6LSjPngIZmBGnzD3lV/I/wrvbHh0xUISXYxLGU
 sgZcuIbDrYkRC/ORpnHOuj2EBpFlSwJktDby3SwtHMAteu5f7yBUjXJ4G5FejdgRMt+G
 AV3ztOikekvtAJQWAzyjMNTgBwgHCplvbh7kYkNkJhavy8APCXv7Giskze3K9IJIBoLd
 T7K52GXxwTI73qFnz/DFAKOE/cv5O9DmEPJbeH8eeUtujukP4e4gMG34gf7Z3p9DBvdY
 5E1C4IyHa6yS9Vj7WSpfcxED0EjN20wjeW6QfwGXRitasNAWta+UDlAwdGpXi7ZFXhqH DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9h91db1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:42:35 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24PDHa5e024998;
        Wed, 25 May 2022 13:42:35 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9h91db0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:42:35 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24PDLWZ4020077;
        Wed, 25 May 2022 13:42:31 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3g94g38xy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:42:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24PDgTuG44433700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 13:42:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAD0352051;
        Wed, 25 May 2022 13:42:28 +0000 (GMT)
Received: from [9.152.224.55] (unknown [9.152.224.55])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ACAFF5204F;
        Wed, 25 May 2022 13:42:28 +0000 (GMT)
Message-ID: <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
Date:   Wed, 25 May 2022 15:42:28 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
 <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7YNK1IdvSF3-GJLmR3Q-L4t9SKNugYbN
X-Proofpoint-GUID: S-1NqOqGvBi3L5z_NUFEEj4iwZiOmrP3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205250069
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.05.22 09:49, Tony Lu wrote:
> On Tue, May 24, 2022 at 02:52:07PM +0800, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> Hi Karsten,
>>
>> We are promoting SMC-R to the field of cloud computing, dues to the
>> particularity of business on the cloud, the scale and the types of
>> customer applications are unpredictable. As a participant of SMC-R, we
>> also hope that SMC-R can cover more application scenarios. Therefore,
>> many connection problems are exposed during this time. There are two
>> main issue, one is that the establishment of a single connection takes
>> longer than that of the TCP, another is that the degree of concurrency
>> is low under multi-connection processing. This patch set is mainly
>> optimized for the first issue, and the follow-up of the second issue
>> will be synchronized in the future.
>>
>> In terms of communication process, under current implement, a TCP
>> three-way handshake only needs 1-RTT time, while SMC-R currently
>> requires 4-RTT times, including 2-RTT over IP(TCP handshake, SMC
>> proposal & accept ) and 2-RTT over IB ( two times RKEY exchange), which
>> is most influential factor affecting connection established time at the
>> moment.
>>
>> We have noticed that single network interface card is mainstream on the
>> cloud, dues to the advantages of cloud deployment costs and the cloud's
>> own disaster recovery support. On the other hand, the emergence of RoCE
>> LAG technology makes us no longer need to deal with multiple RDMA
>> network interface cards by ourselves,  just like NIC bonding does. In
>> Alibaba, Roce LAG is widely used for RDMA.
> 
> I think this is an interesting topic whether we need SMC-level link
> redundancy. I agreed with that RoCE LAG and RDMA in cloud vendors handle
> redundancy and failover in the lower layer, and do it transparently for
> SMC.
> 
> So let's move on, if a RDMA device has redundancy ability, we could make
> SMC simpler by give an option for user-space or based on the device
> capability (if we have this flag). This allows under layer to ensure the
> reliability of link group.
> 
> As RFC 7609 mentioned, we should do some extra work for reliability to
> add link. It should be an optional work if the device have capability
> for redundancy, and make link group simpler and faster (for the
> so-called SMC-2RTT in this RFC).
> 
> I also notice that RFC 7609 is released on August 2015, which is earlier
> than RoCE LAG. RoCE LAG is provided after ConnectX-3/ConnectX-3 Pro in
> kernel 4.0, and is available in 2017. And cloud vendors' RDMA adapters,
> such as Alibaba Elastic RDMA adapter in [1].
> 
> Given that, I propose whether the second link can be used as an option
> in newly created link group. Also, if it is possible, RFC 7609 can be
> updated or extend it for this nowadays case.
> 
> Looking forward for your message, Karsten, D. Wythe and folks.
> 
> [1] https://lore.kernel.org/linux-rdma/20220523075528.35017-1-chengyou@linux.alibaba.com/
> 
> Thanks,
> Tony Lu
>  
Thank you D. Wythe for your proposals, the prototype and measurements.
They sound quite promising to us.

We need to carefully evaluate them and make sure everything is compatible
with the existing implementations of SMC-D and SMC-R v1 and v2. In the
typical s390 environment ROCE LAG is propably not good enough, as the card
is still a single point of failure. So your ideas need to be compatible
with link redundancy. We also need to consider that the extension of the
protocol does not block other desirable extensions.

Your prototype is very helpful for the understanding. Before submitting any
code patches to net-next, we should agree on the details of the protocol
extension. Maybe you could formulate your proposal in plain text, so we can
discuss it here? 

We also need to inform you that several public holidays are upcoming in the
next weeks and several of our team will be out for summer vacation, so please
allow for longer response times.

Kind regards
Alexandra Winter

>> In that case, SMC-R have only one single link, if so, the RKEY LLC
>> messages that to perform information exchange in all links are no longer
>> needed, the SMC Proposal & accept has already complete the exchange of
>> all information needed. So we think that we can remove the RKEY exchange
>> in that case, which will save us 2-RTT over IB. We call it as SMC-R 2-RTT.
>>
>> On the other hand, we can use TCP fast open, carry the SMC proposal data
>> by TCP SYN message, reduce the time that the SMC waits for the TCP
>> connection to be established. This will save us another 1-RTT over IP.
>>
>> Based on the above two viewpoints, in this scenario, we can compress the
>> communication process of SMC-R into 1-RTT over IP, so that we can
>> theoretically obtain a time close to that of TCP connection
>> establishment. We call it as SMC-R 1-RTT. Of course, the specific results
>> will also be affected by the implementation.
>>
>> In our test environment, we host two VMs on the same host for wrk/nginx
>> tests, used a script similar to the following to performing test:
>>
>> Client.sh
>>
>> conn=$1
>> thread=$2
>>
>> wrk -H ‘Connection: Close’ -c ${conn} -t ${thread} -d 10
>>
>> Server.sh
>>
>> sysctl -w net.ipv4.tcp_fastopen=3
>> smc_run nginx
>>
>> Statistic shows that:
>>
>> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
>> |type|args  |   -c1 -t1     |   -c2 -t1     |   -c5 -t1      |  -c10 -t1    |   -c200 -t1    |  -c200 -t4    |  -c2000 -t8   |
>> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
>> |next-next  |   4188.5qps   |   5942.04qps  |   7621.81qps   |  7678.62qps  |   8204.94qps   |  8457.57qps   |  5687.60qps   |
>> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
>> |SMC-2RTT   |   4730.17qps  |   7394.85qps  |   11532.78qps  |  12016.22qps |   11520.81qps  |  11391.36qps  |  10364.41qps  |
>> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
>> |SMC-1RTT   |   5702.77qps  |   9645.18qps  |   11899.20qps  |  12005.16qps |   11536.67qps  |  11420.87qps  |  10392.4qps   |
>> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+-
>> |TCP        |   6415.74qps  |   11034.10qps |   16716.21qps  |  22217.06qps |   35926.74qps  |  117460.qps   |  120291.16qps |
>> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
>>
>> It can clearly be seen that:
>>
>> 1. In step by step short-link scenarios ( -c1 -t1 ), SMC-R after
>> optimization can reach 88% of TCP. There are still many implementation
>> details that can be optimized, we hope to optimize the performance of
>> SMC in this scenario to 90% of TCP.
>>
>> 2. The problem is very serious in the scenario of multi-threading and
>> multi-connection, the worst case is only 10% of TCP. Even though the
>> SMC-1RTT has certain optimizations for this scenario, it is clear that
>> the bottleneck is not here. We are doing some prototyping to solve this,
>> we hope to reach 60% of TCP in multi-threading and multi-connection
>> scenarios, and SMC-1RTT is the important prerequisite for upper limit of
>> subsequent optimization.
>>
>> In this patch set, we had only completed a simple prototype, only make
>> sure SMC-1RTT can works.
>>
>> Sincerely, we are looking forward for you comments, please
>> let us know if you have any suggestions.
>>
>> Thanks.
>>
>> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
>> ---
--------8<  snip  >8-------- 
