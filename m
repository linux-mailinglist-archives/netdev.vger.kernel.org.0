Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46311BEA4E
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgD2Vwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 17:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2Vwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 17:52:32 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D825C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 14:52:32 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e17so3300725qtp.7
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 14:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+8N/ZJhhCl9CtAOFmecWxYrWGwUPpx9caQ4Pdp+FvRI=;
        b=h22AervIu13W/n2LyjT1pWIUkoyijbwXm6Fe8pWa0qbVx7wMehjagzMBuhVztOsJUH
         Z//SR4fjttazQ5L0mbXOlbcvmo2EtbLhEULhxKLV13vpwWoLm8Ox+GmxO9LXlgjHnbQT
         4WhwuJMQQpfw3rC0p4hi6fAZ5Lxm3c0Drzi+HsJZWnJcEEKXGE9iCmnNd0iSqY70eekt
         2bCAKHg4SvgcgQaStY8uGrcNQgcyVoHkJPsIWftTEpF/I/arL9Qn9KxrlhU3oZ4YCt87
         8uHIIbQGMe/FsIcbye59MXXmDKAtEYHnXb2zas7FVgsqQOe3zAXu92y8uNg7yEZEYGYR
         ln1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+8N/ZJhhCl9CtAOFmecWxYrWGwUPpx9caQ4Pdp+FvRI=;
        b=ClJRbKkOC1T+xkTLE2zgLcE7AAY9+3DMQpnt47IjjwKrproh5JQUT9O8Aje4KgBu5l
         jiCgRKN4OipeoaiKr1xxC4MSxLC7siBOq7bKd4CffhlQ3PWiuORrC8c8l04r23QIKSNR
         0LPltRmVPC8/A5xEVkV9bShz6YyxWZCHUgJPnWCJWeVqGgsYWouDp6AH7kWlH3sccHEP
         T2GixeJBI3y0pTVnNFubbb5Z1lRoNuKTGqr0lIouTb2pO9zn85kDMZnyQcC/n998/q0C
         izDi76qVd0cNZAGRCy6mdx3nOXtlP+oHNlMTsOS4zvKUFnGFswzs6sfcWmK7YFbGgIyB
         zjhA==
X-Gm-Message-State: AGi0PubHTrJlxWxaVvrRPLcnXuV0bl/NKFJsJdHIFD6A7n29Ve+MFKf6
        gHFxZg2+TVOCO0E46BZ5+d0=
X-Google-Smtp-Source: APiQypLn9KbUf2676XjWy44TGfTbwoCzNpk4ZY0pNnim9ivcl5cA++UWVqngQVJv6h2bFWqStFX6mg==
X-Received: by 2002:ac8:6cf:: with SMTP id j15mr421345qth.143.1588197151470;
        Wed, 29 Apr 2020 14:52:31 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:3576:688b:325:4959? ([2601:282:803:7700:3576:688b:325:4959])
        by smtp.googlemail.com with ESMTPSA id 103sm391190qte.82.2020.04.29.14.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 14:52:30 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] erspan: Add type I version 0 support.
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Cc:     petrm@mellanox.com, lucien.xin@gmail.com, guy@alum.mit.edu,
        Dmitriy Andreyevskiy <dandreye@cisco.com>
References: <1587913455-78048-1-git-send-email-u9012063@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <435b0763-5b7f-fc4b-5490-e6ac36ec0ff0@gmail.com>
Date:   Wed, 29 Apr 2020 15:52:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587913455-78048-1-git-send-email-u9012063@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/20 9:04 AM, William Tu wrote:
> The Type I ERSPAN frame format is based on the barebones
> IP + GRE(4-byte) encapsulation on top of the raw mirrored frame.
> Both type I and II use 0x88BE as protocol type. Unlike type II
> and III, no sequence number or key is required.

should this be considered a bug fix or -next is what you prefer?


