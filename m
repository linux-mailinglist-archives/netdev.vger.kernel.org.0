Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E558E248F55
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHRUEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:04:23 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11908 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgHRUEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:04:22 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3c34350001>; Tue, 18 Aug 2020 13:04:05 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 13:04:19 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 13:04:19 -0700
Received: from [10.21.180.121] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Aug
 2020 20:04:11 +0000
Subject: Re: [PATCH net-next RFC v2 13/13] devlink: Add
 Documentation/networking/devlink/devlink-reload.rst
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
 <1597657072-3130-14-git-send-email-moshe@mellanox.com>
 <20200817163933.GB2627@nanopsycho>
 <a786a68d-df60-cae3-5fb1-3648ca1c69d8@nvidia.com>
 <20200818110740.GC2627@nanopsycho>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <1599b919-4e74-0352-bf47-cc0d39c5d3a6@nvidia.com>
Date:   Tue, 18 Aug 2020 23:04:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818110740.GC2627@nanopsycho>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597781045; bh=87WgvtCpgCVwtxhzzwkf4l93Jvr5+jYvHLULFM6BC8s=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=SC/oaeYg1SgoFcn1VdycMFdI7So/ljV5lj6i0ylHW1cvAiDnMJQTaYEjreDz3mdGB
         U/fClCt/fduNfNXnaOmWdcaerdQ0+aiGUGpF9tJF6QeHtLJeWBGK8Gnv0mPwpwBCL6
         +gbnN2CWwhNSSTHnzJVTDyN4+kPx30ZM74CY/dE4SBN4qjpiirMdnS5b/5KT1xOwLZ
         hf8iYvCQk+2md2ywDfGcWvNf4W7NY8fouLgp5b+XJtYrpXCGNYuhTZ6m1Z9o/IdE1s
         h5xS+K8ITgPlV5nFq9foZQ7ZvVaIqUVd+an7hVmwEq5NYPIzYdzHZFY1SFBB6Yj9lm
         3mRzayZnVJcJw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/18/2020 2:07 PM, Jiri Pirko wrote:
> Tue, Aug 18, 2020 at 11:14:16AM CEST, moshe@nvidia.com wrote:
>> On 8/17/2020 7:39 PM, Jiri Pirko wrote:
>>> Mon, Aug 17, 2020 at 11:37:52AM CEST, moshe@mellanox.com wrote:
>>>> Add devlink reload rst documentation file.
>>>> Update index file to include it.
>>>>
>>>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>>>> ---
>>>> - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>>>>    actions driver_reinit,fw_activate,fw_live_patch
>>>> ---
>>>> .../networking/devlink/devlink-reload.rst     | 54 +++++++++++++++++++
>>>> Documentation/networking/devlink/index.rst    |  1 +
>>>> 2 files changed, 55 insertions(+)
>>>> create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>>>>
>>>> diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
>>>> new file mode 100644
>>>> index 000000000000..9846ea727f3b
>>>> --- /dev/null
>>>> +++ b/Documentation/networking/devlink/devlink-reload.rst
>>>> @@ -0,0 +1,54 @@
>>>> +.. SPDX-License-Identifier: GPL-2.0
>>>> +
>>>> +==============
>>>> +Devlink Reload
>>>> +==============
>>>> +
>>>> +``devlink-reload`` provides mechanism to either reload driver entities,
>>>> +applying ``devlink-params`` and ``devlink-resources`` new values or firmware
>>>> +activation depends on reload action selected.
>>>> +
>>>> +Reload actions
>>>> +=============
>>>> +
>>>> +User may select a reload action.
>>>> +By default ``driver_reinit`` action is done.
>>>> +
>>>> +.. list-table:: Possible reload actions
>>>> +   :widths: 5 90
>>>> +
>>>> +   * - Name
>>>> +     - Description
>>>> +   * - ``driver-reinit``
>>>> +     - Driver entities re-initialization, including applying
>>>> +       new values to devlink entities which are used during driver
>>>> +       load such as ``devlink-params`` in configuration mode
>>>> +       ``driverinit`` or ``devlink-resources``
>>>> +   * - ``fw_activate``
>>>> +     - Firmware activate. Can be used for firmware reload or firmware
>>>> +       upgrade if new firmware is stored and driver supports such
>>>> +       firmware upgrade.
>>> Does this do the same as "driver-reinit" + fw activation? If yes, it
>>> should be written here. If no, it should be written here as well.
>>>
>> No, The only thing required here is the action of firmware activation. If a
>> driver needs to do reload to make that happen and do reinit that's ok, but
>> not required.
> What does the "FW activation" mean? I believe that this needs explicit
> documentation here.
>
I will add it explicitly.

FW activation means FW upgrade if new image is pending activation. If no 
FW image pending, it reloads the current FW.

>>>> +   * - ``fw_live_patch``
>>>> +     - Firmware live patch, applies firmware changes without reset.
>>>> +
>>>> +Change namespace
>>>> +================
>>>> +
>>>> +All devlink instances are created in init_net and stay there for a
>>>> +lifetime. Allow user to be able to move devlink instances into
>>>> +namespaces during devlink reload operation. That ensures proper
>>>> +re-instantiation of driver objects, including netdevices.
>>>> +
>>>> +example usage
>>>> +-------------
>>>> +
>>>> +.. code:: shell
>>>> +
>>>> +    $ devlink dev reload help
>>>> +    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { fw_live_patch | driver_reinit | fw_activate } ]
>>>> +
>>>> +    # Run reload command for devlink driver entities re-initialization:
>>>> +    $ devlink dev reload pci/0000:82:00.0 action driver_reinit
>>>> +
>>>> +    # Run reload command to activate firmware:
>>>> +    $ devlink dev reload pci/0000:82:00.0 action fw_activate
>>>> diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
>>>> index 7684ae5c4a4a..d82874760ae2 100644
>>>> --- a/Documentation/networking/devlink/index.rst
>>>> +++ b/Documentation/networking/devlink/index.rst
>>>> @@ -20,6 +20,7 @@ general.
>>>>      devlink-params
>>>>      devlink-region
>>>>      devlink-resource
>>>> +   devlink-reload
>>>>      devlink-trap
>>>>
>>>> Driver-specific documentation
>>>> -- 
>>>> 2.17.1
>>>>
