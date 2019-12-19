Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68951270A1
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLSW0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:26:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSW0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 17:26:08 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C692465E;
        Thu, 19 Dec 2019 22:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576794367;
        bh=ZfiNj/3IAqVOdV51Zj3XycsQakVvXcBEq/F55ivmFMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UwXhJnqZ5QclM68Nly3TnFChOXuhZCL+9g7D+jYJVifYRePT0zeVznFzwAxNRDo8Y
         NPfwpGX2+fYJ8dYgUTZR173f/UJELBUwBZIOk80p7gPkrfBAS1e6UFXbdmWxceemyU
         DkvQpoN0VQlMURfkmSZjDIf+ZE2j272gHfJYging=
Date:   Thu, 19 Dec 2019 17:26:06 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>,
        "David S . Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 276/350] net: bcmgenet: Add RGMII_RXID support
Message-ID: <20191219222606.GR17708@sasha-vm>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-237-sashal@kernel.org>
 <d53a8fd0-c4a6-61eb-597c-b4cf094882d3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d53a8fd0-c4a6-61eb-597c-b4cf094882d3@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 01:49:30PM -0800, Florian Fainelli wrote:
>On 12/10/19 1:06 PM, Sasha Levin wrote:
>> From: Stefan Wahren <wahrenst@gmx.net>
>>
>> [ Upstream commit da38802211cc3fd294211a642932edb09e3af632 ]
>>
>> This adds the missing support for the PHY mode RGMII_RXID.
>> It's necessary for the Raspberry Pi 4.
>>
>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
>> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>There are more changes required to make the GENET controller on the Pi 4
>to work, how and why this was selected? Same comment applies to the 4.19
>automatic selection.

I'll just drop it then, thanks.

-- 
Thanks,
Sasha
