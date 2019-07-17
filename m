Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0877A6B8E8
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbfGQJIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 05:08:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44877 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfGQJIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 05:08:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id r15so10978172lfm.11
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 02:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k7UdXNTU/Lcm5T+73Mu9Lk3fJTqZdL2ygB2hxg/bvs0=;
        b=ARPF8ysRS2qme660bnfPo9Sf6dUPUtYkSPR39gw+zuIoL7NZtNifRCF1SXDGFunevB
         uB8IuWYM1iKac8uIBfwlUQMiC8nlsO8DxhVUztZfWDxGTVv0AP3VA2gNewP/19w1a1LW
         +DLcKtE6254Ku0JHNY1kGsvrzSV9XAaFc8P93ruj/1XfqkiXTeiLARokVfXAhvHNhUAp
         oU/deRwXfo0vLuXt+HfYNfQX609LSRr1XRlJKA2ojTpGANWQaz3QzdMP8uvHrMD7iW8j
         FKIENDnCF1zDqRZvKhZ/RJljDTl2EmbDSDS67+xcSz06fthg9HXQPPGsqQ0bzxxY3PqD
         Ki/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k7UdXNTU/Lcm5T+73Mu9Lk3fJTqZdL2ygB2hxg/bvs0=;
        b=ZY7P3HrUQ1tmk+kpRUmkHXkEc17mhdLiTOnubff1DTCan9hx1xAmGsGJd4S7tckUtw
         VYDD3mtuZ8d5OrJ0sFKX1mwmLIuN2lSbAesNeP4P224gndnO2tC+QkqjEH+EqBv0UCw6
         zGPRZcySt/eesJeCDlvGnMCaRSAJAgkUdVpVjCz4Ae5kLkXg7qwWdx7M7ChEcpi27Ekh
         m1eoR+RU/cbIlb+RZF/sf6/g3t8rbAXJEZ3FDxbgUp6NzLKzMbLzke4PXjhTvbZPTqRw
         IPjak37rkFEqtTGU1Y3FrfSdHHElPSB2HUJeb09wraCPu0EZbIN2Z7kiF76jmCHanu1U
         aNzw==
X-Gm-Message-State: APjAAAUEITN6F3sRslsMsWR1ais3RxWUxr4kye8QAG87HKST6sLJ5Sra
        3j62LGJ61tglrBxBHpM2bEiyTEtozIur6DU1m2N+cA==
X-Google-Smtp-Source: APXvYqyUa5Y6gp/AOOmOhWXG0woHIHFHQ/pw+MgFTpkHnca8dVBQpSXO7UwrMm763Jwm92ZWv/5Cb/402QneMPo+DUs=
X-Received: by 2002:ac2:4644:: with SMTP id s4mr17067571lfo.158.1563354489475;
 Wed, 17 Jul 2019 02:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
 <1558611952-13295-2-git-send-email-yash.shah@sifive.com> <CAL_Jsq+p5PnTDgxuh9_Aw1RvTk4aTYjKxyMq7DPczLzQVv8_ew@mail.gmail.com>
 <b0c60ec9-2f57-c3f5-c3b4-ee83a5ec4c45@microchip.com>
In-Reply-To: <b0c60ec9-2f57-c3f5-c3b4-ee83a5ec4c45@microchip.com>
From:   Yash Shah <yash.shah@sifive.com>
Date:   Wed, 17 Jul 2019 14:37:33 +0530
Message-ID: <CAJ2_jOFEVZQat0Yprg4hem4jRrqkB72FKSeQj4p8P5KA-+rgww@mail.gmail.com>
Subject: Re: [PATCH 1/2] net/macb: bindings doc: add sifive fu540-c000 binding
To:     Nicolas Ferre <Nicolas.Ferre@microchip.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sachin Ghadi <sachin.ghadi@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 9:08 PM <Nicolas.Ferre@microchip.com> wrote:
>
> On 23/05/2019 at 22:50, Rob Herring wrote:
> > On Thu, May 23, 2019 at 6:46 AM Yash Shah <yash.shah@sifive.com> wrote:
> >>
> >> Add the compatibility string documentation for SiFive FU540-C0000
> >> interface.
> >> On the FU540, this driver also needs to read and write registers in a
> >> management IP block that monitors or drives boundary signals for the
> >> GEMGXL IP block that are not directly mapped to GEMGXL registers.
> >> Therefore, add additional range to "reg" property for SiFive GEMGXL
> >> management IP registers.
> >>
> >> Signed-off-by: Yash Shah <yash.shah@sifive.com>
> >> ---
> >>   Documentation/devicetree/bindings/net/macb.txt | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
> >> index 9c5e944..91a2a66 100644
> >> --- a/Documentation/devicetree/bindings/net/macb.txt
> >> +++ b/Documentation/devicetree/bindings/net/macb.txt
> >> @@ -4,6 +4,7 @@ Required properties:
> >>   - compatible: Should be "cdns,[<chip>-]{macb|gem}"
> >>     Use "cdns,at91rm9200-emac" Atmel at91rm9200 SoC.
> >>     Use "cdns,at91sam9260-macb" for Atmel at91sam9 SoCs.
> >> +  Use "cdns,fu540-macb" for SiFive FU540-C000 SoC.
> >
> > This pattern that Atmel started isn't really correct. The vendor
> > prefix here should be sifive. 'cdns' would be appropriate for a
> > fallback.
>
> Ok, we missed this for the sam9x60 SoC that we added recently then.
>
> Anyway a little too late, coming back to this machine, and talking to
> Yash, isn't "sifive,fu540-c000-macb" more specific and a better match
> for being future proof? I would advice for the most specific possible
> with other compatible strings on the same line in the DT, like:
>
> "sifive,fu540-c000-macb", "sifive,fu540-macb"
>

Yes, I agree that "sifive,fu540-c000-macb" is a better match.

> Moreover, is it really a "macb" or a "gem" type of interface from
> Cadence? Not a big deal, but just to discuss the topic to the bone...

I believe it should be "gem". I will plan to submit the patch for
these changes. Thanks for pointing it out.

- Yash

>
> Note that I'm fine if you consider that what you have in net-next new is
> correct.
>
> Regards,
>    Nicolas
>
> >>     Use "cdns,sam9x60-macb" for Microchip sam9x60 SoC.
> >>     Use "cdns,np4-macb" for NP4 SoC devices.
> >>     Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb".
> >> @@ -17,6 +18,8 @@ Required properties:
> >>     Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
> >>     Or the generic form: "cdns,emac".
> >>   - reg: Address and length of the register set for the device
> >> +       For "cdns,fu540-macb", second range is required to specify the
> >> +       address and length of the registers for GEMGXL Management block.
> >>   - interrupts: Should contain macb interrupt
> >>   - phy-mode: See ethernet.txt file in the same directory.
> >>   - clock-names: Tuple listing input clock names.
> >> --
> >> 1.9.1
> >>
> >
>
>
> --
> Nicolas Ferre
