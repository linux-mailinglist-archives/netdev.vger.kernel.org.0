Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54E31B11D7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgDTQkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726373AbgDTQkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:40:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B53C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:40:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a22so80811pjk.5
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ulMzQvW0TzIHBJ/5TqpD9HUe5Pfdc1CmSWUFwtyFFAQ=;
        b=Q6DuEXWbCnDa60OvRwgANFK0T6gBot9ps3IZTUQqnEvlfrCafYLc02BetAntySkQ37
         kpSdjBhjg7tok37dvy0OIhWNPCzf1gCkXZyCWcZyubfqMTqEt1nqp7qNOcR19Z3n45Rr
         p0RLuiKJcGBIrbs9X18EZUEHu95yICdTNgon8ba4bD6Z2TiyDE/uYiW2L7SDvOoN+/89
         9HrLFJjIMte+JvCFsqLmixrlF6OSdcvB6Wa1Nu9md9pr6z5dBJR5SRpHxS9keObItjMw
         d3UKp4a3JIHWO6NktBJKFFeTxGxG1fSpPQFl+YywCl5QnX+g+UX820Zc9BjuDweWThv2
         3c0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ulMzQvW0TzIHBJ/5TqpD9HUe5Pfdc1CmSWUFwtyFFAQ=;
        b=OxO06OfxlEwNAX2ZSigRMba/01KcWydoYULNDvvI6S1Ba8Nj9NAYlhtjaMxCO2fEQp
         CnH7cTViQWVC8a7Wg9vH8X6F4y85rUz18NO+99hS/fiI2pDCrapHCKbEs6CfM9YLWoA4
         x2IdCb/r05Dr5/2Czf/nKKaudRrdnb3br8u6ptFU6qOyzgoz2uwuKqHJveypARqd6Ci6
         0+Q4QzgLfMCuP7W3JRFslW0JRElzyDxZg6/TCVUKhCjtdZt1nXNHb7u2F3TOmmj0NrXV
         QFtYycbahCFJxHVcHGUWn0A8h2rzAZwOG08ZMkQTtYbCTvDL9dkJSCpH8Z0Sx1AFVCMo
         wBXA==
X-Gm-Message-State: AGi0PuauOASN4EFTD6ggB3qXWk66GEQ+70LYXO+NiU3/I/q+WDo7PlhQ
        M/wpnImNWSaLKrwAqb6D2ZpCtz4FDT9qaA==
X-Google-Smtp-Source: APiQypKyrnus+9aypStEuyzFrt1tGG6AhLQosS/tDZnxRl6JuvowlChB+ReJDvEGCIobNsL1DysBmg==
X-Received: by 2002:a17:90a:aa83:: with SMTP id l3mr310772pjq.100.1587400832406;
        Mon, 20 Apr 2020 09:40:32 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i4sm135180pjg.4.2020.04.20.09.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:40:32 -0700 (PDT)
Date:   Mon, 20 Apr 2020 09:40:24 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 1/2] man: add ip-netns(8) as generation target
Message-ID: <20200420094024.3460ab6a@hermes.lan>
In-Reply-To: <20200407174306.145032-1-briannorris@chromium.org>
References: <20200407174306.145032-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Apr 2020 10:43:05 -0700
Brian Norris <briannorris@chromium.org> wrote:

> Prepare for adding new variable substitutions. Unify the sed rules while
> we're at it, since there's no need to write this out 4 times.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  man/man8/.gitignore                    |  1 +
>  man/man8/Makefile                      | 10 ++--------
>  man/man8/{ip-netns.8 => ip-netns.8.in} |  0
>  3 files changed, 3 insertions(+), 8 deletions(-)
>  rename man/man8/{ip-netns.8 => ip-netns.8.in} (100%)

Sure, applied both patches
