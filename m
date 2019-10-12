Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA5DD51F7
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 21:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfJLTO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 15:14:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32908 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbfJLTO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 15:14:57 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so8049875pfl.0
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 12:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G75jd65f+k6dA5mBnjXmDH8vVuzXVKq/6E4dOJtLU+w=;
        b=C2ki/HRJPVrWbaIP2jprOPTd6WCu7NDo3Cx3qSsiw9VqVgY8ickIQs42Dkn/PKrull
         5l0uTar+NVmTsxbU5P2hHv9sdnkkDrRYNn7KuNyph0BaTe/6NJpIjaMclVySIGc4pVe6
         Hk9fAS1FjCtw0XJFsnv31ceHiZCmS7uRBHEqCGXVyiUB8Uj2tkrkqoHC59MnDzSDLZW5
         68c2i19T0QqzaYtqvM6jtc/5qPY9XjT7R5KjcOUXAohHD28/0tocSR8O8gGao+2VhXi7
         5nrhibXc5GNlZQKtiMIH8a4oc2+Vl3JSA/j+FHr0bEsAmn/HLh/VYh9xgxZeTqT7FBvw
         vhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=G75jd65f+k6dA5mBnjXmDH8vVuzXVKq/6E4dOJtLU+w=;
        b=dB4JbVCxNyrWzokw5xBQB2sPDMGvMGth0+5fFcb4rRK7VOibzU7D3XkLA4g8xbpsa9
         4NWdol4KJ/3TWRy12I3Lp1hbUqPhqlQ8bPBjiVD/puUm9fZlUjCsH4Pd5rvYhM750iv1
         Dbb9bdVWyKgOGW7iuxa/MRSuMfAmeCra+bQSUnoVCRERuSIw5BXODXFw1lOP0uZ9G7iL
         DQHuYBwYNtHIipTLIGaocLVKzz0JeSrTdsDBVw+GzAraor4u6Y132u9XJAejuzQTDuBB
         q933ygV4G0iPxd9TbniwLQjkDuDaAdCQ0LklFR8d4sv2AoliYNvEnEyY7I4VeINlioC+
         X+NA==
X-Gm-Message-State: APjAAAWjZCLNNBTRRF0uo6qc+myU3z/I7stwnlycRWfhyKw9a2eJiGir
        zxm5/8YVhpDTI0VVcEVebK4=
X-Google-Smtp-Source: APXvYqypkiKr8p3l0TqcUIcEBSfdN1/x5KGDy4ESF/UblFfADvwg0H1UeJN0F++52vS6W99NgNeWKQ==
X-Received: by 2002:a65:408a:: with SMTP id t10mr24235870pgp.385.1570907697241;
        Sat, 12 Oct 2019 12:14:57 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id h2sm17396866pfq.108.2019.10.12.12.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 12:14:56 -0700 (PDT)
Date:   Sat, 12 Oct 2019 12:14:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jakub.kicinski@netronome.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] PTP driver refactoring for SJA1105 DSA
Message-ID: <20191012191454.GM3165@localhost>
References: <20191011231816.7888-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011231816.7888-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 02:18:12AM +0300, Vladimir Oltean wrote:
> This series creates a better separation between the driver core and the
> PTP portion. Therefore, users who are not interested in PTP can get a
> simpler and smaller driver by compiling it out.
> 
> This is in preparation for further patches: SPI transfer timestamping,
> synchronizing the hardware clock (as opposed to keeping it
> free-running), PPS input/output, etc.
> 
> Vladimir Oltean (4):
>   net: dsa: sja1105: Get rid of global declaration of struct
>     ptp_clock_info
>   net: dsa: sja1105: Make all public PTP functions take dsa_switch as
>     argument
>   net: dsa: sja1105: Move PTP data to its own private structure
>   net: dsa: sja1105: Change the PTP command access pattern
> 
>  drivers/net/dsa/sja1105/sja1105.h      |  16 +-
>  drivers/net/dsa/sja1105/sja1105_main.c | 234 +--------------
>  drivers/net/dsa/sja1105/sja1105_ptp.c  | 391 ++++++++++++++++++++-----
>  drivers/net/dsa/sja1105/sja1105_ptp.h  |  84 ++++--
>  drivers/net/dsa/sja1105/sja1105_spi.c  |   2 +-
>  5 files changed, 386 insertions(+), 341 deletions(-)

Acked-by: Richard Cochran <richardcochran@gmail.com>
