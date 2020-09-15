Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD7526AE6C
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgIOUHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:07:50 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15930 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727907AbgIOUG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:06:59 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f611cae0002>; Tue, 15 Sep 2020 12:57:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 12:59:56 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 15 Sep 2020 12:59:56 -0700
Received: from [172.27.1.246] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 19:59:45 +0000
Subject: Re: [PATCH net-next RFC v4 15/15] devlink: Add
 Documentation/networking/devlink/devlink-reload.rst
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-16-git-send-email-moshe@mellanox.com>
 <20200915090448.38b115d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <2795f30c-2816-651b-e2bf-c7c08deb6352@nvidia.com>
Date:   Tue, 15 Sep 2020 22:59:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200915090448.38b115d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600199854; bh=SH309tR0BZLcSEu6wjAP/ZsLVRTyAqlE0ccST4M6dyA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=YDwsD2mqR+zm+qbeJsY1ph5awq7iMfXyZQIjiae/F9cGidtEN2FL2BvZ95SbC/rUN
         kiD06VTMPjIRd0O7ZNCykjpeWSwKw0TnESQwYcm2OWsivNICluYTq/w157BpViSBVt
         hVZGL6/24X8FMOec2Z0u30/YyWfTaObKB41uFXCkLNsS3mN9kUaXJ8Xdt9EG3jqukO
         BmyFo6FQlBdl4Haxbqs9rdoQIDe3ItWywhQFwnKZcZugkipG/GdwIVxfF605MlF19A
         gdz4lkHiWMLiuuG1DLVsQc80Yj5Yv/TQUMeKgPZ/1+ej5l6PLwgvLijlWYamrqabTP
         NMbW4iSFW+R3w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/15/2020 7:04 PM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Mon, 14 Sep 2020 09:08:02 +0300 Moshe Shemesh wrote:
>> +   * - ``no_reset``
>> +     - No reset allowed, no down time allowed, no link flap and no
>> +       configuration is lost.
> It still takes the PCI link down for up to 2sec. So there is down time,
> right?


No, the fw reset with PCI link down is categorized as fw_activate with 
limit level none.

fw_live_patch keeps the pci link up and it fits to "no_reset" limit level.

