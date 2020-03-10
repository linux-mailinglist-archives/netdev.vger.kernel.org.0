Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C921804C4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCJR21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:28:27 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34855 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJR21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:28:27 -0400
Received: by mail-qk1-f195.google.com with SMTP id d8so9089697qka.2
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 10:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=gBFNrsj5knZ4jtQ+IEQLi+hvVOEWPuH2XL5hztNfikM=;
        b=xfaYDUiq/YkaohZ2wnWnwnMCO16V/PC4zlILgxkRY+KRWADjk8dq2xGbtcq1xo+P0T
         QTtC1bKDLPYWMwB8+gd1QeJyCMMCIEYzEZVnlA9RuuMjEIw4pfNCeai40xZNCbmoSobu
         VNz/XUI6JxssQD3a6NZCFA+aWBxEnnlWHoYuUKqrFMCcsWOwKXXJ78kY7mjDHFeaUgdQ
         RRIrGVAyn5ZVTsVyI5aleq5NmnOutRpfzQQ9ZmN5OZ02hpLkdAlwjeoxTbIfyeekr7a0
         Vs5qchQWq1z/P7DIvPyYLt4nIBed9A3+0IDioX8YbKQ8uH2amVT5Y+C67geYnpDxpwE+
         VXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=gBFNrsj5knZ4jtQ+IEQLi+hvVOEWPuH2XL5hztNfikM=;
        b=GYq0xSoyFcVw+mDCuCigQs4T8P9byzIjUseY0LUmTNlEyJYB9QhAAUpYs89UonNoAH
         G1pFof17Pk4xxzVyDLxq2XINjHcNMjwjHyBQiUPqGbuclZt3qEeWyfyJXZCLOrnjUvWB
         yGhwQQ+4Ke+wI88VrMFyOCvokMCgOWk5bQBusiWaA+tqkrns2uJspnr5Fv7ibj9dtynS
         pfitClT6o4QylpG5mWu7UIxQyGbsGDNJV/ASVpgcjWbEz0bgdnq4DSGxtcMo+5jQ3624
         59ToxunjKX0uHtMi1USgLPHExKY+RJpfvUZaz1Wmw4Zuq3yCulVRVUH6dDxMCWSAV222
         +2Tw==
X-Gm-Message-State: ANhLgQ1TUvX+lvvJDcowv8k/5PA0yVRflYxRyJWc2AD9JWp4/A0EWzqQ
        LfwYne4CUr9Ls0xVzhhyOGrLJgDMgSM=
X-Google-Smtp-Source: ADFU+vtQ41OhAqSW5+h+CU0vRacvx+3ocUZDzp4RJBhdZK9mafahoRx69UJhKxbBV3fx/ffUqFUY/g==
X-Received: by 2002:a37:2cc6:: with SMTP id s189mr21127217qkh.223.1583861304580;
        Tue, 10 Mar 2020 10:28:24 -0700 (PDT)
Received: from sevai (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id p191sm7613023qke.6.2020.03.10.10.28.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 10:28:24 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kuba@kernel.org, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/6] selftests: qdiscs: Add TDC test for RED
References: <20200309183503.173802-1-idosch@idosch.org>
        <20200309183503.173802-2-idosch@idosch.org>
        <85a74o5icv.fsf@mojatatu.com> <87pndkxi64.fsf@mellanox.com>
Date:   Tue, 10 Mar 2020 13:28:22 -0400
In-Reply-To: <87pndkxi64.fsf@mellanox.com> (Petr Machata's message of "Tue, 10
        Mar 2020 17:56:35 +0100")
Message-ID: <855zfc5dc9.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Machata <petrm@mellanox.com> writes:

> Roman Mashak <mrv@mojatatu.com> writes:
>
>> Ido Schimmel <idosch@idosch.org> writes:
>>
>>> From: Petr Machata <petrm@mellanox.com>
>>>
>>> Add a handful of tests for creating RED with different flags.
>>>
>>
>> Thanks for adding new tests in TDC.
>>
>> Could you give more descriptive names for tests? (Look at
>> tc-tests/qdiscs/fifo.json or tc-tests/qdiscs/ets.json as examples)
>
> Yep.
>
>> Did you try running this with nsPlugin enabled? I think you would need
>> to add the following for every test:
>
> Is there a flag that I need to use to enable nsPlugin? I put in the the
> "plugins" stanza that you cite below and didn't observe any changes.
> That either means that it works or that it has no effect :)

Look at plugin-lib/README-PLUGINS how to enable the plugin.
