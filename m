Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19CB20EA64
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgF3AlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:41:22 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:59775 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgF3AlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:41:22 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2564a252
        for <netdev@vger.kernel.org>;
        Tue, 30 Jun 2020 00:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=4ETTBytTQ6eTBqFDXPwj85aMdp4=; b=O1CWUJ
        +z77IySHrwpCOwVo1j1MHjLvMb3peAGoglJDAMibaXM72vNJ92WsgCslY7sJSdBw
        2u3KjP+z75hAZknHge4wlvDW0RN+lK9Y+BGJngskfzNp+ghbNCZNpTnRxDP7f6Ee
        a9yzqC1uvoaBt3a09FqrgXYWpoDLdxvOzkF6uoETiOnch4R7wkQEbr+KcpG6h7qs
        1mPrJ2rHfO5d0jGOQIQvLuUFHVmQmf9sbGuoDUY+wPvsFLUx9rxcUEdXJiPi8Q9y
        5FcfFwFir1eaV7hikLJqoFUt1ns1fysNzhko34wmGXTH2pGY2cYEkOtOXXyjf3wv
        mJkV6Ia4yBrAZwIw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 784bed2a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 30 Jun 2020 00:21:33 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id q8so19205801iow.7
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:41:16 -0700 (PDT)
X-Gm-Message-State: AOAM533t1iD5HvDTacbQ5e5e6GXP18y8lzF0lbnMzCe+B+r7BEmNaXZr
        IisJyJTK3SlLE6T+FCCyUiisIBTa0r2S5iOu+Z0=
X-Google-Smtp-Source: ABdhPJxK8xAj5JmbzJmEDehLB4fECb/Q4Es8DkiPu5IsBwaSmTYOIZU+qIak2VAJS81dM5O6GSDTzvPoeOlLDxcHpdo=
X-Received: by 2002:a05:6638:1405:: with SMTP id k5mr19839985jad.108.1593477675221;
 Mon, 29 Jun 2020 17:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200627080713.179883-1-Jason@zx2c4.com> <20200629.171756.655333160664195676.davem@davemloft.net>
In-Reply-To: <20200629.171756.655333160664195676.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 29 Jun 2020 18:41:03 -0600
X-Gmail-Original-Message-ID: <CAHmME9qbKwpWbw33K6Pz78=sHbaLf9Lj5udXtmOcUE-K=Gu6+w@mail.gmail.com>
Message-ID: <CAHmME9qbKwpWbw33K6Pz78=sHbaLf9Lj5udXtmOcUE-K=Gu6+w@mail.gmail.com>
Subject: Re: [PATCH net 0/5] support AF_PACKET for layer 3 devices
To:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Dave, Willem,

Sorry for the delay in getting back to you; this weekend was spent
moving across the state again, so not much time for emails.

> We customarily don't add new Copyright lines for every change and
> fix made to existing files, please get rid of that.

Sure, no problem. I had done that out of an abundance of caution
because the code came out of another file bearing the copyright, but I
don't care much about it, so it'll be removed in v2.

> Also please add the sit.c code handling as indicated by Willem.

Nice catch, Willem. I'll do just that. Looks like I forgot about vti
as well. I'll send a v2 shortly with those and will do another pass
through net/ and drivers/net/. And if you think of others, let me
know.

Jason
