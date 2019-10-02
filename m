Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B50C92F7
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 22:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfJBUmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 16:42:12 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35530 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfJBUmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 16:42:12 -0400
Received: by mail-yw1-f68.google.com with SMTP id r134so205821ywg.2
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 13:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Poxjj3XIvbwAjIUzBePk8SV7HJA84uTeAL91egM6PLw=;
        b=sHQMPIUcLigVYqQ4jtRCyQlddo7tJvarK9Ogcckb1r2l+i+egKdRkABV1v6tgKlRUJ
         Nnle/NrfPkMUIcyhxiT5YFTQixBWJ6QNlbViW7oP45A1eH9gsp3RRjS/KbPw0B8aWvlx
         7LRfRiPbc1Od9Ped9ljOAllha/gPlY1w4BFbmd1NzeNvXIEE4W0bxW3euefavxTtEiLm
         migj3VwyP8N9hq+FtpxVdHIwceMrHVTUoQcAmH6jgrRQUl2ol197pnKdN1RKktVpPkQl
         KvZtntGBvCAmh2Q1HmbRU80yWA9qAZ/yMWTK6E7plPrWpYJrT2UOanm5L6Pk7SDU/8Yl
         2xWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Poxjj3XIvbwAjIUzBePk8SV7HJA84uTeAL91egM6PLw=;
        b=elw6qAhcyefWUVStgWPhFJQ30a5W+f9SHnBnEMsYQZEMrv7gTq9uBD7eAx47DhSnxC
         NsB0OH+NO+E0/SR+PAL/FHdzf46trt4VDRUo0how0/gJbcl3Mw72L3NIXIg9pdmC2ynS
         eyLO9ZLMfBG5LjTWWqee5PSYb3yRIF3FHOoyuZhMFQ27buadxfhOPuKnQBiCtjaX4x5D
         OFN79BJhbd1RJQm7KbRuNZ3w4YFFsiMFqkhrgnQ2Pwti7oas1ejVTkLm06x1qeokrZJ2
         Yydn1q9s5lXnDzn0Km4LCPNu0Av5KBnxbQaaK+o8a+dQgDpwDgf4H883AMtYkCl+BBJW
         Jsrg==
X-Gm-Message-State: APjAAAWTV66PyKO4UaAEYW78bl74nXNdwU4YAeiYHS/myLsSMK2Pszf0
        7aBUBtm/k5gwOAqjsg/3JDtaCfOZ
X-Google-Smtp-Source: APXvYqzgNvLCkTMubDdM6gvRZ4zfhtahCHDp61BtXZ5zCtRUWCbkb34sadZCN2vRZIOvZztnrH8ppA==
X-Received: by 2002:a81:b546:: with SMTP id c6mr3878778ywk.493.1570048931300;
        Wed, 02 Oct 2019 13:42:11 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id g20sm73386ywe.98.2019.10.02.13.42.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 13:42:09 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id x4so157953ybr.5
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 13:42:08 -0700 (PDT)
X-Received: by 2002:a25:a87:: with SMTP id 129mr3940375ybk.203.1570048928460;
 Wed, 02 Oct 2019 13:42:08 -0700 (PDT)
MIME-Version: 1.0
References: <1570037363-12485-1-git-send-email-johunt@akamai.com> <1570037363-12485-2-git-send-email-johunt@akamai.com>
In-Reply-To: <1570037363-12485-2-git-send-email-johunt@akamai.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 2 Oct 2019 16:41:32 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf89E1wOyT09=dLN0BJU-z_xmHSDi=_d1AXkhSs4sfnzw@mail.gmail.com>
Message-ID: <CA+FuTSf89E1wOyT09=dLN0BJU-z_xmHSDi=_d1AXkhSs4sfnzw@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] udp: only do GSO if # of segs > 1
To:     Josh Hunt <johunt@akamai.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 1:29 PM Josh Hunt <johunt@akamai.com> wrote:
>
> Prior to this change an application sending <= 1MSS worth of data and
> enabling UDP GSO would fail if the system had SW GSO enabled, but the
> same send would succeed if HW GSO offload is enabled. In addition to this
> inconsistency the error in the SW GSO case does not get back to the
> application if sending out of a real device so the user is unaware of this
> failure.
>
> With this change we only perform GSO if the # of segments is > 1 even
> if the application has enabled segmentation. I've also updated the
> relevant udpgso selftests.
>
> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks Josh.
