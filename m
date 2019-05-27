Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947CA2BC5A
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 01:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfE0XcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 19:32:23 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34566 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfE0XcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 19:32:23 -0400
Received: by mail-lj1-f195.google.com with SMTP id j24so15921181ljg.1
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 16:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ypIDp6qLOevj5ezuoNAlBi+dILWLNz/hIdEJXlDIeg=;
        b=NQ5vSHZ4+ccnhuMlxZLGegYlVtoRF2PM4rmLWO9P++LL+MoeXe4Lf21nREu61ZsyT3
         VVGiczIBLJ99Pabdogf/I0NSug3ZdgEdmvEg/FRMytg1qUsGqnSrDmEvXBUwYgjcIFmS
         L4kW0yVUy/s9/BBpOZfio7+2917+xhdLMdYZ0ONhgXTNADQqF1IabGD5MBN2nkS0fs3B
         f6jV5ALeDaYQh0MrpcE+rdM/hji7imT8WsP3xAG1ibIM02ovcNS9ryzPUfhzVcWi4qVQ
         DWfuyUKBFCHrdjTXohaPihzuPkGOTB5UYCDQWPWgklk4IL0aLvXDNOyiOnrtYqg+v4+a
         9A4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ypIDp6qLOevj5ezuoNAlBi+dILWLNz/hIdEJXlDIeg=;
        b=lWvUYV4Buqs7/dmrSogFTWAh1Apgh+pSuF2Os7k0u2dh8UjH8MPXJAdchq/HT7aGk2
         VxVJUa+oykmIIUGRG2VSHwrE5Po027qPC3973dlfv7DMDYEWMMWxjqDXR0EwzDyLmPHa
         XVQwm9g35j4oWEndaX+heZ6W245S0ftKsfRx4OELr084k9tj+kNuLkayLtV3u4c0cwHb
         0mAve1vnO+Uh6EMdkds3L+Nsk8grXE2mGVCSCb8dyV/HsgOC7KU4fVGGoIdXdGtbSh0T
         u9sq6ze1dmC0tBozf97zQLF4SUEfYYaRDQyiYh9juaGtW8t5+jxD5r5ZXRe5SctUSvQo
         WX1w==
X-Gm-Message-State: APjAAAXclNvDKKoymYaQz9GcCe6sZFhU878r2VnZxjqG9xeMVHISkKyi
        F6/GgIwKcr5V9SOS1dRE09ZuvykRd/tREKQwWk8=
X-Google-Smtp-Source: APXvYqwmYbr7v9hsOb99dB5eHQGOuT6bmedSwjmPVzjSttcu6NYyMBRXNjvyhfdr+8zJJ5Huxr/7Hy9QRM8+jY2Ewsc=
X-Received: by 2002:a2e:9849:: with SMTP id e9mr13443641ljj.185.1558999941074;
 Mon, 27 May 2019 16:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com> <1558992127-26008-2-git-send-email-ioana.ciornei@nxp.com>
In-Reply-To: <1558992127-26008-2-git-send-email-ioana.ciornei@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 27 May 2019 20:32:26 -0300
Message-ID: <CAOMZO5CKTJT5fOYsw4XuQdKGRiFSQQqum5nci79wSuNOnyhrWw@mail.gmail.com>
Subject: Re: [PATCH 01/11] net: phy: Add phy_sysfs_create_links helper function
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, vivien.didelot@gmail.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

On Mon, May 27, 2019 at 6:47 PM Ioana Ciornei <ioana.ciornei@nxp.com> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
>
> This is a cosmetic patch that wraps the operation of creating sysfs
> links between the netdev->phydev and the phydev->attached_dev.
>
> This is needed to keep the indentation level in check in a follow-up
> patch where this function will be guarded against the existence of a
> phydev->attached_dev.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

As you are transmitting the patch authored by other person, you need
to provide your Signed-off-by tag.
