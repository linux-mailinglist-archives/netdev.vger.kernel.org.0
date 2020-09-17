Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C726D8A8
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 12:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgIQKSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 06:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgIQKRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 06:17:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9769C06174A;
        Thu, 17 Sep 2020 03:17:51 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so1105547pgl.2;
        Thu, 17 Sep 2020 03:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYi8HnIWM/kO8nwJ+HKbxZvF4OkTFzuiSprk/qaZs0k=;
        b=VErbHZweycnRz1NTZf0sAAyPdlJVRIgMutj7R18gOgjemYeXeK/vb/iRDRhEQ8bYL4
         8JGUpbXEwHr6fotZJdNuDJ3rSbl9FzGWFP51foNAha6l9bGytwv986u53o+x54Fupmwr
         B16mB4d/N3TF2GlI4aILFgZTxOlKT34RmtRcILJJst8FUF5RgW4D31iataA5rbzSeAnf
         DgbbQf9yKlPX4PwBzSHvTSxPyuQABKH3vBQIp4ptsLM9WWx8r1o/O6w/4EawOnjPRFBg
         jCdrLqrLEnVHtAL0p/myjF7E5QlllFT9fRJtUKEHHWmoUvLJTS8G3XKd8luIIU9LhumF
         fGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYi8HnIWM/kO8nwJ+HKbxZvF4OkTFzuiSprk/qaZs0k=;
        b=cP5LmbSs6CulNvAwVMtbeNIJNcJr/ijqhFgEqO+E+EVLcZCfu/VSeNAuQYQXhjEUeL
         KKu74xbmP5xbnIaWjX6JZgwCe/T2+vS46mG34NwT49+XXAWCSPpcRWmyOs6uXuE9/1um
         r9pZOE/uFzCH1p5zunR90yi7cvTwV/t7OImgrLkzKkA+R3Sx4OL4Y7aKUXnvyfBhg//G
         zRdeziUEqp1N+TjLNpVtqDAbg/WvEEinYkhZjRaAOQWMtgyR5Al9+00vaJHLoyXYiGHq
         3TAS52kCQvVSlJCOg7H/I/g1jmGwzdG/5d+D5UYA5hpkrdX9X66/+V3EAGpPViHygpuJ
         682g==
X-Gm-Message-State: AOAM53022WiJp4roCVjSFUNjmXhcUuBfGOXA2zc6JegVDRc5Kr/9MvmM
        A7SMp75f6LE7duWHymdddKSpHliFE1vhfK2vOJ4=
X-Google-Smtp-Source: ABdhPJx+W92fXLB9f3uvRh9XMnhkTrwzCBYoLhPoNAPfmfq+DcPXki4QA4/jCVvq8EvJcSfOdF3PsIFt5UEq+jcrdAA=
X-Received: by 2002:aa7:95a6:0:b029:13c:1611:6524 with SMTP id
 a6-20020aa795a60000b029013c16116524mr26930258pfk.4.1600337871456; Thu, 17 Sep
 2020 03:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200916122308.11678-1-xie.he.0141@gmail.com> <CA+FuTSf4di9Zsw+7XD1+3rwRMT4f0pUPprWKtmg83mVkHum9Zw@mail.gmail.com>
In-Reply-To: <CA+FuTSf4di9Zsw+7XD1+3rwRMT4f0pUPprWKtmg83mVkHum9Zw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 17 Sep 2020 03:17:40 -0700
Message-ID: <CAJht_EMHCXc2JEAnQa-4R=uDsRAaAFmWVka3k6+kHzDUWaT8QA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Fix a comment about mac_header
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 1:51 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Acked-by: Willem de Bruijn <willemb@google.com>

Thank you, Willem!
