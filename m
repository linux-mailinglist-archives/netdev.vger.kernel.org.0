Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B822B9C1C
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 06:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfIUESF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 00:18:05 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:39367 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfIUESF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 00:18:05 -0400
Received: by mail-qk1-f179.google.com with SMTP id 4so9470186qki.6
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 21:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:subject:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=iwBwnuaXwAhtP/hl4oR1R1Uto3l//5tGzgaAIagalOM=;
        b=cpzhvmcUYqZaPoupst8FRL+GoTu9L+GEWBWt1Lb8qiMdZq/2l3zFKX1ABbIzeB8veR
         DkA2n6PpdaHzX8yLlvon1+huvk6BYmBJPQR6zqb/c+PmigftS6A/qa18tE6FxP06KueR
         cNfhDDsS/Q90pyr2Pd7QaIuZjoQQ7iL2dRjLtk8iljId4Va0woOYBJxoaFWqLfUTSi59
         vCGFJysW71VFg1mTMPzuYzxqU31px/puvEXzJt3zBnIhLkTyUu9aLfEGTzl45zT8Uc1a
         8LyfKWVtFtdnR61e0kmBB3EUjRoHGWXZLfRvfNIlm171JprH3ciajPbAblcEC5sCs0Ei
         e3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iwBwnuaXwAhtP/hl4oR1R1Uto3l//5tGzgaAIagalOM=;
        b=ZQZ/ONPrTpehnZZlObX/LR+S8OVmc5oG+uGy9Wetu6Us73C55OKs2Nc07X/3WksrCi
         mUWyz+OaWbGLolUdYrlnQ7tuJ9nQGD21Cl38rY4BP4AdkUnpVLsqSeuCSvf1dTqQhRMd
         HDhz+Wq1ah9PjF4Od0kL+0ixGddUI2VyS9cPyZwmK4j5OCZx+TVHLqZeOkR+TMdKjsvV
         XL8AvGN83fAoQsDVerH6eJ7nFcktrBpkDKIPUv2m6RJWtlVUgWvusTRhmdz1CeY0WbgH
         oZgt0JLK3GLCVUNO1QbF1cXLvWkoDwBTxfFejm1HM14Tu07bXyFpsJBMfnrqDu8HeclT
         GTOA==
X-Gm-Message-State: APjAAAWXef4TWzUMKZzzqb7Ji5Zukg/hGstIkHndAswFfj9rC29fXprP
        oe6hNoWXj8BG6Ya5hN59cWI=
X-Google-Smtp-Source: APXvYqxekuygw8GpjWBF6eSztNYyZ9bpfh1PBNhZplwyo0AQxF5JpsthLKZ0+fm2XnGU4C6Fg2gqUg==
X-Received: by 2002:a37:5887:: with SMTP id m129mr6858717qkb.27.1569039484016;
        Fri, 20 Sep 2019 21:18:04 -0700 (PDT)
Received: from [10.182.232.14] (host-68-20.vari85can.richmond.va.us.clients.pavlovmedia.net. [68.180.68.20])
        by smtp.gmail.com with ESMTPSA id u43sm2286896qte.19.2019.09.20.21.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Sep 2019 21:18:03 -0700 (PDT)
To:     w@1wt.eu
Cc:     netdev@vger.kernel.org, thesw4rm@pm.me
References: <20190921031529.GG1889@1wt.eu>
Subject: Re: Verify ACK packets in handshake in kernel module (Access TCP
 state table)
From:   Yadunandan Pillai <ytpillai@gmail.com>
Message-ID: <c52c510d-ad44-c842-319f-f8feb5edf7e6@gmail.com>
Date:   Sat, 21 Sep 2019 00:18:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190921031529.GG1889@1wt.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You're right. I clearly need to be more aware of where I am looking. I think I got tripped up because I was trying to only look at header files like a noob. There is a tcp_ack function there with flags for this purpose. Appreciate it!

Just one question, would it be acceptable to directly include the C file in a kernel module?

