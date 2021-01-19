Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC8B2FB23D
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 08:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbhASG5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 01:57:51 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:38971 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729386AbhASG4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 01:56:11 -0500
Received: from [192.168.0.6] (ip5f5aeabb.dynamic.kabel-deutschland.de [95.90.234.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 64D2520645D54;
        Tue, 19 Jan 2021 07:55:20 +0100 (CET)
Subject: Re: [PATCH 2/2] ethernet: igb: e1000_phy: Check for
 ops.force_speed_duplex existence
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeffrey Townsend <jeffrey.townsend@bigswitch.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John W Linville <linville@tuxdriver.com>
References: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
 <20201102231307.13021-3-pmenzel@molgen.mpg.de>
 <20201102161943.343586b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <36ce1f2e-843c-4995-8bb2-2c2676f01b9d@molgen.mpg.de>
 <20201103103940.2ed27fa2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c1ad26c6-a4a6-d161-1b18-476b380f4e58@molgen.mpg.de>
 <X/ShBVXp32Y+Jeds@kroah.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <19eab284-b7b0-7053-1aa7-5fedcee04263@molgen.mpg.de>
Date:   Tue, 19 Jan 2021 07:55:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <X/ShBVXp32Y+Jeds@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub, dear Greg,


Am 05.01.21 um 18:25 schrieb Greg KH:
> On Tue, Jan 05, 2021 at 06:16:59PM +0100, Paul Menzel wrote:

>> Am 03.11.20 um 19:39 schrieb Jakub Kicinski:
>>> On Tue, 3 Nov 2020 08:35:09 +0100 Paul Menzel wrote:
>>>> According to *Developer's Certificate of Origin 1.1* [3], it’s my
>>>> understanding, that it is *not* required. The items (a), (b), and (c)
>>>> are connected by an *or*.
>>>>
>>>>>           (b) The contribution is based upon previous work that, to the best
>>>>>               of my knowledge, is covered under an appropriate open source
>>>>>               license and I have the right under that license to submit that
>>>>>               work with modifications, whether created in whole or in part
>>>>>               by me, under the same open source license (unless I am
>>>>>               permitted to submit under a different license), as indicated
>>>>>               in the file; or
>>>
>>> Ack, but then you need to put yourself as the author, because it's
>>> you certifying that the code falls under (b).
>>>
>>> At least that's my understanding.
>>
>> Greg, can you please clarify, if it’s fine, if I upstream a patch authored
>> by somebody else and distributed under the GPLv2? I put them as the author
>> and signed it off.
> 
> You can't add someone else's signed-off-by, but you can add your own and
> keep them as the author, has happened lots of time in the past.
> 
> Or, you can make the From: line be from you if the original author
> doesn't want their name/email in the changelog, we've done that as well,
> both are fine.

Greg, thank you for the clarification.

Jakub, with that out of the way, can you please take patch 2/2?


Kind regards,

Paul
