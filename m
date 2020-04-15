Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50FB1A9793
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895152AbgDOIwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505554AbgDOIwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:52:19 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415AEC061A0E
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 01:52:18 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id i22so2600078otp.12
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 01:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZCUHiYYMH/G4Vj/Sqwd6OPeDpXyCtDoKrnuuyZW76nM=;
        b=R+fcctcpUVM7bgjtt7NExQLE64KZbCPh591b4Nqle1ymrs0xUAs9xAbfm+y3RIteHq
         LZxzhYavPfqV/e56OMNc9fNpAdNOssa0Vb8X/Bw6xr8synPXvDFNV45/vPdjIJcBEQmH
         l2mazh36QyecmW4hnuCSM5+VX0lRsNTYPmTGNuojb/6qa9ihAt/B2DCHdCxFk2+KSAra
         7P3OBmp6OUvC0jtT53z0pD2OD5MIZwXz0qmVMwhRnon+Q4lvKVEy89DaxcChUQJhu5Q6
         8epUAaEKHdykKA1+Hru1q0GxZUHAtW5+Q1+pqR+Zju9M/NWp/k9cGQGaT1D3UZuQkIlh
         nUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZCUHiYYMH/G4Vj/Sqwd6OPeDpXyCtDoKrnuuyZW76nM=;
        b=NBhX/iKX8qFhphCEE3QkDal8V5hJ/dy3GeV3/UfXHVRl1cBN0l5r5KDatCJIFrhWpF
         DkmjVFqHh7DQ/tzrHf5hjGIwQ/OWsD2KMR3A6dYaEPE7OGnadpSyAUT54C641Jsc8MOw
         /G1lk3cJQqrCuciUPZGUaoFynaVplferEs+JIbHhedrSpmPAkxVdfVX0TIwbXm+E0gXw
         1y/HyPDVevTiYTZGyrt5VFC13+1f6eJQdeV2CGcBkIzluzneQ6dvMWKQCEC//vNO9r5z
         AuIGAZ9g+jdzCQXwgV09lbaZj8SszwaxvI8IHSM6N2sp3DgVJnSg+bssS+PF8Zgym4QQ
         IyoA==
X-Gm-Message-State: AGi0PubZaOM/NlCjm/liZP3V43jdfvvb9Vat5geNCQzhjcKAG2JjxdRR
        rW+q8PGjg0GhneXAdrSTqh2DM5Uozb5USRPdDsb1nA==
X-Google-Smtp-Source: APiQypKBgMlXolVF7p7MsOedbvV4RyaNeLUsZBlgYqPA/1aeIk6fU5CCiWfO/6W9C+vbRqDTHLyMDAXwBdIuvXdXvZM=
X-Received: by 2002:a9d:6041:: with SMTP id v1mr11709860otj.66.1586940737597;
 Wed, 15 Apr 2020 01:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200414181012.114905-1-robert.marko@sartura.hr>
 <20200414181012.114905-2-robert.marko@sartura.hr> <08c288da-6f5c-7f04-81bc-4c7cb311af3e@gmail.com>
In-Reply-To: <08c288da-6f5c-7f04-81bc-4c7cb311af3e@gmail.com>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Wed, 15 Apr 2020 10:52:06 +0200
Message-ID: <CA+HBbNEke7e=+_zoiv67V5_pZqes+3P7pR6VkTz24=CQySLtRw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] dt-bindings: add Qualcomm IPQ4019 MDIO bindings
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org, Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 11:11 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 4/14/2020 11:10 AM, Robert Marko wrote:
> > This patch adds the binding document for the IPQ40xx MDIO driver.
> >
> > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > Cc: Luka Perkov <luka.perkov@sartura.hr>
> > ---
>
> [snip]
>
> > +examples:
> > +  - |
> > +    mdio@90000 {
> > +      #address-cells = <1>;
> > +      #size-cells = <0>;
> > +      compatible = "qcom,ipq40xx-mdio";
> > +      reg = <0x90000 0x64>;
> > +      status = "disabled";
>
> I believe the preference is to not put status properties in examples.
> Other than that:
Will be changed in v3.
Thanks
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian
