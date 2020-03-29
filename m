Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FB4197058
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 22:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgC2UqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 16:46:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33095 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgC2UqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 16:46:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id a25so18728137wrd.0
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 13:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iJNdfU7+ypYb+eaDGbx1K7wr/elzPg7n79FE9UKwG+M=;
        b=gI4bVJhixuRnUB0HRlzyYAG1D67kT2X6vZhy9hX8sWzwSKbxuSu+x07ySPki+2zN60
         1/mGytqhONrfuE2zcbGvBlXuOrQxz5i4PKnP6KaO92pDzduaGgbcncE0yvNmhgoT3hhj
         OP8ZBbpSbvo0yGXDe/BHrJVsMgswAe5lIxDOk6daxamaFAB1BvThgYKGz00zT7LRITsm
         /YGnNNpC28FI5+Pa65I8p7B9GGcEuciVIKQduB3HWkABhLfqFVuvRmZpW/dX4wmnppAn
         FeTcAkRjlLUoU3hwWgkoGUp5cLNbrcT/k8KWxywapu6vYUgVW7pmslT6hLtWw/wfVYeK
         BlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iJNdfU7+ypYb+eaDGbx1K7wr/elzPg7n79FE9UKwG+M=;
        b=SQbAAL4Sy8jBtraELHnl77dIMfDVAExy8+uSD6MlseXC/u/94nB78SJeqH8N/dceYB
         5i9THv9sGmd7cV9NGgC7O597l1e40EXDPBbWJr4O3OG+qYOgrbC1QQPIGfugG7QRDBSj
         ur7ki6z85B4AZpwjcFJ9DIfeTx/PvwckdqUSaAoWbi6AqO+IjZaBnUAdGLgpyJjgJXb0
         ISqL8MdqXZGq7eRLX1D+dhkvRsHirnPKs9uMiagEi/qG3ytRmqqrff+2KH7wBdbUZoej
         dKobOSvus6y39FJryrADWJRyzWZFbIUSiQNxw4fRKYhsn4kvvdPKA6NITeV6B0wsBJZI
         pvGg==
X-Gm-Message-State: ANhLgQ0uOzBbcGsmxuchjOLYqs0rS4mzMuGdOVVmedqez1nNNeZJO2Mg
        RDmzyqGGqjNh5btRaHWvafU=
X-Google-Smtp-Source: ADFU+vvaKCofGlWgpnyJPheWUNGJfTIOyF1e0SkXMi5lzk/ZzLe0uzMylbyzHI17hZgRXgtHtQcG3w==
X-Received: by 2002:a5d:4acd:: with SMTP id y13mr11273395wrs.61.1585514758875;
        Sun, 29 Mar 2020 13:45:58 -0700 (PDT)
Received: from [10.8.0.3] (host81-135-135-131.range81-135.btcentralplus.com. [81.135.135.131])
        by smtp.googlemail.com with ESMTPSA id e5sm18387536wru.92.2020.03.29.13.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 13:45:58 -0700 (PDT)
Subject: Re: 5.6.0-rc7+ fails to connect to wifi network
To:     Jouni Malinen <jouni@codeaurora.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, johannes.berg@intel.com
References: <870207cc-2b47-be26-33b6-ec3971122ab8@googlemail.com>
 <58a4d4b4-a372-9f38-2ceb-8386f8444d61@googlemail.com>
 <20200329195109.GA10156@jouni.qca.qualcomm.com>
From:   Chris Clayton <chris2553@googlemail.com>
Message-ID: <2fae533d-8b38-3462-f862-aab60b9bd419@googlemail.com>
Date:   Sun, 29 Mar 2020 21:45:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200329195109.GA10156@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/03/2020 20:51, Jouni Malinen wrote:
> 
> Thanks for finding and reporting this. The changes here were indeed
> supposed to apply only to Data frames and that's what they did with the
> driver I tested this with which is why this did not come up earlier.
> However, this path can get Management frames (and it was indeed the
> Authentication frames that were getting dropped in your case with
> iwlwifi) and that needs to addressed in the conditions here.
> 
> Johannes fixed this with the following change:
> https://patchwork.kernel.org/patch/11464207/
> 
  CC [M]  net/mac80211/tx.o
In file included from ./include/linux/export.h:43,
                 from ./include/linux/linkage.h:7,
                 from ./include/linux/kernel.h:8,
                 from net/mac80211/tx.c:13:
net/mac80211/tx.c: In function 'ieee80211_tx_dequeue':
net/mac80211/tx.c:3613:37: error: 'struct ieee80211_hdr' has no member named 'fc'
 3613 |   if (unlikely(ieee80211_is_data(hdr->fc) &&
      |                                     ^~
./include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
   78 | # define unlikely(x) __builtin_expect(!!(x), 0)
      |                                          ^
make[2]: *** [scripts/Makefile.build:267: net/mac80211/tx.o] Error 1
make[1]: *** [scripts/Makefile.build:505: net/mac80211] Error 2
make: *** [Makefile:1683: net] Error 2
make: *** Waiting for unfinished jobs....
