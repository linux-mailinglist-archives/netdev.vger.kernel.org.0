Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF1EE5A73
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 14:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfJZM0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 08:26:20 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:43305 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfJZM0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 08:26:20 -0400
Received: by mail-il1-f196.google.com with SMTP id t5so4148021ilh.10
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 05:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+WlWbArEoZ65OVk4YiNQUfNCgdtey9GvKbDmhX7iLjw=;
        b=tzUB9GQO40LFx5308DljGRz7vdwiU5V/5RIa63W0qh4itrJIBZ27GqJqf9EsV9RqWp
         VgoGPmF+JNyr9+sCXumIA4A15KqiR3xNeb2VSfQUIdUf7FujYMlgKr7j6kZuUJ2ApppQ
         q5ekq/40zt1rY6zYyk45eZgdGh/1cTgbxq20EHgvoadmMxCUjRWwd2O+gMN5ujaivwKR
         4VBr4nBsNnMUOnFRDjJucSkkx79gTkQ6pM+kD5UJI1CTpPwmoOQmt7H9FzbioXLUUgpP
         jCv6HX4Zi6fCQmdhsNuDZL2RhkdZ6iywpBGAwBeWJxlyD3GYMwr9JqiFK2LFFQArszNP
         cZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+WlWbArEoZ65OVk4YiNQUfNCgdtey9GvKbDmhX7iLjw=;
        b=alda4JlVUAi6/LKONarBkrB4GewBeTrBp6Y7ew9Ni+uhbdfZzRWjr+3QMAThsdRNX7
         4+y+l8DvLYZvzQre4+UIS/OuH4qUhAiCdhsUCUUaSk3wnWB4xmVECsVHl4yfJOV+Dzi7
         ocax56ewZd7V752VnhD7lfKhQqlpW4Iw8P/qBOZMreTirqyuRYsBCKg+VuwLxkn40Nbv
         SMx3mlLaBTCDom3od8DImz7xKrlCb/ybm91LhGuo3Xg4Anbh9AcY7stmTAFrewL3bue9
         cyIqLwl3s54is25AYhbqaPcaAfkDDiRLzrDe2g8SPg+DfTnMKezkxpeC3uZkj4pflefb
         1DZw==
X-Gm-Message-State: APjAAAWgYU2qqpPAqvwU12HHdUrVjoB5auDsbXh3e8u30r7cg0Jn/LNW
        pdyd2JHpfR8ZysvKguSmsFI91g==
X-Google-Smtp-Source: APXvYqzOxk/l/Wxkh8utdeRN4pKww/UT4nKwaUOKLVP1vejWb9MmXiQ4WqWEa9lHAWxu/E72hktoAA==
X-Received: by 2002:a92:8189:: with SMTP id q9mr10381135ilk.38.1572092779363;
        Sat, 26 Oct 2019 05:26:19 -0700 (PDT)
Received: from [192.168.0.124] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id i7sm568124iog.10.2019.10.26.05.26.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 05:26:17 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
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
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <517f26b9-89cc-df14-c903-e750c96d5713@mojatatu.com>
Date:   Sat, 26 Oct 2019 08:26:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbflft7u9hy.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-26 5:44 a.m., Vlad Buslov wrote:
> 

> Okay, I understand now what you suggest. But why not unify cls and act
> API, and always have flags parsed in tcf_action_init_1() as
> TCA_ACT_ROOT_FLAGS like I suggested in one of my previous mails? That
> way we don't have to pass pointers around.

That would work.
I am being a sucker for optimization - one flag for a batch
of actions vs one per action.
It is a good compromise, go for it.

cheers,
jamal
