Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694E4311FC3
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBFTr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:47:58 -0500
Received: from linux.microsoft.com ([13.77.154.182]:46586 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhBFTr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 14:47:56 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2A7FA20B6C40;
        Sat,  6 Feb 2021 11:47:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2A7FA20B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1612640836;
        bh=Em3neTU7kEWkLdCJMhXkbwquJqV/Ne+hoEMaVxoNWjs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d/4jnlhyqRrDD29cZR/pgrrLp9O6ZlLestWvPIWnvQ6Hy4Z6FxjY9NxynHgCzwxC3
         Z8N1OnyaBlGmNYfmBQvzRdys/Kpxl5urR/AZRP5N3q3lI5Ad9n0Or1pLDTnh8XOlRt
         bWwb4Wuo3+GhHaRaruCiIlT5B1zFcAUL8ofa1AdM=
Received: by mail-pg1-f179.google.com with SMTP id t11so3333086pgu.8;
        Sat, 06 Feb 2021 11:47:16 -0800 (PST)
X-Gm-Message-State: AOAM530OeE2s0/FtSHFfae7ZKICruJqH7vxEBVZvhuga14HwMiVOVnPV
        6oPEsQHYPkDtmrIC138cfFABzDm2gPwZVXrePzM=
X-Google-Smtp-Source: ABdhPJyw7KND+HkraAuGiLvPo7IX2m5Be8vmNWMFo2edQUL8OaTBZCoZW6DIfWr1KPjb6/UJtgA5yfwFpSGH1Vp9EZY=
X-Received: by 2002:a05:6a00:a88:b029:19e:4ba8:bbe4 with SMTP id
 b8-20020a056a000a88b029019e4ba8bbe4mr10915823pfl.41.1612640835779; Sat, 06
 Feb 2021 11:47:15 -0800 (PST)
MIME-Version: 1.0
References: <20210206122920.3210-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210206122920.3210-1-mcroce@linux.microsoft.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 6 Feb 2021 20:46:39 +0100
X-Gmail-Original-Message-ID: <CAFnufp1VqQYOdcF6cszacB+z7QNXGAqqhKtbSRf5NLgaCz5upw@mail.gmail.com>
Message-ID: <CAFnufp1VqQYOdcF6cszacB+z7QNXGAqqhKtbSRf5NLgaCz5upw@mail.gmail.com>
Subject: Re: [PATCH net-next] cfg80211: remove unused callback
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 1:29 PM Matteo Croce <mcroce@linux.microsoft.com> wrote:
>
> From: Matteo Croce <mcroce@microsoft.com>
>
> The ieee80211 class registers a callback which actually does nothing.
> Given that the callback is optional, and all its accesses are protected
> by a NULL check, remove it entirely.
>
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---

I just noticed that I forgot to cc linux-wireless, I will resend it

-- 
per aspera ad upstream
