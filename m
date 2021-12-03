Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACEC467D26
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 19:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382546AbhLCSXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 13:23:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59084 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhLCSXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 13:23:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8672BB826AE;
        Fri,  3 Dec 2021 18:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EADCC53FAD;
        Fri,  3 Dec 2021 18:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638555625;
        bh=OB4Bx6jJijh7+JRIkpwpBVOrUJtz1NtAnmSn6rSLTJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=epCSKUqma0APZHSuaqurmjtsNySskl2XDvGOhZw2jd40QkkpNJ1hoSvpO7f9yo//m
         1lgU1ZUfJi3wp0tqe5RQtyBCugzs/2nr+SPSy7n3Sq2hD7Im9Y6LR0zOwBGG0T65Lw
         OsMMM+Ks0rYeUKVbA28xXkkL4ntjKFRJfp2SdZ0u/vU7NeOiZdfTJWbFB7Y6LcKL6T
         C72kvpsMStNT7+4kB0gHpldmUMywE2QAtvNIGRaFNq7tmlj7c+G+S2C0te3XI2g+bH
         b9WLVekYKPVnGpmptg1lSdpwkFdcIInxN8Y7V7xOARWOBi1j971wgw58sC1ynbbl+l
         Bci9wSA5Wofgg==
Date:   Fri, 3 Dec 2021 13:20:23 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>, kgraul@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 10/39] net/smc: Transfer remaining wait
 queue entries during fallback
Message-ID: <Yapf55An+RCmIr7G@sashalap>
References: <20211126023156.441292-1-sashal@kernel.org>
 <20211126023156.441292-10-sashal@kernel.org>
 <20211125185139.0007069f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211125185139.0007069f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 06:51:39PM -0800, Jakub Kicinski wrote:
>On Thu, 25 Nov 2021 21:31:27 -0500 Sasha Levin wrote:
>> From: Wen Gu <guwen@linux.alibaba.com>
>>
>> [ Upstream commit 2153bd1e3d3dbf6a3403572084ef6ed31c53c5f0 ]
>>
>> The SMC fallback is incomplete currently. There may be some
>> wait queue entries remaining in smc socket->wq, which should
>> be removed to clcsocket->wq during the fallback.
>>
>> For example, in nginx/wrk benchmark, this issue causes an
>> all-zeros test result:
>
>Hold this one, please, there is a fix coming: 7a61432dc813 ("net/smc:
>Avoid warning of possible recursive locking").

I'll grab that one too, thanks!

-- 
Thanks,
Sasha
