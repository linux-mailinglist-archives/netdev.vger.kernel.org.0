Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945213DA959
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhG2QtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231939AbhG2QtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 12:49:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83D0860EFD;
        Thu, 29 Jul 2021 16:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627577345;
        bh=0PP/z5bKtOvDhFY1GZMQnfRHfUyhpUqQdwKOgptfqFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OSLCrU1Vrcbn+ig/5SEvCYXCLR+Mk08T6TvInWbIuDRv60+XjnCM9m4dbznESygzm
         EIRiLSkcl+sboUqONYoA3dMGeMb1q5dRDEHAlqY3lPIL2oO15ZZMC+Y+VK/mM3MdTu
         hYc1+VmJyM02XVQ/J4Sq0v6lUOhr6eY03Lh8PZz5wKKh5IG0MTDbBSWzNi3WHZ5jfe
         1l4V+Auh1zCW1cHtXl2ty9Pcme+THSW3yqL/B3fqHs54Oyc5jQR+dtCCVLuy6/NfOD
         /2l2Qic8Ue9bgtaV98pZwyeMymQOzOC011qFqaHYQxE1LrDo5pd4edUP+urHtNHpXP
         mUF11sYQS5sag==
Date:   Thu, 29 Jul 2021 12:49:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     gregkh@linuxfoundation.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, stable@vger.kernel.org,
        dhaval.giani@oracle.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5.4.y 0/0] Missing commit 580e4273 causing: general
 protection fault in tcf_generic_walker
Message-ID: <YQLcAP/RkaSq+bQL@sashalap>
References: <1627574254-23665-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1627574254-23665-1-git-send-email-george.kennedy@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 10:57:33AM -0500, George Kennedy wrote:
>During Syzkaller reproducer testing on 5.4.y (5.4.121-rc1) the following warning occurred:
>
>general protection fault in tcf_generic_walker
>https://syzkaller.appspot.com//bug?id=a85a4c2d373f7f8ff9ac5ee351e60d3c042cc781
>
>This missing upstream commit is needed to fix the crash in 5.4.y:
>580e4273d7a883ececfefa692c1f96bdbacb99b5 net_sched: check error pointer in tcf_dump_walker()

I'll queue it up, thanks!

-- 
Thanks,
Sasha
