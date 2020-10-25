Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084992984BB
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 23:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1419347AbgJYWi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 18:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1418971AbgJYWi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 18:38:57 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF23CC061755
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 15:38:56 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z17so8047730iog.11
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 15:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UHxF746S6sbmtOJfJcCJu8MyAxF7FMVjHr2KpqZr0V0=;
        b=fHFfIxI9jQkpIuJy7yEMpEtmPPMTCN5TsrhFgjFJbTUFPdaFvx+4g7Ar1gU+mbMF34
         hdPe2RsSuFGT6Fy9Pg4V3GwDIJHt0FeuC6k7tH2kCLmKmbDXkoeZSWwMI/A4VLq48sja
         Ha9pOZ9j+z2DlQRq3IZa3khQuO3h8mioKK6Essnbde9G1DL6i4yqp5WqG8WRL1Pyd43y
         jrQNTPzPGK04yAgpWNejkWLM9g41XUDfpzdmDy4jlxMYsyPRT9Ifh2yKx6RMHaaUVhYM
         IA4yFm6yRN1O4CMjjyWq2HjdPzuaU3gNUKOjC43YDqUO/As0jfXqnQrD3M1dCjsrxXu7
         pkqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UHxF746S6sbmtOJfJcCJu8MyAxF7FMVjHr2KpqZr0V0=;
        b=MYsd/DsJ20olFYp2PUl2VeHgMw4W3+XjvzhHWJza+4WswqxkII6LfSYENC1ov0AfL1
         yh0mrmel6u2PiOTWaGfvvP5P/XIAiGc/UcGbKXppK3tJnE7sQqRYH8poaY4/U7CMsy7g
         nS//8ZqKwTEO2MuAGQsSMMD++TenB6Xu/fn1AMK0JnI+NebjdCF1rsAjXm5wVfPBvgig
         hPJ8hQiMKQCub++zmoDxgENVsWSGHOeV0KLmmIp46hBkEpAXtfEgZsZAEtLXZe3FzSMp
         0tj4OtXgtET2xH9ozNymYULfF/TI3P9kyKSXEOFfL4u68M2BzftS9J+lr3lF5i206GIj
         OmmQ==
X-Gm-Message-State: AOAM532++rO4PTS1yyPrzS9X9o9xIRwvKTglfJv7LMaaNhM2vRc8suRq
        n9qBlcS2USZJWLOroi/z5ASx2CQk2g0=
X-Google-Smtp-Source: ABdhPJxgDCuFlVbdTQ9z60hpQCC0KdQ92STRhQbql+Eh4BtIxwqr0UY7ao4DpPVOSj1D+oRBzSwQnw==
X-Received: by 2002:a6b:ef15:: with SMTP id k21mr8964640ioh.37.1603665536308;
        Sun, 25 Oct 2020 15:38:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e928:c58a:d675:869a])
        by smtp.googlemail.com with ESMTPSA id f12sm4486070iop.45.2020.10.25.15.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 15:38:55 -0700 (PDT)
Subject: Re: Fw: [Bug 209823] New: system panic since commit
 d18d22ce8f62839365c984b1df474d3975ed4eb2
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20201023082411.27a8a3a7@hermes.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4471a8bf-bfae-f7f9-9adc-d340f5a79809@gmail.com>
Date:   Sun, 25 Oct 2020 16:38:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201023082411.27a8a3a7@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/20 9:24 AM, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Fri, 23 Oct 2020 03:38:54 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 209823] New: system panic since commit  d18d22ce8f62839365c984b1df474d3975ed4eb2
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=209823
> 
>             Bug ID: 209823
>            Summary: system panic since commit
>                     d18d22ce8f62839365c984b1df474d3975ed4eb2
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.4.15

Left a comment in the bugzilla.

5.4 is now at 5.4.72, so 5.4.15 is really old in that line. The problem
has most likely been fixed.

