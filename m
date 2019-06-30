Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373705ADD8
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 02:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfF3AO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 20:14:28 -0400
Received: from mout.web.de ([217.72.192.78]:41609 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfF3AO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 20:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561853655;
        bh=y0nA3tXsogstQ27IaLUCm30ZweAG3NlBkIABrgw/ptg=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=J6MP+C8mpQ4A/GD1lRN1fOi0LcabqjXyu61SMMvPyfhM/p6rPDBdunQXLbstsW2+d
         gYj/buEPWXUSLqi9MkCJZv+KWo/XTe1vrDTfeL9OrpHyqg7mYCmH2MKvWbkeJSYXdQ
         UmO2/ykkP7oS21f5D88xshBOCEijhQuHIg61JtxQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.3.100] ([84.46.37.29]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MJTZX-1hik853toh-00328w; Sun, 30
 Jun 2019 02:14:14 +0200
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com
Cc:     netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
From:   Karsten Wiborg <karsten.wiborg@web.de>
Openpgp: preference=signencrypt
Message-ID: <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
Date:   Sun, 30 Jun 2019 02:14:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:jmpcrGZ0PEDjYVnIXmJrWopK8JSwgCRDsEMo0/hxI+KrgPnqpIe
 2lGkksdC/1089lS7R8JtMfI74pucFor3ZChtqVuzGEMDO9BeCW4qNfRK0k/xpy728Oh4g3h
 assqeTZUkgBAzQNM+WuJTi0ypzMZk8eKu9t0LbbcK4LgIm8As2NCkK+Pe2V50THbgozW8k+
 YqQfNCqkilj0ypQJjYEiA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:V4pRCijkdrs=:rLplpH3eW7TyLW1c3fE3g8
 WVi+J31HPCgZFi35VQKVTrCSxiuq3OMrxKrAw3AQ5AkVKJysqOgi7ALHAZ0pzSjKWfUKGTWNu
 My2+ZGis+IOBnktiChfOMluPd3y3ga2AQKyKz3XyjuTxt1E+jW9YFXEV2ZBpYevaImYkdYWgc
 rvlzBTtCVHCBloGBvQzqBraSjiyTdKgrAJt3Udr8zWVc+zx4HtafmwbgfktDkFHUN/KVoK/oV
 MtjRcJ/FiBnJY0s2rJpPrie2jlIcTqyLBZI2bcGlETULYJz0XEGngAv7zDxqe3UmNuqx+Prfc
 D6z7lGT5vYydNuPxHL788JHlQIhYSwwhRlaMvUPXI5RBtgm2goVp4YxRGBTpZVT3AJbEEXqVv
 4BDFbJEe8dxkSynyLKJKvGS33aBJ04u6iipUItN27/FIgdWHNEFIBfYeoXfJIQe8luVIrgaZX
 SgFvGnzU4a1FZegHOmNRRI1MiLfHKE7uGTOMElLmW4vmRBlvePeu9c4QkrfXtffEKF7WgUxAa
 dadhplufxiwmzwFkpP+8vWb1r1LaB2z9Cm9eBsBhdQGV40FtlZm7tqMGysWJ7mIwdp1uztsMj
 OEJogrd91s78X2h47uEVH3lATYe3pmKeeM46ibrce2IjSfKmwAD+sXBQxlVwhrSbQVxd5SwzU
 86SINhT4xQncxFrJOxLnF+s06yV71ZbplfZuLjIvX22XeaDE9VpMmyD5IdYKPQdJwcTaKnWCx
 y2M3+NC+FJPt/z1GdOaTaW3pREp+HS7XKWqhh55Xnrc31oaRhCiyr1toMpy2HnUPRd71x/gD1
 aK3/qceS2aB7jD8HjJRRCtT0nPFPFI+TQlBbFjH3QwBl2d2zBflOILtjkUW5pWn6sC5qR/tlw
 WwQp6zdgV8IrEa+aVEDWzPhVhHbaNNqNdBsz2r5RuBr1rULhOmFfRyidGH+LJTbdDu2yAGNED
 uJTTXFIRwjnrfl/UDonkXXHsQMp+8IHALtNtPwixhxikPQdzHN7BGxwopQEjnbJlvIvi7jLHP
 YDQ6+FXtjt9feXQyzkk+c0bkKXQhWli2wthM6qu52zfqtMtHO/nDKx8ArlzPjhKXeHdAQT9M8
 ZfEUBi0+iA+Z2FFDAr+Xe2L8VLOvM3tqEze
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

thanks for the speedy reply.

On 6/30/19 12:09 AM, Heiner Kallweit wrote:
> If r8169 (the mainline driver) is running, why do you want to switch
> to r8168 (the Realtek vendor driver)? The latter is not supported by
> the kernel community.
Well I did install r8168 because r8169 is not working.
Didn't even get to see the MAC of the NIC.

>> 2: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group
>> default qlen 1000
>>     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
> Seems like the network isn't started.
Jepp, that is the output from the r8169.

Regards,
Karsten
