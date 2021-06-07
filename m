Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D1F39E00E
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFGPRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhFGPRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:17:40 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912F8C061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 08:15:49 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so17069253otl.3
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 08:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7orNREbLkRW0dk5e16vzR76DVIE3Iz2dBUY0x1YW0JY=;
        b=vAdMAZgXowW4bi+hJkZ3lQb7LnwgGPKUIcnbAuUuMPpHZ9WI3pOSJrCDs4gNoDrXKG
         qCCvkcOuM7kmckCnKPNYikbZHeB96L5/SHtvfyplJapG8F8PVzy04aw3U4k1Y5yC9DJ1
         Bj9u3PWCQb6FanNPbrJDU/7Y0ydRIqPsT8VHsZ/09U0iesbuLsmKoZ9ynHCy2SMjcgjO
         yzT7YmuOKkqTsa8Zjhb4hklXDtezZbMeb4juQB+UyKksYIbcYzVi6slv4U1+QvHJiWko
         RFpX+j1g2uWRYK/eKrcxNMgZ3DNnvtpuQsxlmbXHd881wGztRjnKav29cfUnUQYZ8VNx
         yrww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7orNREbLkRW0dk5e16vzR76DVIE3Iz2dBUY0x1YW0JY=;
        b=l05o814ilgCcLB1XsSEzVZqWjR81IfMu6KKcJwMrEzWJrUH3NTCAXnymaiGMdunyqd
         +UTfhPIPJXcinjbF9RWgJavz1glnrynjHAljaqxXgsgxVONez025fdMs6pkjB7VbQSUs
         Xlb1D7cb82hvb/j2KmvTo80WP8tvl4q8fmHbGdVY3WT+Zd8d3s7oqJbTuA44u1ETLXvt
         M0KRgRwpPvi2v/QPO8RygDuFanWhiORLBf1IJuWMMhi7LXYVmAcyx+iFJP5cVQyia8is
         MDt+cdzETNWRSFiZrYRPc7RIvt92hZwGToHVDyUqHw9uZ8g5mzdMrH9bE7x7KZjumIOb
         BgHQ==
X-Gm-Message-State: AOAM533IgKlCozIwgvmNzhnZEgt8dg4Rx7Nm4LUw0OglshkM2TDF5D11
        dZA/BPbSpI1vbQVK5G4IvEA=
X-Google-Smtp-Source: ABdhPJwE8QXoSprTzkTAhielIC7N+Kn7AZkXvC8yx1N+sOQUwek9BKXSAK0ULuYVLT7VyuU+Eht7Rw==
X-Received: by 2002:a9d:74c2:: with SMTP id a2mr12815797otl.324.1623078949001;
        Mon, 07 Jun 2021 08:15:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id c205sm2320076oib.20.2021.06.07.08.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 08:15:48 -0700 (PDT)
Subject: Re: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
To:     Parav Pandit <parav@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20210603111901.9888-1-parav@nvidia.com>
 <43ebc191-4b2d-4866-411b-81de63024942@gmail.com>
 <PH0PR12MB548101A3A5CEAD2CAAB04FB1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <d41a4e6c-0669-0b6c-5a2d-af1f3e5ae3bd@gmail.com>
 <PH0PR12MB54813150C3567170590BE36DDC389@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <531cec55-d460-3254-df23-4adac5c18743@gmail.com>
Date:   Mon, 7 Jun 2021 09:15:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB54813150C3567170590BE36DDC389@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 9:12 AM, Parav Pandit wrote:
> I see. So do you recommend splitting the print message?
> I personally feel easier to follow kernel coding standard as much possible in spirit of "grep them". 😊
> But its really up to you. Please let me know.

yes, I am saying user help messages from commands are different than
kernel code. Users are not typically grepping iproute2 source code
looking up the help string.
