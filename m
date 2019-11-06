Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B76EF0DDA
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 05:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbfKFEh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 23:37:27 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37485 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfKFEh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 23:37:27 -0500
Received: by mail-qk1-f194.google.com with SMTP id e187so10740827qkf.4
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 20:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=ZdeOG1DKUPi+B4+CRZdpA5o1uOygUil9fdO09b4Cog4=;
        b=jrZ2pwq7+LdPfwVadkDYVOiy+kMhEB30WCEzxHbDQKtgsfPK5i/dPQE68M2dyFvFK2
         sIJD/Jx78MQ2kPH/KJe1EwvB9ZShCVO/V279WO0Nv4XTsWiBqhWTs7UtRHg8ripRHBgr
         3bXQi40ZTtLTyXpS6nL54UZtwUbdT03z6SqiEh9Jr+hl0s65f6pIRZ3CBrajahK0DsDA
         xn8baZfVDOYnV0w5/D8XvSCAz1oPLyKzWLoiJltUKaXEAJj/yeNsw6O0Edb04EeplyhX
         h9E5PGHTBHavW6U4p855SuvmwuyQCozcAWsY07dlTf1d+oIIFn2lc1lIoGNSjSR3qU4G
         GJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=ZdeOG1DKUPi+B4+CRZdpA5o1uOygUil9fdO09b4Cog4=;
        b=At7TdwS8++KQvlmOu1Aucu0QzX8V6x9tr8V9rGl+7CtonohCn4eJWf5qGDH8eis7uP
         KOrFW3jPyWLajT/oDsZvcPjcrvTPwImeRu4WiRWRhULqbw13XIm5TAZZW3jT6smjf3NG
         cw8fV1wpKaULUNECL6LUbkEvJkfSFn9Hf06LcHjnN3mUxGo0mk34FJY4QCXQORtCHIhI
         pVYYoKTSNIyqNCXKRxVef5BV5+zz/u+YvjC49XgtP2pQOKKM1HiWZTSlGB5FK1wJHjGG
         7fICexhdPcENaC3A4A4lje0TQ/6rH+/89davnzuAsieUZqssffQWnOpab1eUiCtlrgAT
         m5dg==
X-Gm-Message-State: APjAAAVZiYkikEamWhznMD9UPIoHnajUQQ6caYgdOZf1ZGMbVoAjHGPu
        F3ru5bOfG5FywyGzVVP8pOU=
X-Google-Smtp-Source: APXvYqxXVcKCdT0hmEktIyI4rRu4oHIYWGZxnuuwoGXmSK60s/Opw/bIn9d7pBzS16BV36hvzx1bzA==
X-Received: by 2002:a05:620a:12c2:: with SMTP id e2mr410065qkl.162.1573015046550;
        Tue, 05 Nov 2019 20:37:26 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q34sm14495425qte.50.2019.11.05.20.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 20:37:25 -0800 (PST)
Date:   Tue, 5 Nov 2019 23:37:24 -0500
Message-ID: <20191105233724.GD799546@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 3/5] net: dsa: mv88e6xxx: global2: Expose ATU
 stats register
In-Reply-To: <20191105233241.GB799546@t480s.localdomain>
References: <20191105001301.27966-1-andrew@lunn.ch>
 <20191105001301.27966-4-andrew@lunn.ch>
 <20191105233241.GB799546@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, 5 Nov 2019 23:32:41 -0500, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> > +int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
> > +{
> > +	int err;
> > +	u16 val;
> > +
> > +	err = mv88e6xxx_g2_read(chip, MV88E6XXX_G2_ATU_STATS, &val);
> > +	if (err)
> > +		return err;
> > +
> > +	return val & MV88E6XXX_G2_ATU_STATS_MASK;
> > +}
> 
> I would use the logic commonly used in the mv88e6xxx driver for
> functions that may fail, returning only an error code and taking a
> pointer to the correct type as argument, so that we do as usual:
> 
>     err = mv88e6xxx_g2_atu_stats_get(chip, &val);
>     if (err)
>         return err;
> 
> > +
> >  /* Offset 0x0F: Priority Override Table */
> >  
> >  static int mv88e6xxx_g2_pot_write(struct mv88e6xxx_chip *chip, int pointer,
> > diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
> > index 42da4bca73e8..a308ca7a7da6 100644
> > --- a/drivers/net/dsa/mv88e6xxx/global2.h
> > +++ b/drivers/net/dsa/mv88e6xxx/global2.h
> > @@ -113,7 +113,16 @@
> >  #define MV88E6XXX_G2_SWITCH_MAC_DATA_MASK	0x00ff
> >  
> >  /* Offset 0x0E: ATU Stats Register */
> > -#define MV88E6XXX_G2_ATU_STATS		0x0e
> > +#define MV88E6XXX_G2_ATU_STATS				0x0e
> > +#define MV88E6XXX_G2_ATU_STATS_BIN_0			(0x0 << 14)
> > +#define MV88E6XXX_G2_ATU_STATS_BIN_1			(0x1 << 14)
> > +#define MV88E6XXX_G2_ATU_STATS_BIN_2			(0x2 << 14)
> > +#define MV88E6XXX_G2_ATU_STATS_BIN_3			(0x3 << 14)
> > +#define MV88E6XXX_G2_ATU_STATS_MODE_ALL			(0x0 << 12)
> > +#define MV88E6XXX_G2_ATU_STATS_MODE_ALL_DYNAMIC		(0x1 << 12)
> > +#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL		(0x2 << 12)
> > +#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL_DYNAMIC	(0x3 << 12)
> > +#define MV88E6XXX_G2_ATU_STATS_MASK			0x0fff
> 
> Please use the 0x1234 format for these 16-bit registers.

Oops the series has already been applied. Andrew please consider
these comments for your future series, they always apply...

Thank a lot,

	Vivien
