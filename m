Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CEFE5EAE
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfJZSi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:38:26 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37910 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfJZSi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:38:26 -0400
Received: by mail-io1-f65.google.com with SMTP id u8so6115988iom.5
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 11:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5fbvtgKebC3a7hduykLWquaP/bnqsRE4Nje5NZekOCw=;
        b=ho0K0yhOVV+jW5oUr8Owb8cpzAhfzpqHmMQELuOVKgKTAgnlm2nGcf0vgdaN/CN/uO
         HLrRLxKTkrk0NmPvO5mnAqFnoZZ2UmKCDiw2lQUyFYuVC5en6wUo/dzGvXZZyw7Q4DWq
         sKDwMSZv23PiQP+1i3Fw+1mprRh/DChqWvM7wHIPjHs5N6B5U64K3RHO8lzsH3HbiKxA
         9LiH3CogdHJq9R7MNS/oEcIghZNngsNno1o5ARPtXw4Gzo5yRttdy2qbJiHMqIy0KQ6i
         3AXuonuYoX0t73GxYrCMZz9dGmSbjJMlYml0k/S2yVYZDPONAlOf/CTpbrERfLlpT28e
         ftfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5fbvtgKebC3a7hduykLWquaP/bnqsRE4Nje5NZekOCw=;
        b=FzC88WaZ5MyXPjxxxBgaOdIf7k6t49F0HbJ/cQ2KAaRiutoql6P1cBrQ1DehjI9fp7
         miPihbA977nzfOwN7VFYFA4yfIFsJDlyVt72XltbGD3l7757Amky8rVxsZ/huhDxKyQx
         Ns1+/tXRBGddh04+JF/DAgeCiO7iit4i+s6Atrb/4acoqhI1csBCo8ZcWrpPXHvcdD36
         9YXBF+X+xwqwn8S/b0krWlmqJik81JfZMDLLHe1EBSd/+AEO5y7T9PEqcPXNX8PfNxU+
         p1j4SnYCisTAg6imdzU18VthdUkctPhHRXes/sulrrfVRD/SRgZDVjD21jBjEVTUOdBo
         YJEg==
X-Gm-Message-State: APjAAAURQ/3xaKAg6LgY2I1GEOgFgHDHT+wPqFGnMpbnjUQQCCLE2mNc
        S5fMPym6n5CsuuZFqmhQN+7DJQ==
X-Google-Smtp-Source: APXvYqx8gapvSWRVToFH4KcjeVtFCQhyMhxizd3i8jWsM5SFKcRBdDUzIP520TsUgo9mJE58IWYttg==
X-Received: by 2002:a02:300f:: with SMTP id q15mr10499489jaq.6.1572115105328;
        Sat, 26 Oct 2019 11:38:25 -0700 (PDT)
Received: from [192.168.0.124] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id n3sm884249ilm.8.2019.10.26.11.38.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 11:38:23 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Roman Mashak <mrv@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
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
 <517f26b9-89cc-df14-c903-e750c96d5713@mojatatu.com>
 <85eeyzk185.fsf@mojatatu.com>
 <2e0f829f-0059-a5c6-08dc-a4a717187e1a@mojatatu.com>
 <vbfk18rtq52.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7c1efa70-bf63-a803-0321-610a963dcd9c@mojatatu.com>
Date:   Sat, 26 Oct 2019 14:38:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbfk18rtq52.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-26 12:42 p.m., Vlad Buslov wrote:
> 
> On Sat 26 Oct 2019 at 19:06, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> Hmm, yes, this looks quite redundant.

It's legit.
Two different code paths for two different objects
that can be configured independently or together.
Only other thing that does this is FIB/NH path.

> At the same time having basically
> same flags in two different spaces is ugly. Maybe correct approach would
> be not to add act API at all and only extend tcf_action_init_1() to be
> used from cls API? I don't see a use for act API at the moment because
> the only flag value (skip percpu allocation) is hardware offloads
> specific and such clients generally create action through cls new filter
> API. WDYT?
> 

I am not sure if there is a gain. Your code path is
tcf_exts_validate()->tcf_action_init()->tcf_action_init_1()

Do you want to replicate the tcf_action_init() in
cls?

cheers,
jamal
