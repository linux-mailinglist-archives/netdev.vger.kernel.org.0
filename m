Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540D626DEE3
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 16:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgIQO6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 10:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgIQO4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 10:56:35 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E394DC061352
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 07:56:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t10so2433981wrv.1
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 07:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5WWJnUiVV8xQIounCSA9TC9B/8xEj+eiqEw7XoNCU+4=;
        b=JYxo13TO/XEZs3VNeokubUvB9P8CBHzwgRQav+MKHLIsAJI1W7NQ2HSnDdwh5WHGX3
         vEUbpZsItKIhYbRIcKQJiteSUwzN67aPuxo6ZtPleTRiw9YGAYQFsx3jZD5eXbMzGL5q
         HuGXvhiMalSFHgQzD7pLhDQhCD2UDdgnAtFMhQ5sHjejA5E5EvX3ApVH1eoGV4BtwMu1
         4OXUbbXaJ+4PFWJwZXlXUikGyIkBRuHBcBlbyzOrEVp6aSVJ6JAfNdszc8hrJhQJ1XiN
         jAkT3wjlSoV+rulwXEhF34a0kTEoqng+1x+urJk+qNj7VHJtKTAa9sleZtMqPJ7/6yyI
         8O3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5WWJnUiVV8xQIounCSA9TC9B/8xEj+eiqEw7XoNCU+4=;
        b=gtlPLzKgkHdV80UHiU2i/802RbG3z+7pFLJdKX6uuGOwdxAiWw9YPF+Oa/bkjPuSj2
         Q5wXqSchVfHsw1wLUyrUEuABlzFpbi8lHPKoNUsR1uTXnZSy2H6yjqQBtNT51U/xexbw
         omgwdRtls5bxgsvZC0eD3uCNqMbpSEKFxpaEfc1LMpRyEFZWHsiBJJaId9pPOVEAwwJX
         xm+nO9DxKTJ7oUAapoyxMWuPkjWSdhD7Ixss3FGXFyaJrYhtScmR3KuSx73rWuUXZ2W0
         BTSbBzBXSCD/Dj2UdWDxuzlEb7rWVc8lg5pI4ERKUJkM1ibrQ9FZkkIo/oB6Dnpv01Zd
         pvOQ==
X-Gm-Message-State: AOAM5331A+yafy1PWArLd0T5/vSQLuaoPXl+QTkXBwanoF+4ljcOlV+F
        iLq8jJJg8hW6DOLSeJX4bvwrnw==
X-Google-Smtp-Source: ABdhPJxgA3yFQqYbYn5qv/ZjHU66UDfDKgdlyjRQC9IL33sK78Q+HhAZlVM1jcgG288HKnjqL04ESA==
X-Received: by 2002:adf:c64e:: with SMTP id u14mr31692294wrg.373.1600354584615;
        Thu, 17 Sep 2020 07:56:24 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.117.91])
        by smtp.gmail.com with UTF8SMTPSA id s17sm41233012wrr.40.2020.09.17.07.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 07:56:24 -0700 (PDT)
Subject: Re: [PATCH bpf v1] tools/bpftool: support passing BPFTOOL_VERSION to
 make
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200917115833.1235518-1-Tony.Ambardar@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <33dd4a10-9b2a-7315-7709-cd8e7c1cd030@isovalent.com>
Date:   Thu, 17 Sep 2020 15:56:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:82.0) Gecko/20100101
 Thunderbird/82.0a1
MIME-Version: 1.0
In-Reply-To: <20200917115833.1235518-1-Tony.Ambardar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/09/2020 12:58, Tony Ambardar wrote:
> This change facilitates out-of-tree builds, packaging, and versioning for
> test and debug purposes. Defining BPFTOOL_VERSION allows self-contained
> builds within the tools tree, since it avoids use of the 'kernelversion'
> target in the top-level makefile, which would otherwise pull in several
> other includes from outside the tools tree.
> 
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>

Acked-by: Quentin Monnet <quentin@isovalent.com>
