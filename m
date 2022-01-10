Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB20489ECE
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 19:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbiAJSJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 13:09:19 -0500
Received: from mail-oi1-f182.google.com ([209.85.167.182]:43771 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbiAJSJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 13:09:18 -0500
Received: by mail-oi1-f182.google.com with SMTP id u21so19723738oie.10;
        Mon, 10 Jan 2022 10:09:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e+IJ/H3vHc96FCz349IEzD3v2PAh/04rXoK0wUxSNSk=;
        b=iDeDJajNAQ4atO6WvPsTeBj3J3bj4dHL6BpHaVdETbozQJmE0QLTnCtzqbHPrK3qXj
         Tbf4W9BsXDBaSar3mxK8O9IqOWEs3wMJ9K09SDTMGd8QhRcJH3M6vt4avEo73HJO4jCW
         xlUkl1/ddVXI7Dxu6wwV0Z8e2WVKIAQkDJVReswtis1JWHVfZZ3ZGPCGiu/fNZonQyTV
         E1MF67HcFf9JN6yAxOsQJsqVUr0qX8BZjjMrChykr8l2iMfG7jU/4zPmZY4pNXnMgD8M
         CDxT+SaJ367rR77zWPYVwXrwlU7KBaFi7Voqqt3XiSSfkzd+lC68/INpTRzXMvMQJIvd
         eYYw==
X-Gm-Message-State: AOAM532R2N/Yl9zl1zoLjyHB0iFkSRIE7dnJCFYmn1FSGBdplDj6e3X1
        FjCjMlmsnBaN/mOKJ5TY7Q==
X-Google-Smtp-Source: ABdhPJxyEhB2UbZMI+FmtQ8XT80zneLJxQ6M4BfFQhDzJ7SM3kTcdKi15btwdNzVk+g+mfLVLAo/8w==
X-Received: by 2002:a05:6808:b0e:: with SMTP id s14mr9892843oij.61.1641838157674;
        Mon, 10 Jan 2022 10:09:17 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 4sm1591108otl.26.2022.01.10.10.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 10:09:16 -0800 (PST)
Received: (nullmailer pid 1208088 invoked by uid 1000);
        Mon, 10 Jan 2022 18:09:15 -0000
Date:   Mon, 10 Jan 2022 12:09:15 -0600
From:   Rob Herring <robh@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML
 schema
Message-ID: <Ydx2SwE6DiEd+OEY@robh.at.kernel.org>
References: <20211228072645.32341-1-luizluca@gmail.com>
 <CACRpkdbEGxWSyPd=-xM_1YFzke7O34jrHLdmBzWCFZXt-Nve8g@mail.gmail.com>
 <CAJq09z5k396kc1VU0S_a_6gwpT5sO5LtXFcW_T8PPzKmkRpnQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z5k396kc1VU0S_a_6gwpT5sO5LtXFcW_T8PPzKmkRpnQg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 08:44:37PM -0300, Luiz Angelo Daros de Luca wrote:
> Thanks Linus!
> 
> > > +    description: |
> > > +      realtek,rtl8365mb: 4+1 ports
> > > +      realtek,rtl8366:
> > > +      realtek,rtl8366rb:
> 

Why have you removed Linus' comment?

> There is some confusion with the n+m port description. Some 4+1 means
> 4 lan + 1 wan while in other cases it means 4 user + 1 ext port, even
> in Realtek documentation. The last digit in realtek product numbers is
> the port number (0 means 10) and it is the sum of user ports and
> external ports. From what I investigated, the last digit numbers
> normally mean:
> 
> 3: 2 user + 1 ext port
> 4: 2 user + 2 ext port
> 5: 4 user + 1 ext port
> 6: 5 user + 1 ext port
> 7: 5 user + 2 ext port
> 0: 8 user + 2 ext port.
> 
> The description in YAML was from the TXT version but it is a good time
> to improve it.
> 
> BTW, I couldn't find a datasheet for rtl8366rb. The commit message
> says it is from a DIR-685 but wikidevi days that device has a
> RTL8366SR, which is described as "SINGLE-CHIP 5+1-PORT 10/100/1000
> MBPS SWITCH CONTROLLER WITH DUAL MAC INTERFACES".
> 
> Do you have any suggestions?

I think Linus just meant to add spaces around the '+'.

Rob
