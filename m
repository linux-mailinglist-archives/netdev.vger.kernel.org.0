Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4164E160
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 09:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfFUHtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 03:49:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52613 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfFUHtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 03:49:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so5402206wms.2
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 00:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nHThIuIfrVMnglTEV9GlrOiwAPFC9u5y9ZkeZILZ1Ks=;
        b=hkdIGPhnzc/Xc72FRHWloS6gf35UNw0obhQbODyRZ97wLApSTXXOcafLim7RQpdPNP
         c5ouCUy3Ya2Y85wt4YivpjTX4WjmOe4nDNbAFtJfjkxuNL9R8zEyCmwGiaoOMxXx32F5
         ILClng/GaJVaAmqgZT0TOXE5DHJ+ZN0S1+Dp29DA+8NHPKr7s7YNW2XWHcDTDfW9T/Wk
         E+OsWvNaiMyLfInW1K4UTVHJs5ht48HZis8EpC2pul7vhtVGkrQP6sTySvbYU4KE/FVP
         VLgrrW3r21xFBHQfV9YrYscXAOtYdCJSTQRdPzc5pLF7N5t7hJcw0ggsxG/a0qdUllYf
         9IoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nHThIuIfrVMnglTEV9GlrOiwAPFC9u5y9ZkeZILZ1Ks=;
        b=S6Opj5jITKhUeD7Z15xS5nICed06nMZL3xBLVg0BjpY9sWB7bndW5wwISDZ7wqGqrY
         ELqIqJa8f7R/fKWMj4mfgQmGzWZ6ceb+Fs8GrUI1WUGauU6vhblQmc1+IO+dCOCK+/9L
         mxx9/X9oogbmKN3qHgSexE/cVkO9tP+v4WIxWl0UNg9co5GdIicZfUJIvbDEwEKbo3Im
         NsgL0E2kZcvznZk/MH0yG9CKsAs8LEid6edKCxWPyKQ8pRpo2CTUmifMe/fIBpXj5/ZW
         V1Hku5LqFxaS4CGUJU6AlXzHPxEOElvqBXNY8NTZXp2IEveMyjaxyay1mYKcJfViDt7T
         6ORA==
X-Gm-Message-State: APjAAAUnMmpyHFsNtZz81IziURF2SVaAgbCAGzkfQ1BCy/bxVcj8NQW/
        OredRWP7rMBsqIZq8yv5sOByLg==
X-Google-Smtp-Source: APXvYqzrDh2/Nb4xW4Tel4uq27WAKRBNk/5yTtbMJ8ahdEusVdzFciJKWx7Gd6Y1GdL6kRWWNYoydw==
X-Received: by 2002:a1c:9d48:: with SMTP id g69mr3059332wme.31.1561103340242;
        Fri, 21 Jun 2019 00:49:00 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:519:49a0:d5f3:b366? ([2a01:e35:8b63:dc30:519:49a0:d5f3:b366])
        by smtp.gmail.com with ESMTPSA id u18sm1401013wmd.19.2019.06.21.00.48.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 00:48:58 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC PATCH net-next 1/1] tc-testing: Restore original behaviour
 for namespaces in tdc
To:     Lucas Bates <lucasb@mojatatu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, kernel@mojatatu.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>
References: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com>
 <30354b87-e692-f1f0-fed7-22c587f9029f@6wind.com>
 <CAMDBHYJdeh_AO-FEunTuTNVFAEtixuniq1b6vRqa_oS_Ru5wjg@mail.gmail.com>
 <0bd19bf9-f499-dc9f-1b26-ee0a075391ac@6wind.com>
 <CAMDBHYLYpbARw1P3YadLMbm8R3CDaT83R2J0n6P22OwYFxi-Pg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <fed29b14-b8b3-bfc6-fa4c-abdee7d67c09@6wind.com>
Date:   Fri, 21 Jun 2019 09:48:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAMDBHYLYpbARw1P3YadLMbm8R3CDaT83R2J0n6P22OwYFxi-Pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/06/2019 à 02:45, Lucas Bates a écrit :
[snip]
> Very true. I think I just put that one in quickly and meant to come
> back to it later, but either way it's a bit too vague.
I understand. As a developer, we tend to focus on the technical part, but we
need to remember to look at the big picture at the end ;-)

> 
> I'll get that corrected, but I believe I'll add it to a separate patch
> after the requires functionality goes in.  I want to update some of
Sure, not problem.

> the documentation as well.
Fine.


Thank you,
Nicolas
