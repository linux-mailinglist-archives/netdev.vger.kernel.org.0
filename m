Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A661AE328
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgDQRGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbgDQRGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:06:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E62520771;
        Fri, 17 Apr 2020 17:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587143196;
        bh=hy5+wTTXwIXBr6G+6XYJaWV+EGnOSq4AUnya+8uN2do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ExzEQW0onLdUY7N4ragrNoKgJotZ+lnDj0qvYFMBr2J/OuboW8hNWW1wOxV9puDRD
         21HJ6D0hDHXMIPgm82HbX+XEdOg1YvKk3AjdXKLVVd3MfsmLRKfD+VrT18APR/c5Vk
         FDiMU2I0kPCnyPAsrCvqxRK03Sk7zNcFUsrWCjko=
Date:   Fri, 17 Apr 2020 13:06:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 053/149] net: dsa: bcm_sf2: Also configure
 Port 5 for 2Gb/sec on 7278
Message-ID: <20200417170635.GU1068@sasha-vm>
References: <20200411230347.22371-1-sashal@kernel.org>
 <20200411230347.22371-53-sashal@kernel.org>
 <1fabff1d-63ed-e4c3-8db3-ff9443c5ade7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1fabff1d-63ed-e4c3-8db3-ff9443c5ade7@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 06:16:49PM -0700, Florian Fainelli wrote:
>
>
>On 4/11/2020 4:02 PM, Sasha Levin wrote:
>> From: Florian Fainelli <f.fainelli@gmail.com>
>>
>> [ Upstream commit 7458bd540fa0a90220b9e8c349d910d9dde9caf8 ]
>>
>> Either port 5 or port 8 can be used on a 7278 device, make sure that
>> port 5 also gets configured properly for 2Gb/sec in that case.
>
>This was later reverted with:
>
>3f02735e5da5367e4cd563ce6e5c21ce27922248 ("Revert "net: dsa: bcm_sf2:
>Also configure Port 5 for 2Gb/sec on 7278") please drop it from this
>selection.

Dropped from all branches, thanks!

-- 
Thanks,
Sasha
