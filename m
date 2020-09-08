Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802CF261F19
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbgIHT67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbgIHPfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:39 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E52B206DB;
        Tue,  8 Sep 2020 12:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599567145;
        bh=qmVm2cBZbFlDXg2K5rwPxPvrNmapd2esw84x5y2TZFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NQ7N43mQZ4LkTz66NIKWIOC2tQ5F40LoHwfxM6xc2UuMF2nup3sPRlDg2/4oHVOgE
         ueQDJCcgHx6hagKe8KacN6yDsSoeaI90haVA0MrSWqN19Ht8L0EgNacfxJSXPfOOzo
         XziLjCQjkwu0AgW5+bxQSftlzmQ6q6ckvclcRO5g=
Date:   Tue, 8 Sep 2020 08:12:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lars Melin <larsm17@gmail.com>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 17/33] net: usb: qmi_wwan: add Telit 0x1050
 composition
Message-ID: <20200908121224.GT8670@sasha-vm>
References: <20191026132110.4026-1-sashal@kernel.org>
 <20191026132110.4026-17-sashal@kernel.org>
 <CAKfDRXjjuW4VM03HeVoeEyG=cULUK8ZXexWu48rfFvJE+DD8_g@mail.gmail.com>
 <20200907181552.GN8670@sasha-vm>
 <6e09f3e2-674d-f7c1-e868-c170dff1dbb9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6e09f3e2-674d-f7c1-e868-c170dff1dbb9@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 07:33:21AM +0700, Lars Melin wrote:
>On 9/8/2020 01:15, Sasha Levin wrote:
>>On Mon, Sep 07, 2020 at 11:36:37AM +0200, Kristian Evensen wrote:
>// snip
>
>>>When testing the FN980 with kernel 4.14, I noticed that the qmi device
>>>was not there. Checking the git log, I see that this patch was never
>>>applied. The patch applies fine, so I guess it was just missed
>>>somewhere. If it could be added to the next 4.14 release, it would be
>>>much appreciated.
>>
>>Interesting, yes - I'm not sure why it's missing. I'll queue it up.
>>
>
>The patch is missing from all 4.x LTS kernels, not only 4.14

Right, it's queued up for all the trees.

-- 
Thanks,
Sasha
