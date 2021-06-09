Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5883A1437
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbhFIMXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:23:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:34136 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbhFIMXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 08:23:18 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8643C20B83DC
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 05:21:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8643C20B83DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1623241284;
        bh=ibqfUg1zzvpuVCQLklhXfBpy5DRH5KxeuVWTPmWAZh4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IDbHIyEh/1qjt+WlYxwntEV09afv3PTtTkJoxxuc1VmqMDVIo//oOCeJcCqRgEGGq
         apZWZK+8jX4ydS3r4eUUuKEG8VZXjV8GZS8u/OSoXEhjLSvXsJQ8aKx4YXUAUa7YRD
         M4t1UyQzRW1ucbrHcWGMtnsuN7ikkEnpqAx0LB8Y=
Received: by mail-pg1-f172.google.com with SMTP id y12so7461367pgk.6
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 05:21:24 -0700 (PDT)
X-Gm-Message-State: AOAM533j8CBIVRUo22WQmP1bEK7C2lthkGrwqweUWA7AvpozXkKTri57
        Mk6TTGQVqDll9XEKxwf8B6G17KFiQxJYUift0cE=
X-Google-Smtp-Source: ABdhPJxkQ4bAYeALvN1cnj3bjDBtzJ2sjO4578brJtCHKmota5fZ0ClgFYV8RcgUtmPvquP3h/WMWNQMVv6u/LnElRI=
X-Received: by 2002:a63:6f8e:: with SMTP id k136mr3670085pgc.326.1623241284026;
 Wed, 09 Jun 2021 05:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <ef808c4d8447ee8cf832821a985ba68939455461.1623239847.git.lorenzo@kernel.org>
In-Reply-To: <ef808c4d8447ee8cf832821a985ba68939455461.1623239847.git.lorenzo@kernel.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Wed, 9 Jun 2021 14:20:48 +0200
X-Gmail-Original-Message-ID: <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com>
Message-ID: <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com>
Subject: Re: [RFT net-next] net: ti: add pp skb recycling support
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, grygorii.strashko@ti.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 2:01 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> As already done for mvneta and mvpp2, enable skb recycling for ti
> ethernet drivers
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Looks good! If someone with the HW could provide a with and without
the patch, that would be nice!

-- 
per aspera ad upstream
