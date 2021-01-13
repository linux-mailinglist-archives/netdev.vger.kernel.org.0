Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA5C2F4455
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 07:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbhAMGHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 01:07:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:44840 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbhAMGHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 01:07:31 -0500
IronPort-SDR: EVvHc23bn1xCsPXZgIxFbtuGH/OwrtbXy+tYPadhvVxz7SUZpZupXIvmVwSRvsDB3Vas1TFNCh
 93aCHoq9/UlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="196790353"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="196790353"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 22:06:50 -0800
IronPort-SDR: s7mv/kilUT1izL//LEJx2iNlUVtCR4x26PEZgILlkjvyW9Yp8ARiBjnTy3HSNv9ebHO3POZDUA
 JqChtI4pOMsw==
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="381720516"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.117]) ([10.239.13.117])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 22:06:47 -0800
Subject: Re: [kbuild-all] Re: [PATCH v10 1/1] can: usb: etas_es58X: add
 support for ETAS ES58X CAN USB interfaces
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        kernel test robot <lkp@intel.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>, kbuild-all@lists.01.org,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
 <202101122332.Z7NglWp9-lkp@intel.com>
 <CAMZ6RqJNQ8MtLYu6i0Q3POBFYVrnFh3bUjiQC57vv-UqArCLfA@mail.gmail.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <bb840aed-5b48-432b-cc12-6ffb9d41ca03@intel.com>
Date:   Wed, 13 Jan 2021 14:05:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqJNQ8MtLYu6i0Q3POBFYVrnFh3bUjiQC57vv-UqArCLfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/21 11:13 AM, Vincent MAILHOL wrote:
> On Tue 13 Jan 2021 at 00:29, kernel test robot <lkp@intel.com> wrote:
>> Hi Vincent,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on linus/master]
>> [also build test ERROR on v5.11-rc3 next-20210111]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
> The patch is applied on linux-can-next/testing. All the warnings
> are related to the latest drivers/net/can/dev API changes.

Hi Vincent,

Thanks for the feedback, we'll try linux-can-next/testing next time.

Best Regards,
Rong Chen

>
> I thought that the test robot only checked the
> linux-kernel@vger.kernel.org open list and I didn't bother adding
> the "--base". So this is my bad, sorry for that.
>
> Because this is a false positive, I will not send a new
> version (unless if requested).
>
>
> Yours sincerely,
> Vincent
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org

