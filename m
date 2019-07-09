Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5264462FDE
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 07:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGIFL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 01:11:28 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38509 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfGIFL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 01:11:28 -0400
Received: by mail-pl1-f195.google.com with SMTP id az7so1979271plb.5;
        Mon, 08 Jul 2019 22:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FV7uyWwtvMV2i7smjumOV97N5dk29bMDQstes/Ncgy8=;
        b=M1hijk/ui8sZaqBVT1hjia0XKdY92edcBLMt/AqWFpmfQsqBEOgMfsSK+W3BuwgcEa
         6mPZdg1UiPSs4tEYeCdU5Pub/SRt3Nw2Hz/Ic6HkOMGBnPp16VT9umklQiEna77qBY5m
         LUJEPOLbbLNyGuJxAS4JhDfMHv5mOT4skAYdSccR7cUSMg78MkpTyqRGD1CxaLwyr8ca
         SkxbfEYz9/aOPrbSgbg0z4lUht3GB/SbqGFMhRRqDYoPc0Z4kYheE7RNBMbQSsQTfekk
         Gm6n5efJcvho99X9ZiD1CTAZo2Pe2Q0ChO/Tn1MMesKSGqdzKKL7SBvFs5F+dcIoJSH1
         Epbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FV7uyWwtvMV2i7smjumOV97N5dk29bMDQstes/Ncgy8=;
        b=B5Xt18elO4yPGn64ihkKfem8AmW01dmXzgdggj4yma4pea3eBXoxqJz8UwnV8UMP6i
         b2hkWEUT0MT10sr+99ylyFDVIwFGb82v3KInFK/F+DXQ9yh4auJJ+l0btZD3d2Z9D39i
         6KHTDB6AMjKSeaohNxLJ+meHmixvEhrcOvnBXWuQKCrRC/648i9OhXA1e+nTWNA6Yitv
         cmc5LssDZuk41tdzyg3E/HVU+VogPD3e6K4SuFBampMiaqDcdMLg2brN9ENJJXAyPXys
         uT/0J1DhJnCRprVeG/AxAGdnf7ndTKNBB96tksgeb18ewByanblGprShESHFhj31JAS+
         7dRw==
X-Gm-Message-State: APjAAAVL6IXdzt+KIEbO7HFZzf+VvzC8b+zIotTR4ro4E+ZK2L3RWXuX
        Jg/Ueb5oLj9/+DS68jxqaw0=
X-Google-Smtp-Source: APXvYqyn99tXbTiSR+YpshSEG0gQfV6PEnPvcaCgcu+OMifv2wZR2jjLqnWEVM8gIJHRncKFDeSrdw==
X-Received: by 2002:a17:902:9004:: with SMTP id a4mr29689029plp.109.1562649087747;
        Mon, 08 Jul 2019 22:11:27 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id i6sm16416325pgi.40.2019.07.08.22.11.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Jul 2019 22:11:26 -0700 (PDT)
Date:   Mon, 8 Jul 2019 22:11:24 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V5 net-next 4/6] dt-bindings: ptp: Introduce MII time
 stamping devices.
Message-ID: <20190709051124.vf2au5htyhghk4yx@localhost>
References: <cover.1559281985.git.richardcochran@gmail.com>
 <d786656435c64160d50014beb3d3d9d1aaf6f22d.1559281985.git.richardcochran@gmail.com>
 <20190708213837.GA28934@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708213837.GA28934@bogus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 03:38:37PM -0600, Rob Herring wrote:
> > +Required properties of the control node:
> > +
> > +- compatible:		"ines,ptp-ctrl"
> 
> This is an IP block that gets integrated into SoCs?

It is an IP block implemented in an FPGA (like the zync or the socfpga).

> It's not very 
> specific given that there could be different versions of the IP block 
> and SoC vendors can integrate various versions of the IP block in their 
> own unique (i.e. buggy) way.

There is a version register where both the interface and FPGA are
versioned.  The driver doesn't presently do anything with that field,
but if newer interfaces appear, then the driver can deal with that
without any DT help.

Thanks,
Richard
