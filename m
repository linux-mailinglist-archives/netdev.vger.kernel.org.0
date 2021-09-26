Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688FE418AF3
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 22:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhIZUWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 16:22:45 -0400
Received: from mout.web.de ([212.227.15.4]:60423 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhIZUWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 16:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1632687651;
        bh=9o/e66vAWG/z2ECjYL1NyiGoc7RJt52pRYvR60FMngk=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=jsP+1sFnoXMIb3sNNXYOutEgzo64bqRHeyQP60oS/RDRX/N6X3sKNI4se83ExgAxF
         Z29gyHBDgKsiIAzLsA7In7FKxHhoBALP6GDsbO6zxcwkCH59ib4mllo/ufNTsoaPFi
         Ofn373r0TB6efKE3YLc7epzlmGVdiidOg2/ZollI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [10.9.8.2] ([62.227.172.72]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MmQYX-1nClDG0Owr-00iJRf; Sun, 26
 Sep 2021 22:20:51 +0200
Subject: Re: [BUG] Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as
 fallback
To:     Kalle Valo <kvalo@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
References: <20210425110200.3050-1-shawn.guo@linaro.org>
 <cb7ac252-3356-8ef7-fcf9-eb017f5f161f@web.de> <20210908010057.GB25255@dragon>
 <100f5bef-936c-43f1-9b3e-a477a0640d84@web.de> <20210909022033.GC25255@dragon>
 <56e9a81a-4e05-cf5e-a8df-782ac75fdbe6@web.de> <20210912015137.GD25255@dragon>
 <87pmt2uvxu.fsf@codeaurora.org>
From:   Soeren Moch <smoch@web.de>
Message-ID: <ffe146e8-a393-2388-0f31-2bd030a75812@web.de>
Date:   Sun, 26 Sep 2021 22:20:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <87pmt2uvxu.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Provags-ID: V03:K1:xaz3Z1xGU/FK/ErZ/VHwScYBHhAAf/Wz3uXzw3rKTjaX9jJKLnM
 abFUKWeJORbgaPadeDVLaedD6HO25jRa3NmRorRM4IabQ87iQyb7m43idS7aaBex2cxc9/5
 LxwgzS2ZSu3wCpyrpcPalFbVSgeb6LJ7wuYHpFnf+KD483grJJk4cIj3CCMH6SB7ygvo1Ei
 kAOFSBHK48g/KzYTTZBvA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DFz2lwZNGAw=:zbH7iSdhVjqiEUCj+tjfey
 LD6rygIFVCROy4Nxe0esCXUx3Tl131W4RfZ5NLxPyiRqjltu6sI5DhPwHfklIN6vL6KjNf2F/
 lJBCLiBPQJMQCzHIk7Gxycsyu63SCCnGX/EXmAe+aM9sqnL0fvUWy9cF8ucjMN1TB9K2UFp2g
 9lg+7/OPty1j0mwmPrFuUhOMby0ud8YSPK7J9VL/9UO3xrsam/8g635f0s+wyPCZJyC5G5Grc
 4fyWMi8IsBirwhoe3GPk928M9oWprhy2ZVkLKxjQtstoBwZzt/fBIEmz3zBgsZUauJDPnwmMv
 hVRP6NDjRosoEPK5kNkA3EcM1bvvnG7k3T6KN0De9pbdFgndn0qzaVUs7NCQt4XLPdQH1xbXz
 E+7jsRVTQ5xvHmG0Gz7n5tVwPORTkSk9yDRpEE1CASy0nt9DCRozCudszpC3w1QcyMrQYRDKE
 tsMtTLe109nIv4LJt1xVoJ+6j5iLmipuekPeJFjA4+NcUGcO1tc6XO+oJ3OarNRRWpgzIvLcR
 FBZ0yrZ1V7tMjCbK67TyfJA8XVL5NefVwUEHx5zhY9C1cIeWuHYphrQ8FD8TB7HVkwDA0CSiR
 HpuBEHCjpYXHG8UmiF1bvupdIItI6Vaw5mwVX9Wob5/5eVc2Yc31ROdIvIZn0G9MxNeXU/DDI
 hcDHFpjrp3N2BDo9xOc5etxemDCIgzLVD57KbgOVIXxwjYrUhZvVm0MUFBin8WKh4RuRYCJ0s
 SiFItiYnLHzanGfItUOjEmW4kzN1Ei7UNroH9M91ME6f0N8XRLS8YPUyRB4gtJzE9Ia31zIUV
 7wfsYqejLN3Mv73OQGzQqWhlGeGOQrjEw70IIxwbj0t6QoygWzeAAGCr/yMV1jqUHc1vQesU7
 pmufhAGzRCb1mNgZ4VDwz1rJLdX5x6DamnuTUE8BsL0ow7c3GUqi4UCswNuYWHmPPkUWpQmke
 uPylkm+TOxmwDX0Mp932V/JlCX5Bk0ttXhR2E89KKFQIvgOXhFgzkgj+ckIzlQ84Y9aw6ggYc
 IjhDjnRSHJBK4xUyarpshRVN7itmPa9doxWuFIe8URY/yssMa+3ugz3VUyohQAppWG8IWPJwr
 OxYGYFZNOGZBnY=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.09.21 11:20, Kalle Valo wrote:
> Shawn Guo <shawn.guo@linaro.org> writes:
>
>>> Is this not the usual DT policy, that missing optional properties should
>>> not prevent a device to work, that old dtbs should still work when new
>>> properties are added?
>>>
>>> I'm not sure what's the best way forward. A plain revert of this patch
>>> would at least bring back wifi support for RockPro64 devices with
>>> existing dtbs. Maybe someone else has a better proposal how to proceed.
>> Go ahead to revert if we do not hear a better solution, I would say.
> Yes, please do send a revert. And remember to explain the regression in
> the commit log.
>
I sent a revert patch.

Sorry for the delay,
Soeren
