Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9A8A538
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 20:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfHLSCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 14:02:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726497AbfHLSCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 14:02:10 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CHq4Ia084385
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:02:09 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ubcw08bu9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:02:09 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <tlfalcon@linux.ibm.com>;
        Mon, 12 Aug 2019 19:02:08 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 12 Aug 2019 19:02:05 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7CI240b50331938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 18:02:04 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D236FAC05E;
        Mon, 12 Aug 2019 18:02:04 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8738CAC064;
        Mon, 12 Aug 2019 18:02:04 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.213.234])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Aug 2019 18:02:04 +0000 (GMT)
Subject: Re: [PATCH net] ibmveth: Convert multicast list size for
 little-endian systems
To:     Joe Perches <joe@perches.com>, netdev@vger.kernel.org
Cc:     liuhangbin@gmail.com, davem@davemloft.net
References: <1565631786-18860-1-git-send-email-tlfalcon@linux.ibm.com>
 <93581c35c0a8c06434221e628153028105849064.camel@perches.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Date:   Mon, 12 Aug 2019 13:02:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <93581c35c0a8c06434221e628153028105849064.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19081218-0064-0000-0000-00000407B163
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011585; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01245841; UDB=6.00657399; IPR=6.01027344;
 MB=3.00028147; MTD=3.00000008; XFM=3.00000015; UTC=2019-08-12 18:02:07
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081218-0065-0000-0000-00003EA46340
Message-Id: <5cd35ff4-ba11-936d-db6a-2311d3fc063f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/12/19 12:49 PM, Joe Perches wrote:
> On Mon, 2019-08-12 at 12:43 -0500, Thomas Falcon wrote:
>> The ibm,mac-address-filters property defines the maximum number of
>> addresses the hypervisor's multicast filter list can support. It is
>> encoded as a big-endian integer in the OF device tree, but the virtual
>> ethernet driver does not convert it for use by little-endian systems.
>> As a result, the driver is not behaving as it should on affected systems
>> when a large number of multicast addresses are assigned to the device.
>>
>> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
>> ---
>>   drivers/net/ethernet/ibm/ibmveth.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
>> index d654c23..b50a6cf 100644
>> --- a/drivers/net/ethernet/ibm/ibmveth.c
>> +++ b/drivers/net/ethernet/ibm/ibmveth.c
>> @@ -1645,7 +1645,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
>>   
>>   	adapter->vdev = dev;
>>   	adapter->netdev = netdev;
>> -	adapter->mcastFilterSize = *mcastFilterSize_p;
>> +	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
>>   	adapter->pool_config = 0;
>>   
>>   	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
> Perhaps to keep sparse happy too: (untested)


Thanks! I will test this and submit a v2 soon.


> ---
>   drivers/net/ethernet/ibm/ibmveth.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index d654c234aaf7..90539d7ce565 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -1605,7 +1605,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
>   	struct net_device *netdev;
>   	struct ibmveth_adapter *adapter;
>   	unsigned char *mac_addr_p;
> -	unsigned int *mcastFilterSize_p;
> +	__be32 *mcastFilterSize_p;
>   	long ret;
>   	unsigned long ret_attr;
>   
> @@ -1627,7 +1627,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
>   		return -EINVAL;
>   	}
>   
> -	mcastFilterSize_p = (unsigned int *)vio_get_attribute(dev,
> +	mcastFilterSize_p = (__be32 *)vio_get_attribute(dev,
>   						VETH_MCAST_FILTER_SIZE, NULL);
>   	if (!mcastFilterSize_p) {
>   		dev_err(&dev->dev, "Can't find VETH_MCAST_FILTER_SIZE "
> @@ -1645,7 +1645,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
>   
>   	adapter->vdev = dev;
>   	adapter->netdev = netdev;
> -	adapter->mcastFilterSize = *mcastFilterSize_p;
> +	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
>   	adapter->pool_config = 0;
>   
>   	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
>
>

