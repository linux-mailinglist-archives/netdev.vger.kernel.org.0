Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492373F2F7F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241038AbhHTPbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbhHTPbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 11:31:42 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE91C061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 08:31:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 7so8911264pfl.10
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 08:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cye6WzyUi6T9Hng6ZW3V74r+W+uk1OJmxGJuP4EsEHw=;
        b=KORNtiBrdDcQjEe3hRcef63mzNcFjbeA7XBH86+XbdKaUuMoVA0oGPLKZ52ZdLTm4G
         usNYHuN41sI3+GnVjpOWK6svdMt1p1ZkKGau0x2JRKYeWXuQU7wDWglZ4HqnZ6Jivt11
         Yx/fShJUDEquBu1tftDo0fsD/Y7xIpxXu6B9pjNt09ViIVLFTDIZp1rSFOvP4iKaoWQ1
         H0d+kKXUnTOjDsguJGloYr2X75RZ8AVDoolicEMzDEEjZdtfx54GQGrlQl7O44MgxkXV
         bVukiPlWCbjCSK3zHdzMKZ7vHo8q13cHfiecqC7Y/ZAi/hE49X3hfbyihoBRtKVc2cEF
         pVfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cye6WzyUi6T9Hng6ZW3V74r+W+uk1OJmxGJuP4EsEHw=;
        b=puUSTdYSmZ0fr9bVUNPuj7jsCuP7WtjMLJNSGakjo5RTFUrrXgJaqO8RANr018x9Im
         1AOxZfydkIhRGfaHUiwE912gzMnZDFsLG7ejgUsOLoOurfUfm5K8nQVU9L0w3NdMZjMN
         h7G+4ykuQVibB0JTWZKY9OF9WKRuxom/XrJ3PVePSp0kQt2CGJJFtORImLwvSM4mBfAS
         SSyeeRq14NaKg0xa7pS3DNrUYW908/RDrIxJA7sF/qWqy4BM746qCWNUhkqJkQ6qRuSx
         LDMZMzr7cmxhSg3TRI0MuSP6RvBDToMig0S4EptBXK7ZazSJBpqGvjHgL2XoQy4z0LwC
         8XKg==
X-Gm-Message-State: AOAM531vrsoYpZB4DfoQA6uSBqhvAN48zIkqfHQHDJk3ztaUPm/FMuLo
        y0lHsOHrJM7NnEUbtnQsyjw=
X-Google-Smtp-Source: ABdhPJx9AKNhl6RFvq53Y1JPc0UJDop/8to8brzf42/snWDtyl8yAl15q32jqgUqlOSDOvlpMtX+Pg==
X-Received: by 2002:a63:5f15:: with SMTP id t21mr19340006pgb.391.1629473463823;
        Fri, 20 Aug 2021 08:31:03 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o2sm1874661pgu.76.2021.08.20.08.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 08:31:03 -0700 (PDT)
Date:   Fri, 20 Aug 2021 08:31:00 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
Message-ID: <20210820153100.GA9604@hoboy.vegasvil.org>
References: <20210813203026.27687-1-rdunlap@infradead.org>
 <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 12:45:42PM +0200, Arnd Bergmann wrote:

> I would also suggest removing all the 'imply' statements, they
> usually don't do what the original author intended anyway.
> If there is a compile-time dependency with those drivers,
> it should be 'depends on', otherwise they can normally be
> left out.

+1
