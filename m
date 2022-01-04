Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04107484929
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 21:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiADUT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 15:19:26 -0500
Received: from mail-oo1-f50.google.com ([209.85.161.50]:42884 "EHLO
        mail-oo1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiADUT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 15:19:26 -0500
Received: by mail-oo1-f50.google.com with SMTP id y13-20020a4a624d000000b002daae38b0b5so11851377oog.9;
        Tue, 04 Jan 2022 12:19:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oz+HvnLuVeXA2qrM66f9Ph2sFVFIVhOyEfqagnXLQEw=;
        b=7879kqMtvv4efTHf770pyZ5AKUME0t3voN5hbSYsLq4UvR57Y6/NbTMphoERKFUeLf
         p0MyEFvj0xRYFBecx4Guq3J8QUFFPXBZYKS4fJa+BGwpGk88Uwr8bMVJL5xzknfwE0BI
         nYX0N/I368LiOo8RJQv18rjs/OMvYY9r+kqnga5PQ3loQoTBKua9LM2hlKbv1DNlaw1N
         HrGK25FJtZQHAsJoav04L7Jo17GSZKxb6/ahmfvj0gLgTConiVKoTdHYNNTMpUWzsCUh
         2pdAvqIOf7B6FguuL4SWAn2kx4GbtorUJ9fhq2BhQldrKAvcDeCKXWMhsUoDhgGpqaYC
         Z6eQ==
X-Gm-Message-State: AOAM533MR5tDCyJhSZpGNObfw+On45kmXroc3I+GIRqlISUAvuJ3OvFI
        vq1XZm2B0TGPVWh1K0VvUw==
X-Google-Smtp-Source: ABdhPJwQJ/rJLQa9f0z2SCGzyxz+P0cb37Z6zuJHCsD6OMACKgJMxn7YLE9i+MfBQW7NA3xc/q4rNQ==
X-Received: by 2002:a4a:bf06:: with SMTP id r6mr32685682oop.62.1641327565501;
        Tue, 04 Jan 2022 12:19:25 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id u14sm8295759ote.62.2022.01.04.12.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 12:19:24 -0800 (PST)
Received: (nullmailer pid 1350345 invoked by uid 1000);
        Tue, 04 Jan 2022 20:19:23 -0000
Date:   Tue, 4 Jan 2022 14:19:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: dsa: Fix realtek-smi example
Message-ID: <YdSry15jzwdbh6GO@robh.at.kernel.org>
References: <20211223181741.3999-1-f.fainelli@gmail.com>
 <CACRpkda_6Uwzoxiq=vpftusKFtQ8_Qbtoau9Wtm_AM8p3BqpVg@mail.gmail.com>
 <CAJq09z6_o9W8h=UUy7jw+Ngwg26F8pZVRX5p0VYsgoDKFJRgnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z6_o9W8h=UUy7jw+Ngwg26F8pZVRX5p0VYsgoDKFJRgnA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 08:24:05AM -0300, Luiz Angelo Daros de Luca wrote:
> > Ooops thanks for fixing this! (Wouldn't happen if we converted
> > it to YAML...)
> 
> I'm working on it. I might post it in a couple of days.

Then just fix this in the conversion.

> 
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > Yours,
> > Linus Walleij
> 
