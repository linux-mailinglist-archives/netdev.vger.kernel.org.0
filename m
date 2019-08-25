Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391439C281
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 10:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfHYIHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 04:07:34 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38820 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfHYIHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 04:07:33 -0400
Received: by mail-lj1-f196.google.com with SMTP id x3so12399599lji.5
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 01:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RaaUZOyKisXPYgTZX0sHZMjbg52SAZMA6mxrJ730EM8=;
        b=MDqN1EpV2zFJNiwz9b83MjzukO521rm3d9c3JSHxNrtHtbfOEL8B5OKAbYQWCqYKaP
         smItcV4A+nkUzf9DEDjEeTvw1TftngyzMdo2JcbpYO4Tss6gHvr9zQke7RsN0cBc/YvL
         QS/T+h3U+kWprpP8fwK8JIB4VtSLYeMHa/9uHAO3SaFQJar7CmoZNXOWZu3POXSVcDsw
         mfJcLQeHLfw8Y10ODesonne5VCYO8Fuei+5Qpa81wEpMdJc7KU4uF+nYrUFV95/bUiNp
         qOEZ28Qh0VYAlLOoVmNn/bRtYjR+hctaL+bw2bpV8Gb4if3Z2X2Hi7h7IMHkbSR3qfpm
         1BbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RaaUZOyKisXPYgTZX0sHZMjbg52SAZMA6mxrJ730EM8=;
        b=KUkWAvOxeDWyNEOUu8OcbjZrRa9acCtdI5KNFeVfA3m3JFDCup2QZv9HlL6nIgqtYw
         EwPkFqfdUixmg54rI5O9G1COXG55f/UZ1kSmB1u5Rng4+uIWsuPrXCx/WBinQk0NNWUI
         VEBAb6kFVaUhKoOwAQ86jnjHL/nYbeo2bg1pYi9Zg8qVSb50B0VFGxsk1Rju+XZGBQRo
         hGo6oV3N7BKwFejLyLaz+DJT3wlZetbtTstbg317lopLBiOflHGBTp8P3AD64VTZS0j4
         RFs27UbehUEDL77SNH/4gyJNrRTeC4gbgwP8S0QKOsupVqfenVfPHYmKQB9rU3sIuOm8
         +k5A==
X-Gm-Message-State: APjAAAUPjkmvE3HjJ4aBq1w2dfkugf7YdTOXVeFEOSB9sS5SDeH5VgOv
        KHhn6m4PCVOtxD1rVWIYLl+nweIjBT7Qrg==
X-Google-Smtp-Source: APXvYqxhX3Fc0jWoNtBm9mHZ3Q98u2PONHlDbqMjtGiILfEOHh/geGaY+fRBZ9CdBCcQAzFhR8QCSw==
X-Received: by 2002:a2e:970e:: with SMTP id r14mr7277191lji.204.1566720451496;
        Sun, 25 Aug 2019 01:07:31 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:440c:1c3:8867:87d6:cdba:87a4? ([2a00:1fa0:440c:1c3:8867:87d6:cdba:87a4])
        by smtp.gmail.com with ESMTPSA id t21sm1308858lft.5.2019.08.25.01.07.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 01:07:30 -0700 (PDT)
Subject: Re: [PATCH net-next] MAINTAINERS: Add phylink keyword to SFF/SFP/SFP+
 MODULE SUPPORT
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     Russell King <rmk+kernel@arm.linux.org.uk>,
        netdev <netdev@vger.kernel.org>
References: <20190824223454.15932-1-andrew@lunn.ch>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <44e3aac9-8c94-39d4-b415-934ce5750cca@cogentembedded.com>
Date:   Sun, 25 Aug 2019 11:07:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190824223454.15932-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 25.08.2019 1:34, Andrew Lunn wrote:

> Russell king

    King, with capital K. :-)

> maintains phylink, as part of the SFP module support.
> However, much of the review work is about drivers swapping from phylib
> to phylink. Such changes don't make changes to the phylink core, and
> so the F: rules in MAINTAINERS don't match. Add a K:, keywork rule,

    Keyword?

> which hopefully get_maintainers will match against for patches to MAC
> drivers swapping to phylink.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
[...]

MBR, Sergei
