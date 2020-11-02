Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824342A2DB1
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgKBPKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgKBPKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:10:33 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0610C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 07:10:31 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id y17so13251053ilg.4
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 07:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H0XYAVKnEHF+vyMT1nf9jpk2juyymss8CccZfOgHI/M=;
        b=N0CYExffB1sGr5E4+JIqrsClSwBYsDCNH204ASOBZN6u4ymw1bO+sfgZvTOYIU2VAS
         j5xAtokFR7Ad0lfZwMuo4Z1i/yvcTICFuJlcqeWsBMVc83ty9IW10Bx3TEGHXrUWJGcU
         BBYCm39ObOXrdWIcJFZ0J7nch1dMYkasUP+nJM9Vyx22/EcqiuOTFn7gcHve4hYLoetn
         vChnLpeAJ3qHaegIgL23EvpEz0SN4PxrUtFUpKC4uvCZUWwcqk92SlyMDaAWgn6NA19k
         hJA8WUApxzjt8NBRdo4yPA4Z5Ekm9eyPzLY/1x2y0Pez3zCt/QF4Rpzg2obgO4uR9W5c
         mc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H0XYAVKnEHF+vyMT1nf9jpk2juyymss8CccZfOgHI/M=;
        b=c4XUJVdXDgnyzKdZTdxZsbV7v3MMhFIOl0PLxPSuSo2aKOy/ZJV8IgwUHkIpRTUUTx
         8tIHBnSzIUay/RqrIbqLBMBIMYy5xKl8a1Ka5p8M+FtgNWPbMF1CJC9tsl9iWkT0EsvP
         f3aU9wc5IRU/zPF9nHd+29aTZ12jmhmVVkAavDI3uBqWdwQrKetO7cZFwqyCAfWAWCWe
         jp7Gq23CWeBLY+6L49TX32hO4w5hsqjoy9nxwp0WaNWrZS5HRKeritgQzKX8WCAdw7zu
         CQLQuKcPg3LSGUcEO78GJ1MbdGGCNZiGeJMSef6rNjEgQLLrAPknHHITgBrn/kAqc1Pc
         RQvg==
X-Gm-Message-State: AOAM531Xcty7IsrLXZ5jO/JYZ1oRJLxoNne5Kvf0aCKYOhuCRV4EftCA
        yrnplLMWbSkSS0TKC7SPjQA=
X-Google-Smtp-Source: ABdhPJzzuqQ4HHNWBYlYlhkxnwAYLhGvfy7Y7ogOjqQjuzFSzO6i71QL1bbX8nItTRpAmLpI/x0G+g==
X-Received: by 2002:a92:a14f:: with SMTP id v76mr11355481ili.293.1604329831236;
        Mon, 02 Nov 2020 07:10:31 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4ca9:ddcf:e3b:9c54])
        by smtp.googlemail.com with ESMTPSA id c3sm12418824ila.47.2020.11.02.07.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 07:10:30 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add
 print_on_off_bool()
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
References: <cover.1604059429.git.me@pmachata.org>
 <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
 <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com> <87o8kihyy9.fsf@nvidia.com>
 <b0cc6bd4-e4e6-22ba-429d-4cea7996ccd4@gmail.com>
 <20201102063752.GE5429@unreal>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1e77c615-5ad9-e999-8c68-874baddfecfd@gmail.com>
Date:   Mon, 2 Nov 2020 08:10:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201102063752.GE5429@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/20 11:37 PM, Leon Romanovsky wrote:
> However I don't understand why print_on_off_bool() is implemented in
> utils.c and not in lib/json_print.c that properly handles JSON context,
> provide colorized output and doesn't require to supply FILE *fp.

Good point, I missed that earlier.
