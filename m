Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171EA2D9B5B
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438331AbgLNPpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:45:30 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41143 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728570AbgLNPp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:45:29 -0500
Received: by mail-ed1-f67.google.com with SMTP id i24so17580303edj.8;
        Mon, 14 Dec 2020 07:45:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YxCiPQ08bXOR9WwEZlKFbDgY/znMZCzuPkpK3/N4u4I=;
        b=lz9aXCmh8VqXMUvFjgkC7pKZ9tPU+aSucVZgbKViPQLt8hrZ2j8xNqfalc60k86irR
         qjaA+QFmp25tFNmDHlBU7oHkSbNE8fwKjOTI+moTPdD81kHe78/swztpKcGpUXAOtZG+
         UBX07ORSMculEgZjHkCklpQsaHzXrQh1LYcbcQudO5Vt4q7tklyxEQMmO7oEx3KqLrt4
         dEBFAwd67JUyy4aLGEqUlPlz4NiHOYVvkBEnmyjkbhJpAh6CXrtXbTNxaLJk5+cbU0Np
         09zgOUqxxupfhNXzY2QHwOAtW7LEjLEGJtoqR/Sz7QH9oYDay81ELhVWMf3PMx9v3DD7
         V+ew==
X-Gm-Message-State: AOAM533LoFLgxzAy+5QARdJvxT6lHZx9OPnpgPWigj2aJgZ7Jb99HJ2Z
        gTy1TCRUmkb4JJtx9nRTCSg=
X-Google-Smtp-Source: ABdhPJzax4Rk6o4qgm3tHTPLlC1IzRv08FnPJymM2C3AEOPFB+5xVKkaqEAgt1Ts0aOI6t3gmPe05g==
X-Received: by 2002:aa7:d915:: with SMTP id a21mr25033719edr.251.1607960687860;
        Mon, 14 Dec 2020 07:44:47 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id m7sm16014117eds.73.2020.12.14.07.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 07:44:46 -0800 (PST)
Date:   Mon, 14 Dec 2020 16:44:44 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [linux-nfc] [PATCH net-next] MAINTAINERS: Update maintainer for
 SAMSUNG S3FWRN5 NFC
Message-ID: <20201214154444.GA2493@kozik-lap>
References: <20201214122823.2061-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201214122823.2061-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 09:28:23PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> add an email to look after the SAMSUNG NFC driver.

Hi Bongsu,

Review and testing is always appreciated. However before adding an entry
to Maintainers, I would prefer to see some activity in maintainer-like
tasks. So far there are none:
https://lore.kernel.org/lkml/?q=f%3A%22Bongsu+Jeon%22

Contributing patches is not the same as maintenance. Please subscribe to
relevant mailing lists and devote effort for improving other people
code.

We had too many maintainers from many companies which did not perform
actual maintainership for long time and clearly that's not the point.

Best regards,
Krzysztof
