Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D770746D0CC
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 11:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhLHKVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 05:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhLHKVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 05:21:12 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BFDC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 02:17:40 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x6so6685674edr.5
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 02:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:in-reply-to:content-transfer-encoding;
        bh=0LeQHXIMph+BYd4ryWmOykUMfJm5Zi1BU3mfux9e5e8=;
        b=3o+3QemkSEstT07cGczLZLqYjvuloOZPMyuFNKqF18ESm4okdC9McP2oQGJCVkhyxv
         zpo1t8I4+5tviiDgEcVXuldCt7JUbNGFSZkKmb9G4pqnZYVYs6M3a5n04B1wy//Uk4p8
         zWZEKgmWOQ1CIwhQjQGe0HZqhtLYlEy+LbVqUiEBSaR4WJf3U4N3gW+cO1yP++xmk8Ss
         5eBPvohBuUaEKliQrNzV+tyNDlzFHC/iKgWAH5vVdIbRSzfPs5cLmhyWPWcuJJpyOvbE
         yx90Wr+xI4yE55PX7cTTdOXMCAPXcYarDCuVFvsaeMqV+Cngp6iLgg3xuGQ30jxvjeBj
         7jNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=0LeQHXIMph+BYd4ryWmOykUMfJm5Zi1BU3mfux9e5e8=;
        b=eQPQ+PxlS0ceQt/TzyI2RKLJW07F3AaiThD7vDGZl3oiU5UIzwbehF1v1vF2o9/q1i
         cun0CKlihiYDN1v96dfaL02kyXnrWzz+V+pwB8+YBj8RhNJgBFdYlToxDRDd8ZlT15vJ
         DYVfalty3h8ODg2JiRSjAMkWyMuN3BUBmkOKs26Dz+nwVS+TJ+/re97EjHhAV+/SJ9zE
         BWUcLkfxHXCqLZ9vculy1mMxeMTtn/Ls2fAVezTUvzVo4vCUxWgjXhpfa3HTQhJJkGh3
         8O0mvxrDCq3bVTXHtCFpPLAREvFYcixP3givwzl+UM8vFCLbvW5qLrvgiUt7RQTwKcYM
         hJ8g==
X-Gm-Message-State: AOAM532kH+q/UKEgbhx1NznSSDH7793OWVg8q4Lz8UX8oJzkScGrG8As
        Oj45989kYZ7w3hOnrTRQHO5IsA==
X-Google-Smtp-Source: ABdhPJzvwnne79blJ3+kreFpK3H1zg+SEkdFn6pCYIlvxQCZ2XqXZTnGTr/R7lAMVHU0AZN0pKWtQg==
X-Received: by 2002:a05:6402:50cf:: with SMTP id h15mr18197283edb.90.1638958659393;
        Wed, 08 Dec 2021 02:17:39 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:9dd5:a52b:99d6:b584? ([2a02:578:8593:1200:9dd5:a52b:99d6:b584])
        by smtp.gmail.com with ESMTPSA id ga37sm1224349ejc.65.2021.12.08.02.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 02:17:39 -0800 (PST)
Message-ID: <130b7af7-41fb-74dc-e6a2-7e223f062676@tessares.net>
Date:   Wed, 8 Dec 2021 11:17:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next] net: mptcp: clean up harmless false expressions
Content-Language: en-GB
To:     =?UTF-8?Q?J=ce=b5an_Sacren?= <sakiwit@gmail.com>,
        mathew.j.martineau@linux.intel.com
References: <20211208024732.142541-6-sakiwit@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20211208024732.142541-6-sakiwit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jean,

On 08/12/2021 08:20, Jεan Sacren wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> entry->addr.id is u8 with a range from 0 to 255 and MAX_ADDR_ID is 255.
> We should drop both false expressions of (entry->addr.id > MAX_ADDR_ID).

Good catch!

I wonder if we should not define MAX_ADDR_ID to UINT8_MAX then, ideally
with an extra comment saying it is linked to mptcp_addr_info's id field.

It would make it less like: by "coincidence", addr.id has a max value of
255 which is the same as MAX_ADDR_ID. WDYT?

If you are OK with the suggestion, please send this v2 to MPTCP's ML
only so we can validate and apply it in our tree. Then we will take care
of sending it to Netdev ML.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
