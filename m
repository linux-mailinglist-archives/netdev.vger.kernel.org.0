Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B237231421
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgG1Unn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgG1Unm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:43:42 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683A0C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 13:43:42 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k4so10612988pld.12
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 13:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=YXT78Tt/ShNPLgsntxfIPeSXGRz+CqhgWhtK/HlJk4Q=;
        b=gwCf1GJarAjr9IOqOpg4OMwl2b5TJ+gYzmu7cThQ4zj+wwsnLQrURIu5D1FZzFj0fs
         R/TjfzS/jQz6shIeekSkKDfItAbAyHxCjMJmRLuNUDuciBDA8A0G2923BuU7VVnFqMk2
         dBk5LlV1SW++wBf7W9SHpo1d3zClqxaSw9NdjCG78HaBC8dXKKL2JL5qvDIZBswHOZqs
         XoEc5y8Q4WAuzWJVCoCZrx1q1yWwg/uLy9pdUoBOPhCFMwYziy9CR987RN8FTZD4nqkX
         sn472XwuJw4kWtxATLTrV9h815XswJ1GhnTx84yr/c0+B1i11YSkfrHXRL7UkbMSzKna
         OxqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=YXT78Tt/ShNPLgsntxfIPeSXGRz+CqhgWhtK/HlJk4Q=;
        b=a/e+du7zZ8X4b5uaT0esxMdY0efBVmmYuxQWofNzxqNaXwSl+TF9mCkaNjDIh5rPEO
         JF83gxunbD8nHHXexCletClgRuqSGR0z04PxN4RbXEq+40ftAL4m6hgnINupL9Ctu+AR
         68coDLHQrw6eDNEd/HjjJit+nBcWd8IUGGVxRRXUkmfDAhFBsfmp+qSi8pqqHf7peDlW
         g0QoYaOUrbpAJ3Gd+CBXGOelRqeiDtnD+3U82ErUKwE9M9c9RdT4RwosTDNz0sbjSB5U
         s+oJDG/TuzSmIgqekk7Njg0fHnjhlKGxLLy5NTZreNZmJlFeaWu25QuKrIydRNTKxdj4
         MEdg==
X-Gm-Message-State: AOAM530i3HjIxs2gpAIkloFKc0kck/5deKoEIcL+MuFj7fJg/Sgt6HXI
        GynBuu6eNuhKmtHbZcLrtkp6bkaQ
X-Google-Smtp-Source: ABdhPJyBol7owL6gEOAs9t5LrgyPzB2T+QB6RJ8TJx2+pJrZ9vbD8aMtM+PhdK5wxCRIfyDud/vzWw==
X-Received: by 2002:a17:90a:8506:: with SMTP id l6mr6199987pjn.139.1595969021881;
        Tue, 28 Jul 2020 13:43:41 -0700 (PDT)
Received: from [100.108.30.118] ([2620:10d:c090:400::5:d1c2])
        by smtp.gmail.com with ESMTPSA id t19sm3008057pfq.179.2020.07.28.13.43.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 13:43:41 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Stephen Hemminger" <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH v2 00/21] netgpu: networking between NIC and GPU/CPU.
Date:   Tue, 28 Jul 2020 13:43:40 -0700
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <7D130AAD-B062-4C52-8C31-49EF11146745@gmail.com>
In-Reply-To: <20200728125513.08ff7cf7@hermes.lan>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200728125513.08ff7cf7@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Jul 2020, at 12:55, Stephen Hemminger wrote:

> On Mon, 27 Jul 2020 15:44:23 -0700
> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>> Current limitations:
>>   - mlx5 only, header splitting is at a fixed offset.
>>   - currently only TCP protocol delivery is performed.
>>   - TX completion notification is planned, but not in this patchset.
>>   - not compatible with xsk (re-uses same datastructures)
>>   - not compatible with bpf payload inspection
>
> This a good summary of why TCP Offload is not a mainstream solution.
> Look back in archives and you will find lots of presentations about
> why TOE sucks.

I.. agree with this?  But I'm failing to see what TCP offload
(or any HW offload) has to do with the change.  I'm trying to do
the opposite of HW offload here - keeping the protocol in the kernel.
Although obviously what I'm doing is not suitable for all use cases.

>
> You also forgot no VRF, no namespaes, no firewall, no containers, no 
> encapsulation.
> It acts as proof that if you cut out everything you can build 
> something faster.
> But not suitable for upstream or production.
-- 
Jonathan
