Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9F496D71
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 19:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbiAVSvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 13:51:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58574 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiAVSvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 13:51:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62ABE60EA6;
        Sat, 22 Jan 2022 18:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A92C340E4;
        Sat, 22 Jan 2022 18:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642877476;
        bh=eDFJ0JvkUYQt0VUhHH3xRwKMAQTmz7VtgWrSGyhYsdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=knla0GCS/tX+SXQsXvKOghLFoRA2cGwynzhpzR8WFQprnwyghvGmb3PbSrfU/RtH0
         gQC9Sg/33EXmsQOTDXOxrpwgInXnZnTtI2F/sXIxXnqvzq7qwggTxg8Yl1EjGthpBv
         6X8IETYGflMUpTtmvcjF41CW1/CKddiOqzYjTuoZlva8JWNth0gu0Dq217kSEyNTFA
         QYQXrivZwnYWtEPZuyH5OWTda4E4P1ujykzTlf98WDLW9WvTS4JIcBEZC+CDkGgaeG
         9JoQpTIVH9SUjv2pmDONFP1axnzCnC2o7GITWBUctdMULEWBiU7Vfb4+bBjG9buZ46
         XrIMXYJllv7fA==
Date:   Sat, 22 Jan 2022 13:51:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 047/217] cirrus: mac89x0: use
 eth_hw_addr_set()
Message-ID: <YexSIQFF/lXAt8L9@sashalap>
References: <20220118021940.1942199-1-sashal@kernel.org>
 <20220118021940.1942199-47-sashal@kernel.org>
 <20220118085641.6c0c7cc9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220118085641.6c0c7cc9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 08:56:41AM -0800, Jakub Kicinski wrote:
>On Mon, 17 Jan 2022 21:16:50 -0500 Sasha Levin wrote:
>> From: Jakub Kicinski <kuba@kernel.org>
>>
>> [ Upstream commit 9a962aedd30f7fceb828d3161a80e0526e358eb5 ]
>>
>> Byte by byte assignments.
>>
>> Fixes build on m68k.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Hi Sasha! You can drop all the eth_hw_addr_set() patches.
>They aren't fixes, I should have used a different verb, the point
>was to mention the arch where the driver is built. The patches are
>only needed in 5.17 where netdev->dev_addr becomes a const.
>
>I think that's patches 34-47, 53.

Will do, thanks!

-- 
Thanks,
Sasha
