Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538CD1720CF
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 15:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbgB0OpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 09:45:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730226AbgB0Oo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 09:44:59 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01REeAb2142540
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 09:44:59 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydqbtyf7u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 09:44:58 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 27 Feb 2020 14:44:56 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 14:44:54 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01REirOi35848568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 14:44:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B03E94C040;
        Thu, 27 Feb 2020 14:44:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6653E4C04A;
        Thu, 27 Feb 2020 14:44:53 +0000 (GMT)
Received: from [9.145.6.242] (unknown [9.145.6.242])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 14:44:53 +0000 (GMT)
Subject: Re: [RFC net-next] net/smc: update peer ID on device changes
To:     Hans Wippel <ndev@hwipl.net>
Cc:     ubraun@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org
References: <20200227113902.318060-1-ndev@hwipl.net>
 <b56d4bbc-2a4e-634f-10d4-17bd0253c033@linux.ibm.com>
 <20200227150946.60f12541f7541a64150afe2a@hwipl.net>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Thu, 27 Feb 2020 15:44:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227150946.60f12541f7541a64150afe2a@hwipl.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20022714-0012-0000-0000-0000038AD72F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022714-0013-0000-0000-000021C780D0
Message-Id: <4c3b6802-7b27-73ec-f53c-ec1326aecb2b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_04:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0
 impostorscore=0 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=911
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002270117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/02/2020 15:09, Hans Wippel wrote:
> On Thu, 27 Feb 2020 14:13:48 +0100
> Karsten Graul <kgraul@linux.ibm.com> wrote:
> 
>> On 27/02/2020 12:39, Hans Wippel wrote:
>>> From: hwipl <ndev@hwipl.net>
>>>
>>> A SMC host's peer ID contains the MAC address of the first active RoCE
>>> device. However, if this device becomes inactive or is removed, the peer
>>> ID is not updated. This patch adds peer ID updates on device changes.
>>
>> The peer ID is used to uniquely identify an SMC host and to check if there
>> are already established link groups to the peer which can be reused.
>> In failover scenarios RoCE devices can go down and get active again later,
>> but this must not change the current peer ID of the host.  
>> The part of the MAC address that is included in the peer ID is not used for
>> other purposes than the identification of an SMC host.
> 
> Is it OK to keep the peer ID if, for example, the device is removed and
> used in a different VM?
> 
> Hans
> 

Yes, exactly this case is described in the RFC (instance id):

https://tools.ietf.org/html/rfc7609#page-93

-- 
Karsten

(I'm a dude)

