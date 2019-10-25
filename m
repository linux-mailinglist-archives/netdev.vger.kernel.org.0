Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE009E5030
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395417AbfJYPcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbfJYPcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 11:32:42 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCAE921929;
        Fri, 25 Oct 2019 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572017562;
        bh=0nyovhNiQQVYIxIcfWTgd7etJWK5tEiahN5tt+ZftH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJDdGOXNjvx0GLM8SY8zPNoc8ck0G1QAJdgnw2KqTbivk0e1FBcUilc1qG6ZcFeKQ
         a0BDEqzNBig9AOXuw61DTIEFYlFy2bkp3f+eIBn59zSqvhGFgqXXzg6o4OBHKRbe2X
         1XzOizz0/Y8CmwKM6T6a0parDR9HFaIZuV5wLTSo=
Date:   Fri, 25 Oct 2019 11:32:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 19/20] ipv6: Handle race in addrconf_dad_work
Message-ID: <20191025153240.GG31224@sasha-vm>
References: <20191025135801.25739-1-sashal@kernel.org>
 <20191025135801.25739-19-sashal@kernel.org>
 <f3c4a11c-b5b5-455a-6c88-83b8cc56623d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f3c4a11c-b5b5-455a-6c88-83b8cc56623d@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 08:22:59AM -0600, David Ahern wrote:
>On 10/25/19 7:57 AM, Sasha Levin wrote:
>> From: David Ahern <dsahern@gmail.com>
>>
>> [ Upstream commit a3ce2a21bb8969ae27917281244fa91bf5f286d7 ]
>>
>
>that patch was reverted in favor of a different solution. It should NOT
>be backported to any releases.

I'll drop it, thank you.

-- 
Thanks,
Sasha
