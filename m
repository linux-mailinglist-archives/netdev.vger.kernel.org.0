Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48771BEE5F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgD3CkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3CkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 22:40:22 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A700C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 19:40:22 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c63so4334653qke.2
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 19:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f5Ak7oI1eIiRhEKWpiKXEIFPcL2Rb3apHTUCS9FOGPQ=;
        b=lRNlOttgBSRTPoAeJBxFDZFRoqtDFLaD1ppWg2uL8GnqyUcny8rb9I3dRySviWej/i
         qsLTVXxkU86FsMfBP9VXRGG6kl4ozNknRniVFHRyr2061oFqUP9j76XCX8ne0QGpxOco
         inu0uBYmw94lryBJn36xi4m8IjnMM5oFU+zVz3n4WksAaYkVbTU6tKPsiFNbeQFjCJGE
         p8zslUVgwRSzB5vv4B/b/b/M17LGJgDMjVAKv+C8LHhVidUPouL4k7PZpQirfmxGXJfQ
         qcNZTrXGdc5+tAfFjUFZflupoRzdshfDR9wdZ9rAxKq7Kd7xtbVFRiv5emVN5sy6/k5e
         E0Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f5Ak7oI1eIiRhEKWpiKXEIFPcL2Rb3apHTUCS9FOGPQ=;
        b=r7zQmbWVA88sFsNE92Fqpkznd86cbRmzIC4wSzh4/RaLQxrW2SOLoxo56ldc8Fqb05
         bjc2sslm48mO/aNdFXQDvnVxxPZcu4cNbpp21x2yUb9+EtU/P0GEEI8Le44kPt/YiZ07
         QkQFumTkSlM+bhP/Y0dN3Gp+snEcPkK07O9baumCGBiaZs0tyQDjmj58OejjKyrQrNLC
         KoyuKPix/s458822itQ78OHcOno9Iv7XN9l6eL3xMgKdcyaepkbqFc+EkRPgQtAnDtOP
         GszbbuFbxAKLDP6s1INJxcsIB7iVgdfVRIpfgbt+zl4o/KtH8+LMyPPJiDn7M/P6FcGE
         DeCg==
X-Gm-Message-State: AGi0PuYscpH7OrqvCGRc5wrSXC9/zzw0KNFMJT6N9qV9TsOOMfyBt9SG
        WgtHQiN38CobjSIi4nj/eE8=
X-Google-Smtp-Source: APiQypLF1Z2DZaCgmEWd4ZUOnvdFkQLCO1nT5Noq/NWSTmIQiqLkkp7Ajmx0k238a4WAp2j4OgfMEg==
X-Received: by 2002:a05:620a:1458:: with SMTP id i24mr1491902qkl.279.1588214421420;
        Wed, 29 Apr 2020 19:40:21 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:ec9c:e6ab:797a:4bad? ([2601:282:803:7700:ec9c:e6ab:797a:4bad])
        by smtp.googlemail.com with ESMTPSA id m26sm985337qta.53.2020.04.29.19.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 19:40:20 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] erspan: Add type I version 0 support.
To:     William Tu <u9012063@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>,
        Xin Long <lucien.xin@gmail.com>, guy@alum.mit.edu,
        Dmitriy Andreyevskiy <dandreye@cisco.com>
References: <1587913455-78048-1-git-send-email-u9012063@gmail.com>
 <435b0763-5b7f-fc4b-5490-e6ac36ec0ff0@gmail.com>
 <CALDO+SZY+VVfYXfwUE6z7TzqGkK8fpak8-a3XJ8_ghwyyxJjwg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7477680c-4e01-e0b7-c51c-03fcd4c27ad8@gmail.com>
Date:   Wed, 29 Apr 2020 20:40:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CALDO+SZY+VVfYXfwUE6z7TzqGkK8fpak8-a3XJ8_ghwyyxJjwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 6:45 PM, William Tu wrote:
> On Wed, Apr 29, 2020 at 2:52 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 4/26/20 9:04 AM, William Tu wrote:
>>> The Type I ERSPAN frame format is based on the barebones
>>> IP + GRE(4-byte) encapsulation on top of the raw mirrored frame.
>>> Both type I and II use 0x88BE as protocol type. Unlike type II
>>> and III, no sequence number or key is required.
>>
>> should this be considered a bug fix or -next is what you prefer?
>>
> Hi David,
> Since it's supporting a new type, I'd consider -next.
> But either way is ok to me, I don't have have any preference.
> Thanks!
> William
> 

applied to iproute2-next.
