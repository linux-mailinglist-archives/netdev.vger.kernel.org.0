Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6DA1A5D27
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 09:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgDLHKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 03:10:35 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41636 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgDLHKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 03:10:34 -0400
Received: by mail-yb1-f194.google.com with SMTP id t10so3537949ybk.8;
        Sun, 12 Apr 2020 00:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5dMs1/R8c1BoFICQe+ss7qAa5dztJPb8EW7x2uSWMTI=;
        b=XyHMczT4d5WJkb7C5BBDe1ZpbUzKqFltMjm6SGe9oFDYeugtu3ZExnFgLV0JPNvB5x
         hoQ5ZXq2EKhdU0XmspBDkkXsK4jmTOhbfQbZ0dbnhF+mdpW7tcoAx69imz+78v6DI4/Y
         eJKhIHK0rU/yWdSyfK/OWiKaOlFTtdXNo3BZn7BMWEC5w7BesW+LzRGUTk3qNR2ULmLc
         4h+M1AIIdK3/l+YeNKeWHAGp2bNkMi/qQYheMWYeNfnf52BUkkOBc1Dllmf0O2fzX25z
         ppnV8xBX5Sz/F3AzJGyKRwZdrYOsl/Vsi8FWb6CEBm9q+BeyhoGcxUDObzZ1IMbrHIMu
         QnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5dMs1/R8c1BoFICQe+ss7qAa5dztJPb8EW7x2uSWMTI=;
        b=XbadzZiyBvD5sDDZjmdG8Gea7XsqdLmpT6v5FdZkAJRHqG04DMZ86P6f354d7Z+hew
         I/M2bXxyGZcaTcWZVSOoaIcezOISB6/rReRpd8WCV7fkluNc9D/Xb0sQUMIXadQcVwO/
         9DAWvgCWE9UYbrQnRk7lHdoLhAJB3olteL2OqAJjxQHfC63A49/MZcMvW5iPq/wkcqjw
         J/7JMfWA8Ap1+OeoUE28OOCUgLZWEz+z03RRoXeF0hMHlvGYJw37nZ9Ud2uNfO1WCMnq
         AYp1Hh5PhhXaz55RRwxdFMa/kqkIXkSnoABIqdvK46oiR6I7yy7xoAljccvFzFdLGER/
         jgAA==
X-Gm-Message-State: AGi0PuaFz9craegTr/EufDp7/k8rWk1qjKwd5nXPDf1+VJ/gSEw+QJYu
        v329S2k8Xqadwyy5biIUslgq15+m+HhnF39odyM=
X-Google-Smtp-Source: APiQypI4MEdSfu8ZJCJDZGzJ/6gcjVZZFAZf/PuAX6zB8f8D89P8ujl0GfIPsdwHtOUAzm4mJqXPtpH7oVp0FA+x4X0=
X-Received: by 2002:a25:3b15:: with SMTP id i21mr20083761yba.11.1586675433985;
 Sun, 12 Apr 2020 00:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200411231413.26911-1-sashal@kernel.org> <20200411231413.26911-9-sashal@kernel.org>
In-Reply-To: <20200411231413.26911-9-sashal@kernel.org>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 12 Apr 2020 10:10:22 +0300
Message-ID: <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for representors
To:     Sasha Levin <sashal@kernel.org>
Cc:     Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 2:16 AM Sasha Levin <sashal@kernel.org> wrote:

> [ Upstream commit 6783e8b29f636383af293a55336f036bc7ad5619 ]

Sasha,

This was pushed to net-next without a fixes tag, and there're probably
reasons for that.
As you can see the possible null deref is not even reproducible without another
patch which for itself was also net-next and not net one.

If a team is not pushing patch to net nor putting a fixes that, I
don't think it's correct
to go and pick that into stable and from there to customer production kernels.

Alsom, I am not sure what's the idea behind the auto-selection concept, e.g for
mlx5 the maintainer is specifically pointing which patches should go
to stable and
to what releases there and this is done with care and thinking ahead, why do we
want to add on that? and why this can be something which is just
automatic selection?

We have customers running production system with LTS 4.4.x and 4.9.y (along with
4.14.z and 4.19.w) kernels, we put lots of care thinking if/what
should go there, I don't
see a benefit from adding auto-selection, the converse.

Or.


> During transition to uplink representors the code responsible for
> initializing ethtool steering functionality wasn't added to representor
> init rx routine. This causes NULL pointer dereference during configuration
> of network flow classification rule with ethtool (only possible to
> reproduce with next commit in this series which registers necessary ethtool
> callbacks).


> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
