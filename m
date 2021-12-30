Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E512B482056
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242130AbhL3UyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242120AbhL3UyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:54:22 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D23CC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:54:21 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id by39so42408536ljb.2
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q2IXsLE2l5/6TJ7wqHXmxiiQRR/nEVo42BOPkuRD48I=;
        b=cUp6Awaj1KCyzTGarpydLwWr292y9sXi+sbBksKAVJCN7HzP14a2cqILT4QtjlDcy7
         FIe0UF3VgCfLhao8O8Du5AkmEuvcXGUP82hKkhP0G3kuh8+E+e9TkjFspx2t5tRBtA7n
         AlDgy0Nk7cA1If8PRrPaJqqY5yu82PgiOG/Co=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q2IXsLE2l5/6TJ7wqHXmxiiQRR/nEVo42BOPkuRD48I=;
        b=TNV5aBJkIL2AcdIJ41E4m3rCKmm25wG0LephDL6H+L63w9NpiUXPoLfLv2XBM1FwbW
         c7nk5VMXoXlGbA+vDc6hH8H+eLXEopqSdJ668zKa+T+cVjKGTTCnJZK1KtzN49/ybySU
         Y+LX+W+hOUezu4lUdzbZvaKXQNO9rk0febpCYuHvNM94xCY7pBhnFHFbihRfzvTt4ret
         zU7AnXIth4uB6q6ZxoteX2GA7klwtnhoJq2A9Nrfpggz1Oo22MRBOKfMR7OkQPl2DPUU
         H81FHLzKD7G/PkcY4gOZyRG/tqZ8pkC8HYWAUPIy5f47Cl7Q9+zcjwlMwzJYnwv0OpA3
         O4Ww==
X-Gm-Message-State: AOAM532AuhCxTXg4zMUpCqvDrKIqvnpZqRjaL+jqiZJVAdLQ8XRXdjQN
        nijyIPnP/ckxX6LG2OP2SI9SKKnWJj4dLXzmdGRNhkmEGoFCpA==
X-Google-Smtp-Source: ABdhPJzaXE9kRp20caJvZT//TTLvkWwDiqWq75KFG1uoT01p03+tllVOw92nDx71X4swoPA4hSgvKJ1zff0HczLZnxc=
X-Received: by 2002:a2e:9cd8:: with SMTP id g24mr4191791ljj.509.1640897659569;
 Thu, 30 Dec 2021 12:54:19 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-9-dmichail@fungible.com> <20211230094327.69429188@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230094327.69429188@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 12:54:07 -0800
Message-ID: <CAOkoqZ=18H6CAE8scCV7DWzu9sQDLJHUiVgZi3tmutUNPPE2=A@mail.gmail.com>
Subject: Re: [PATCH net-next 8/8] net/fungible: Kconfig, Makefiles, and MAINTAINERS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 9:43 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 30 Dec 2021 08:39:09 -0800 Dimitris Michailidis wrote:
> > Hook up the new driver to configuration and build.
> >
> > Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
>
> New drivers must build cleanly with W=1 C=1. This one doesn't build at all:
>
> drivers/net/ethernet/fungible/funeth/funeth.h:10:10: fatal error: fun_dev.h: No such file or directory
>    10 | #include "fun_dev.h"
>       |          ^~~~~~~~~~~

Hmm, I don't get this error. What I run is

make W=1 C=1 drivers/net/ethernet/fungible/

and it goes through. Tried it also on net-next as of a few minutes ago.
Any ideas what may be different?

I do get a number of warnings because there are constants in one of
the headers defined
as 'static const' and they get flagged when a .c doesn't use them.
This looks like a tool
shortcoming to me. Do you want me to try to redo them as defines or enum?
