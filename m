Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1B41A883A
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503245AbgDNSCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:02:01 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44369 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503222AbgDNSBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:01:40 -0400
Received: by mail-ot1-f67.google.com with SMTP id j4so532951otr.11;
        Tue, 14 Apr 2020 11:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bilYsvZAPOBeLR5infdzzosnMgLyQCA6aquQk0OK3DQ=;
        b=tEgFCishxzyDCcPfTWc/NiPCcFl2AZDqtzJq255uxUrD9woHp2cRTyA8ivEke4kXuo
         rd/B0IkKDbtEb4AoFDejP1HYOlgAwlMufPFrvSCxWgw40BJdAx5jQJwbTB+B4B9FaGkz
         twmlvqG3ZwxFPJyteqTvrORYprjjHZIq4AxaFcST6GBWx0FoO/u12H8Z92m3p0K+Y/Ip
         /RUVrfNnkiE9XEOHdt81KeH2CpzfleBXcUkB4Uu/2LGkppgk7MhG/L6Wy1FexiTsIx9d
         lsMKJWxdK2gQ8OPFnac+ic2oIzsX1/J8QK4PCPs9NER3WJoctTnYvgmXf5YyFYW+gGX+
         LDKw==
X-Gm-Message-State: AGi0PuacHfOtzLqxUun/EmEwW/1/jAGeKkFRIx+NRUlkLnqV+xe5goKA
        lOZQeqOprzofxHP35YneOQ==
X-Google-Smtp-Source: APiQypIyeT6xZf0FyX/A4PwaP/ZCpTja6l9L2zgL1zqqCWt/vp9DiITDaZcngdai2PZwvxJRbfN1Ag==
X-Received: by 2002:a9d:12c4:: with SMTP id g62mr814625otg.164.1586887299735;
        Tue, 14 Apr 2020 11:01:39 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h11sm6288667ooj.17.2020.04.14.11.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 11:01:39 -0700 (PDT)
Received: (nullmailer pid 11421 invoked by uid 1000);
        Tue, 14 Apr 2020 18:01:37 -0000
Date:   Tue, 14 Apr 2020 13:01:37 -0500
From:   Rob Herring <robh@kernel.org>
To:     Christophe ROULLIER <christophe.roullier@st.com>
Cc:     David Miller <davem@davemloft.net>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 0/2] Convert stm32 dwmac to DT schema
Message-ID: <20200414180137.GA4816@bogus>
References: <20200403140415.29641-1-christophe.roullier@st.com>
 <20200403.161414.635525483978443770.davem@davemloft.net>
 <df446a1a-c651-caa9-6086-9d84b11f3159@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df446a1a-c651-caa9-6086-9d84b11f3159@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 03:11:03PM +0000, Christophe ROULLIER wrote:
> Hi,
> 
> Gentle reminder

If it is in DT patchwork, you can see where you are in the queue. Feel 
free to review patches in front of you for faster response. :)

Rob
