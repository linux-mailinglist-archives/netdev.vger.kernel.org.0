Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B239218C38
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgGHPtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbgGHPtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:49:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79251C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 08:49:13 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mn17so1389135pjb.4
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 08:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6kCq93Qx6Ba8p2Dr6/uAUb/bzt+4sTHyUBo+LKPEGuo=;
        b=xu6JR5DuVTNcNANwbGFv3movcO1arvC4iLgAaaPRQupGSGgfIO7bdGak+sCJcICZvo
         ozEpbOjIKuUff7/6+tEzSBZoNkIJRNdYbAai1+q+tthIydnvfz/gfwL9hISrYga+lOM6
         gNu1CDxnN3nnv0CfQ9i/QVAQ52OZrdPzomN9AerUWQIjok9k08bAz9IQ67cfuQAHy2Ok
         nUKUl08LyYWuLvKxo7yMPvJWJCSSW7jyLN21Xw0nYr2h6LWk3lTSfhgcekn6U7EQbkXc
         cgmv6MAW9+akpVUfHnN5m8oyKqASFTtquRSugubTOsOTAGTBjPr0s9dsj+4+2up/aL5x
         GpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6kCq93Qx6Ba8p2Dr6/uAUb/bzt+4sTHyUBo+LKPEGuo=;
        b=VgNKDKP+IryQBCcC4/3GfAyzCwuq6JlIt/nSFCEUtreVGOBXliLlak3KlcfXPC3RRk
         dTvlfV8bo8W2/uWT4wbIiQvudfWEK/swCPcQoyMMZGQ9xSZAkjI8pOfsNjKwZUqYe5s2
         ktkA+zpOjiGEaIQ17rxb7dvnWZHSBk0b22EATC4qSMksC+Jj7UkzdET+RUWhJsQZYQVk
         P/NwNBHYdayBmFaOWUwD4nhivRm73YLhOXFqDu9V43GQIiT2e3h/iDZNxV+oof1L5iGY
         t0CMa8HLfxMzR9VCr7MQ0EZDzU65TwK2TDhFj/QN2e5uB7qDqDqXqU5slVdR7Yhydv+w
         dgXQ==
X-Gm-Message-State: AOAM531meEODKUVUkzz/lx9blM1FsVWashnOScJMMppwVvMUgWADXX8w
        K73QKxuJXqHNqrLqmLIsBIyPFI4jnedWUg==
X-Google-Smtp-Source: ABdhPJxbyxsF4vZ1I/kSESkzul+UmsMi7Ckf5CvA6PckTok/jFhjeTHuTkGvQNL7t8tJppUcWKoryg==
X-Received: by 2002:a17:90a:db02:: with SMTP id g2mr9680477pjv.43.1594223352939;
        Wed, 08 Jul 2020 08:49:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p9sm70766pja.4.2020.07.08.08.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 08:49:12 -0700 (PDT)
Date:   Wed, 8 Jul 2020 08:49:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tony Ambardar <tony.ambardar@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] configure: support ipset version 7 with kernel
 version 5
Message-ID: <20200708084904.5affa861@hermes.lan>
In-Reply-To: <20200707075833.1698-1-Tony.Ambardar@gmail.com>
References: <20200707075833.1698-1-Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Jul 2020 00:58:33 -0700
Tony Ambardar <tony.ambardar@gmail.com> wrote:

> The configure script checks for ipset v6 availability but doesn't test
> for v7, which is backward compatible and used on kernel v5.x systems.
> Update the script to test for both ipset versions. Without this change,
> the tc ematch function em_ipset will be disabled.
> 
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>

Sure applied. Maybe it should just check for > 6 to be future proof.
