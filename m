Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8F33C3520
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 17:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhGJPXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 11:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhGJPXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 11:23:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C535C61375;
        Sat, 10 Jul 2021 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625930465;
        bh=rF8u2jQBxhx3PDpbzzimq05yM9RfWiVQUbblM3OrCiM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DQ4ogT1KINQvsIFaugeOIh1ZU3JhD6dK77Q044WMIN4+9+PR+a58HUQH9tAM0GOPc
         G5hDJmZkdwcPvqrWLA4zmArRogoGGulcQT4PqSv3JhG82ux/f1EedSja2hH8z6Yq+o
         JwsXnAh3eo5bR87NS8oZj2i3boVfVCwzwR5caBcIhFQe59oJElQJDoQg0kPnTKhHdh
         JDVBXueJqhtP1hVIdF3D0sVMRU7hbEX3nWVB/kakLy37BMzPYxmlY746nWYL2ESgpz
         1P04PdgUazikO6P21kZ/Kp+bS3U48pLKRyhHkrYU9EOQNvm5sf4IB4HcZHNhe7cmOC
         C0qQllNTQmgAw==
Received: by mail-pj1-f41.google.com with SMTP id i16-20020a17090acf90b02901736d9d2218so2785263pju.1;
        Sat, 10 Jul 2021 08:21:05 -0700 (PDT)
X-Gm-Message-State: AOAM533oAoiaREMeI9XX08e5mX286ojj8bbpcQfLpth8PIIomGsORQb1
        YT48jXI+a7+89euN2YOjxPtcxRyNr+OlmNoByl0=
X-Google-Smtp-Source: ABdhPJxAwJwB/+gS/7JG0EPNkRbIr7GN/8dlvUFI/dE5ARTixMwBhRaDTMh4bP9em8kWg4FGqSnc/L+rNC6IKVKtSrg=
X-Received: by 2002:a17:90a:7d13:: with SMTP id g19mr44110440pjl.163.1625930465566;
 Sat, 10 Jul 2021 08:21:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210709142418.453-1-paskripkin@gmail.com> <CAOZdJXWm4=UHw42YjUAQLZTNd=qbxyRag7-MJ5V4aq_xf8-1Vw@mail.gmail.com>
 <20210710095717.140ec45a@gmail.com>
In-Reply-To: <20210710095717.140ec45a@gmail.com>
From:   Timur Tabi <timur@kernel.org>
Date:   Sat, 10 Jul 2021 10:20:28 -0500
X-Gmail-Original-Message-ID: <CAOZdJXVuaiWaJ-D7iZVPQzqW7KV=K9kPjK2LGacZecFdL0vNFw@mail.gmail.com>
Message-ID: <CAOZdJXVuaiWaJ-D7iZVPQzqW7KV=K9kPjK2LGacZecFdL0vNFw@mail.gmail.com>
Subject: Re: [PATCH] net: qcom/emac: fix UAF in emac_remove
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Timur Tabi <timur@kernel.org>, David Miller <davem@davemloft.net>,
        kuba@kernel.org, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 1:57 AM Pavel Skripkin <paskripkin@gmail.com> wrote:

> David has already applied this pacth. So, should I send v2 or maybe
> revert + v2? I haven't been in such situations yet :)

No, don't worry about it.
