Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD618D754
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfHNPla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:41:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728188AbfHNPl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:41:27 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7EFVtMH130677
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 11:41:26 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uckr1bynx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 11:41:26 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <tlfalcon@linux.ibm.com>;
        Wed, 14 Aug 2019 16:41:25 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 14 Aug 2019 16:41:22 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7EFfLKJ35652050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 15:41:21 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E9E6AC060;
        Wed, 14 Aug 2019 15:41:21 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA26AAC059;
        Wed, 14 Aug 2019 15:41:20 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.41.178.211])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 14 Aug 2019 15:41:20 +0000 (GMT)
Subject: Re: [PATCH net v2] ibmveth: Convert multicast list size for
 little-endian system
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, liuhangbin@gmail.com, davem@davemloft.net,
        joe@perches.com
References: <1565644386-22284-1-git-send-email-tlfalcon@linux.ibm.com>
 <20190813194037.464bea2c@cakuba.netronome.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Date:   Wed, 14 Aug 2019 10:41:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813194037.464bea2c@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19081415-0072-0000-0000-00000452AAD9
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011590; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01246749; UDB=6.00657947; IPR=6.01028256;
 MB=3.00028173; MTD=3.00000008; XFM=3.00000015; UTC=2019-08-14 15:41:23
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081415-0073-0000-0000-00004CC3BF59
Message-Id: <a496c317-264a-ee1a-238a-4043eb4fcb3e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/13/19 9:43 PM, Jakub Kicinski wrote:
> On Mon, 12 Aug 2019 16:13:06 -0500, Thomas Falcon wrote:
>> The ibm,mac-address-filters property defines the maximum number of
>> addresses the hypervisor's multicast filter list can support. It is
>> encoded as a big-endian integer in the OF device tree, but the virtual
>> ethernet driver does not convert it for use by little-endian systems.
>> As a result, the driver is not behaving as it should on affected systems
>> when a large number of multicast addresses are assigned to the device.
>>
>> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Okay, applied, but:

Thanks!

...

> ibmveth_init_link_settings() is part of your net-next patch which
> you're respining, so I had to apply manually. Please double check your
> patches apply cleanly to the designated tree.

Sorry about that, I thought I fixed that but maybe I got patches mixed 
up somehow.  Thanks again.

Tom

