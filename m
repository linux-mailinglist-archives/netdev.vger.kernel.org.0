Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48BE135CBF
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732419AbgAIP31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728257AbgAIP31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 10:29:27 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 494B220673;
        Thu,  9 Jan 2020 15:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578583766;
        bh=4yxdqliRGaByZbgaDZ+g0vdg0HH/Wm3FEJvh3Vpr2hA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TcAh4qCnn5OC28taqif6ZQ5peLRBI0+88/71AT9LJjl1Yooy6ln/XA/nkGmMTYWM1
         AafmmaIpfOvqtN2/d6SYTQ4fphKoWzNLx6DvYDK5syk1uVnzIrtiX032CJAPc67pJj
         1c3QK0M89DmKJsTda8pbXY2AW7E601NPpiJFVbGM=
Date:   Thu, 9 Jan 2020 10:29:25 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        huangwen <huangwenabc@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Subject: Re: [PATCH AUTOSEL 5.4 008/187] mwifiex: fix possible heap overflow
 in mwifiex_process_country_ie()
Message-ID: <20200109152925.GF1706@sasha-vm>
References: <20191227174055.4923-1-sashal@kernel.org>
 <20191227174055.4923-8-sashal@kernel.org>
 <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 02:51:28PM -0800, Brian Norris wrote:
>On Fri, Dec 27, 2019 at 9:59 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Ganapathi Bhat <gbhat@marvell.com>
>>
>> [ Upstream commit 3d94a4a8373bf5f45cf5f939e88b8354dbf2311b ]
>
>FYI, this upstream commit has unbalanced locking. I've submitted a
>followup here:
>
>[PATCH] mwifiex: fix unbalanced locking in mwifiex_process_country_ie()
>https://lkml.kernel.org/linux-wireless/20200106224212.189763-1-briannorris@chromium.org/T/#u
>https://patchwork.kernel.org/patch/11320227/
>
>I'd recommend holding off until that gets landed somewhere. (Same for
>the AUTOSEL patches sent to other kernel branches.)

I'll drop it for now, just ping us when the fix is in and we'll get both
patches queued back up.

-- 
Thanks,
Sasha
