Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C23C9D1F
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 12:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241647AbhGOKsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 06:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240397AbhGOKsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 06:48:52 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A00C06175F;
        Thu, 15 Jul 2021 03:45:59 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso5650117otu.10;
        Thu, 15 Jul 2021 03:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Jk25+mO6gq+gMDn28sQ3Y0BDoaGWAn+4tPGTJctpw8=;
        b=byAbUrIUxgZplMcAKPW7DwgnL1zq7qyXFkKcw9ARufU+RPfFjTR/4rHhoQ4IlWLjZ2
         kTYbar/0LhpUCZN1rRdJWCRsqf2sSBJyPa9/+sIGmxKuOB4QRA71vhlAkuUsrbGAhiEX
         pkC8UblcfhiFjAZLB2rH5QfiM/UrYlEWOrDc4C6VknvZbpRC/8zPnkUnZAOEjRW9eA2b
         HaIjovCLCLMJ5JHVBwllSPUI1KZuXHepW/4QkDr6Wym+GECrc/HuH+W1LG96d1Xvivj9
         nRyJY6BWekAUI339weOU3UQ9768kZ2cetkbWN82X1MjZSPKhWKdcGKJ9ooFMy82Xc0Ug
         I+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Jk25+mO6gq+gMDn28sQ3Y0BDoaGWAn+4tPGTJctpw8=;
        b=H3Wr4qRKavlbcvCkXwZKD62v3SqyykSGrD8H/n1gWgjhRrj6PgDN0QXyei+V3uZ5hS
         Kra2GLRuqhLETqz7qJtsDHe06xcdq9n+sZOJeaLWhwuhUyZ8G1fZjH+owKOCWVzlOazV
         pb0kXvZ6zISDwESe1RuRFD3oIDNl/c/acIub1OFSTyAJJYUre7orGgAlLmFpTuI/4U2k
         1n34RNaTbcQPPy3DGeczL9wXLW6iaODuWCBGOhGyLe2F7ah50TkVq33d9wKaNDM6l1zi
         xMUXj/5X+vupE+WHevOiPIf5XNl88D5bZIsVIuBjVjb95jMtMDlzzSwvlpY0YbST1kf5
         ju4w==
X-Gm-Message-State: AOAM5314saJuU6giUXyjWtlRq6F3QYSkBvXMKAwICv0bo8to8Lx7ytS7
        LteRC6zb97Xb3TwEipsmYj+mG5JXM2s0T84CkjI=
X-Google-Smtp-Source: ABdhPJwPYZyDrk72aq32SqOs1xSvJQ6wXIQzeMQuusn5Z7uJCBFdc8Uq9U5RLdjm7NDxElvqr2jKrggauSZHQuzlbnU=
X-Received: by 2002:a05:6830:160c:: with SMTP id g12mr3158089otr.118.1626345958771;
 Thu, 15 Jul 2021 03:45:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-4-aisheng.dong@nxp.com> <20210715100457.ut7ji2mizog4qghe@skbuf>
In-Reply-To: <20210715100457.ut7ji2mizog4qghe@skbuf>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Thu, 15 Jul 2021 18:43:58 +0800
Message-ID: <CAA+hA=QN5noP4FBcn+UPjbKBd4dEk5Rai0qMML=Ov7AUOe8hUQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] dt-bindings: net: dsa: sja1105: fix wrong indentation
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Dong Aisheng <aisheng.dong@nxp.com>,
        devicetree <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 6:05 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Aisheng,
>
> On Thu, Jul 15, 2021 at 04:25:32PM +0800, Dong Aisheng wrote:
> > This patch fixes the following error:
> > Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:70:17: [warning] wrong indentation: expected 18 but found 16 (indentation)
> >
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Vivien Didelot <vivien.didelot@gmail.com>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: Vladimir Oltean <olteanv@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
> > ---
>
> Thank you for preparing and sending the patch.
> It looks like Rob already applied another version of this change
> yesterday:
> https://lore.kernel.org/netdev/20210622113327.3613595-1-thierry.reding@gmail.com/
> I wasn't copied on that patch, I noticed it rather by coincidence.

Got it, then this one can be dropped.

Regards
Aisheng
