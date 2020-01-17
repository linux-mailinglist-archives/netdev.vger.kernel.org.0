Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0C140216
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 03:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733166AbgAQCpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 21:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729067AbgAQCpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 21:45:23 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4F920730;
        Fri, 17 Jan 2020 02:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579229123;
        bh=dKyqaaGGcB1MEqXs9BPg8uYw+xt+15onKXbpCmYtg4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AexsPH/wskCzkb4pS2nT3LvFZB4U5CmfvO1tbOlwAmfd1Rs1rv3bPekfFJAR5fOPa
         Au3WHsZFYfHiNbNL6NdkHnXQrtTALNMarDKuHPbl1Js/orf59bNMpKaiNiW+B4WdMw
         K/sVKwM5KdYMz2jVOfnearTXlAGR34ko/ivRC6H8=
Date:   Thu, 16 Jan 2020 21:45:22 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 573/671] ipv6: Handle race in
 addrconf_dad_work
Message-ID: <20200117024522.GN1706@sasha-vm>
References: <20200116170509.12787-1-sashal@kernel.org>
 <20200116170509.12787-310-sashal@kernel.org>
 <fc012e53-ccdf-5ac5-6f3f-a2ecdf25bc39@gmail.com>
 <630c6286-2ab4-44ab-693e-0615a2ac690b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <630c6286-2ab4-44ab-693e-0615a2ac690b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 10:20:16AM -0700, David Ahern wrote:
>On 1/16/20 10:18 AM, David Ahern wrote:
>> On 1/16/20 10:03 AM, Sasha Levin wrote:
>>> From: David Ahern <dsahern@gmail.com>
>>>
>>> [ Upstream commit a3ce2a21bb8969ae27917281244fa91bf5f286d7 ]
>>>
>>
>> That commit was reverted by 8ae72cbf62d2c1879456c0c5872f958e18f53711 and
>> then replaced by 2d819d250a1393a3e725715425ab70a0e0772a71
>>
>
>BTW, the AUTOSEL algorithm should be updated to look for reverts and
>even ones that have already been nack'ed from a backport perspective.
>
>I felt a bit of deja vu with my response and sure enough this patch was
>selected back in October and I responded then that it should not be
>backported.

Sorry about this David. This series is a result of an experimental work
I did rather than the regular AUTOSEL workflow, so it ended up
accidentally bubbling a few commits that were previously rejected.

-- 
Thanks,
Sasha
