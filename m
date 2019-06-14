Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B334466EE
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfFNSDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:03:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33089 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbfFNSDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 14:03:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so1918102pfq.0
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 11:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aDQDmrrdbESRd/EZP9QEPVbzMXDWofgJgdBOve8tnOw=;
        b=NVAY6kuqWEhgNUp5AxEOeWdCvgTHUEX8rABkUOOVavpbQcfe8a2tk7Qx+r0sRJ5Zhy
         B0XRBN2xPdInfmEn3OjM5ZAd2WH1JbrSjqkE8c4KfzaV9RgWSvrcSIpslf7Hvknp0SrH
         5WGXRdwGHmgLFRj+yyKH/c+3LyHLtOW2mptEz7lKzGrGwZ7xs3oHRIE4AIVG5nGyJocf
         KRWIjqhglqbUVADUwJ/CVj11hn9x3+weK0nYobqzqv7HRsGKCr46G/RNUe5WPy0vbJRf
         mXbqnBmD8NMFL35vyeu09xb1YnJ9q+hCfPLYP6RH6hH3lVx6FE9uosWZME5XJYKH2bn3
         bWmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aDQDmrrdbESRd/EZP9QEPVbzMXDWofgJgdBOve8tnOw=;
        b=IDXaYeYZ18oAhS1qOQcAAddrd9V0SCss5AsKLYxWUt6IWH6894HtvgWkXY0VuXj2OA
         qqgQg+fIUxCox6syUGRCB3GWhFQFm71Eh5CQKvWx3XGEVYEjMPqze76shb6mpwcdk5yc
         YGhVDinKlygxzITXZltj0aTAq8sB/QTp8Nr32BYAIdMhUHpcSprek7+yw8fRXsgEOjJu
         0apRa6iUBRySrgMbA3490OBT9jklxx5j/aCmgT95YpFvL+Mj5fCa3LiCLgT1nKdDyEY5
         44gFY4fqIAUgJlV2MbE5ekz7ty/IIbojKRw7CA5HQvdqHp9e61+6nWooot8MKMWUc1Sy
         6ZVw==
X-Gm-Message-State: APjAAAU01MUzDbu/hdCW3pqviusach8xhQZDrGNkFweIv6TI+/4C0O53
        XIK05UGczfzfuYPMbqcmdT4xONjYY15KVU6gCRE=
X-Google-Smtp-Source: APXvYqzzioIp7K0M61ERFSL7x48aNc5/P9H/hlMHh/il2yVHhqzfAk4wN+7rGt0UE4cGGpqKzE8flj3AbPsy8X/FEl0=
X-Received: by 2002:a17:90a:b883:: with SMTP id o3mr4373399pjr.50.1560535380495;
 Fri, 14 Jun 2019 11:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com> <1560259713-25603-2-git-send-email-paulb@mellanox.com>
In-Reply-To: <1560259713-25603-2-git-send-email-paulb@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 14 Jun 2019 11:02:48 -0700
Message-ID: <CAM_iQpXQgJti9faPA5kVV7Ly3LStHf3zwDP5S-PfBz2jR0Y8xA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 7:05 AM Paul Blakey <paulb@mellanox.com> wrote:
>
> Allow sending a packet to conntrack and set conntrack zone, mark,
> labels and nat parameters.
>

This is too short to justify why you want to play with L3 stuff in L2.
Please be as specific as you can.

Also, please document its use case too.

Thanks.
