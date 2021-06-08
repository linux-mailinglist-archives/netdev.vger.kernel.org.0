Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBDD39F0E6
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhFHI3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhFHI3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:29:33 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A75C061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 01:27:28 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id o12so6858320plk.8
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 01:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kru1jVKIZDBbX/gbXId8v7rU5ZsvCdv1CDcksUANLSM=;
        b=PCY7GfBYObdBW6XaxdECThXX+WKhR0WID57PrjrWtuc52OtUQzDC1l6FFxmF5/dMVw
         G+QM5sEHfZmNy/aEaLf6Acw0vzeeoMSHkt3bqAJnjjo4RfSqrk0okxmOs/mn2uA8zpGp
         fSgXCMbgNwV5H7JNsjXoGUmrr0GrxfI/hi6JfLrG2YhIEJk5AgVbmh6z5R/aj1cw6/p+
         +4G9qZPpXLdjYsPSlnNZbAp6Hj42wgyVnSZOq1/SElmgJBL4Z2W3NmaBks7ULIfhNrui
         DhXwZuoCSY9xiEpGPuin1DAtSnENmnMHhinlG4gKCT2Px0sylPVun+ttRHxAYFtvNxz/
         /iUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kru1jVKIZDBbX/gbXId8v7rU5ZsvCdv1CDcksUANLSM=;
        b=J75UhqeUK26JmDT9ON8Tp3xxMwDr3TlK2fbOi2+wYbQF5wgZGLUlKLPrs87dGqQGrK
         6nh/NJuuj8CptxLgJ9CsswVnBaeDpR1BqgUMuHfMBzkCLHEjJMcMYB3sixwYP7aK4zJw
         P+ORi44Z8n4Eqvi3voAf/K261VT0wQdErenNDhZZX8j30GVnJWmjQD8ow3keBEZjwjAl
         7JKpmpa+EvNpf4XrGCqQKEpThdErM2xRlOPY4m9onj8SLK15jer3HvtqSi5ypy6nRL1h
         FLCtsU/EGv7cnVR3X7xUrgSo3DBzrzNVdfrkQC/evTH3384JIDVazHzgPPRONI5f3uU+
         Btvw==
X-Gm-Message-State: AOAM530rXkNzAPSfnlDNvPwlsvoVCsucDeM2wFf1x37NQtodbFAJi0No
        oIPgrHWAF2E/g24YeryRLmBcGZn4UiPRfHTQyCknoEg9bze3CzUj
X-Google-Smtp-Source: ABdhPJzbAX1nUH+3GGcXlPZ9uD9JPAK6Bo2dLzJrat++g2PixCKqruoRtTKM8RrwvOduXp07jnUJUOlJHmx5O/L29mA=
X-Received: by 2002:a17:902:8e86:b029:10f:44bb:2c42 with SMTP id
 bg6-20020a1709028e86b029010f44bb2c42mr20670116plb.67.1623140848266; Tue, 08
 Jun 2021 01:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com> <20210608040241.10658-5-ryazanov.s.a@gmail.com>
In-Reply-To: <20210608040241.10658-5-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 8 Jun 2021 10:36:39 +0200
Message-ID: <CAMZdPi9myKaDmanHv-FGrdwv0taDU3Q-8=n5zL0QHA12go=9Kw@mail.gmail.com>
Subject: Re: [PATCH 04/10] net: wwan: core: init port type string array using
 enum values
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Jun 2021 at 06:02, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> This array is indexed by port type. Make it self-descriptive by using
> the port type enum values as indices in the array initializer.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
