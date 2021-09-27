Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CF64191E8
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 11:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhI0KAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 06:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233703AbhI0KAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 06:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6456C60F43
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 09:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632736739;
        bh=SoA7/TUXdS+d0oJCF/cTsqi0L4GYYaT5vD9ANx+qFHw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BhE9VupGim4vn1SzuZbIEpKDG85PyptFiBT2uet+M1UtUVk5vcdrS3J36KM+j98bM
         ZA1NUE/5RxfTITv27nrhW9T2Bk1kudJojA7a8MuCr0A7qDxMvuAHbmrD4yJB5Klh8J
         JVvEw5SRaUoR3wsGoF3tUS8oHNG6hiKU49pG5T+r24W4OuBJxFaQ8ECuhL73m/yFSX
         Y1ycLDUbh3OVVBuJr+nCrMv2ubgD+mr2kvS6F+x6m4FbAroV+LspFpU+6PZUW1S+LR
         nKHVUyNx8xc3YX0u5EtM/cWqo663w6plIadrJ+pnBsJ4nBPeaMBbWNpsVkmCB9gpFx
         S0QDqijRHN9MQ==
Received: by mail-wr1-f46.google.com with SMTP id t18so50833905wrb.0
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 02:58:59 -0700 (PDT)
X-Gm-Message-State: AOAM531T3tDPqYzGsMYXJO5MD0MM+q8h7Hr3uOWAdShgaCJv2DTUwxMd
        gMxYal05PTtAEvjEZ156mddtjdayYlGwSuk9pe4=
X-Google-Smtp-Source: ABdhPJxDPzCLWYQaXd7udwL3YLW3EwUfMD/ylr/9ES0fKJRHADzbENA3gObhpsoacIvzYzwXV9Gt3Aualem8nn62zAs=
X-Received: by 2002:a5d:4b50:: with SMTP id w16mr26770643wrs.71.1632736738026;
 Mon, 27 Sep 2021 02:58:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210723231957.1113800-1-bcf@google.com>
In-Reply-To: <20210723231957.1113800-1-bcf@google.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 27 Sep 2021 11:58:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1aGA+xqpUPOfGVtt3ch8bvDd75OP=xphN_FrUiuyuX+w@mail.gmail.com>
Message-ID: <CAK8P3a1aGA+xqpUPOfGVtt3ch8bvDd75OP=xphN_FrUiuyuX+w@mail.gmail.com>
Subject: Re: [PATCH net] gve: DQO: Suppress unused var warnings
To:     Bailey Forrest <bcf@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 24, 2021 at 1:19 AM Bailey Forrest <bcf@google.com> wrote:
>
> Some variables become unused when `CONFIG_NEED_DMA_MAP_STATE=n`.
>
> We only suppress when `CONFIG_NEED_DMA_MAP_STATE=n` in order to avoid
> false negatives.
>
> Fixes: a57e5de476be ("gve: DQO: Add TX path")
> Signed-off-by: Bailey Forrest <bcf@google.com>

Hi Bailey,

I see that the warning still exists in linux-5.15-rc3 and net-next,
I'm building with my original patch[1] to get around the -Werror
warnings.

Can you resend your patch, or should I resend mine after all?

      Arnd

[1] https://lore.kernel.org/all/20210721151100.2042139-1-arnd@kernel.org/
