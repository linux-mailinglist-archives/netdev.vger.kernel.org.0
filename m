Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C972C3A05C
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 17:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfFHPD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 11:03:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39588 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbfFHPD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 11:03:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so2279157wrt.6
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 08:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quantonium-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RmygWDdK00l2JFKoif8UmIlOShnC8/YOpCeXjYPnpWM=;
        b=dWk6ipS89swyGzfJ4QPuuejpzoR7X6hpIaNN2BYYJlLkmycy2wX3V4Fn2IA+xpTm8y
         +qb/8PW44Tlzf3xvXZe4YXnVWnfoWo+vpA7oJOJpTjBZFQn88VIoCt8ym/nII6eiakmJ
         12h4Z6wrKI/xZWqr4Dye/uAVpUWkclxAJKwpuaE4MPSMRq0F3gmOLdQ7V+KVs7FaXbna
         RrmhQnzldgvqwhwW5LbIj1N/vq52jMXHILeHy6KzccXfeihaZYvaOYR/Z4LdeRO4JRSB
         pdSW54OsfACYRiAc3FWQXULjNQ9V7O6fWZWhPHLsHG/l7w2KAy06fJXdUTAf/Lu3TGhE
         5KGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RmygWDdK00l2JFKoif8UmIlOShnC8/YOpCeXjYPnpWM=;
        b=gWoOi91+DoHK2QHmLISDWk1NEqygazLQ0htluas54cWr/W301yOfPnjijgZyp6fHej
         KxdrzBpUywlQd/vf52+A86fuTJ99bmMa0m7KEMcweFP1NLXJ4B6N7E5d6ALzXapxUktK
         nxOArcnOhprj9SBaI8GhpCjrUWWSreK2tiDCF1y6XzQrnJNJEhGZn5QI+OzbPGCqCXXN
         3hzvqIUeKCYBNKASqffWmIR3fYnlFldlhyAMprsMxozvExyEgD0/rs3ppsL4usqU6m+a
         ZECi55cQVjBP2b+tjzMxZFiMZZrLk7Z4Zv1qOodAGyyDNYyW4e0dRjt5WiNS+aTJ9cLb
         KJUQ==
X-Gm-Message-State: APjAAAWN178BMcbQ8KOy1rYN94A8mZgpJ9vefkht9tBp4V2nBuNQDTUK
        B1DtshLsAs+7doMYwojB2CcTxwjUvEuNxzOUjVUTjQ==
X-Google-Smtp-Source: APXvYqypUrZ99VTCq6Ekc+5b51uWWpGjqIlVi/KP9fZ/tBpgE1cLuEaZYIxaB37o4hQkYszdwO5u4ywOuM1xP2DHN0M=
X-Received: by 2002:adf:db4c:: with SMTP id f12mr15060679wrj.276.1560006236393;
 Sat, 08 Jun 2019 08:03:56 -0700 (PDT)
MIME-Version: 1.0
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
 <1559933708-13947-2-git-send-email-tom@quantonium.net> <215ec4c5-bef0-f34e-20d5-3c35df0719f4@gmail.com>
In-Reply-To: <215ec4c5-bef0-f34e-20d5-3c35df0719f4@gmail.com>
From:   Tom Herbert <tom@quantonium.net>
Date:   Sat, 8 Jun 2019 08:03:45 -0700
Message-ID: <CAPDqMerV80=wyF62XHZVMxdmEPsU73msjZJ7ZFSayNmgGuvQLw@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 1/5] seg6: Fix TLV definitions
To:     David Lebrun <dav.lebrun@gmail.com>
Cc:     Tom Herbert <tom@herbertland.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Lebrun <dlebrun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 8, 2019 at 2:50 AM David Lebrun <dav.lebrun@gmail.com> wrote:
>
> On 07/06/2019 19:55, Tom Herbert wrote:
> > -#define SR6_TLV_PADDING              4
>
>  From a uapi perspective, should we rather keep the definition and mark
> it as obsoleted as for the rest of the TLV types ?
>
Yes, that is an omission.

> Note that I'm fine with both.
