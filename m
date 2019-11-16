Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD951FE9AD
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 01:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfKPAfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 19:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfKPAfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 19:35:01 -0500
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4157B2073A;
        Sat, 16 Nov 2019 00:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573864501;
        bh=ZowElwrmsGrsNzdowivw08ySLvn8WkJT901VnVvmvGw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ygrAkebUlqZfkZp2vvd8sS0C0NiPPlF+KrDc5sE1QhRQcMKtqWyc1qsODSsjfTciY
         E+HUX8VoRveGntQIbUNNsniNJJ8ALcw5it4RnGImAImabL5ELsYByOSzRuth713yGZ
         XguNNc6kFrrEWg1AlZfNsRVuZpZSY+8GUNKz8rlc=
Received: by mail-qv1-f42.google.com with SMTP id q19so4460474qvs.5;
        Fri, 15 Nov 2019 16:35:01 -0800 (PST)
X-Gm-Message-State: APjAAAWjZLyTNqthUrzj2eaFyj3uZ3NFklY7GgjkrDEhtrlfDUcZ8VYt
        ZcAutlbGJ+rILUlfRrdYVlu/32SB59yt2Cyb8g==
X-Google-Smtp-Source: APXvYqxWUYJ0VE48z5aNU9FLHSWMIgzyDb+dTJpIrmDUhsIbuI6lda5haPFdPXIkYUkRAmM+TqYkVFiMmLlmrmaXVgM=
X-Received: by 2002:ad4:42b4:: with SMTP id e20mr2714620qvr.85.1573864500398;
 Fri, 15 Nov 2019 16:35:00 -0800 (PST)
MIME-Version: 1.0
References: <20191115195339.GR25745@shell.armlinux.org.uk> <E1iVhi2-0007au-2S@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1iVhi2-0007au-2S@rmk-PC.armlinux.org.uk>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 15 Nov 2019 18:34:49 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL3-gTeQqiVmiMCvx9hmDiuAYLP1TBdg_pDXgaERZwd6g@mail.gmail.com>
Message-ID: <CAL_JsqL3-gTeQqiVmiMCvx9hmDiuAYLP1TBdg_pDXgaERZwd6g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: net: add ethernet controller
 and phy sfp property
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 1:56 PM Russell King <rmk+kernel@armlinux.org.uk> wrote:
>
> Document the missing sfp property for ethernet controllers (which
> has existed for some time) which is being extended to ethernet PHYs.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml      | 5 +++++
>  2 files changed, 10 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
