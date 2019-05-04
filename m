Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 038CE13C27
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 23:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfEDUoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 16:44:08 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37830 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfEDUoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 16:44:07 -0400
Received: by mail-qk1-f196.google.com with SMTP id c1so1032945qkk.4
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 13:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=4lCC3F3+CDz9Ahb9rgo0P2vN9CX4+ndmjrKLAhx63ho=;
        b=JVyQ2+yFzoJc3vki7fCSqSjSOFpEJBth7Ltl37a8x2pP+YdJWu0Yw3eviLc8rYqAmM
         PN3oa3zEzPoSkqOtuS0VRQdfR6KG/KASvTWZrequyeu3bLsDDcEk0+OzaPTwEuGYG1eJ
         5shGZt8B1NZ/rnby6yumvZ0PazCRf3iBJhq4JclS42QRO1tUZciYPGLDD5J+9vhSd7hq
         sGB8m203BFs/XfAuoduOEAOzBC1MP9Lr1DZoeO51Lk+dX8pE3ucJ0B3tJzxSw36/Rgxg
         L0qdCLFvCZ2Al6AznV5YbodItuZD3RO/pJnoa6A8v/2s4jCCrTnZuBpR4XalyWJFRaBn
         6xGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=4lCC3F3+CDz9Ahb9rgo0P2vN9CX4+ndmjrKLAhx63ho=;
        b=faq751UxqG5yw+OJiQrho1Eo4tUFLtSclp/tBS/uxQ7Tn823XKXKnH6m6WcpQiHSzT
         5ScdzbmEpwmsNpbo2zpUEHiE2PAx2WqIzUgoLDoNK4MGeOCmc07ZboQY/I8Xyjmsfp8d
         ifR5HfrFlc5cpuxTHZaHX00wBdicVRJz5pF1lEv3mtH78XCdvQsyqtx0DHTX3hrkcJdb
         +x+ST0p0wP5BTkSBzQDc4g1ovCMEjEuG3s8ORaFQmvMzeAAEM6UtA532XKu192CoMDOu
         Kw7+sLD6Fb55P40T4FEikG3i4w9E1+rT4/6kjoHg5rV1snHRXXPZbOezhKf0qIVTFO+8
         3v9g==
X-Gm-Message-State: APjAAAUalepom+esKHjG/kUzJAcVA/IdZDHPMtLymR/jrJod4FszO0bP
        SGyLAyr/L+JbREWj6X0rUXU=
X-Google-Smtp-Source: APXvYqwGTDKpCt/gzmarSI4iSEHFvNFwhfAxdgLEnSDBJrNpB2m390Biukb+igcH2Ujg/wAUXwzcbg==
X-Received: by 2002:a05:620a:1598:: with SMTP id d24mr2977870qkk.292.1557002646710;
        Sat, 04 May 2019 13:44:06 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 28sm5193577qtv.40.2019.05.04.13.44.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 13:44:05 -0700 (PDT)
Date:   Sat, 4 May 2019 16:44:04 -0400
Message-ID: <20190504164404.GB21656@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 1/9] net: dsa: Call driver's setup callback
 after setting up its switchdev notifier
In-Reply-To: <20190504135919.23185-2-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
 <20190504135919.23185-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 May 2019 16:59:11 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> This allows the driver to perform some manipulations of its own during
> setup, using generic switchdev calls. Having the notifiers registered at
> setup time is important because otherwise any switchdev transaction
> emitted during this time would be ignored (dispatched to an empty call
> chain).
> 
> One current usage scenario is for the driver to request DSA to set up
> 802.1Q based switch tagging for its ports.
> 
> There is no danger for the driver setup code to start racing now with
> switchdev events emitted from the network stack (such as bridge core)
> even if the notifier is registered earlier. This is because the network
> stack needs a net_device as a vehicle to perform switchdev operations,
> and the slave net_devices are registered later than the core driver
> setup anyway (ds->ops->setup in dsa_switch_setup vs dsa_port_setup).
> 
> Luckily DSA doesn't need a net_device to carry out switchdev callbacks,
> and therefore drivers shouldn't assume either that net_devices are
> available at the time their switchdev callbacks get invoked.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
