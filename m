Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FC69186A
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 19:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfHRRnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 13:43:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40720 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRRnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 13:43:24 -0400
Received: by mail-qt1-f195.google.com with SMTP id e8so11653908qtp.7
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 10:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=a44i3zU5U+PuFYTKqIN1lPdT06ZCAuybMmafvz3tLmE=;
        b=EiyX2Kkg/USd/tikhdy6ld9Dk47DrJn058fdOvEUTx7x66L4AoeYGS9/jaFfdpgCOT
         +2+KxLIpWYszb7nDtRieT6CtX7vhUeYnp/f1iHqttcZD8bx/1Rvzlk5K7L7R5FggGAA6
         D9xxP+uINfiIaWsU+zQ4IHaAyCWiIVgj+v17G0kcPGf+YgC89t6YvA2IKLZaQ3LjUUzK
         FCA77SmNB/otvupZlEXU5KJmqg3v0iupQh3CYwP3PFz7MuIF5AmbL6JPHeyKj+029oGH
         I6dSAN8ssKI9Zp6RmQcG1wOq4EPxlQKQAjU2n+CwPSqY6zpNEfcvhmYkwKfVz7SADT7O
         cWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=a44i3zU5U+PuFYTKqIN1lPdT06ZCAuybMmafvz3tLmE=;
        b=km16X1incB8nU75T/rM3PT/Ru+mZ84imGRpVCYsbq5bld2eG7cF8UGGz3Xmp9Bob+j
         R2tkU9wyMxBA2N6eDQBvp6kPEzAt5eIfOWF2l6kPwng5+SVYyZoPqMVVduQbOLZXFZcw
         EjTA2RPk1OKClTlN44oIOeE/uPAnvHXtrXTB/nZHnNbPoakS8shnKh2vHnhDnqC7RhdV
         nqnrPSE0mz8DlRU1gLd+ZG5kY2Lka9nepFtiOllVOW/Ml9hnv/cwUILhj+qV/K4UfkKB
         Z6fAEJKZcCoP3NP2OKQmMvIp2HKRnJw8KaVwUP1yw8JyBlwjP4/CxJcrrKlMB5leOeSY
         FsdA==
X-Gm-Message-State: APjAAAUVjuHjZRCj0qUefStoG8OdyXMIUS/L6BNmfM2RdeCrZtoOtkG2
        i4ksCpePNLMKvIJAeXEj760=
X-Google-Smtp-Source: APXvYqwSFTYgPPRi18ZKeUda2qypeNHYip8RwABADYMEH1hX92S6jpZ45NYDmp5zF67L8B4+m5T7SQ==
X-Received: by 2002:aed:3aa1:: with SMTP id o30mr17476886qte.198.1566150203676;
        Sun, 18 Aug 2019 10:43:23 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s58sm6488282qth.59.2019.08.18.10.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 10:43:23 -0700 (PDT)
Date:   Sun, 18 Aug 2019 13:43:22 -0400
Message-ID: <20190818134322.GB19565@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH RFC v2 net-next 0/4] mv88e6xxx: setting 2500base-x mode
 for CPU/DSA port in dts
In-Reply-To: <20190817155025.GB9013@t480s.localdomain>
References: <20190817191452.16716-1-marek.behun@nic.cz>
 <20190817155025.GB9013@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sat, 17 Aug 2019 15:50:25 -0400, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> > here is another proposal for supporting setting 2500base-x mode for
> > CPU/DSA ports in device tree correctly.
> > 
> > The changes from v1 are that instead of adding .port_setup() and
> > .port_teardown() methods to the DSA operations struct we instead, for
> > CPU/DSA ports, call dsa_port_enable() from dsa_port_setup(), but only
> > after the port is registered (and required phylink/devlink structures
> > exist).
> > 
> > The .port_enable/.port_disable methods are now only meant to be used
> > for user ports, when the slave interface is brought up/down. This
> > proposal changes that in such a way that these methods are also called
> > for CPU/DSA ports, but only just after the switch is set up (and just
> > before the switch is tore down).
> > 
> > If we went this way, we would have to patch the other DSA drivers to
> > check if user port is being given in their respective .port_enable
> > and .port_disable implmentations.
> > 
> > What do you think about this?
> 
> This looks much better. Let me pass through all patches of this RFC so that
> I can include bits I would like to see in your next series.

I went ahead and sent a series which enables and disables all ports
in DSA, I hope you don't mind. You can now send a single patch on
top of it focusing on the 2500base-x issue with all the details.


Thank you,

	Vivien
