Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4812CB568
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 07:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgLBG6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 01:58:08 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14248 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgLBG6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 01:58:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc73ad80000>; Tue, 01 Dec 2020 22:57:28 -0800
Received: from [10.26.73.44] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Dec
 2020 06:57:15 +0000
Subject: Re: [PATCH iproute2-net 1/3] devlink: Add devlink reload action and
 limit options
To:     David Ahern <dsahern@gmail.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
 <1606389296-3906-2-git-send-email-moshe@mellanox.com>
 <165b31e9-6dce-477d-339d-206fe221fcee@gmail.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <0d081210-b27b-85ab-a794-482dec484598@nvidia.com>
Date:   Wed, 2 Dec 2020 08:57:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <165b31e9-6dce-477d-339d-206fe221fcee@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606892248; bh=g7+Sb9hLwQlc5816A99Bb7vReCspmvvY3IEM1AnkeeM=;
        h=Subject:To:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=Uiu1iMnpzc3WD1ncZ0Q71fHcfLeRDe+9sbps6eLMHV8ZISknF5grTvLMfXYJStCYa
         /l1U67oC/unmBrFm40w8HFBEPPEmqDh7y2h1xJ3SUkEKk6YzK2NlAOJ+gPIiNLmql7
         sMJYkITsqln28tchh+/4xAXFtzZaqX95mLl/G9Y6PY9wphTZOvwh+W7NGquI4dL5kk
         RIanTFioh/F49WsQagiR2+XKlTT0uvbuQKEMtQtUlT4mexTOvA2kvzr1c6Xh4SwdSV
         BOc6IBELb4pVFDVZ8VPxlzaybsO69BlZ9MuRAbTCPo+C98Zw/EoqTfCprgzxBgRVV5
         54f4wbFDhxIRA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/29/2020 11:12 PM, David Ahern wrote:
> On 11/26/20 4:14 AM, Moshe Shemesh wrote:
>> @@ -1997,7 +2066,7 @@ static void cmd_dev_help(void)
>>   	pr_err("       devlink dev eswitch show DEV\n");
>>   	pr_err("       devlink dev param set DEV name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
>>   	pr_err("       devlink dev param show [DEV name PARAMETER]\n");
>> -	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
>> +	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
> line length is unreasonable; add new options on the next line.
Ack.
>>   	pr_err("       devlink dev info [ DEV ]\n");
>>   	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
>>   }
