Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6714B397D05
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 01:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhFAX2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 19:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbhFAX2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 19:28:47 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E924C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 16:27:05 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id u22so159325ljh.7
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 16:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=LxhJNLbL7zy9P78thi+FO/rz6BLUObpyILXwuDbH/vs=;
        b=GItBkRCz4DaFw75ju2VE63etRJd7q1fG5+CXBEPpb/V8BUi8D8UMjUubcL0wn/qrw7
         yA1434EtBVDx0pohnQcYV8cgqU8h70OovryFIxvuzvBb5z5Z0qdHYXTYhxuKqkBSxSAu
         uQvoNowlaJY+noPuTceudaHOYf2kwQicpZZBzSHzxvv9gtruzLL1vBSTlrCxr1pjo17Q
         QPyJSkr3y0T2B6shsP7n+ujCpiQKL8mJwr8F8HQBIMe9RTTGeilNBhvlRru8JuOgVbwE
         mH3YgIdCUpQxc5HUYRqmVDvXrbbr21m2fvtLQJ44c7AIVNcEila2ZJ1g9svk2KiU71Tm
         57zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=LxhJNLbL7zy9P78thi+FO/rz6BLUObpyILXwuDbH/vs=;
        b=lCGaHVryI+muMSkS4BMqHKGTpNpkxfiAZgtRAJwlbhWfDiFCiwSqoAtgciD4QlLifM
         f2JI7BpV47i0z+9G+XYmOVhDjkj2nKOPfk7eqbAzBHwxroMA5eIF12TH8vKvSgYLr9uM
         Uq0AZBSP7X846gSMcCtehRLM6GIn2BNk0VcfT5XRdOcXNW33LoRWZbMnbgoX99xC4Lmn
         MxcfD4ENkAiMKqYMPDK82pwHQkHrvTxfJPhAZVLL1M8UAxiXELl09Z65uCitUZ7P9y2d
         jHh9C8CxOIX+aGKFhHLdRj7Dhn9YyghrrWzkAXd3SPHg6xC9NfQZHnQ1IyMHOcepzxJL
         wsNQ==
X-Gm-Message-State: AOAM532qCPu70xIbMVVOm/wmY2hfE5o/kWZV0Zc8NhfdY2ErKrYGkvv4
        69Gc/c7AAf/rpPXGx3ZwZ2w=
X-Google-Smtp-Source: ABdhPJwUrJaT5HcdxcMbm04cbilT/tk1TufkAbIs6A7KxzlfvTzHJJ5jWr6T2EVqKYUaE/Vm02eG5g==
X-Received: by 2002:a2e:9f49:: with SMTP id v9mr23174181ljk.15.1622590023563;
        Tue, 01 Jun 2021 16:27:03 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id n130sm1982220lfa.10.2021.06.01.16.27.02
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 01 Jun 2021 16:27:02 -0700 (PDT)
Message-ID: <60B6C4B2.1080704@gmail.com>
Date:   Wed, 02 Jun 2021 02:37:22 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     Arnd Bergmann <arnd@kernel.org>, netdev <netdev@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
In-Reply-To: <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

02.06.2021 0:48, Heiner Kallweit:
> Driver 8139too has no maintainer.

Ups, indeed. I just looked at the header and supposed it has. Sorry.
(I do not touch kernel development much, usually)

> who are paid by somebody to maintain all drivers in the kernel. That's not the case in general.
> You provided valuable input, and if you'd contribute to improving 8139too and submit patches for
> fixing the issue you're facing, this would be much appreciated.

Ok, it is a bit more clear now.
I'll do more testing/searching/reading and probably come up with 
something then.


Thank you,

Regards,
Nikolai
