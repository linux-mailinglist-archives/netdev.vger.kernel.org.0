Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560AB912B2
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfHQT13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:27:29 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45065 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfHQT13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 15:27:29 -0400
Received: by mail-qt1-f195.google.com with SMTP id k13so9821832qtm.12
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 12:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=35Kv9h71xebUNnBBavB8bN3iQIDitPoBHAcSKtJWJMg=;
        b=iZ0yf7uL2WMODvmnmfZCvmFeQ7y0Q/UGpkSwgq1gDOudDaRM3skPDqY9ErrVI7TG0m
         s4axROEn6K0hxr0H6hJrvUeYaSpHh+B8PDRb43KUXMOj+S/q45g19fuuWgmMDxN4bF1n
         0f7/KK7UWX34y4XKJ/VZxyQOrfpUee4se8PHI8uraeh/iiwJ9ryAVSZhMIcpYh80WQS2
         sYyMQ6OG1NZUgLqg78Gcm9t0GRtczdSEtHcrYjikr3WlHDBuG9ZvPY9YxtM8k4LkjxY2
         LDZQHwMyRnISxskLy93TGrpjy56Mffpl//iq3tVqiHMwKs1D1EKhPuTXZHFJ242HWUC/
         UeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=35Kv9h71xebUNnBBavB8bN3iQIDitPoBHAcSKtJWJMg=;
        b=KuJxGJre/0uAofM2S3sjADFsQPyeCK2GfDwvlFN63QT334YjJEWRa2OwO1qXOzful4
         xBG4Mf8iKaIxqyLkPDpFbvXcZ8+drvJpwMw5MLOrJv8JYJjrl0OZVhsvz1bMt1+xK8QR
         Ov0Gey61a9P/qd3zJEpLjjGIYCYJ95+ZMBS2KQvuN2OKMgmQs6Fahgr0F0gSux+7sYI6
         v/y3EWRBs47xu0xRn548/ofA+19yvuUHjrhhj/rkOfGjyW5z565+bhUlHEnfxTYeiaCn
         DxzBws3/S4GzxS+kyUdyi0XktSoO0CtxbYLvBDYeoyYxENAvjfiXv76hgiT/GXR0dlSH
         6AIA==
X-Gm-Message-State: APjAAAUYDfseqaWOZUBiVgJNAQkkNoqTRLOIi6rho8qwP3MPaXnhdmpc
        JL9DhJODAQk6YZjreu7Od9Y=
X-Google-Smtp-Source: APXvYqzj5CfxxUDGnncCkbPOZN9ItqFPtn2YyiTMM0Bv0EFZ5GkPEnh25HqwlaosVtPVT3ImOEafVg==
X-Received: by 2002:ac8:549:: with SMTP id c9mr14445244qth.223.1566070048499;
        Sat, 17 Aug 2019 12:27:28 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id m38sm5587175qta.43.2019.08.17.12.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Aug 2019 12:27:27 -0700 (PDT)
Date:   Sat, 17 Aug 2019 15:27:26 -0400
Message-ID: <20190817152726.GB4404@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH RFC net-next 3/3] net: dsa: mv88e6xxx: setup SERDES irq
 also for CPU/DSA ports
In-Reply-To: <20190817201552.06c39d3e@nic.cz>
References: <20190816150834.26939-1-marek.behun@nic.cz>
 <20190816150834.26939-4-marek.behun@nic.cz>
 <20190816122552.GC629@t480s.localdomain> <20190816190520.57958fde@nic.cz>
 <20190816190537.GB14714@t480s.localdomain> <20190817200342.567c13c4@nic.cz>
 <20190817201552.06c39d3e@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sat, 17 Aug 2019 20:15:52 +0200, Marek Behun <marek.behun@nic.cz> wrote:
> On Sat, 17 Aug 2019 20:03:42 +0200
> Marek Behun <marek.behun@nic.cz> wrote:
> 
> > One way would be to rename the mv88e6xxx_setup_port function to
> > mv88e6xxx_setup_port_regs, or mv88e6xxx_port_pre_setup, or something
> > like that. Would the names mv88e6xxx_port_setup and
> > mv88e6xxx_setup_port_regs still be very confusing and error prone?
> > I think maybe yes...
> > 
> > Other solution would be to, instead of the .port_setup()
> > and .port_teardown() DSA ops, create the .after_setup()
> > and .before_teardown() ops I mentioned in the previous mail.
> > 
> > And yet another (in my opinion very improper) solution could be that
> > the .setup() method could call dsa_port_setup() from within itself, to
> > ensure that the needed structres exist.
> 
> I thought of another solution, one that does not need new DSA
> operations. What if dsa_port_enable was called for CPU/DSA ports after
> in dsa_port_setup_switches, after all ports are setup, and
> dsa_port_disable called for CPU/DSA ports in dsa_port_teardown_switches?
> 
> This seems to me as cleaner solution.
> 
> Marek

Yes DSA needs to initialize a switch before its ports, but the driver may
need the opposite. Splitting the switch and ports setup and moving it up to
the DSA stack is a separate topic in fact that I'll handle soon.

I guess you meant dsa_tree_setup_switches instead of dsa_port_setup_switches.

Let's call dsa_port_enable/dsa_port_disable for the CPU and DSA ports as well.


Thanks,

	Vivien
