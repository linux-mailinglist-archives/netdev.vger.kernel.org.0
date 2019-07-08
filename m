Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E6362696
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732870AbfGHQse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:48:34 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36957 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730341AbfGHQse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:48:34 -0400
Received: by mail-ot1-f66.google.com with SMTP id s20so16886448otp.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hEJiFjkdHYVeR3K4SHQIvRtGqvUMlHnXZqvajLoLJY8=;
        b=HXgtBfQ2/gIQzVaHNnrx5mV2GweY+LaUI+ZYhMW7ME7JcSCQ3u6Xev114cMOU+mrkx
         39Z0w9TP1zdIGTXkKs3YBVpEITsGu58DD20m0b2p5upB+7xFqr1Z7P/jNKXQEhQ3prk7
         NjDyJIgzv5wli5ooS/0nAPsX8U8XjLr0gNM1P0+ySc2UUhT0fzxf+v/9mDepKtq4QNyD
         n7GEzR52+sVIH6ZKZoTLC4cpuU5NSkfe8Yfh6Ks+6eadO5Xf/JJX8UDC4t6KliFHIAwz
         poroEtVcZER4WRXXel3uKIxgpxLN5ym4KIOdqC/gVovc6pzbk2YZYkHwaGKHrRw3+/3g
         F0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hEJiFjkdHYVeR3K4SHQIvRtGqvUMlHnXZqvajLoLJY8=;
        b=I9mbCWaaCtqpS7aUxCX4WCOhVSiMr7DleAl/hu6aLTn7jm+bVRonw2aG2M1FlBO8il
         K05VrQbM7dotnutru2UmIp8vWzyZ/Gk+B+mOZSMpwjKhyLS4+eB+n2mh5QpiqHM1kzTs
         YR7Eu2s5FrtzYun44XT6+etVSCMnMQVSg/c7TKV48M6Xp3ygDWWv38wMnGloudXcsKja
         F6A2bj+H7H5RUNeDT3tUEXgVcBVc1PrIMy3fTDfRG4eBsMZqw0IC94yOszRGhvS01I3M
         z39iiLwlZznf650hpE5h9B4brOrYSfrK3HTVWTnZjlp753iYmSqmdqW/c/Pbux0Fxke/
         /xNw==
X-Gm-Message-State: APjAAAWEYQUg0Cc7FuqCPsnLHaK7/k+sU0RMbgOD5vbIlMj3L/AzVte9
        MkepKSA1o63vbSvx5XgCYYSwgKbPRNgOqSKUmmQH8g==
X-Google-Smtp-Source: APXvYqwgoUi449XeXMj/OC0JQG+PyPaTEfbjQyBK4qplkxOOafmELb9/Xy+ilqeGu4PHMXGxflr+e/Cj8cZC/OY9tpw=
X-Received: by 2002:a9d:19e5:: with SMTP id k92mr7528701otk.65.1562604513635;
 Mon, 08 Jul 2019 09:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
 <1562201102-4332-2-git-send-email-lucasb@mojatatu.com> <20190704202130.tv2ivy5tjj7pjasj@x220t>
In-Reply-To: <20190704202130.tv2ivy5tjj7pjasj@x220t>
From:   Lucas Bates <lucasb@mojatatu.com>
Date:   Mon, 8 Jul 2019 12:48:12 -0400
Message-ID: <CAMDBHY+Mg9W0wJRQWeUBHCk=G0Qp4nij8B4Oz77XA6AK2Dt7Gw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/3] tc-testing: Add JSON verification to tdc
To:     Alexander Aring <aring@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>, kernel@mojatatu.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 4:21 PM Alexander Aring <aring@mojatatu.com> wrote:

> why you just use eval() as pattern matching operation and let the user
> define how to declare a matching mechanism instead you introduce another
> static matching scheme based on a json description?
>
> Whereas in eval() you could directly use the python bool expression
> parser to make whatever you want.
>
> I don't know, I see at some points you will hit limitations what you can
> express with this matchFOO and we need to introduce another matchBAR,
> whereas in providing the code it should be no problem expression
> anything. If you want smaller shortcuts writing matching patterns you
> can implement them and using in your eval() operation.

Regarding hitting limitations: quite possibly, yes.

Using eval() to provide code for matching is going to put more of a
dependency on the test writer knowing Python.  I know it's not a
terribly difficult language to pick up, but it's still setting a
higher barrier to entry.  This is the primary reason I scrapped the
work I had presented at Netdev 1.2 in Tokyo, where all the tests were
coded using Python's unittest framework - I want to be sure it's as
easy as possible for people to use tdc and write tests for it.

Unless I'm off-base here?

Lucas
