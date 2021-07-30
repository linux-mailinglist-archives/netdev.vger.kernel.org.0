Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06043DBACA
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239445AbhG3OkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 10:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239507AbhG3Oj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 10:39:59 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09A9C06179F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:39:52 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id o20so13404288oiw.12
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RHaVjwy0+N87jhqXW6f5abVa/kyNseTWeQCGGj3+AwQ=;
        b=qL/C27lbAZ/7e3LVzVXZ1CFgcAYXmwP8eSw0VcjQ5AYqMuK9xFTuCaig/0xekDwDJd
         XcqCRkLinrpK1XTK8kH7Z5PJQqjIASK9MG7AZyYYxsWQC9Re/sg7cUVKbp99vPPKsi/d
         PYfDISUTu273ii9jbHrndVl0+XroM35HifGbPqKizVwwURqI4Q2jLWwAk6+Cg0NimXUT
         uG9N4UXAgT6V1W1W1V4K/EnPT52RuxAI7dFGtRrhuCSxGnw84zY4i5tyxBCFabVceyAd
         ANg4gUofLGBB1IqrCis0epDgLRwVg7mQ/TVwj4z0N33BA79qvS0iyHqsaPLFU1LaIvpt
         uAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RHaVjwy0+N87jhqXW6f5abVa/kyNseTWeQCGGj3+AwQ=;
        b=cTxeVd1Ig39MnxUbjh/K4l8CcCBxM89/MjcBL9MWyeKVOPYwXI966XHz2flOp6npTD
         0ck35og9oc3Dh8rlPjE98NdCs/8Xd5hXdCNQRjXX7oJrJjedbDqYjiooo5lBzJJaSQ61
         colMnSXoT7A6IEud7YspcBcSl94z6uJI5phLwq0n32SWYvuCds/CksaBfv8A/h5/W9aq
         3U4MiGkj+cWHdGFjH/8fsu+6Ji8cWSz+M/hKJHttmSoIcSUD1hkJKjd5ql5W9Yn21wjm
         uKn9FSB5atUoAbCmdxA7XwxsR4eDyjDf3wVcSFxwkB++JG+cDKONH0sgENdz/hpIHgck
         wTCw==
X-Gm-Message-State: AOAM532MkOZxOLp8swQdV9zA09SIa70y0k3RBpCBI5Ll4yoMAjLffNBp
        mkqTd9CgK2LZWLJDRQBrAfAAQINhGG8=
X-Google-Smtp-Source: ABdhPJxyaNb0VbH9JxGX8kf7zCaNzLv03vzdZrFDXpT1sBMNT4hAPMQnnXP964A/mfxL9jAztMqu6Q==
X-Received: by 2002:a05:6808:158e:: with SMTP id t14mr1963625oiw.23.1627655992263;
        Fri, 30 Jul 2021 07:39:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id t144sm308691oih.57.2021.07.30.07.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 07:39:51 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 1/3] Add, show, link, remove IOAM
 namespaces and schemas
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
References: <20210724172108.26524-1-justin.iurman@uliege.be>
 <20210724172108.26524-2-justin.iurman@uliege.be>
 <54514656-7e71-6071-a5b2-d6aa8eed6275@gmail.com>
 <506325411.28069607.1627552295593.JavaMail.zimbra@uliege.be>
 <6c6b379e-cf9e-d6a8-c009-3e1dbbafb257@gmail.com>
 <1693729071.28416702.1627576900833.JavaMail.zimbra@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dbec63c4-8d05-b476-f508-b43eac749810@gmail.com>
Date:   Fri, 30 Jul 2021 08:39:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1693729071.28416702.1627576900833.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/21 10:41 AM, Justin Iurman wrote:
> I see. But, in that case, I'm wondering if it wouldn't be better to directly modify "matches" internally so that we keep consistency between modules without changing everything.
> 
> Thoughts?

matches() can not be changed.

iproute_lwtunnel code uses full strcmp. The  new ioam command can start
off the same way.
