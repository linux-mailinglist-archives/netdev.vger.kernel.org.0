Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFE41A2203
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 14:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgDHM14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 08:27:56 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:8734 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726769AbgDHM1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 08:27:55 -0400
X-Greylist: delayed 8401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2020 08:27:54 EDT
Received: from pps.filterd (m0049295.ppops.net [127.0.0.1])
        by m0049295.ppops.net-00191d01. (8.16.0.42/8.16.0.42) with SMTP id 038A1Hnp002121;
        Wed, 8 Apr 2020 06:07:44 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049295.ppops.net-00191d01. with ESMTP id 3091nvh12q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Apr 2020 06:07:44 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id 038A7hGs123659;
        Wed, 8 Apr 2020 05:07:43 -0500
Received: from zlp30497.vci.att.com (zlp30497.vci.att.com [135.46.181.156])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id 038A7e89123623
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 8 Apr 2020 05:07:40 -0500
Received: from zlp30497.vci.att.com (zlp30497.vci.att.com [127.0.0.1])
        by zlp30497.vci.att.com (Service) with ESMTP id 7CE1C4016998;
        Wed,  8 Apr 2020 10:07:40 +0000 (GMT)
Received: from clpi183.sldc.sbc.com (unknown [135.41.1.46])
        by zlp30497.vci.att.com (Service) with ESMTP id 50DA64016997;
        Wed,  8 Apr 2020 10:07:40 +0000 (GMT)
Received: from sldc.sbc.com (localhost [127.0.0.1])
        by clpi183.sldc.sbc.com (8.14.5/8.14.5) with ESMTP id 038A7ex5018242;
        Wed, 8 Apr 2020 05:07:40 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by clpi183.sldc.sbc.com (8.14.5/8.14.5) with ESMTP id 038A7XoR017759;
        Wed, 8 Apr 2020 05:07:33 -0500
Received: from [10.156.47.146] (unknown [10.156.47.146])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id C5B6C3601B3;
        Wed,  8 Apr 2020 03:07:32 -0700 (PDT)
From:   Mike Manning <mmanning@vyatta.att-mail.com>
Subject: Re: VRF Issue Since kernel 5
Reply-To: mmanning@vyatta.att-mail.com
To:     Maximilian Bosch <maximilian@mbosch.me>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>
References: <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
 <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
 <20200401181650.flnxssoyih7c5s5y@topsnens>
 <b6ead5e9-cc0e-5017-e9a1-98b09b110650@gmail.com>
 <20200401203523.vafhsqb3uxfvvvxq@topsnens>
 <00917d3a-17f8-b772-5b93-3abdf1540b94@gmail.com>
 <20200402230233.mumqo22khf7q7o7c@topsnens>
 <5e64064d-eb03-53d3-f80a-7646e71405d8@gmail.com>
Message-ID: <d81f97fe-be4b-041d-1233-7e69758d96ef@vyatta.att-mail.com>
Date:   Wed, 8 Apr 2020 11:07:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <5e64064d-eb03-53d3-f80a-7646e71405d8@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 lowpriorityscore=0 phishscore=0 clxscore=1011 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004080084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maximilian,
Can you please clarify what the issue is with using 'ip vrf exec <vrf>
ssh' for running the ssh client in the vrf? This is the recommended
method for running an application in a VRF. As part of our VRF
development on this a couple of years ago, we provided a changeset for
openssh so that the vrf could be specified as an option, cf
https://bugzilla.mindrot.org/show_bug.cgi?id=2784. That was not applied
due to the ease of using 'ip vrf exec'.

Alternatively, to run the ssh client in the default VRF, you can bind it
to an address on an interface (or specify the interface) in the default
VRF using ssh -b (or -B) option, or similarly add an entry in
/etc/ssh/ssh_config for BindAddress (or BindInterface).

Then for egress, leak a route in the default table to get to the gateway
via the VRF (as you must already be doing), and for ingress, leak a
route in the VRF's table for the return path to the ssh client. For
this, get the table id for the vrf from 'ip vrf', add the route for the
client prefix with the additional 'table <tbl-id>' option, and confirm
the route with 'ip route show vrf <vrf-name>'.

I have started looking at the issue you have reported, but as you may
appreciate, it is not trivial. This client-side use-case is not typical,
as VRF config is generally applied to routers or switches, not hosts.

Thanks
Mike


On 05/04/2020 17:52, David Ahern wrote:
> On 4/2/20 5:02 PM, Maximilian Bosch wrote:
>> Hi!
>>
>>> I do not see how this worked on 4.19. My comment above is a fundamental
>>> property of VRF and has been needed since day 1. That's why 'ip vrf
>>> exec' exists.
>> I'm afraid I have to disagree here: first of all, I created a
>> regression-test in NixOS for this purpose a while ago[1]. The third test-case
>> (lines 197-208) does basically what I demonstrated in my previous emails
>> (opening SSH connetions through a local VRF). This worked fine until we
>> bumped our default kernel to 5.4.x which is the reason why this testcase
>> is temporarily commented out.
> I do not have access to a NixOS install, nor the time to create one.
> Please provide a set of ip commands to re-create the test that work with
> Ubuntu, debian or fedora.
>
>
>> After skimming through the VRF-related changes in 4.20 and 5.0 (which
>> might've had some relevant changes as you suggested previously), I
>> rebuilt the kernels 5.4.29 and 5.5.13 with
>> 3c82a21f4320c8d54cf6456b27c8d49e5ffb722e[2] reverted on top and the
>> commented-out testcase works fine again. In other words, my usecase
>> seems to have worked before and the mentioned commit appears to cause
>> the "regression".
> The vyatta folks who made the changes will take a look.


