Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD83830FC1A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbhBDS7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239481AbhBDS7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:59:06 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B424C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:58:26 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c6so5599944ede.0
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dbxr5xg4qL8sih5Y0n1I1CEM+e3b+/PUXbcWXH5zZcs=;
        b=nGWgUjhmyYVTq/fZg05Bsnu5y1IneDilgG+lWQlCZ+W8yDNRisJuxcf7kwNpBPqRNU
         wydouML8FCl6S4nzkT/52sY2gUSTwz3TlMqgzRi7L6YvlSV3MJ4afgtsNlIEqEjBQe5q
         5UEsIEuX9jy1Fngfqx6slJ4peNtImm/6c0BjyYb/5GPTIYguKRsp59d/LPgc08bUy+Xp
         RzCOPyklHbiboL4EVYjOvTTATRMGzXTxdltd4PP2a1q7hzOsdz4ol3lRqogo0KIg0w3k
         B9FajpDzlyQMorLYWnivROZuo+lVDuBAF16eIz98sVuh6pkTeP2fOhUQEB379Zvyl63I
         LxVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dbxr5xg4qL8sih5Y0n1I1CEM+e3b+/PUXbcWXH5zZcs=;
        b=LQy37rkYwOHa8PLenHpTHBmfhqNWYL7wZjHIPU2hbScG6hr/QK+3ZgSHoMoco9GqOV
         fzDLY0qpvURHOYlAONd38wldDZy4HjtDPwpUCdROz4XuLXB2DcsKXJeOThoVtNX7qs24
         aG+u3rRSjZ7q7utqbW+PiTiNqnmnwlj/YvmeNJAGhS/z4duF8vbHoGkwQjbw3PEVDV2G
         HBPryLOJMTZ8XBcavhhRI4QKjIGevforqHes0/7Snd79CL2qCKrXgLv0b7Ma/xQO1NgJ
         e3u/wVacUc5QPSemabCG7Z+VtW21y/MVPuTx/qdwl2xqBuJjCXyCENpba9QPRdUMggSQ
         tLlA==
X-Gm-Message-State: AOAM530LZZauvfxsNmTTXM5FB/dWpWpLhpV7MviljTmTxf8COhGX2wJf
        xqicDO8ctn25aBh4lyAaXssSae59o4cyO1DaAO4=
X-Google-Smtp-Source: ABdhPJxEAEUtz2OqJNNJY5Y3EgrxruQPEyzIZCl5tNEMbrgPQIJvAmvXd+VaYjJruFriu2eiK4cxIr+TDcK/yQc0hGg=
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr38270edv.254.1612465105122;
 Thu, 04 Feb 2021 10:58:25 -0800 (PST)
MIME-Version: 1.0
References: <1612461034-24524-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1612461034-24524-1-git-send-email-vfedorenko@novek.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 13:57:48 -0500
Message-ID: <CAF=yD-LgMjFt11kSvNUbwS-pXZdnucF8UxNZjyGUvJQcKyU-8w@mail.gmail.com>
Subject: Re: [net v4] selftests: txtimestamp: fix compilation issue
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jian Yang <jianyang@google.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 12:51 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> PACKET_TX_TIMESTAMP is defined in if_packet.h but it is not included in
> test. Include it instead of <netpacket/packet.h> otherwise the error of
> redefinition arrives.
> Also fix the compiler warning about ambiguous control flow by adding
> explicit braces.
>
> Fixes: 8fe2f761cae9 ("net-timestamp: expand documentation")
> Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for fixing this, Vadim.
