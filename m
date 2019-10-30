Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA651EA553
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfJ3VWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:22:44 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:2992 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726261AbfJ3VWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:22:44 -0400
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9ULLfFc019627;
        Wed, 30 Oct 2019 21:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=9yJQjJkoMrNHYc80zQMs2PVQiOvbPj9231bnuPF0NSQ=;
 b=Uz8m06LhVqQYzFQuMq0/B8qYpRKLvMnkkXzDnCgNBOas8lD5T5UJW2FDSeOB9ixVdO5a
 fXnNV4viZXA0O181jnO0p//ez6PxFhhRswDU0wQ4XTJP+P1Bi+TN+1GUi1tH1L4afOeu
 wmh+tj0rKR2djdpW1/nK/GmsnwvlbE2l5Uu+jur50lIkj5QOWW5zQpwzF0wmyrddich8
 Rf4wJ0ciN0IrjfDoREiECiSuZNQhHkgv0BxJiIox7Umh2/a9cEsI8Q9fbHf2U0rbwdKF
 I5qIxYwdjZnHfOSEwgZCEMTSuYLf4GPH5A77BFop/OmYgAq7+8OMOV+WVN5WiXtSFl9/ MQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2vxwgfw2hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Oct 2019 21:22:34 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9ULHvc5027330;
        Wed, 30 Oct 2019 17:22:34 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2vxwfnwbp7-1;
        Wed, 30 Oct 2019 17:22:33 -0400
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 3881B21A1B;
        Wed, 30 Oct 2019 21:22:33 +0000 (GMT)
Subject: Re: USO / UFO status ?
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>
References: <BN8PR12MB326699DDA44E0EABB5C422E4D3600@BN8PR12MB3266.namprd12.prod.outlook.com>
 <CA+FuTSdVsTgcpB9=CEb=O369qUR58d-zEz5vmv+9nR+-DJFM6Q@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <99c9e80e-7e97-8490-fb43-b159fe6e8d7b@akamai.com>
Date:   Wed, 30 Oct 2019 14:22:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdVsTgcpB9=CEb=O369qUR58d-zEz5vmv+9nR+-DJFM6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-30_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300186
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-30_09:2019-10-30,2019-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910300187
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 12:48 PM, Willem de Bruijn wrote:
> On Wed, Oct 30, 2019 at 3:16 PM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>>
>> Hi netdev,
>>
>> What's the status of UDP Segmentation Offload (USO) and UDP
>> Fragmentation Offloading (UFO) on current mainline ?
>>
>> I see that NETIF_F_GSO_UDP_L4 is only supported by Mellanox NIC's but I
>> also saw some patches from Intel submitting the support. Is there any
>> tool to test this (besides the -net selftests) ?
> 
> UDP segmentation offload with UDP_SEGMENT is always available with
> software segmentation. The only driver with hardware offload (USO)
> merged so far is indeed mlx5. Patches for various Intel NICs are in
> review.
> 

I recently added UDP GSO offload support for ixgbe, igb, and i40e. I saw 
that Jeff sent the patches to Dave earlier today targeting net-next so 
you should be able to test with those once they land in net-next.

I also wrote a wrapper script around the selftest benchmark code to do 
my testing with, and believe the Intel folks used it as part of their 
validation as well. You can find it attached to this thread:

https://lore.kernel.org/netdev/0e0e706c-4ce9-c27a-af55-339b4eb6d524@akamai.com/

Unfortunately it's poorly named there since there's already a 
udpgso_bench.sh in the kernel tree... :|

Josh


