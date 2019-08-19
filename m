Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B55C94B70
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfHSROi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:14:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46464 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbfHSROh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:14:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id q139so1519667pfc.13;
        Mon, 19 Aug 2019 10:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bR7mwEF0w/r77aEvWSCrOS34E2BqLczCk25LMswkdoQ=;
        b=X9ED/012GHjxgNHbYCrnbaYzs5L41V4HCZmvvZLERBLh4AQj78Ec82Pk6ptcOVjlop
         0o9xCEBP5OLWAAeANFSLx5NtdfVnABd/9fEA3vxSFunxagJdGqLZ1OjdapdRuOJSP3fy
         gQ/eJlKWg+rgWI26kQ/uxxg4DZJ5re1KzRm3al7VP1FpXiR4XQEoTRUU/yyVk5IcEK3v
         aGbQ47ADYhCSW7zTDPjls1b5j3YZ5IOqbP3TJzbBu//mQdTScHjMXr1kzMVE0RyiKxbR
         mpimEluhXI5pRVOfK2uj2NtmSS0IF01DeZsaItmlKrJnBsVoRfruDqFOBXLO2gPndW4q
         d5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bR7mwEF0w/r77aEvWSCrOS34E2BqLczCk25LMswkdoQ=;
        b=r0vh2yrAbvCwO+n84tjbPLZpQjmuZnXPvmggWLz4BucxqzwZvgTfEQvgUWZ49YcXHC
         8kd4AKNEjHnh0aHcLtneHiwJ6tpiBrE6BENUktDpqSMJLH6TRP5X6l9J5XMUK8UDP5jG
         v9Ey9Hiqp1Fma7fxkB2YjuIGpn3rJzgg6rBHWKOW3RMLzoq+pIjZe5ucwfA4juHBQTOj
         5t0PBB7/x15sv8YsZAwjdW82YKhSD2dg/TzksDWeby0x0rLmaAZ2leGZ50x1EUpQQ83F
         6vwAsKzn6HcAXlbUdcdD3dfmVZS6LUJN71TrQadNnndslY88fnoV34KPq9a+o+E4Chaq
         dq/Q==
X-Gm-Message-State: APjAAAUK67+ofa59DyoZYHoIEqF0NvS4VUZqKwBs402usK1+wwXHbrmg
        flaffvnWmbRuFSWITI0tMBjbqHE5v1dLLw8xN37QyR4T
X-Google-Smtp-Source: APXvYqzBv1CscJ2UVR/obqgyuT4uSXs4WcoLb6+nJiH1zdkZMnnDVN/tKn4B8eeJJ9rMYKzgzNTotERZbdVTAobG2Hs=
X-Received: by 2002:a17:90a:b908:: with SMTP id p8mr21687303pjr.65.1566234877070;
 Mon, 19 Aug 2019 10:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190816163157.25314-1-h.feurstein@gmail.com> <20190816163157.25314-3-h.feurstein@gmail.com>
 <20190819132733.GE8981@lunn.ch>
In-Reply-To: <20190819132733.GE8981@lunn.ch>
From:   Hubert Feurstein <h.feurstein@gmail.com>
Date:   Mon, 19 Aug 2019 19:14:25 +0200
Message-ID: <CAFfN3gUNrnjdOt8bW2EugzjSZMb_vvdEaLN0yOv_06=roqcJYQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: extend PTP gettime
 function to read system clock
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am Mo., 19. Aug. 2019 um 15:27 Uhr schrieb Andrew Lunn <andrew@lunn.ch>:
>
> > @@ -45,7 +45,8 @@ static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
> >  {
> >       int ret;
> >
> > -     ret = mdiobus_write_nested(chip->bus, dev, reg, data);
> > +     ret = mdiobus_write_sts_nested(chip->bus, dev, reg, data,
> > +                                    chip->ptp_sts);
> >       if (ret < 0)
> >               return ret;
> >
>
> Please also make a similar change to mv88e6xxx_smi_indirect_write().
> The last write in that function should be timestamped.
Since it is already the last write it should be already ok (The
mv88e6xxx_smi_indirect_write
calls the mv88e6xxx_smi_direct_write which initiates the timestamping).

Hubert
