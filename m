Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7F7379A00
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhEJWZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbhEJWZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 18:25:35 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187D0C061574;
        Mon, 10 May 2021 15:24:26 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z13so25733203lft.1;
        Mon, 10 May 2021 15:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UB7STX+2BxkjlcmPswGdadDbZZquPtBCCQkaCzIDE+k=;
        b=tPKvon4TXZcQUmVNIMXsbJNJJfRhE8yBGDSSU1l2CObWZ6JvokUJMkr4Y0pG4jnU0m
         pJHdDDxlftKQbdiIkBsrQHk+9in+js7ZwPOK3T/OtTlhT9rMuXbRwBzSw1ZCgg4uLWve
         bphsC/Abi4M3nkWnXGopGbLCiPU+omE+YKixVjfPBs67M5TcLZuVluRyEsT9GJgP4vH7
         BOb3tWDFEYYHmu9aBSCR9SUQcOeQ8DDpqiMYh5Q8ZDQYsWcwA4PM/e6xHwkAepVD9pF3
         sUPbAc84hitbwheGjhtRZwTj3P3bFgcHM/wwnBYUdsKxP4iLQE2/uZjP6MIQj0byMB2c
         xkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UB7STX+2BxkjlcmPswGdadDbZZquPtBCCQkaCzIDE+k=;
        b=m8eM26pp6vLvhKMBnpl7MPrFu5TdPXj/FEr5cTGxGiYTyd5q/0gm1ZkIiAM+Wbwv4r
         RAkFyyZeEUWjBQNp8cxHsRo4aGsRB1cArtULPRP3qXij2fwf73B1WbIuOiwcNPaxIiHh
         QJxWC/hIYGOKK5zyHaHWWPuDlLEVO9N2p+i9yaqjgL4oF+FCC20CfcIFfvxkVBs/UgEo
         otzyuWqifQ7x6Jk2+G7judDB7BnLXRh1q0IF0C9a2jjMvpPv/QIuAqCKaFzvHBIPsaQu
         Yx080i6AfDlbHRU4c7Rew2wXDJfqfeB27QHRnBrSiE2zvnBM5uinB3RHNJg6IZVgwCJ7
         SXmA==
X-Gm-Message-State: AOAM532RmJWgWZnCLQWLRpLBMr4RGBbWl42YtoB3qybgEsITxOjAu4ni
        /PxiPqO+qHTIRbi2LAex7PdWqrYAw0k=
X-Google-Smtp-Source: ABdhPJwz1nXqStPCyV4kW/r7tJbrKbNs1e+uZx5KRX66nTHku4J3LhN5phbEJ2JfUGc2GVv6Ww1p5Q==
X-Received: by 2002:a19:6a07:: with SMTP id u7mr18725829lfu.579.1620685464366;
        Mon, 10 May 2021 15:24:24 -0700 (PDT)
Received: from [192.168.2.145] (109-252-193-91.dynamic.spd-mgts.ru. [109.252.193.91])
        by smtp.googlemail.com with ESMTPSA id x62sm2388400lff.295.2021.05.10.15.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 15:24:24 -0700 (PDT)
Subject: Re: [PATCH v1] brcmfmac: Silence error messages about unsupported
 firmware features
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210510221148.12134-1-digetx@gmail.com>
 <CAHp75VdbFDxQy6vxDheTzcQhYEoodwbjD_LTOCyoiuLUoj4DXQ@mail.gmail.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <34330b8c-1c9d-de77-8f7f-4400855777fb@gmail.com>
Date:   Tue, 11 May 2021 01:24:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAHp75VdbFDxQy6vxDheTzcQhYEoodwbjD_LTOCyoiuLUoj4DXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

11.05.2021 01:18, Andy Shevchenko пишет:
> On Tuesday, May 11, 2021, Dmitry Osipenko <digetx@gmail.com
> <mailto:digetx@gmail.com>> wrote:
> 
>     KMSG is flooded with error messages about unsupported firmware
>     features on BCM4329 chip. The GET_ASSOCLIST error became especially
>     noisy with a newer NetworkManager version of Ubuntu 21.04. Let's print
>     the noisy error messages only once.
> 
> 
> Seems like you are reinventing *_once() printing methods. Please use
> them instead

Indeed, I see now that it won't be difficult to add the new
wiphy_err_once() helper that will use the generic dev_err_once(). I'll
make a v2, thank you for taking a look at the patch.
