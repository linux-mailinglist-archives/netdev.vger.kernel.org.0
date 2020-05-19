Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB37D1D9110
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgESH30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgESH30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:29:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9655C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:29:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i15so14588134wrx.10
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P9/K+jjZ7ATU2vdjvWdW3WXdSVdHtWWRvPFh5pgokZQ=;
        b=q8XgRyI7Ib8a6XMQX7hWNqQAyuqykcxgAHY9FKBS03dtcH7SWP57xu9MjMBbwZ2+nf
         IbSLMoQ2ymK9XFHjN4voqTrRB8vxgYWlx6+gt8sJHJSxAGo+qrvuBmHOkvHqnt8bVG5l
         XiZMmuvV/zFmzAo5qEqp1x2AWmR9TTgA5cgg8YkyMFQSfJ43g7BHpMWmnLHXxA1CJjak
         mAY2DFR7lmyO/AXT7vuCN9bjGZ7hrT0Jb92/oJdUqMpJvRWhRoaGY62zE8eONUb8oWO8
         v26DqoOIIdnplPRRSprxicNa4Wy2GLRDIw6+RvLUFBBterUj0Pqw57IxrxWYI7eA8uZd
         a2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P9/K+jjZ7ATU2vdjvWdW3WXdSVdHtWWRvPFh5pgokZQ=;
        b=F/YKsvJaJFRxhZeyoj3RUhQhCfy0i1TJ290+c9EXLZYOwj/hCzS8byTDhmTUHvGuqW
         ipkTAucqTv5t/xaWu0gW3afqYE+2Xe8ftq0iSWza60CiH352OUuZHSw3ao/+33CpEfKs
         IvJQmOquENQkrqFXsL1ipHL9Ex2AAAHQ7/CCt6c6MJSiAVRUvuQwFNVqU/zzX3tdzHaG
         uFDg1y8KAZ3Jen+5vv5TMHOTLdmMkdxk4/o4L0buvWvkNaF4/CEfxFQQXExTfs+rWknW
         EvA3d0695j2S6kxkk76npAL8H3IY75HyBQcBXuyzfRfk8Clo7zQKcce4P5CJbd4rGOid
         eS+A==
X-Gm-Message-State: AOAM532UpcOcA3unwc02jducdbMzfImQOPTPdwjOkW0PxJgT6c4ajuF8
        Qzq2PBSCYUbq4aagJmONqHGMZInrrEQ=
X-Google-Smtp-Source: ABdhPJzg/rPTz8eKSvFr2a983Wswe6UYCK8J0P5htoBC94+mfSf7yqh2sCA+vcGjqGniZMLnugy5aw==
X-Received: by 2002:adf:f5cb:: with SMTP id k11mr24219418wrp.300.1589873364513;
        Tue, 19 May 2020 00:29:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k5sm18974891wrx.16.2020.05.19.00.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 00:29:23 -0700 (PDT)
Date:   Tue, 19 May 2020 09:29:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
Message-ID: <20200519072923.GD4655@nanopsycho>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho>
 <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
 <20200519052745.GC4655@nanopsycho>
 <CAKOOJTxVbJ0QUCUz8JKDSJKoiQ8FecifbRRo9gcM8ijhDkA9HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTxVbJ0QUCUz8JKDSJKoiQ8FecifbRRo9gcM8ijhDkA9HA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 19, 2020 at 09:13:46AM CEST, edwin.peer@broadcom.com wrote:
>On Mon, May 18, 2020 at 10:27 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
>> >I am adding this param to control the fw hot reset capability of the device.
>>
>> I don't follow, sorry. Could you be more verbose about what you are
>> trying to achieve here?
>
>Hi Jiri,
>
>Vasundhara is not adding a mechanism to trigger the actual reset here.
>This is a parameter to enable or disable the hot reset functionality.
>It's configuration, not an action.

I understand is it not an action.

But I think I missed what exactly it configures. I still don't have a
clue.

>
>Regards,
>Edwin Peer
