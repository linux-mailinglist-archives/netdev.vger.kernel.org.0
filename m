Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C822608F7
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgIHDYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgIHDYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 23:24:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89456C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 20:24:17 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id v15so9058855pgh.6
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 20:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hk2onWbIeXwajOVtABKbeyGyntomXoHMbYFJEtUeYaA=;
        b=fnR5IWMBBXt/aTw77zYEyJYGccNyt6WrI30TcG3CqSsQJILdRfcVg5J4y3bC7Zf58Q
         Y/rF1K63XbXZltAA6qLuFfod/fcZfb3VDcgt4moTtfS3kj70aGBkIl/p3xD2SWGFuTjB
         82j+AX0Kw7igzlt4qbwYyDhhaB5vgWc7zFV57pefdq8OsHBzKhFHgT+hOrZRHcVX11Fd
         966/enEz9NtzonUy956HyJgujeOMyjt0Ef0xfbeafFZ39msfYTN0XqLnZdcXDT97hblQ
         /YIuusKoqyG1pf8zjDY9l2J7ixo1/Z7MHCR3APGyNRK+lce3rV1kiD+9aUyLqr2sioPF
         OHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hk2onWbIeXwajOVtABKbeyGyntomXoHMbYFJEtUeYaA=;
        b=L/hfuZZdLL6JbygZG9TQU2RxD8aZzB0KIsHWZTRTA83OMx4/CTPz8eVvxKXDpBmGRu
         odSJX27wCnZcvavmlb3b1d9x5WazCYADxt3Nnqv2Mc2L0CzKwlDpsdmSeiUI0BIXNU8D
         ST1QKaIuvi0/nJgqUsUjBmKKlKdE5h0JMxmXSB17Qlh6W6FcZjC15/TILMkQ+sBOUCzr
         FzqdxGU4qoUj0PSTplnlNC9PI42DOqHZwW9oYyFcgF5n0SwxhnSXGDLfjQUmOGSISH1a
         Zh+O+gB0JpP0FtSFh2kkg5EhgFGR4ahnSCMMm5XGKh9Ev5QGmxWcp52N0g31vCngAdkc
         iRjw==
X-Gm-Message-State: AOAM531oLXaei8bZ4IY68FEcaVUBU2FRc7rQklK72vQN+7Xtw/UQhp8s
        GqQa1sCEUfxBbOV0crfl/8w=
X-Google-Smtp-Source: ABdhPJyoOwHsW8sB/otOOYsq1a0wd9yYHXbat805TpPHIliZOgjEDP4GPMeZyO4SidiitLq2iyKjWw==
X-Received: by 2002:a17:902:d210:b029:d0:81cc:a649 with SMTP id t16-20020a170902d210b02900d081cca649mr20581171ply.1.1599535456823;
        Mon, 07 Sep 2020 20:24:16 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a13sm13825568pjq.36.2020.09.07.20.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 20:24:16 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/7] net: dsa: mv88e6xxx: Add devlink regions
 support
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
References: <20200908005155.3267736-1-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0400390b-a31a-578d-e882-2bc142786fcb@gmail.com>
Date:   Mon, 7 Sep 2020 20:24:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200908005155.3267736-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 5:51 PM, Andrew Lunn wrote:
> Make use of devlink regions to allow read access to some of the
> internal of the switches. The switch itself will never trigger a
> region snapshot, it is assumed it is performed from user space as
> needed.
> 
> v2:
> Remove left of debug print
> Comment ATU format is generic to mv88e6xxx
> Combine declaration and the assignment on a single line.

Andrew, can you run scripts/get_maintainters.pl for your patch 
submissions and copy the various DSA maintainers as Vladimir who gives 
valuable feedback? Thanks

> 
> Andrew Lunn (7):
>    net: dsa: Add helper to convert from devlink to ds
>    net: dsa: Add devlink regions support to DSA
>    net: dsa: mv88e6xxx: Move devlink code into its own file
>    net: dsa: mv88e6xxx: Create helper for FIDs in use
>    net: dsa: mv88e6xxx: Add devlink regions
>    net: dsa: wire up devlink info get
>    net: dsa: mv88e6xxx: Implement devlink info get callback
> 
>   drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
>   drivers/net/dsa/mv88e6xxx/chip.c    | 290 ++----------
>   drivers/net/dsa/mv88e6xxx/chip.h    |  14 +
>   drivers/net/dsa/mv88e6xxx/devlink.c | 686 ++++++++++++++++++++++++++++
>   drivers/net/dsa/mv88e6xxx/devlink.h |  21 +
>   include/net/dsa.h                   |  13 +-
>   net/dsa/dsa.c                       |  36 +-
>   net/dsa/dsa2.c                      |  19 +-
>   8 files changed, 807 insertions(+), 273 deletions(-)
>   create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.c
>   create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.h
> 

-- 
Florian
