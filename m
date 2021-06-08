Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDD23A067F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhFHV7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbhFHV7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:59:16 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0600BC061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 14:57:11 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id d2so24848409ljj.11
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 14:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=jX6DjFCNfQrcrC4O1qoASN1CYNBq2BvhPJCp9VXlGew=;
        b=YBDxfB7zI+ESqPFXX/DVzkqpZHLoFfheLQt+MmNMvWkrHndDQDpgCu7FWAkYQVVNRP
         s5eiJqgUF/KIrxujuxghnHSWvT3zah+eL7F16piKzXrRo4fLl77AvYORx7BsaThRruAM
         VkwtiWi8FVGL2QwULu20JRmf3NjGB6V2MgguV6pRmiuyN+SVAeG6joI1WMqLq5xOIwHq
         xdTys0ZlijqGWeIErWJUfPpTZ+EjobWlh5OMIROHGIqfmaOvln1srwXlSKGgvbMfHZyo
         /Cg1dOuErMu+XB7CB0768P9jqB2nvG0SCmhpYZOEsaqQgEVkiLggIR95zxUvFUdXT4Aq
         y7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=jX6DjFCNfQrcrC4O1qoASN1CYNBq2BvhPJCp9VXlGew=;
        b=qHClzJYsdufNjjK6j+ViCQfX7iqut8BjeOgX5FnFcXCNZIt3q5vmrsJMBRdbPB9iAw
         VBWKikImvs/soV/xfXq3PSfwGvzSCkyrB8o9uEq6DqoVlPOnIgJSd7uC3IJZti39nydK
         jP5gdXXskWw9kr3ZCE7yA8EDOrzJfHG6ztCo6swWSwYDeYbYjMuP4goqm1WQtWI5asCn
         pp4m7JbN9so909Np7vZnpl3I0Lc1TzjvOkSK2Fw+0oaa6jkleIe7ouAJyQNd4orb36yu
         wXyOxU3iUh0SAYDm0HfmMK78gzdsJXsFe8PqmmGAeYjqWIICkcTJgxrXv07ZREG/Zg59
         1g+A==
X-Gm-Message-State: AOAM530d+DD5jRh2wllusms2P+xyxS3CHlnF06mh+0ZmzAjbsi51joeq
        PM5ZoodPpPsjUv8MTThCTVc=
X-Google-Smtp-Source: ABdhPJz8L5yxtWbkm93dEgLU8V/T6S49ufwLxc1UQKJ+nRHkSoAQQef90XAGbmhgjOi921uEv4QpPQ==
X-Received: by 2002:a2e:b166:: with SMTP id a6mr3545692ljm.4.1623189429390;
        Tue, 08 Jun 2021 14:57:09 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id f11sm107574lfk.9.2021.06.08.14.57.08
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 08 Jun 2021 14:57:08 -0700 (PDT)
Message-ID: <60BFEA2D.2060003@gmail.com>
Date:   Wed, 09 Jun 2021 01:07:41 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     netdev <netdev@vger.kernel.org>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com> <60BEA6CF.9080500@gmail.com> <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com> <60BFD3D9.4000107@gmail.com> <CAK8P3a0Wry54wUGpdRnet3WAx1yfd-RiAgXvmTdPd1aCTTSsFw@mail.gmail.com>
In-Reply-To: <CAK8P3a0Wry54wUGpdRnet3WAx1yfd-RiAgXvmTdPd1aCTTSsFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

08.06.2021 23:45, Arnd Bergmann:
> The idea was that all non-rx events that were pending at the start of the
> function have been Acked at this point, by writing to the IntrMask
> register before processing the particular event. If the same kind of event
> arrives after the Ack, then opening in the mask should immediately trigger
> the interrupt handler, which reactivates the poll function.

Ok, it works, indeed. The overall bitrate seems lower somewhat.
I'll re-test and benchmark some few variants (e.g. with and without busy 
loop) and report my findings.


Thank you,

Regards,
Nikolai

