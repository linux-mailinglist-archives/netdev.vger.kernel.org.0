Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C07E16F12D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgBYVde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:33:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57872 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgBYVde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:33:34 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PLOqeq016986;
        Tue, 25 Feb 2020 16:33:29 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yax39ann1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Feb 2020 16:33:29 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01PLQOJ4020340;
        Tue, 25 Feb 2020 16:33:28 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yax39anmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Feb 2020 16:33:28 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01PLUQHU005443;
        Tue, 25 Feb 2020 21:33:27 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 2yaux6ya1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Feb 2020 21:33:27 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01PLXQ6631719920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 21:33:26 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CB12AC05B;
        Tue, 25 Feb 2020 21:33:26 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4452AC059;
        Tue, 25 Feb 2020 21:33:25 +0000 (GMT)
Received: from Criss-MacBook-Pro.local (unknown [9.24.11.154])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 25 Feb 2020 21:33:25 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH, net-next, v5, 2/2] net/ethtool: Introduce link_ksettings API for virtual network devices
In-Reply-To: <20200221181622.GD5607@unicorn.suse.cz>
References: <20200218175227.8511-1-cforno12@linux.vnet.ibm.com> <20200218175227.8511-3-cforno12@linux.vnet.ibm.com> <20200221181622.GD5607@unicorn.suse.cz>
Date:   Tue, 25 Feb 2020 15:33:22 -0600
Message-ID: <m2blpmwdwd.fsf@Criss-MacBook-Pro.local.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_08:2020-02-25,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 spamscore=0 suspectscore=1 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These changes have been applied to v6. Thanks for the suggestions Michal!

Michal Kubecek <mkubecek@suse.cz> writes:

> On Tue, Feb 18, 2020 at 11:52:27AM -0600, Cris Forno wrote:
>> With get/set link settings functions in core/ethtool.c, ibmveth,
>> netvsc, and virtio now use the core's helper function.
>> 
>> Funtionality changes that pertain to ibmveth driver include:
>> 
>>   1. Changed the initial hardcoded link speed to 1GB.
>> 
>>   2. Added support for allowing a user to change the reported link
>>   speed via ethtool.
>> 
>> Changes to the netvsc driver include:
>> 
>>   1. When netvsc_get_link_ksettings is called, it will defer to the VF
>>   device if it exists to pull accelerated networking values, otherwise
>>   pull default or user-defined values.
>> 
>>   2. Similarly, if netvsc_set_link_ksettings called and a VF device
>>   exists, the real values of speed and duplex are changed.
>> 
>> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
>> ---
> [...]
>> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
>> index 65e12cb..f733ec5 100644
>> --- a/drivers/net/hyperv/netvsc_drv.c
>> +++ b/drivers/net/hyperv/netvsc_drv.c
> [...]
>> @@ -1187,18 +1193,19 @@ static int netvsc_set_link_ksettings(struct net_device *dev,
>>  				     const struct ethtool_link_ksettings *cmd)
>>  {
>>  	struct net_device_context *ndc = netdev_priv(dev);
>> -	u32 speed;
>> +	struct net_device *vf_netdev = rtnl_dereference(ndc->vf_netdev);
>>  
>> -	speed = cmd->base.speed;
>> -	if (!ethtool_validate_speed(speed) ||
>> -	    !ethtool_validate_duplex(cmd->base.duplex) ||
>> -	    !netvsc_validate_ethtool_ss_cmd(cmd))
>> -		return -EINVAL;
>> +	if (vf_netdev) {
>> +		if (!vf_netdev->ethtool_ops->set_link_ksettings)
>> +			return -EOPNOTSUPP;
>>  
>> -	ndc->speed = speed;
>> -	ndc->duplex = cmd->base.duplex;
>> +		return vf_netdev->ethtool_ops->set_link_ksettings(vf_netdev,
>> +								  cmd);
>> +	}
>>  
>> -	return 0;
>> +	return ethtool_virtdev_set_link_ksettings(dev, cmd,
>> +						  &ndc->speed, &ndc->duplex,
>> +						  &netvsc_validate_ethtool_ss_cmd);
>>  }
>
> I may be missing something obvious but I cannot see how does
> netvsc_validate_ethtool_ss_cmd() differ from ethtool_virtdev_validate_cmd().
> If it does, it would be probably worth a comment at the function.
>
> Michal Kubecek
