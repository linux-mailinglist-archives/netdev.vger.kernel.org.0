Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7CF7ACC7
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 17:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbfG3Puq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 11:50:46 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41869 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfG3Puq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 11:50:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id d24so62561191ljg.8;
        Tue, 30 Jul 2019 08:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjZf+MF90g13zAX26LAEhRqKIVvf2OUOjoC3kV1A4hg=;
        b=VCiOqmTYTGpW6+TzwBMHfJxMPqrUu8XF30lk6st37bbgYF0Nf7k/Ayzd0LJg8IBLBq
         B3nvq4nVJBAQxNrRqb7+W+Jm6ixv8nCgbaSG6aa4rLbAnY8luPpY6ID6P5a5Nw3+J5Vp
         NPKJjRJpfwWiwxG33PpNADm57+cWKpUJallVPjO8oxqWC6rZo1F2IHOuJzfN9gSUdbaR
         mopvFTWRS4ljV2AxObuvoOxuWM1rbjnoJlMoPhjnW+WsmxmmDHPoF/4hSDABmRprWtLP
         GU1NqSCyGEgJG4UB3Coad+OcB9LKekzx4b08QHehDl5s4aH/oDP1GZExKz5AD2EL1i91
         tJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjZf+MF90g13zAX26LAEhRqKIVvf2OUOjoC3kV1A4hg=;
        b=LtwYJzksIIj4VKXFb76yw3iblmhH6AFpQOKmkatUVSuDEMTQ/EUA56QpIL4ySiZdeG
         Rbts1YEwIuwUUhLWVJQurpr2DxHZ6TqWcFsrM/vA2U/9nT7qoptr0aMhQgX4esPiiAGw
         +/Fp8RqSJJVk/OaJt04pmW4sABTDMxx0WXLLpta6HX7TijoBWhXfCmD1iJUMubGtPVVt
         Oh/bTGmwBTYGXxo+dNBNuw6z2+Kv5O07+neAseFsm2/Xtk6WjdGlYNZzq5uth7GhbgSX
         2jMg/3+F00iMOdHX9DM0NIfaN8cR15mJU2vRRgf31qxuubvJd/QnGMZ0nChRbd0qCrdb
         0azg==
X-Gm-Message-State: APjAAAXYDNQNx9mUO8grho5+Aht7hsvWVEbPq0mcIxEUm7Bf9grkBN+V
        KgotI923XCi6DtHjy2p8LaV31nUv9BAQ2l2aF9w=
X-Google-Smtp-Source: APXvYqwkPXJqhZBbFxl4c3kyyps9obbir8sQKSKYcOVSdu+a9rKp3mkmY8WgYDRqTdAoVGsUk7BE8h3GnFHlnbo87c0=
X-Received: by 2002:a2e:8155:: with SMTP id t21mr4643059ljg.80.1564501844026;
 Tue, 30 Jul 2019 08:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190730101451.845-1-h.feurstein@gmail.com> <20190730140930.GM28552@lunn.ch>
In-Reply-To: <20190730140930.GM28552@lunn.ch>
From:   Hubert Feurstein <h.feurstein@gmail.com>
Date:   Tue, 30 Jul 2019 17:50:32 +0200
Message-ID: <CAFfN3gXxC+t7nStOfTd=iCodg6S0ZwdtV309_qpYrrJ0eweVzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: dsa: mv88e6xxx: add support to setup led-control
 register through device-tree
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Di., 30. Juli 2019 um 16:09 Uhr schrieb Andrew Lunn <andrew@lunn.ch>:
[...]
> Sorry, but this is not going to be accepted. There is an ongoing
> discussion about PHY LEDs and how they should be configured. Switch
> LEDs are no different from PHY LEDs. So they should use the same basic
> concept.
>
> Please take a look at the discussion around:
>
> [RFC] dt-bindings: net: phy: Add subnode for LED configuration
>
> Marvell designers have made this more difficult than it should be by
> moving the registers out of the PHY address space and into the switch
> address space. So we are going to have to implement this code twice
> :-(
Ok, good to know. I'll wait for the first implementation and take it
as a reference.

Hubert
