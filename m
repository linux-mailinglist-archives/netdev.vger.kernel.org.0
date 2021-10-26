Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2D343AE83
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhJZJGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhJZJGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:06:30 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F000FC061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 02:04:06 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id t184so13726544pfd.0
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 02:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7SuwmMznv291EArC/acJqYKGYQ4pyQjobmduB0kcbwo=;
        b=MLsKMd1SVAQqzYfJ20vebZm4pk/4Cm+y0zmeoisAfDKBVuZhis7c5Mly+GcJLM1dOY
         /zO4L7OwxZycFzYyf4wLxO0V1r8mqw3RjurFDGQQUTXRYdZvcNkOpZfaEL682NdUFY6J
         2z/anZAv1yd23obCWE53eVCOjsfSwvJYj2T4Z7HEZUJuet8A+u3cNgSyZkpnjlxYVr9k
         DbLmioylk62jOF+2qjehddYoKvEmX0uPwzZ/yg4ga4nuGA228RK2LLFtc+Sr4iKN0zvF
         10jYTlkloagYHbIMHJ/3q//9H/yHdkYiQlvLjspYrg4sS2kGVbJATCz588OTFEL9BtCs
         LKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7SuwmMznv291EArC/acJqYKGYQ4pyQjobmduB0kcbwo=;
        b=sAFJxPZGmBtirNnGRGIbhfH7WC2hQ8A+Yyxjij5keZGrHBsjq5Q6DzFZ6GTboEEuuR
         AC4M5JNIfEeEj+JEZ5ClF3NL3O4kQEoZIo5Nr6QPZLi2FAAiAsXCveOOzvNk1kU3eoJ9
         XhBbSqkCTR1cqZFZHcdMwj0w6ZXUI7nTI3BdDeAZHA++ZCD3M0WHJkebyyzruPiD3FLh
         5RZCycbZtaQh63d40VDGY8+V3astwKYY+6/aBGOzofPNk7+jgzqegI5cKFOheVbCVFfl
         pS52/WGCgYS6iXtvqVyGNu94Ro3ztukIdu9MSUnW3IraQ8ZHUpUWEupRAASLmqB3ZW9w
         K2ow==
X-Gm-Message-State: AOAM533aSp6aS1WvR3OJbUJVqj3mrK8VnDHhCEQGraVcrfH88JGiEKG3
        wukDkqU4+WG/wyWhlyliKsMkVngZ8ziSdQ==
X-Google-Smtp-Source: ABdhPJwqPQjqq6QEZ8t4aSeuzkGIK3T44qSoxImYxIgmsAOnNiHxXf9AdjMoNkqBh+2FbCtpJuAdUA==
X-Received: by 2002:a05:6a00:22c8:b0:44d:cb37:86e4 with SMTP id f8-20020a056a0022c800b0044dcb3786e4mr24561835pfj.78.1635239046083;
        Tue, 26 Oct 2021 02:04:06 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id i7sm13363395pgk.85.2021.10.26.02.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 02:04:05 -0700 (PDT)
Subject: Re: [PATCH net-next v3] amt: add initial driver for Automatic
 Multicast Tunneling (AMT)
To:     Denis Kirjanov <dkirjanov@suse.de>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, netdev@vger.kernel.org
References: <20211026081248.4963-1-ap420073@gmail.com>
 <53af42e1-f7c5-26c3-8937-f86682ea0c99@suse.de>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <4b0ed903-8b95-5831-9dd8-dfd0bcc8a952@gmail.com>
Date:   Tue, 26 Oct 2021 18:04:02 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <53af42e1-f7c5-26c3-8937-f86682ea0c99@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Denis,
Thank you so much for your review!

On 10/26/21 5:33 PM, Denis Kirjanov wrote:
 >
 >
 > 10/26/21 11:12 AM, Taehee Yoo пишет:
 >> This is an implementation of AMT(Automatic Multicast Tunneling), RFC
 >> 7450.
 >> https://datatracker.ietf.org/doc/html/rfc7450
 >>
 >> This implementation supports IGMPv2, IGMPv3, MLDv1. MLDv2, and IPv4
 >> underlay.
 >
 > Would be nice to see the patch broken down to logical pieces
 >
Okay, I will split it.
Thank you!
Taehee
