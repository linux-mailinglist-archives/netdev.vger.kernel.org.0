Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E2D395236
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 19:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhE3RSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 13:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhE3RSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 13:18:47 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B9EC061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 10:17:07 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id i9so13144135lfe.13
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 10:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=ejvNcuuzF9OhY79csg8yJ5jtab4D6vkFbIn5TzbaVsg=;
        b=n2mbiG+t1QL8DJ7TMM5tx6Hy6Vq2OWsBGwUzUmqbtTeLAUCBEOgDE2t870SXHjQqU2
         W0+MKvmiZNg1WSSmXE+027/2SoI1cnG/MGRVfWpcXzGxAJ764PwFfu6YpefpwiPSstft
         YedThenfmThQ7UKy+HxWxTnDpBuSdHXDtEo6IaQx+mANMIGUWROoIh5VrrScsS6cr9ga
         qTvruIZNCFDxL1itjFc9935LMYf0jrev3ZeHgLTX8WzpmnNgZf88nBT2vdjAp8sqfMqw
         eKpY0wUCamQJGto1fiDGK4wOiA021FxSdkQQ1172tONVn/jt+lKxXL5eDkL5WR7jUxVr
         g2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=ejvNcuuzF9OhY79csg8yJ5jtab4D6vkFbIn5TzbaVsg=;
        b=RPc3GowbOxKwuQ7qjB/CcFUccNFxF9pqtSVq56c/BXR1vjAnhZuEnSk6dbA7f1p41f
         K55SODKEjYNr/KwkqpZsdBLIS28B9fkbMwJa1mnpcpHarmaUrVJB4uH6qOSjW5f34gb2
         jZQ4vBpIQ50CS2uNUDrzI8ksSNAk6A4EGjO8vi9MmVPyjqI2CMhSeSmw1jDV3TiUoJre
         6MC6b+XXKW7IH/3FcKwIRixg9gI0rR0OE9x0paZuPWOJgYdlsXrNXJZtI0ZooWhSIR5d
         AYzMJdSrLgYG93ciXEsxJWuF6DpAt/3afH+8YalyD6H2QNDEkhTCe0AJo8KT1IghkoDh
         ri5w==
X-Gm-Message-State: AOAM532udyLUeb/CyhUA1/8cz1rV13l+viZ2bSZRKTVu/lHwmYeblmv1
        JyuVkvb5atvCkOOBTuIFTPz2qah4ZDxlg6+h
X-Google-Smtp-Source: ABdhPJyHKUbr1+giXArH8eODScjtMu1lAX55eSusl/Thelb1+1ah0Fj7/i4s2A1cekCfuGOBQM8MXA==
X-Received: by 2002:ac2:4294:: with SMTP id m20mr12500439lfh.6.1622395025591;
        Sun, 30 May 2021 10:17:05 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id u13sm1284389ljk.133.2021.05.30.10.17.04
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 30 May 2021 10:17:04 -0700 (PDT)
Message-ID: <60B3CAF8.90902@gmail.com>
Date:   Sun, 30 May 2021 20:27:20 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     netdev <netdev@vger.kernel.org>
CC:     tedheadster <tedheadster@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, whiteheadm@acm.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com>
In-Reply-To: <60B36A9A.4010806@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

30.05.2021 13:36, Nikolai Zhubr:
> So, 8139too 0.9.18-pre4 as of kernel 2.2.20 is the one that apparently
> works correctly here. I feel the bisect is going to be massive.

It appears the problem arrived between kernel 2.6.2 and 2.6.3, that is 
respectively 8139too versions 0.9.26 and 0.9.27.
Unmodified kernel 2.6.2 works fine, unmodified kernel 2.6.3 shows 
reproducable connectivity issues.

The diff is not small, I'm not sure I can dig through.
Any hints/ideas greatly appreciated.


Thank you,

Regards,
Nikolai


>
>

