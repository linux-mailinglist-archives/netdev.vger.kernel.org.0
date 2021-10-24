Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35877438CA3
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 01:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhJXXy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 19:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhJXXyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 19:54:50 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28166C061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 16:52:29 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id u69so13202915oie.3
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 16:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nwbLzTWpNBPchWK3vFoOd1B7C3oWHwVhfv6VCOWBn1Q=;
        b=Bf7cfzwIXQtC80DvLss0tTqnOWcQmJq7KKB+gLQ3J2v+7NwpTfvtA0+SMKacvGzN8U
         iZgsdSaTNHAS7ZtGgp50GZvFMnbplhPRnn7kdUvuOGwKSZWd+R181H2P5hW3QuLNcEPB
         9UeRgTndjEX4cDSuOLoVU/HOZk4R6lsEuwmklO4CnMZC309H6d9Ez3y3B3pJJW5yQYVn
         8hLQ87xH4l2vUDOU4TZFoZ2NDgH7lKN4GciFZKAurW0BvT/++JIRLVaCFXskiHeMF9As
         RfiHB3FB59J0rmNomUjSfC677Y5D4+k87d2pvfQM6pnMj7JDDux5gDLp5BW6HLTlnElj
         kcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nwbLzTWpNBPchWK3vFoOd1B7C3oWHwVhfv6VCOWBn1Q=;
        b=ZjaINlB4Es9eFLq2Udj0Jn4ee+K6tH+EkImLCaNQkbYxFb388Tq5yfZPCvws5CuDiD
         E0+8dV+dU5YyMjg16OjqUWwSvRUGb6iDkOLN4OKYuWkLBufRMIVDGQsmJzXGPTrZvV+M
         OqaFhs3ij2RMW5yZCenFAMFgaeKWs48jq3VnEY11YJTbcgoZq455fRavrn1Ej4TFzfyp
         a7invRCAuwMJPSaWCLzo0IfjYuUbnRGoRbiXF0xvWKVasgzCPy5IySZI74hNd8jhaxfz
         OgIT38SrwQNw3F4aPVz7iip9NAWeeEWC9SAqdCcPgc7DqFWV8Q1zXZEzJx+VsQH9UcFV
         qBGw==
X-Gm-Message-State: AOAM530g12AOS/lSaU8U0CemLbqYd9quj9sQg0RVZqAgr3rHWCuEb8aL
        6bAvoya0q1sBXAYYyTst0ZajH4Iv/TE=
X-Google-Smtp-Source: ABdhPJxcQaUD3U6ufh4ekjoIluW/WUL0vSaoLYRYepR1jRJgeDrEVH5LFnV3qvdIeMEPS6mYBpZ/7Q==
X-Received: by 2002:a05:6808:144c:: with SMTP id x12mr18507522oiv.6.1635119548586;
        Sun, 24 Oct 2021 16:52:28 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id o12sm3223638oti.21.2021.10.24.16.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Oct 2021 16:52:28 -0700 (PDT)
Message-ID: <acab97fc-e134-47a5-0385-4dc3754a818e@gmail.com>
Date:   Sun, 24 Oct 2021 17:52:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH iproute2-next] ip: add AMT support
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Taehee Yoo <ap420073@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20211023193611.11540-1-ap420073@gmail.com>
 <20211024164526.2e1e9204@hermes.local>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211024164526.2e1e9204@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/21 5:45 PM, Stephen Hemminger wrote:
> On Sat, 23 Oct 2021 19:36:11 +0000
> Taehee Yoo <ap420073@gmail.com> wrote:
> 
>> +	while (argc > 0) {
>> +		if (matches(*argv, "mode") == 0) {
> 
> Try and reduce/eliminate use of matches() since it creates

Make that do not use matches. We are not accepting that for any new
command line arguments.

> lots of problems when arguments collides.  For example "m" matches
> mode only because it is compared first (vs "max_tunnels").
> 

