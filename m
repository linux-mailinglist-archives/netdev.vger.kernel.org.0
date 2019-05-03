Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6880513604
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 01:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfECXOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 19:14:23 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41478 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfECXOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 19:14:23 -0400
Received: by mail-qt1-f193.google.com with SMTP id c13so8633643qtn.8
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 16:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=pZYJcuEuKITuFEBvMwXJ33znV0apJb7Zeo+LeTCKgFA=;
        b=O8t9/HNQiV1SpZznLMYQdO1Ex4R/L238I70J46OmfP7hNNG5/s7IVt7+iBCqegq8XJ
         RuzyJmVeAuuA5gHCOz1lF8W9PDouMZIie512RAHyW+QcA4AOMeaaE7zwswMbtJ+/LoHa
         37MFR8PX9DmrvxVuAqcyjwNhyeh7Lj14U4anjNoBS4qPW3/TRqh0mxSaNpSpzXmjn7W8
         UQjXXDjR1ECPlOgyAa16sikmgamUpFSwVGuqRKtU+aAem8eoTAni+CmaKOw0xuqhGgmM
         O8XpBjRmphRu9juM0kzt+LJGlLhX9mEOV3zctioLVnbuD6657Mq2jzmp8V39SUrnUk5S
         Sqrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=pZYJcuEuKITuFEBvMwXJ33znV0apJb7Zeo+LeTCKgFA=;
        b=MuUSOV/xOA0qZ57X+Kwma1nJ5QH9X7smqkThlWQZnvmfnvs430/UlUgkpHwNzmYePa
         ayCQBL4oeqs7pKVsGP+Sd3LS7SZVIX3jjlgEXnCSPzkgk9imFtCBw0Ww2UQb5P6ZDq6W
         +Az/jF4lQw8qTDy2voznc88DUcso4ZqFMK9+8mWMgJ5fM7IILojhYD7XSEF0kz0BusB+
         Yb9eeXioufl1ZrS7IjET2akRhpzM59IvYrE+FjnmoN4S1IDUT0dsEVSmiKPMX2TD4Tqy
         i+cpz1wHF0P8XIN3jkkvqxzetp6QDGwW7osemOUYzhu0rFZ6wWFNSuAyv9qd38cz628/
         a1sg==
X-Gm-Message-State: APjAAAX42Ej06yMfjfa5ONFYjXuU4h+zksTiqPqtRq32Tw3nBMx3ugD5
        cMY++mE7tEULKIHOWVKfUPs=
X-Google-Smtp-Source: APXvYqyDeIbcjbBHz2/H6/Gw12PD0r6zQ0TpAJWOShIV0jo00SH8TfvXWAguBQ/MjD77fPxuWe9AkA==
X-Received: by 2002:a0c:96eb:: with SMTP id b40mr8849069qvd.188.1556925262730;
        Fri, 03 May 2019 16:14:22 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id n36sm3234030qtk.9.2019.05.03.16.14.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 16:14:22 -0700 (PDT)
Date:   Fri, 3 May 2019 19:14:21 -0400
Message-ID: <20190503191421.GB5333@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: refine SMI support
In-Reply-To: <d50590b2-a7bc-587a-bee1-5616a73f6bef@gmail.com>
References: <20190503224937.1598-1-vivien.didelot@gmail.com>
 <d50590b2-a7bc-587a-bee1-5616a73f6bef@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, 3 May 2019 16:01:38 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:

> [snip]
> 
> >  	assert_reg_lock(chip);
> >  
> > -	err = mv88e6xxx_smi_read(chip, addr, reg, val);
> > +	if (chip->smi_ops)
> > +		err = chip->smi_ops->read(chip, addr, reg, val);
> > +	else
> 
> You might want to check for smi_ops && smi_ops->read here to be safe.
> You could also keep that code unchanged, and just make
> mv88e6xxx_smi_read() an inline helper within smi.h:
> 
> static inline int mv88e6xxx_smi_read(struct mv88e6xxx_chip *chip, int
> addr, int reg, int *val)
> {
> 	if (chip->smi_ops && chip->smi_ops->read)
> 		return chip->smi_ops->read(chip, addr, reg, val);
> 
> 	return -EOPNOTSUPP;
> }

I've written it that way to simplify the check for an alternative
mv88e6xxx_bus_ops pointer implemented in a future patch, but your approach
is simpler, let's make it inline for the moment.

I'll respin a v2 right away with the subject prefix this time ;-)

Thanks,
Vivien
