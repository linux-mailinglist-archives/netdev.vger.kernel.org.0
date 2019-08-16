Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52698901BF
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfHPMh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:37:59 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42013 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfHPMh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:37:59 -0400
Received: by mail-ed1-f65.google.com with SMTP id m44so4983686edd.9;
        Fri, 16 Aug 2019 05:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aT3jGG1YNcHwcyTnJmTqzndCbFRkZE1GryxTRKjRC44=;
        b=MGnpH0iy4SRhnjY6YG8W5zBbE7lgLdoyttUmgLOZTBEBWklUL5cQb9AObOdrzee672
         ZU4SlhvmtdSCTSPf/kbR0aGWiGVfaDpPtmUa74uoNY7uG2oaMjFoRZoQ2AOLvglt0pTn
         FnysPTSP5rK4ha6EBjtuOYC6Q95z3+0421sMFtgvrvPfkMtP1jvqar0KwjUQhxjqhf1c
         JSU2V0SwYNWueQghJ/E64nFSlPWRi2uP/kWhrQv2JttVzLlAHZXnUj112tvn2HeRNzIx
         +GkTnP3Cz9JBFX8p03C4R4fwlK+AYQyqTekm72wbTk5IlHsjzjImBvOizlzgIFnanSXS
         jhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aT3jGG1YNcHwcyTnJmTqzndCbFRkZE1GryxTRKjRC44=;
        b=hbhynUZew2vzQkkhVMK4B2kKIrhjpkFb2dOkf4IX/9X8rdOPWMYWJHAZ127SxUSNDw
         LGjIaJ15LCeSSmQ2zbuf8DpM0TU2TToguJBlpLHVO1aX9Zfo3QcNyMxUekQP4ebo9zbH
         EoyL/BrkAon5Hf5wHrA5y32i7Cvx65L2FCUiddgzz2p7Q6wsmMzIk1uqvePPUHM7VnO2
         uHO9FKfeUw6kYfiF4JgRUB75/nOGS2K+gV2h56WzmE1H9dW/hev+AgWcgcYYbNQn2eWi
         yBuxt9kq7+rKYwZadMhC/S9GRX7GfBBhmfuKGHFyzbJN2bgio/lCPKriiyuUpOnngjLt
         Ojuw==
X-Gm-Message-State: APjAAAXm9aTVy400SK3cOkwOyBkHhzkMFaowihFV8Ufd08w3EkjjsVaC
        sns+V+aG8L6sy2O+SVkVq+VP8nyiuFLVDQbgoOI=
X-Google-Smtp-Source: APXvYqweKlLMG8XDoYHQkkr7XvayGS1UCf+qnxoZiAw/uATvp93SN67Fb5wnSisUWCgZi4Y0a8g8WQ9K6lARrMTUtkw=
X-Received: by 2002:a17:906:d298:: with SMTP id ay24mr9162561ejb.230.1565959077466;
 Fri, 16 Aug 2019 05:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190816004449.10100-1-olteanv@gmail.com> <20190816004449.10100-5-olteanv@gmail.com>
 <20190816122103.GE4039@sirena.co.uk>
In-Reply-To: <20190816122103.GE4039@sirena.co.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 16 Aug 2019 15:37:46 +0300
Message-ID: <CA+h21hoP3t6j2mTd2BLwizqbFap+9Z2vdxQ4ahHS3-7Vr31Lxw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 04/11] spi: spi-fsl-dspi: Cosmetic cleanup
To:     Mark Brown <broonie@kernel.org>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Fri, 16 Aug 2019 at 15:21, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Aug 16, 2019 at 03:44:42AM +0300, Vladimir Oltean wrote:
> > This patch addresses some cosmetic issues:
> > - Alignment
> > - Typos
> > - (Non-)use of BIT() and GENMASK() macros
> > - Unused definitions
> > - Unused includes
> > - Abuse of ternary operator in detriment of readability
> > - Reduce indentation level
>
> This is difficult to review since there's a bunch of largely unrelated
> changes all munged into one patch.  It'd be better to split this up so
> each change makes one kind of fix, and better to do this separately to
> the rest of the series.  In particular having alignment changes along
> with other changes hurts reviewability as it's less immediately clear
> what's a like for liken substitution.

Yes, the diff of this patch looks relatively bad. But I don't know if
splitting it in more patches isn't in fact going to pollute the git
history, so I can just as well drop it.

Regards,
-Vladimir
