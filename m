Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A348B2684D3
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 08:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgINGZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 02:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgINGZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 02:25:08 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE8FC06174A;
        Sun, 13 Sep 2020 23:25:07 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mm21so4920451pjb.4;
        Sun, 13 Sep 2020 23:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m+ubujVIMN5tvcfBHHHzSWGRiDzzBaa34xu4brJPkZA=;
        b=b2nvnA8cEwUSr1B8BNTmLgZZiEwXPDr5vS58ZrXeAcwAEi2Nm5TjW4Al3Rdt2gXw7y
         85mDl5MgokeogcLvFXVrTeuZFbibtUHRRTKDMvRhG+Wld4EhLIcDXtAVKFzX2ovT/DaX
         KaOo6G8dg6FvOh1siJG1i9RZci8MiYHRtU2ZpufYYAG6bUgYX9yWd0o5a8NdjYTvT10W
         leIh/LF50FKb+siy8na4vF4so/rfYQ1Qg6l1tmE7BOICS/7YPDIH1G3LSfgHAAu1znhD
         E1RYipyIzjJOywhIfwKDjn43RkPb5rIokvduzbmVgObZluiHf8ML32EW2fPw+6V7LzPr
         Z72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m+ubujVIMN5tvcfBHHHzSWGRiDzzBaa34xu4brJPkZA=;
        b=WqsK1J6rIlvE+/QySvC99LdqsxPWInzLZshhRx0a6T4Lg4/WY8/tX3frfjjm9JMBUl
         iAkNt+iSRKrAQzyfG50hHXdbAmG/jyC1G7045xwMBhdnhbDmQzZN7g51+ILxt3rH/ulw
         69NR/9GiGx19UCyb/J0j7QJsBfxvp1Ov8tTkoLxEYJ1O1POuOOWAYucOZQWWaJfNNnll
         Y1RKWMTg5j8YOFhhsvCSXSXSrY0QaCWQlB608mUBCvvpgMewONfAeHTEaSwmkXV2Ojkd
         Qu+jKueU54paV+N8IgyyEPgE2jIYJl8BDPMTzXugNiS24Ty+sxFUloTMWRpAzttQZAPd
         jcUw==
X-Gm-Message-State: AOAM531aKjUoJzt8x7BT2xgEv9RAFhuhg6Nvys50HkfhicFWzsaFkV4U
        uDxyYOlmyGFRK3xxmH1WpYAIpIbhStFMD5CM/UU=
X-Google-Smtp-Source: ABdhPJwRx6qk8cMtTCIKYEE9S79qxd5Xzvnh1youlhWSlyLGiktQO5Xn3ANgRN6hpuaOx18p1ICjJMxr0k8mNYDFob8=
X-Received: by 2002:a17:90b:816:: with SMTP id bk22mr12802874pjb.66.1600064707356;
 Sun, 13 Sep 2020 23:25:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200912021807.365158-1-xie.he.0141@gmail.com> <4d6345b6b072f60366aec9626809da95@dev.tdt.de>
In-Reply-To: <4d6345b6b072f60366aec9626809da95@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 13 Sep 2020 23:24:56 -0700
Message-ID: <CAJht_EOkUS3JWqpFEvogB6T190L9NM=JuZFENdL4eVf0BkAthQ@mail.gmail.com>
Subject: Re: [PATCH net-next] drivers/net/wan/x25_asy: Remove an unnecessary
 x25_type_trans call
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 10:32 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> Acked-by: Martin Schiller <ms@dev.tdt.de>

Thank you, Martin!
