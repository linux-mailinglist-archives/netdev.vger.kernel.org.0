Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E87C2E32F8
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 22:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgL0V23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 16:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgL0V22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 16:28:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEBF8207AE;
        Sun, 27 Dec 2020 21:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609104468;
        bh=dlUOHzdT6jqxNMlS7tKqm2HOUmsvt41fj/QA+qUzYuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LmC2caxmKrmbf7bEAgezvmwRBWBxQ0zThEPdwxvwtMI9dZ6Ri2AeWQrxIypSzHa4U
         MuvrouwwqnAi+Bz4M08GCuZp1ESgAYv5x5k38Dr25b2vwhVA2uSmbQi+jxW7uFfLjM
         cAR64DMSdHM7T91XYSvTrgc7hiPjKBPYOFdy55iiN2iugdPwONLW9+tLOGm9hYpVM+
         1kFXEEnPiaZK+1zMwiw460a/7go+/uHu2FZ52+cdFdRxbfSj4oGZre/BVnNtVogWkN
         zk12bzwTSn2UHGfqr5sF38U+er57hCVHQaJYSX1DQZV1loLFycMID4Mo5OG/is3fsG
         yS3yQCE0VHAvA==
Date:   Sun, 27 Dec 2020 16:27:46 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.4 075/130] net/lapb: fix t1 timer handling for
 LAPB_STATE_0
Message-ID: <20201227212746.GF2790422@sasha-vm>
References: <20201223021813.2791612-75-sashal@kernel.org>
 <20201223170124.5963-1-xie.he.0141@gmail.com>
 <CAJht_EOXf4Z3G-rq92hb_YvJEsHtDy15FE7WuthqDQsPY039QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJht_EOXf4Z3G-rq92hb_YvJEsHtDy15FE7WuthqDQsPY039QQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 24, 2020 at 01:49:47AM -0800, Xie He wrote:
>On Wed, Dec 23, 2020 at 9:01 AM Xie He <xie.he.0141@gmail.com> wrote:
>>
>> I don't think this patch is suitable for stable branches. This patch is
>> part of a patch series that changes the lapb module from "establishing the
>> L2 connection only when needed by L3", to "establishing the L2 connection
>> automatically whenever we are able to". This is a behavioral change. It
>> should be seen as a new feature. It is not a bug fix.
>
>Applying this patch without other patches in the same series will also
>introduce problems, because this patch relies on part of the changes
>in the subsequent patch in the same series to be correct.

I'll drop it, thanks!

-- 
Thanks,
Sasha
