Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728AB5ECD11
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiI0Tmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiI0Tms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:42:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3B518D0D8
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:42:47 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28RJAvfs012432;
        Tue, 27 Sep 2022 19:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iZT7P33zGvokczjtFxujaE/k1kwAyYmvAda5ZajDK30=;
 b=IGRLExZv9ACi0ok3K68nmOEiXsggtCdgP7S7fghdZSdoMWYFFDMJdwuT3LzmLdz9lbVg
 wjHo1vjK7L3bhgRPrJ2vFZWUfbxPVMqSW7sqH0w0Ocra7jHdgFAWMKuRDlfDW2almgja
 8er9MKNxQphlQm9CtDbu7jsSh2pDSFb+5IKjtjCDFisQJGNIoTZVOU3k3gUdvwpMj3JR
 +fKpeHgVYwdvlAoAhCoTshAr5OBfeQidxw0Kn1/LdCh2F+6yXL3Qdc1H/L5ggD5g9xIm
 oZSlzCO5wFw59nJW4DOQOq1ZtnehfoDx10jU8E0R7pB1sglAXlq/pRqhq0zOeLSjJcKI 8A== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jv6w60ws8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 19:42:44 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28RJZDKN024770;
        Tue, 27 Sep 2022 19:42:43 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 3jssh9pjnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 19:42:43 +0000
Received: from smtpav01.wdc07v.mail.ibm.com ([9.208.128.113])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28RJgghS66847056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Sep 2022 19:42:43 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E43D5805B;
        Tue, 27 Sep 2022 19:42:42 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 252E358063;
        Tue, 27 Sep 2022 19:42:41 +0000 (GMT)
Received: from [9.160.10.183] (unknown [9.160.10.183])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 27 Sep 2022 19:42:40 +0000 (GMT)
Message-ID: <7e18bf4d-b922-f6f5-b7fb-08d8cc9d58aa@linux.ibm.com>
Date:   Tue, 27 Sep 2022 14:42:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net-next 3/3] ibmveth: Ethtool set queue support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com, mmc@linux.ibm.com
References: <20220921215056.113516-1-nnac123@linux.ibm.com>
 <20220921215056.113516-3-nnac123@linux.ibm.com>
 <20220926114448.10434fba@kernel.org>
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <20220926114448.10434fba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IkF8GEBkaQTDDd6lTqOkcZDtz-j1YCT8
X-Proofpoint-GUID: IkF8GEBkaQTDDd6lTqOkcZDtz-j1YCT8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_09,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 clxscore=1011 lowpriorityscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209270122
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/26/22 13:44, Jakub Kicinski wrote:
> On Wed, 21 Sep 2022 16:50:56 -0500 Nick Child wrote:
>> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
>> index 7abd67c2336e..2c5ded4f3b67 100644
>> --- a/drivers/net/ethernet/ibm/ibmveth.c
>> +++ b/drivers/net/ethernet/ibm/ibmveth.c

>> +static void ibmveth_get_channels(struct net_device *netdev,
>> +				 struct ethtool_channels *channels)
>> +{
>> +	channels->max_tx = ibmveth_real_max_tx_queues();
>> +	channels->tx_count = netdev->real_num_tx_queues;
>> +
>> +	channels->max_rx = netdev->real_num_rx_queues;
>> +	channels->rx_count = netdev->real_num_rx_queues;
> 
> Which is 1, right?

Correct, there will only be one rx queue. I chose doing this over using
hard-coded values to ensure that the values presented to the user are
actually being implemented in the networking layers.

>> +static int ibmveth_set_channels(struct net_device *netdev,
>> +				struct ethtool_channels *channels)

>> +	/* We have IBMVETH_MAX_QUEUES netdev_queue's allocated
>> +	 * but we may need to alloc/free the ltb's.
>> +	 */
>> +	netif_tx_stop_all_queues(netdev);
> 
> What if the device is not UP?

 From my understanding this will just set the __QUEUE_STATE_DRV_XOFF bit
of all of the queues. I don't think this will cause any issues if the
device is DOWN. Please let me know if you are worried about anything
in particular here.

Just as a side note, ibmveth never sets carrier state to UP since it
cannot determine the link status of the physical device being
virtualized. The state is instead left as UNKNOWN when not DOWN.


The other comments from Jakub's review are left out because I fully
agree with them and will apply them to a v2 soon (as well as adding
anything else that comes up before then).

Thank you very much for the review Jakub :)

--Nick Child
