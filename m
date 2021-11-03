Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB78A444B97
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 00:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhKCX2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 19:28:13 -0400
Received: from mout-p-102.mailbox.org ([80.241.56.152]:53176 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhKCX2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 19:28:12 -0400
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4Hl2tz34SczQk2Y;
        Thu,  4 Nov 2021 00:25:31 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <f688d90c-f625-7b10-fde9-769bc1d49334@v0yd.nl>
Date:   Thu, 4 Nov 2021 00:25:22 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] mwifiex: Add quirk to disable deep sleep with
 certain hardware revision
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
References: <20211103201800.13531-1-verdre@v0yd.nl>
 <CAHp75VdmynnjFnmxy5ebJ44BpikYt+WaqEhVB6qkftVHGoa2FA@mail.gmail.com>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <CAHp75VdmynnjFnmxy5ebJ44BpikYt+WaqEhVB6qkftVHGoa2FA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2A43F264
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 22:50, Andy Shevchenko wrote:
> On Wed, Nov 3, 2021 at 10:19 PM Jonas Dreßler <verdre@v0yd.nl> wrote:
>>
>> Fourth revision of this patch.
>> v1: https://lore.kernel.org/linux-wireless/20211028073729.24408-1-verdre@v0yd.nl/T/
>> v2: https://lore.kernel.org/linux-wireless/20211103135529.8537-1-verdre@v0yd.nl/T/
>> v3: https://lore.kernel.org/linux-wireless/YYLJVoR9egoPpmLv@smile.fi.intel.com/T/
> 
> Not sure why you ignored my tag...
> As we discussed with Bjorn, it's fine to me to leave messages splitted
> to two lines.

Whoops, sorry, that wasn't on purpose. I'm still not really used to the whole
email workflow of the kernel...

> 
>> Changes between v3 and v4:
>>   - Add patch to ensure 0-termination of version string
> 
> 

