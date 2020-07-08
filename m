Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A172190E2
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgGHTjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgGHTjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:39:11 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E7AC061A0B;
        Wed,  8 Jul 2020 12:39:11 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so22154037pgh.3;
        Wed, 08 Jul 2020 12:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WTMxuhF4PjD0nlzQ2RlEoSU3DISq4JMFhiXOc2dhut8=;
        b=DKkGr6fBQ8dPpagkVIHS48tG8TgWYJZvhQtNOb7rE7EmDsx++o/fD7HCyzTiLGjQ6F
         JyAVKI1hIsIlVOWXmwVNUkor0MdgGqZcSrhKSk09XOLQKCQTWvsuT9NY+J9JiKN3YI1U
         yi5AUuMzfgocgULfIntC8pE/WXuVS9ADB0F66zN6g/osj8W0Svzr0WRZP/K+68kubfC6
         Bg/0V6hPhq96RctZx9AgluCNsf6CFcPy9B9lzhoSoTGQW4mJlaNpNAa/+KQoLxG7J3tP
         rpJx2uFbZLavBpv+5/4PNV8UGUw24CX5sXnO4juPfCjtk0CII7gv6oSsxuoic8WHHVj/
         L/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WTMxuhF4PjD0nlzQ2RlEoSU3DISq4JMFhiXOc2dhut8=;
        b=YOpEnRV5Ev9pI9wD+GvNa9khtQuNCLcTJ827bBbZs/8CKorciDJtvl5x8oYvaJVC8O
         XHRbpbpVuqdqPJfy08VVRJ2KObcD5Xn3Q9/BgpUjCGpKG33Trlm4DcKAcoeS+335XQ2K
         tKlvWR0gQkHAMaai0A3X5y9QQ2obifKr39o3tKp+M38sXMGb8vh/GqC2ywsavJxS0x9j
         //Tsn78vpFqeqgRSDSmI8kwjXfnzSSfQd8JI6KQBheI1ve9DulTfp9c9qSf70ulfDq7s
         2uAvX7B9/CHQdPdyWJOq/EwkWlVb5kL4HMUDJ+jFvWr4ddMZQ5QJxr9J8cl4vkyb6U9K
         99Qg==
X-Gm-Message-State: AOAM533j4L86A2t9gVeTq4nfnxtlICwGY8As6t39UtzXrQVidxBD4/Ly
        xj9jOiqzTlj7oAAudLb//jVqIKPrAgCLak9ddYofW4PB
X-Google-Smtp-Source: ABdhPJzJdg/FqcNBNSOJ8kS6Db1fKWu8wt49NKNdbKwuqObjdU+bRYMXAGB9iIFEIxwpCU8ECm7a9oVt9jERJuUDdTM=
X-Received: by 2002:a63:924b:: with SMTP id s11mr49294907pgn.74.1594237150622;
 Wed, 08 Jul 2020 12:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200708173435.16256-1-calvin.johnson@oss.nxp.com> <20200708173435.16256-3-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200708173435.16256-3-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 8 Jul 2020 22:38:54 +0300
Message-ID: <CAHp75VfcmctOquXGRRi-cfvaUVtSeQK0xeTh0HYtPcmzhv-8gQ@mail.gmail.com>
Subject: Re: [net-next PATCH v3 2/5] net/fsl: store mdiobus fwnode
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 8:35 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Store fwnode for mdiobus in the bus structure so that it can
> later be retrieved and used whenever mdiobus fwnode information
> is required.

...

> +       if (pdev->dev.fwnode)

But do you need this check?

> +               bus->dev.fwnode = pdev->dev.fwnode;

Shouldn't be rather something like dev_fwnode().
And maybe set_primary_fwnode()? I'm not sure about the latter, though.

-- 
With Best Regards,
Andy Shevchenko
