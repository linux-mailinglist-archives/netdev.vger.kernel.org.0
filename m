Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3C328D39D
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 20:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgJMSYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 14:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729007AbgJMSYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 14:24:35 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B85C0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 11:24:35 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id q202so560912iod.9
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 11:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=b3UOT0JizEwGIchXB0/Zk5FvRtFOlTNreHoHzeOyCsk=;
        b=I+5f7ZTb4yaYaTKRJRGbE8iwkW6NqPVqEmGsQ2bLYrbSp+H3ENiKrf19kycaT1kPwX
         wYu24VW1eqm8KMTGXz1Vg19iMcurT+2Dp6HfL3pFU/nP+jPEocCPju/HfJ1sAhkvzOnF
         YcXzD9csH9v8qyA9N8xGTI0HWaBxcH3f6kjRwCo7SaCVOQoiTlRSh/Uu9ji0xWouj0sO
         7mBTqayqMPBgPD0JiDwqCyvis16mhgmoD35xt3d+bR9u4CjZvXXMSlv63Sm8a7WuZV/6
         lukY5jwhItYlaT1hzI+v+MTO2ejtG5CTdAtf+bR6C7gNrAaQrlYFkYPHrZSfSL4VAGqy
         qgAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b3UOT0JizEwGIchXB0/Zk5FvRtFOlTNreHoHzeOyCsk=;
        b=EHtFPv/XI737mt4BYfeOJRq18b8F+uR/R9UeVgAZ9MmcFQFU5o4gPAekZ8b27UB4DQ
         6rdhb229ysTTHSoI8paagez9CaFmctr4lmxDnHKgQ1AEKlE2ue+vYVRkFhoPdW9LqQ95
         ib6FtPh4GWnb1OnlJSmW2nFDQKTPK0LY8XZoLPpZo/ZdagS+nYsf0lEOn4bYoREV8Y0/
         LjwLc40S86EgQzJ5o6chxE0L/ntUtBHtBmjBWfeld2AttEsX46magZC0Vw7gUkrjrcNg
         Yf8H5kMrQ1k5PR+z1YBZ6fUd2ssGdcHKXoiB62BYqvBvB50idkIYYRKuuowmIWuOVkq+
         z1ZQ==
X-Gm-Message-State: AOAM532wTODAlFvLGODOUG8gGSH70vVZGRCS6NPLRsZpyHXipSP2ZRqx
        tHdj+hNkif7QPS9RAEzrlwhmJyr2Gy8=
X-Google-Smtp-Source: ABdhPJxrUATGMOVcPjPpcUbw4po/ag5eYAK+28ocWlsO1fJ9pLju1kBpMfteRGDa9Wn+kq5+Vi4Whg==
X-Received: by 2002:a5d:9842:: with SMTP id p2mr101110ios.113.1602613474777;
        Tue, 13 Oct 2020 11:24:34 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:914:29ce:4c18:5cb6])
        by smtp.googlemail.com with ESMTPSA id s17sm646782ioa.38.2020.10.13.11.24.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 11:24:33 -0700 (PDT)
Subject: Re: [iproute2-next v2 1/1] devlink: display elapsed time during flash
 update
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
References: <20200930234012.137020-1-jacob.e.keller@intel.com>
 <5ebd3324-1acc-8d9b-2f45-7c4878ad7acc@gmail.com>
 <e039e78a96c7442aa542f4bac60eb186@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <85a4a31a-7af5-ebae-462b-15363ec6c4df@gmail.com>
Date:   Tue, 13 Oct 2020 12:24:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e039e78a96c7442aa542f4bac60eb186@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/20 11:30 AM, Keller, Jacob E wrote:
> Ah. Good point. This should use CLOCK_MONOTONIC instead, right?

that or MONOTONIC_RAW.
