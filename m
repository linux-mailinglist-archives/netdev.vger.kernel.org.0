Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF0F44BDC5
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 10:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhKJJaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 04:30:06 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:42339 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230037AbhKJJaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 04:30:05 -0500
Received: from [141.14.13.160] (g415.RadioFreeInternet.molgen.mpg.de [141.14.13.160])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 43F7161E5FE00;
        Wed, 10 Nov 2021 10:27:17 +0100 (CET)
Message-ID: <38c47f1b-f153-6c79-2ec5-ed4332c52f6c@molgen.mpg.de>
Date:   Wed, 10 Nov 2021 10:27:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [Intel-wired-lan] [PATCH net] iavf: missing unlocks in
 iavf_watchdog_task()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jakub Pawlak <jakub.pawlak@intel.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>
References: <20211110081350.GI5176@kili>
 <89022668-5c63-bf19-a768-6bef2a3be3b0@molgen.mpg.de>
 <20211110090557.GL2001@kadam>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20211110090557.GL2001@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Dan,


Am 10.11.21 um 10:05 schrieb Dan Carpenter:
> On Wed, Nov 10, 2021 at 09:53:50AM +0100, Paul Menzel wrote:

>> Thank you for your patch.
>>
>> For the future, just a nit for the commit message summary. Could you make it
>> a statement by adding a verb (in imperative mood) [1].
>>
>>> iavf: Add missing unlocks in iavf_watchdog_task()
> 
> Imperative shmeritave.
> 
> When subsystems get taken over by fussy bureaucrats then I only send
> them bug reports instead of patches.

It was just a wish as the standard commit messages follow that format, 
and any verb could be added. It’s not a requirement to my knowledge, and 
I do not have any authority anyway. Sorry about that, and thank you for 
your patches.


Kind regards,

Paul
