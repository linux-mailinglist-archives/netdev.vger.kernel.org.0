Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914282E6C31
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgL1Wzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbgL1WSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 17:18:04 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17FEC0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 14:17:23 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id q5so10642249ilc.10
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 14:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8xaj/jrjDBxtnaPPmX1iSXAwxW5U7nW7mac1QKCQt1w=;
        b=OTBqYKoOILzVU9eToB8LYAc9fm99ATlzGwIpXEWGueY9o3ux1tSvDNU7CaF8mxfLfx
         VVhi+STJRUDGteqxz1qRkfoQ+J7yQmBzwc6c2N1ygU9rOZjd5htpHqTyQ2UBmNsEzzrj
         i8JRk5fV2tVOenYroHvVGaxuNArFosOrwQyWMNKOaAGaCH546Q4FQ8TAq6pW6kt/L5Qt
         xf5x6Q4cz8m0U2airN2j047RFInruih3sJbFQpomPx/hI5Kiki9caG+Q0iM370W53dy5
         6CCTMhKlxkCaeWMkjZPYXNpwVx4bxFYukXma8RyzD4LOukclrfcIjU+VvS/CNGykoSLP
         UjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8xaj/jrjDBxtnaPPmX1iSXAwxW5U7nW7mac1QKCQt1w=;
        b=l9eJzSUuDIhXN28IlUj8kTcJX5TRZW9PTpydeIns7ZqbuLRoa0XibQRllI9WNfqUe0
         pt6ukvMugx2uFWy05dlp0dofeXHs+/2vsWGIdi/sUaeSohlK+B46RyUyHHo2XDB/ADtD
         ApgpPxZLQoG/41faScOU48KPIP+L/a0/po4KIyDLB3cfwTlA3BPgEANwSvnIl8amsBIH
         b6EU1B+mzNfHpjeSD9neTT9tPUQVy95uI6vHyNKDcbwagNZHk6i6wUikUHT4QTmkzU+S
         5XGy2mlHt8pO0/J5+Ky6R2JwmJqiciVbzaJG/Y1OfW0jhdHD351tfdKpA4lzWbjc/Lc5
         Q+Vg==
X-Gm-Message-State: AOAM533TfETyCHBHh9EBujn/NZge6kAg6aM3gt5yZkyuDHDx1OjovGAd
        yW/PXuDUPLEgDsuVDo5oraxAbg==
X-Google-Smtp-Source: ABdhPJyi74AHx8bsd3qh/e4LtuarYznBgKMBlzlkPZgDUcfteqZNxh3MxIKKb5SApTqhzLuqAvbmGg==
X-Received: by 2002:a05:6e02:102f:: with SMTP id o15mr45440769ilj.142.1609193843113;
        Mon, 28 Dec 2020 14:17:23 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b18sm27875236iln.46.2020.12.28.14.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 14:17:22 -0800 (PST)
Subject: Re: [PATCH net 0/2] net: ipa: fix some new build warnings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201226213737.338928-1-elder@linaro.org>
 <20201228141439.15b83fbf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <ed4d1fdf-4def-7e2b-863a-a01c2096e170@linaro.org>
Date:   Mon, 28 Dec 2020 16:17:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201228141439.15b83fbf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/28/20 4:14 PM, Jakub Kicinski wrote:
> If only it could have been caught with COMPILE_TEST.. ;)

I know, I know!!!  I've had a branch that's half done
for a long time.  It has other dependencies that are
not set up for COMPILE_TEST so it's harder than I'd
like.  Let me see if I can make some headway on it
before the end of 2020.

Thank you.

					-Alex

