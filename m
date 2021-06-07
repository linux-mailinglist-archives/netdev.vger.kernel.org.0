Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FECE39E4C3
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 19:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhFGRIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:08:20 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:39551 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhFGRIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 13:08:17 -0400
Received: by mail-ej1-f52.google.com with SMTP id l1so27877433ejb.6
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 10:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6jG8fG0GqzHaHTewjIgBEd/sf2X5LfQRA/MV1//47rE=;
        b=whUEEw+Tpa+aHX4KqcRNinkQaQDZZR1eVDWgqy2acmutkSNAKodGfV3Eh3zCFF/r2E
         EZuI6vEGmpvM9b9tpCC3m4mE6rV4VGvDBbEdp6/eMQIHAfmXLAq+rgKyWXQDYLWxN1DW
         PkeyeB552VkZiac16yN5s9wfxUBlnIw7Ro7n9VmzUTx861wQKnDEgOobPy2LmTu1Pu3I
         lPF6JKTP5EKFQ8XbaJ0rb4pswTvk1E4jLVsSz2a8dXxrvvB/QeIxVPpdTlJu0NqHFHjd
         o8qoGwkTRbeEJOFR0vl6mqJfDhu2pHl0gk1AsW+SSo1T6rJAFL3TuCrYCjzdO57Eff+C
         q7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6jG8fG0GqzHaHTewjIgBEd/sf2X5LfQRA/MV1//47rE=;
        b=CynXevp1K9ocqp0bzC7hsPSMjH4OcB54T71CgoXfUHkPiy+fDstj175I16s8imQUzo
         I3KxoxSdOS8d7yH+fX6V1DxRyiRRwI5vb4J4TWxKX7wVJp6hiq4df2UcU6E7b77qPuw8
         RUyoYa+9vyp2Nrth7SUnTSvQn0JbymyZ9W98hQl+LjckDvT9JqTX2My8BCASnB1jH0/9
         i7MTUUrQsi+0AMsM4ZqR6czTOT/AJMMqewf2s0FCM2+pv7yhm3eAlNWcxQTLFlLsRKrE
         S+cZSFns6h0X6QKIhJu1QnodRLaj6/41iuSX4Ko9DXjRN+dDIdyi6l4gEiaTpw5+ORXR
         KmZQ==
X-Gm-Message-State: AOAM532reXj5fDvrbRA7Hg2UZIRTFh4tMqTC77PClg6V/6JWAUM6Vl+S
        zYmTcF0bIvEzUgeDw9j4rCVTmMkJ6ocmLEtDEMrY
X-Google-Smtp-Source: ABdhPJxSqbbzdEkBauzBSZOj63lXqru92bwaU25QDlfWMPQ0Xv+0ErdjoGY3j8FBExHlfkyjKqjxqNBL+6LMw0E28KE=
X-Received: by 2002:a17:906:1113:: with SMTP id h19mr18675234eja.398.1623085525430;
 Mon, 07 Jun 2021 10:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210607150100.2856110-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210607150100.2856110-1-zhengyongjun3@huawei.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 7 Jun 2021 13:05:14 -0400
Message-ID: <CAHC9VhRbcBjYSpt0q2LrizWA6O2iPPOSfsEggUxfU4oigk3x2A@mail.gmail.com>
Subject: Re: [PATCH net-next] netlabel: Fix spelling mistakes
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 10:47 AM Zheng Yongjun <zhengyongjun3@huawei.com> wrote:
>
> Fix some spelling mistakes in comments:
> Interate  ==> Iterate
> sucess  ==> success
>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/netlabel/netlabel_domainhash.c | 2 +-
>  net/netlabel/netlabel_kapi.c       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

-- 
paul moore
www.paul-moore.com
