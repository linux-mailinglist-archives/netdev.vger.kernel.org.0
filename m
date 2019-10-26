Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E351EE5DBE
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 16:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfJZOxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 10:53:16 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39971 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfJZOxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 10:53:15 -0400
Received: by mail-yb1-f195.google.com with SMTP id d12so2282649ybn.7
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 07:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=wLHc6xVX23o25w4Uy9ZLDreD0/areLd8xcc6Rj0gcMg=;
        b=HajS5JbS8EXetkchiaF3YsegrCmtAr/EW1fKR/MzhFiOvcksA0HLZawzf7USJXCB/C
         kN/PyvC8NJZu63XNxod/1LF9QicoVoB/iZg2bHJ6bo87/oFLzMJQy4YQUPDEaC+lOCme
         Jp2422X0PmOby+bN+KxbBy0P0XoMNh/8CQPctaNXL60jJhna+Ub34BS1tMO7Aht9fuyi
         giTGkZWvqIKDezJFy16jpTBPypOj3+A4PEh28clrtUoW4x8wp+PPp8L6plYcpiLunTs3
         rAPFwDn6Ly8aoEwp+U6tLdtLCqEsyiCR44wD8GS/S3sU44NXTWRZzaMvhwAIH2y0sd1j
         sQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=wLHc6xVX23o25w4Uy9ZLDreD0/areLd8xcc6Rj0gcMg=;
        b=A6XXtTHoB0p9j5A4EFnQ1z9Q8dQHdxLfUsPbC5Xx516rfAGzrJRw5PZqdC+eOzsC0f
         8eLNGOvV6u6H226nZ0nYBaSy0CJTbbS8wVc3VfoB8cMdAgNsw1MTssl8KFft78zAIfc5
         jK551BqA5Gu9KdKGcQlTPYpLQ4aeN0uNaLE4lLnlrS6xwabV4IIm0nGy+k+9d0y2Qtvt
         2h6zFpIq2ISnAFdl+PSByrXCHDqZ88ZfcMtqgxC0nJk8IBFvOlntc8Bma70XTabpYsP0
         icFnihpuh529inNEDh4R6phG6VWIkq9FVbdUL/PTDb3O1l38hgI6IFDbznXRpIm2y7EA
         n2qg==
X-Gm-Message-State: APjAAAVM0s+OR+7nw/3cpM6zpR4x2n+R4gcxwQ6Dmrj6pjQX9Q6IVK4E
        hZ39dsuAZWOIoJlSIG3n7DFG2Q==
X-Google-Smtp-Source: APXvYqxjhov5ni2/7gWoHww+Fvl2OgNrLYfq1T2XI9spVCHk7vv1481EwAB4gFWAAYB6evcTMqDgmA==
X-Received: by 2002:a25:4607:: with SMTP id t7mr8104795yba.383.1572101593571;
        Sat, 26 Oct 2019 07:53:13 -0700 (PDT)
Received: from sevai ([74.127.202.187])
        by smtp.gmail.com with ESMTPSA id x201sm6273931ywx.34.2019.10.26.07.53.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 07:53:12 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "mleitner\@redhat.com" <mleitner@redhat.com>,
        "dcaratti\@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation by netlink flag
References: <20191022141804.27639-1-vladbu@mellanox.com>
        <vbf7e4vy5nq.fsf@mellanox.com>
        <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
        <20191024073557.GB2233@nanopsycho.orion>
        <vbfwocuupyz.fsf@mellanox.com>
        <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
        <vbftv7wuciu.fsf@mellanox.com>
        <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
        <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
        <vbfsgngua3p.fsf@mellanox.com>
        <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
        <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
        <vbfpniku7pr.fsf@mellanox.com>
        <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
        <vbfmudou5qp.fsf@mellanox.com>
        <894e7d98-83b0-2eaf-000e-0df379e2d1f4@mojatatu.com>
        <d2ec62c3-afab-8a55-9329-555fc3ff23f0@mojatatu.com>
        <710bf705-6a58-c158-4fdc-9158dfa34ed3@mojatatu.com>
        <fcd34a45-13ac-18d2-b01a-b0e51663f95d@mojatatu.com>
        <vbflft7u9hy.fsf@mellanox.com>
        <517f26b9-89cc-df14-c903-e750c96d5713@mojatatu.com>
Date:   Sat, 26 Oct 2019 10:52:58 -0400
In-Reply-To: <517f26b9-89cc-df14-c903-e750c96d5713@mojatatu.com> (Jamal Hadi
        Salim's message of "Sat, 26 Oct 2019 08:26:16 -0400")
Message-ID: <85eeyzk185.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim <jhs@mojatatu.com> writes:

> On 2019-10-26 5:44 a.m., Vlad Buslov wrote:
>>
>
>> Okay, I understand now what you suggest. But why not unify cls and act
>> API, and always have flags parsed in tcf_action_init_1() as
>> TCA_ACT_ROOT_FLAGS like I suggested in one of my previous mails? That
>> way we don't have to pass pointers around.
>
> That would work.
> I am being a sucker for optimization - one flag for a batch
> of actions vs one per action.
> It is a good compromise, go for it.

But why do we need to have two attributes, one at the root level
TCA_ROOT_FLAGS and the other at the inner TCA_ACT_* level, but in fact
serving the same purpose -- passing flags for optimizations?

The whole nest of action attributes including root ones is passed as 3rd
argument of tcf_exts_validate(), so it can be validated and extracted at
that level and passed to tcf_action_init_1() as pointer to 32-bit flag,
admittedly it's ugly given the growing number of arguments to
tcf_action_init_1(). With old iproute2 the pointer will always be NULL,
so I think backward compatibilty will be preserved.
