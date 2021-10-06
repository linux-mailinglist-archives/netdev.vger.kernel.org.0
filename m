Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DB3424012
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbhJFO3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbhJFO3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:29:45 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE28C061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 07:27:52 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id y17so3047371ilb.9
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 07:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tzhphZZ1690S0FZs59RskF2J4YhRE3ZcYADV+KWARlg=;
        b=HwoJ0gjhuKW+6tmC2tugm0QjU/4jK/r2V9z3bEO7fs4D9gBRFKAGtDBfNnMkkz3oqT
         2cD+UK5ukU77N5+CHdoBpVzYozuw7sqW/LMoIVnDUZ7Y/i7JF6F6229ZnFCfIR+DN2nx
         UjdAlA6HLntV3XqHC/adiwlAsZDL7NDL3tmYZlWw9FxJC2zeloDxVk1s137xITkBeMT3
         CegYXWcxtyAcGWfq3tSlQ0AhlHXEzcQKTOTPJ5tmhcT0+TMFOoeIlP3/C4j/VwhAsGnv
         Aw3dI5hWj9yhKMABtNsA35i54mXTpSJRc+GPDhNQPz3MR1w8ynbcRW4jtsLS6ZYGFkuI
         akPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tzhphZZ1690S0FZs59RskF2J4YhRE3ZcYADV+KWARlg=;
        b=wddASm4VIcwmWcDf+A6NN8erpHCYAd1IYM0akrKlwuEDtYe2upPRARk0xSaXKueIRs
         exWO6oDahI6UVPlzhnWo2sWO2kea/tY9SUUTPXkPnK5C9JidUzDI04Dn0Sg1/E9+lsRB
         Ww8ss/CKfduj9NP4ysA8VucFt2JhEQXb3yU9mYubQWyhA206RQzVQgiSxcWimZwhVwap
         vwn+bk4/6mnc1CEIrK1WAZVJTp3BP0pGxm6LJMWd+Zo1SWv8hjVaHRUbBvvqaoK2ni2U
         ywaMMUp898swBB9WMwZsb3cYPJaRAkS86+PUHGytXEXjQ+M11A3YlHHXQ/SyianAC/Km
         dYGw==
X-Gm-Message-State: AOAM5322bSFKZFsugTPPLVLRp3jT2EbRYZn1El9w9ELU8+gBHd4V0l7D
        EIFacs+ntsr9Gr57VUVyWkYQsF2VAM+93Q==
X-Google-Smtp-Source: ABdhPJwwGgJjvTjIaFiS1lHRp9CcZ06ikTPnS8yPkrFggUCJrePkh/E+cSmn3Zcgu32s61lWE17kcg==
X-Received: by 2002:a05:6e02:1522:: with SMTP id i2mr827807ilu.66.1633530472428;
        Wed, 06 Oct 2021 07:27:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id z6sm12850109iox.28.2021.10.06.07.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:27:51 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3 1/3] configure: support --param=value style
To:     Phil Sutter <phil@nwl.cc>, Andrea Claudi <aclaudi@redhat.com>,
        netdev@vger.kernel.org, stephen@networkplumber.org,
        bluca@debian.org
References: <cover.1633455436.git.aclaudi@redhat.com>
 <caa9b65bef41acd51d45e45e1a158edb1eeefe7d.1633455436.git.aclaudi@redhat.com>
 <20211006080944.GA32194@orbyte.nwl.cc> <YV1xLsQsADEhrJPz@renaissance-vector>
 <20211006101857.GB29206@orbyte.nwl.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <54638ccd-deb5-1212-b2fc-876ceaee67da@gmail.com>
Date:   Wed, 6 Oct 2021 08:27:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211006101857.GB29206@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 4:18 AM, Phil Sutter wrote:
> Hi Andrea,
> 
> On Wed, Oct 06, 2021 at 11:49:34AM +0200, Andrea Claudi wrote:
> [...]
>> That was my first proposal in v1 [1]. I changed it on David's suggestion
>> to consolidate the two cases into a single one.
> 
> Oh, sorry. I missed the 'v3' tag and hence didn't check any earlier
> version.
> 
>> Looking at the resulting code, v3 code results in an extra check to
>> discriminate between the two use cases, while v0 uses the "case"
>> structure to the same end.
> 
> Given that David explicitly requested the change I'm complaining about
> in his reply to your initial version, I guess any further debate about
> it is irrelevant.
> 


I did not like the exploding duplication of checks on the value just to
support '=' in the command line.

Phil's suggestion seems reasonable.
