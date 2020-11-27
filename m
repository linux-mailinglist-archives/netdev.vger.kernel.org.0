Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B0C2C5FD3
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 06:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389213AbgK0Fl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 00:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729830AbgK0Fl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 00:41:29 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2685C0613D1;
        Thu, 26 Nov 2020 21:41:27 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id d8so5432694lfa.1;
        Thu, 26 Nov 2020 21:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=jTbdJPLCPCmKC1sQucjkCurKOKfvRNOl0rPRqRFsYFs=;
        b=lFl6N3Dg+QQ82za+rkFQ0TN+wf6XTCAJuruvQ/rrIsW+JH+D44/zJlOW3SqcRKZIzT
         lrRUUZPKbtB2kqYAq+AG/QGqZnD3PXXa8rUpw0vPmd3QOKe8zCEtDvYkazvF7Y4BEMAL
         9uMKD7Um+UjqidjIlmJB1Gz24rF2LRwt89wKJlaBEOvo5X67mE2q44rxEr+e0Gzfr8P8
         Km+FaG/xOR4VkuWgezqfjuDohMKNDO928+38/BHAOd2G36s7mO7/NdYODdGc5YzNI4qd
         j7Mmc3ReOCJX5xWGgLsjyniTKsBTL7SfoyFF+ZZ6UJxdrXfpCVrG0BJWXM49wLTuMUWg
         LGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=jTbdJPLCPCmKC1sQucjkCurKOKfvRNOl0rPRqRFsYFs=;
        b=Rseq4T825vTcZ9fY5qZbdG86OABoDRlcwN33GBHkV3qpb+jsOSus7qTEUb1G6ErWRB
         BFGBbw9K69KnRw8BP5+gfAKRAvEhSg9ljkautRGI9q6U2oDTuM99wJt9sgJdDtQ8nTgq
         IK7whHO7pgsJINrbZF48N6qhqoxOFB5wOnJAt2fjFnikNixLwVWarriTnn4Vm4ZBdqeG
         AD9YaVz6y49nzS7vmjKtfF5Mb1+9dYFV4cN9lz53vz8v30+p9cm+S0InrGzTumSCh08z
         t/JnCA80m1gTLuC1AkDlEvaAWbNAC+3f9W3JIrawXsT47QRG5z7ozBKzNSMxcKSZErTj
         RxZg==
X-Gm-Message-State: AOAM530jLHLYZY1zpi299V3B9hv1ojZTytrwrSGUC7xzWZh3D4V5uS1c
        GFHLzU/tG7mwzwhDEs3Oxf6jn76lnFTlOHcKHxY=
X-Google-Smtp-Source: ABdhPJyAeMEzfdGrvJT9b5AUNWayhzIAW5+4r+WiiKzD3LJnSTc5sziUMYp+pVfE4rkRvctYI3pCNM0lKqC81E7N614=
X-Received: by 2002:a19:f60e:: with SMTP id x14mr2458236lfe.199.1606455686176;
 Thu, 26 Nov 2020 21:41:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9a:999:0:b029:97:eac4:b89e with HTTP; Thu, 26 Nov 2020
 21:41:25 -0800 (PST)
In-Reply-To: <CAEx-X7esGyZ2QiTGbE1H7M7z1dqT47awmqrOtN+p0FbwtwfPOg@mail.gmail.com>
References: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
 <20201126170154.GA4978@kozik-lap> <CAEx-X7esGyZ2QiTGbE1H7M7z1dqT47awmqrOtN+p0FbwtwfPOg@mail.gmail.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Fri, 27 Nov 2020 14:41:25 +0900
Message-ID: <CACwDmQA5acuCpUcjf7Q0biG9KnfK+3WGjTDbDaFpnMMMhBv9sg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] nfc: s3fwrn5: use signed integer for parsing
 GPIO numbers
To:     krzk@kernel.org
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/20, Bongsu Jeon <bs.jeon87@gmail.com> wrote:
> On Fri, Nov 27, 2020 at 2:06 AM Krzysztof Kozlowski <krzk@kernel.org>
> wrote:
>>
>> On Fri, Nov 27, 2020 at 12:33:37AM +0900, bongsu.jeon2@gmail.com wrote:
>> > From: Krzysztof Kozlowski <krzk@kernel.org>
>> >
>> > GPIOs - as returned by of_get_named_gpio() and used by the gpiolib -
>> > are
>> > signed integers, where negative number indicates error.  The return
>> > value of of_get_named_gpio() should not be assigned to an unsigned int
>> > because in case of !CONFIG_GPIOLIB such number would be a valid GPIO.
>> >
>> > Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC
>> > Chip")
>> > Cc: <stable@vger.kernel.org>
>> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>>
>> Why do you send my patch?
>>
>
> I think that your patch should be applied before refactoring for this
> driver.
> So, I applied your patch to net-next branch and included your patch at
> my patch list.
> Is this the wrong process?
>

Sorry to confuse you.
I found your patch when i updated my workspace using git pull.

>> Best regards,
>> Krzysztof
>
