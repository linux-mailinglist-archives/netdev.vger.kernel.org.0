Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9219031B957
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 13:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhBOMev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 07:34:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229652AbhBOMeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 07:34:44 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11FCVeIv196377;
        Mon, 15 Feb 2021 07:33:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uTZbJF61MWIySwgOEwIy++a9zzQmJiw5dbiW7pn8iBo=;
 b=sQ1fs118j4Oo0b6kiK6hIzR1s3qR86zEM8bGrWi8cuzTEcvjLfoyWesaLZN6ET3CtPaS
 rjt5S7Hs9rQh35UyDyESaay7ZD7D7PrQL0NB8pC7OJKRmWqyMYf1n6S32zJGjTuiHGfW
 t1uiKDzG9p//Yd8zJilI4ZO5BGyMVwTKQK7CRj7xUGbew68PFfsfis3RC3/b5cDH3Q3Y
 Mu4zW3z26Zu9FEtA8cSZuE4HDBNe7l9hUEl48I0QWbfYzqmh/C38dLsUrmbshUOebTJW
 zSxkf1P8EE4c8s6zP5mnyHMa+iUTFaL1sc1LWBSaguMMAWk/DN1+tXx6yiDKJVmBw4b5 CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36qrbw263n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 07:33:56 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11FCVht4000583;
        Mon, 15 Feb 2021 07:33:55 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36qrbw262s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 07:33:55 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11FCTfh4015223;
        Mon, 15 Feb 2021 12:33:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 36p6d89tyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 12:33:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11FCXpKT63242686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 12:33:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DDFC42049;
        Mon, 15 Feb 2021 12:33:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3DD342047;
        Mon, 15 Feb 2021 12:33:50 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box (unknown [9.145.21.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Feb 2021 12:33:50 +0000 (GMT)
Subject: Re: [PATCH iproute2 5/6] man8/bridge.8: explain self vs master for
 "bridge fdb add"
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210211104502.2081443-1-olteanv@gmail.com>
 <20210211104502.2081443-6-olteanv@gmail.com>
 <65b9d8b6-0b04-9ddc-1719-b3417cd6fb89@linux.ibm.com>
 <20210215103224.zpjhi5tiokov2gvy@skbuf>
 <5530c6b8-4824-64da-f5a9-f8a790c46c3b@linux.ibm.com>
 <20210215121342.driolhmaow7ads5g@skbuf>
From:   Alexandra Winter <wintera@linux.ibm.com>
Message-ID: <69a3c453-8cc8-08ec-0ad7-39c0452919a7@linux.ibm.com>
Date:   Mon, 15 Feb 2021 13:33:50 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210215121342.driolhmaow7ads5g@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-15_06:2021-02-12,2021-02-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102150101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15.02.21 13:13, Vladimir Oltean wrote:
> On Mon, Feb 15, 2021 at 11:53:42AM +0100, Alexandra Winter wrote:
>> Actually, I found your first (more verbose) proposal more helpful.
> 
> Sorry, I don't understand. Do you want me to copy the whole explanation
> from bridge fdb add to bridge link set?
> 
>>>> Maybe I misunderstand this sentence, but I can do a 'bridge fdb add' without 'self'
>>>> on the bridge device. And the address shows up under 'bridge fdb show'.
>>>> So what does mandatory mean here?
>>>
>>> It's right in the next sentence:
>>>
>>>> The flag is set by default if "master" is not specified.
>>>
>>> It's mandatory and implicit if "master" is not specified, ergo 'bridge
>>> fdb add dev br0' will work because 'master' is not specified (it is
>>> implicitly 'bridge fdb add dev br0 self'. But 'bridge fdb add dev br0
>>> master' will fail, because the 'self' flag is no longer implicit (since
>>> 'master' was specified) but mandatory and absent.
>>>
>>> I'm not sure what I can do to improve this.
>>>
>> Maybe the sentence under 'master':
>> " If the specified
>> +device is a master itself, such as a bridge, this flag is invalid."
>> is sufficient to defien this situation. And no need to explain mandatory implicit defaults
>> in the first paragraph?
> 
> I don't understand this either. Could you paste here how you think this
> paragraph should read?
> 
Sorry, I did not mean to cause confusion. Your original proposal:
 .B self
-- the address is associated with the port drivers fdb. Usually hardware
-  (default).
+- the operation is fulfilled directly by the driver for the specified network
+device. If the network device belongs to a master like a bridge, then the
+bridge is bypassed and not notified of this operation (and if the device does
+notify the bridge, it is driver-specific behavior and not mandated by this
+flag, check the driver for more details). The "bridge fdb add" command can also
+be used on the bridge device itself, and in this case, the added fdb entries
+will be locally terminated (not forwarded). In the latter case, the "self" flag
+is mandatory. The flag is set by default if "master" is not specified.
 .sp
 
 .B master
-- the address is associated with master devices fdb. Usually software.
+- if the specified network device is a port that belongs to a master device
+such as a bridge, the operation is fulfilled by the master device's driver,
+which may in turn notify the port driver too of the address. If the specified
+device is a master itself, such as a bridge, this flag is invalid.
 .sp


The above is fine with me and IMHO much better than it is today.
But if you ask me I would change it to:

 .B self
- the operation is fulfilled directly by the driver for the specified physical device. 
If the network device belongs to a master like a bridge, then the
bridge is bypassed and not notified of this operation (and if the device does
notify the bridge, it is driver-specific behavior and not mandated by this
flag, check the driver for more details). The "bridge fdb add" command can also
be used on the bridge device itself, and in this case, the added fdb entries
will be locally terminated (not forwarded). The flag is set by default if "master" 
is not specified.
 .sp
 
 .B master
- if the specified network device is a port that belongs to a master device
such as a software bridge, the operation is fulfilled by the master device's driver,
which may in turn notify the port driver too of the address. If the specified
device is a master itself, such as a bridge, this flag is invalid.
 .sp


