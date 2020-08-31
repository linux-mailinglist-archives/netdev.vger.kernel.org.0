Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73CD2579FD
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 15:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgHaNDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 09:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbgHaND3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 09:03:29 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447B1C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 06:03:28 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c8so1714977edv.5
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 06:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=05NmgxAogRMxikqEYOFhSuRC9ehvmNY8RMYUyTHbKT4=;
        b=YRKWGcTBqleO/DnJm2RbiYkX8DkEc6u+4PPUegMayYWk+YRcjWc0LjnB/DMI2QgV3R
         ihMOLGMabPmzGk/rkAAdAwV6QpSkpRywdM4tJ1S3bF96mnywgTyAm6g1Fbu14sQ7oaRN
         4x9e5yU3aTrJIWpWyYSKv5d5Pxtpo4FZJtKgxzWXFsy7clRc9Qsx8FLb4po0sCgiCGZZ
         yxHPrknorasnsQ6J+XqBqi6QmRfOZcdPstpBKQJzaY7IJZJdh36AmS5kSu5WfXE4VZj9
         EDL7SZmw3F0aHeMH0QB59hVdCUc4OgRkCgcYAlhr/aYvRjruuoGeun94rLzwXh9f2dR5
         gu2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=05NmgxAogRMxikqEYOFhSuRC9ehvmNY8RMYUyTHbKT4=;
        b=WAFyodJLa3kKRaTvfhps5COc/tq6OflCyNqkCfMuIpOfTm/qUumINO1t1eTFKJQB04
         CAz4EAC6RHCWxPnRYddY3Yb6jreHtT+RK6eBEf5yXhPRS1pF6UH8vutetznMyifA/lwm
         3J5ywFbP/Y0/Qqy+d1Vg+XgRiOhCD+OrgssBf1oIoSIkXwVS7HOjA9SHE0w9cyj9O5KV
         sTaEBG+UYmML1yx9dHNvr+IzcB48yzJbaeoBnQINmAceGjgBrqSDusmt6yP2FB1cbPWZ
         3occOjlPxu49saCk5AL0cQtvEJpzJCBfrkk5wsKYr2lonOD7owsJynh+yeemlmvh960M
         Bs5g==
X-Gm-Message-State: AOAM5319dXB7r/nJUqpOYruluKIY86jHdW3DyfgXGvO7PQ6UOeN9N9TC
        wf9TaMr8eiAMMpFR8TggE30tWxlHmioAAr0cJ/MbhbjL28A=
X-Google-Smtp-Source: ABdhPJwRi19vqk/GhTaXpKYrR2gVo9M++thTpcKYUQc8Ee/5SHOL42UbOH3L32Cw111hCwKUQ84oJ/Zh78Wa2Lj22vI=
X-Received: by 2002:a50:8f44:: with SMTP id 62mr1215795edy.3.1598879006959;
 Mon, 31 Aug 2020 06:03:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200824073602.70812-1-xiangxia.m.yue@gmail.com>
 <20200824073602.70812-2-xiangxia.m.yue@gmail.com> <CAOrHB_BaechPpGLPdTsFjcPHhzaKQ+PYePrnZdcSkJWm0oC+sA@mail.gmail.com>
In-Reply-To: <CAOrHB_BaechPpGLPdTsFjcPHhzaKQ+PYePrnZdcSkJWm0oC+sA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 31 Aug 2020 21:00:28 +0800
Message-ID: <CAMDZJNU47t1TuqWt+HLBcdiPhTyiYWJeG3y4xFTrnysKcLOALQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: openvswitch: improve coding style
To:     David Miller <davem@davemloft.net>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin Shelar <pshelar@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 3:23 AM Pravin Shelar <pravin.ovn@gmail.com> wrote:
>
> On Mon, Aug 24, 2020 at 12:37 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Not change the logic, just improve coding style.
> >
> > Cc: Pravin B Shelar <pshelar@ovn.org>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Acked-by: Pravin B Shelar <pshelar@ovn.org>
Hi David
This series patches were ACKed by Pravin. Will you have a plan to
apply them to the net-next ? or I sent v4 with ACK tag.


-- 
Best regards, Tonghao
