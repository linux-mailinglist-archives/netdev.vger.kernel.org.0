Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C2131B7B0
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 11:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhBOKyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 05:54:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60382 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229933AbhBOKyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 05:54:38 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11FAh1YA111343;
        Mon, 15 Feb 2021 05:53:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8XUn/RrF8fEXCE56SjQD66uzzMsCUDqSF5XwaE1CYfw=;
 b=RULAr7ADa0brMHHJB8rr77OoB4ReaH8Qi/hv9i4qu5AIWrJuQYo1Z0huD+RSYKITJE3v
 +UwAvTuLEXGlgLqNDsCOLkPu3LpHYhABqX3ovn/MlS/d7Mg9kTPLmLhefzez+B9N1aDi
 Hlr+UAsGV6He9xY1WX6f4RizTb/zpN6oIciAHg7gfEIPfEgh5uuTheojOc7UTf4sRkwv
 DhxyehLkj/MbrE6JHTN7qZVfaukKaK6vicvp8ldCssPzOywich5Gg7XHpOJybL6XGhns
 z7pHeWFJ+Pjb6iYyJqBkTxqtE8jZOatMajIkHWysfzH9YmHaZuWvDYI0Hp8oS+WyIFHQ Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36qqet8a11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 05:53:48 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11FAptgq142774;
        Mon, 15 Feb 2021 05:53:48 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36qqet8a0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 05:53:47 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11FAlwc6018878;
        Mon, 15 Feb 2021 10:53:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 36p61h9rn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 10:53:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11FArhMx38273512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 10:53:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5E4042049;
        Mon, 15 Feb 2021 10:53:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23B1D4203F;
        Mon, 15 Feb 2021 10:53:43 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box (unknown [9.145.21.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Feb 2021 10:53:43 +0000 (GMT)
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
From:   Alexandra Winter <wintera@linux.ibm.com>
Message-ID: <5530c6b8-4824-64da-f5a9-f8a790c46c3b@linux.ibm.com>
Date:   Mon, 15 Feb 2021 11:53:42 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210215103224.zpjhi5tiokov2gvy@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-15_03:2021-02-12,2021-02-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102150081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15.02.21 11:32, Vladimir Oltean wrote:
> Hi Alexandra,
> 
> On Mon, Feb 15, 2021 at 09:22:47AM +0100, Alexandra Winter wrote:
>> In the section about 'bridge link set' Self vs master mention physical
>> device vs software bridge. Would it make sense to use the same
>> terminology here?
> 
> You mean like this?
> 
> .TP
> .B self
> operation is fulfilled by the driver of the specified network interface.
> 
> .TP
> .B master
> operation is fulfilled by the specified interface's master, for example
> a bridge, which in turn may or may not notify the underlying network
> interface driver. This flag is considered implicit by the kernel if
> 'self' was not specified.
> 
Actually, I found your first (more verbose) proposal more helpful. 

>> The attributes are listed under 'bridge fdb add' not under 'bridge fdb
>> show'. Is it correct that the attributes displayed by 'show' are a
>> 1-to-1 representation of the ones set by 'add'?
> 
> Bah, not quite. I'll try to summarize below.
> 
>> What about the entries that are not manually set, like bridge learned
>> adresses? Is it possible to add some explanation about those as well?
> 
> Ok, challenge accepted. Here's my take on 'bridge fdb show', I haven't
> used most of these options (I'm commenting solely based on code
> inspection) so if anybody with more experience could chime in, I'd be
> happy to adjust the wording.
> 
> 
> .SS bridge fdb show - list forwarding entries.
> 
> This command displays the current forwarding table. By default all FDB
> entries in the system are shown. The following options can be used to
> reduce the number of displayed entries:
> 
> .TP
> .B br
> Filter the output to contain only the FDB entries of the specified
> bridge, or belonging to ports of the specified bridge (optional).
> 
> .B brport
> Filter the output to contain only the FDB entries present on the
> specified network interface (bridge port). This flag is optional.
> 
> .B dev
> Same as "brport".
> 
> .B vlan
> Filter the output to contain only the FDB entries with the specified
> VLAN ID (optional).
> 
> .B dynamic
> Filter out the local/permanent (not forwarded) FDB entries.
> 
> .B state
> Filter the output to contain only the FDB entries having the specified
> state. The bridge FDB is modeled as a neighbouring protocol for
> PF_BRIDGE (similar to what ARP is for IPv4 and ND is for IPv6).
> Therefore, an FDB entry has a NUD ("Network Unreachability Detection")
> state given by the generic neighbouring layer.
> 
> The following are the valid components of an FDB entry state (more than
> one may be valid at the same time):
> 
> .B permanent
> Associated with the generic NUD_PERMANENT state, which means that the L2
> address of the neighbor has been statically configured by the user and
> therefore there is no need for a neighbour resolution.
> For the bridge FDB, it means that an FDB entry is 'local', i.e. the L2
> address belongs to a local interface.
> 
> .B reachable
> Associated with the generic NUD_REACHABLE state, which means that the L2
> address has been resolved by the neighbouring protocol. A reachable
> bridge FDB entry can have two sub-states (static and dynamic) detailed
> below.
> 
> .B static
> Associated with the generic NUD_NOARP state, which is used to denote a
> neighbour for which no protocol is needed to resolve the mapping between
> the L3 address and L2 address. For the bridge FDB, the neighbour
> resolution protocol is source MAC address learning, therefore a static
> FDB entry is one that has not been learnt.
> 
> .B dynamic
> Is a NUD_REACHABLE entry that lacks the NUD_NOARP state, therefore has
> been resolved through address learning.
> 
> .B stale
> Associated with the generic NUD_STALE state. Denotes an FDB entry that
> was last updated longer ago than the bridge's hold time, but not yet
> removed. The hold time is equal to the forward_delay (if the STP
> topology is still changing) or to the ageing_time otherwise.
> 
> 
> .PP
> In the resulting output, each FDB entry can have one or more of the
> following flags:
> 
> .B self
> This entry is present in the FDB of the specified network interface driver.
> 
> .B router
> ???
> 
> .B extern_learn
> This entry has been added to the master interface's FDB by the lower
> port driver, as a result of hardware address learning.
> 
> .B offload
> This entry is present in the hardware FDB of a lower port and also
> associated with an entry of the master interface.
> 
> .B master
> This entry is present in the software FDB of the master interface of
> this lower port.
> 
> .B sticky
> This entry cannot be migrated to another port by the address learning
> process.
> 
> .PP
> With the
> .B -statistics
> option, the command becomes verbose. It prints out the last updated
> and last used time for each entry.
> 
Thank you so much!! This will be very helpful.

>>>  .B self
>>> -- the address is associated with the port drivers fdb. Usually hardware
>>> -  (default).
>>> +- the operation is fulfilled directly by the driver for the specified network
>>> +device. If the network device belongs to a master like a bridge, then the
>>> +bridge is bypassed and not notified of this operation (and if the device does
>>> +notify the bridge, it is driver-specific behavior and not mandated by this
>>> +flag, check the driver for more details). The "bridge fdb add" command can also
>>> +be used on the bridge device itself, and in this case, the added fdb entries
>>> +will be locally terminated (not forwarded). In the latter case, the "self" flag
>>> +is mandatory. 
>> Maybe I misunderstand this sentence, but I can do a 'bridge fdb add' without 'self'
>> on the bridge device. And the address shows up under 'bridge fdb show'.
>> So what does mandatory mean here?
> 
> It's right in the next sentence:
> 
>> The flag is set by default if "master" is not specified.
> 
> It's mandatory and implicit if "master" is not specified, ergo 'bridge
> fdb add dev br0' will work because 'master' is not specified (it is
> implicitly 'bridge fdb add dev br0 self'. But 'bridge fdb add dev br0
> master' will fail, because the 'self' flag is no longer implicit (since
> 'master' was specified) but mandatory and absent.
> 
> I'm not sure what I can do to improve this.
> 
Maybe the sentence under 'master':
" If the specified
+device is a master itself, such as a bridge, this flag is invalid."
is sufficient to defien this situation. And no need to explain mandatory implicit defaults
in the first paragraph?
