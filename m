Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DACD313197
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhBHL6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:58:55 -0500
Received: from m12-16.163.com ([220.181.12.16]:60617 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233247AbhBHL5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 06:57:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=ZFWMb
        A8IIRM4Y2Shp9y2AqfBxFZ/llCxBUNcYxvSxTA=; b=Pjl2oCBG+fOIGH7V7Lb92
        4SukxyrkxChW8Z4GoKiOrNPtYqVph1cBznGFHBWqRDIelLcRjmPNewW1tKII/Jhz
        0oojKTLMnHsWSkSVGCW/NGGuX4WKxda0oVibPFpZyOzaZ8OnxCWR5puEHwyVpR5h
        Vv7DbQNPyF7wzfV6FOUgFM=
Received: from localhost (unknown [119.137.53.134])
        by smtp12 (Coremail) with SMTP id EMCowADn7VkvGyFgczS4bA--.30517S2;
        Mon, 08 Feb 2021 19:06:24 +0800 (CST)
Date:   Mon, 8 Feb 2021 19:06:19 +0800
From:   wengjianfeng <samirweng1979@163.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, lee.jones@linaro.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: Re: [PATCH RESEND] wl1251: cmd: remove redundant assignment
Message-ID: <20210208190619.00006644@163.com>
In-Reply-To: <20210208105954.1EAD9C433CA@smtp.codeaurora.org>
References: <20210208022535.17672-1-samirweng1979@163.com>
        <20210208105954.1EAD9C433CA@smtp.codeaurora.org>
Organization: yulong
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowADn7VkvGyFgczS4bA--.30517S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GryUXw4fJw4xZFy5GFW7urg_yoW3Cwc_uF
        4fWF1ruryktF48tFs2kw43XFn5Kr1UGw4kGw1FvryfCw1YgFWj9a1kKr9ayw4xX34Igr1D
        WFn5trWktryjgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0fuctUUUUU==
X-Originating-IP: [119.137.53.134]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqhUzsVr7sEK95gAAs1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Feb 2021 10:59:54 +0000 (UTC)
Kalle Valo <kvalo@codeaurora.org> wrote:

> samirweng1979 <samirweng1979@163.com> wrote:
> 
> > From: wengjianfeng <wengjianfeng@yulong.com>
> > 
> > -ENOMEM has been used as a return value,it is not necessary to
> > assign it, and if kzalloc fail,not need free it,so just return
> > -ENOMEM when kzalloc fail.
> > 
> > Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> 
> You sent the previous version just five days ago:
> 
> https://patchwork.kernel.org/project/linux-wireless/patch/20210203060306.2832-1-samirweng1979@163.com/
> 
> We maintainers are busy and usually takes some time to review the
> patch. So please avoid resending patches in such short intervals.
> 
> Patch set to Superseded.
> 

Hi Kalle,
  I see, thanks your reply.

