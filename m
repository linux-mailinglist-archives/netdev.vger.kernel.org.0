Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CE99C126
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 02:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfHYAxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 20:53:53 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:45487 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfHYAxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 20:53:53 -0400
Received: by mail-qk1-f173.google.com with SMTP id m2so11479617qki.12
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 17:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Czgfnr1LBA1EPIm4kK5oXhoWgj0xQVR8chG4RIpkRgE=;
        b=jfTHKNIqu0zeuxZrDvqcWGx+LXJBr8VF48EV9IIXzdlDrL377KhFTkYuH7w80iwcEM
         4Nk4hZSgs3t1TyJTWuFs5rwBErbdsLzJGzrbzsJ9El7PD26ZR483JG/rphRypIg7XIfv
         k5oPPo4/gLw+3MpluJ93tbuQHSPEcdCH1j7xW6HJXSDLhklgG6jlJTQG8pU9v36Bdgnz
         qkvu1AkSaPWlV+oJfCfTGfM0RgFc1cb/1INXxpAuf1vOh/FXgqlFsAdQz3M23YE9yzu4
         A+wYU0Dm3h3lRlhAvnB+PLbu6r8L33ws05rrJJ94A5JQNsBMpfiEGR/XYdc2xLmNtmUK
         bEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Czgfnr1LBA1EPIm4kK5oXhoWgj0xQVR8chG4RIpkRgE=;
        b=Bhnl7AqN9JSCZwP2yhMugoOG1D1DMVFDcBlFBNoPvZ/rHJDW74ftykUpiVVAvMrmFI
         0K8dHyLx15wMD+LWbk445YJtrT1iiCoq63ptMgIS+3F4rainwJEbZLLAd2gDAhBOSeiU
         43gC1gSWEHX17WnQml3SZgRUqlzeJVcYvCnUXmU2nMesAFDrE2LzQepvhrOY9//DjVkj
         4dTjjH5sE7bm+uelWlPi+CwWXwqoxWe9rWsDclJ6aIBFA4KLA6LZMQhVpCpTvQou6mR8
         iPTw49K4HxkUzJ+oKYZbw58JVdxCrPAOo17Q6bQ9dSKXhhh7s3f8uSt9SQ3IQEAid0OZ
         u2dQ==
X-Gm-Message-State: APjAAAVlJMByXF0wOIcjugU5VtytpyHMa9lbRa+J+1BFpFllzGrK5rph
        WC6ECj2xyeD5Ze+4tGXJpJI=
X-Google-Smtp-Source: APXvYqwM/ZcSPmL5Q4+DUOQCrD88Z0yVPhZCQD0h8mk1qi9FJNTSrJ1wROciIuHot19KWKQOEMYYPg==
X-Received: by 2002:a05:620a:71a:: with SMTP id 26mr10910345qkc.374.1566694432279;
        Sat, 24 Aug 2019 17:53:52 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id i3sm4806332qta.96.2019.08.24.17.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 17:53:51 -0700 (PDT)
Date:   Sat, 24 Aug 2019 20:53:49 -0400
Message-ID: <20190824205349.GB27859@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: Regresion with dsa_port_disable
In-Reply-To: <20190824231653.GA17726@lunn.ch>
References: <20190824225306.GA15986@lunn.ch>
 <20190824191220.GB1808@t480s.localdomain> <20190824231653.GA17726@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, 25 Aug 2019 01:16:53 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sat, Aug 24, 2019 at 07:12:20PM -0400, Vivien Didelot wrote:
> > Hi Andrew,
> > 
> > On Sun, 25 Aug 2019 00:53:06 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > > I just booted a ZII devel C and got a new warning splat.
> > > 
> > > WARNING: CPU: 0 PID: 925 at kernel/irq/manage.c:1708 __free_irq+0xc8/0x2c4
> > > Trying to free already-free IRQ 0
> > > Modules linked in:
> > > CPU: 0 PID: 925 Comm: kworker/0:2 Not tainted 5.3.0-rc5-01151-g7ff758fcdf65 #231
> > > Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> > > Workqueue: events deferred_probe_work_func
> > > Backtrace: 
> > > [<8010d9e4>] (dump_backtrace) from [<8010dd9c>] (show_stack+0x20/0x24)
> > >  r7:8016edf8 r6:00000009 r5:00000000 r4:9ec67944
> > > [<8010dd7c>] (show_stack) from [<8083b03c>] (dump_stack+0x24/0x28)
> > > [<8083b018>] (dump_stack) from [<8011c108>] (__warn.part.3+0xcc/0xf8)
> > > [<8011c03c>] (__warn.part.3) from [<8011c1ac>] (warn_slowpath_fmt+0x78/0x94)
> > >  r6:000006ac r5:80a8cbf0 r4:80d07088
> > > [<8011c138>] (warn_slowpath_fmt) from [<8016edf8>] (__free_irq+0xc8/0x2c4)
> > >  r3:00000000 r2:80a8cca8
> > >  r7:9f486668 r6:9ee25268 r5:9f486600 r4:9ee25268
> > > [<8016ed30>] (__free_irq) from [<8016f07c>] (free_irq+0x38/0x74)
> > >  r10:9eeb3600 r9:9e412040 r8:00000009 r7:9ee26040 r6:9ee2404c r5:9ee242c8
> > >  r4:9ee25268 r3:00000c00
> > > [<8016f044>] (free_irq) from [<805a244c>] (mv88e6390x_serdes_irq_free+0x68/0x98)
> > >  r5:9ee242c8 r4:9ee24040
> > > [<805a23e4>] (mv88e6390x_serdes_irq_free) from [<8059bc94>] (mv88e6xxx_port_disable+0x58/0x98)
> > >  r7:9ee26040 r6:00000009 r5:9ee2404c r4:9ee24040
> > > [<8059bc3c>] (mv88e6xxx_port_disable) from [<80806f70>] (dsa_port_disable+0x44/0x50)
> > >  r7:9ee26040 r6:9ee26d74 r5:00000009 r4:9ee26040
> > > [<80806f2c>] (dsa_port_disable) from [<80805df0>] (dsa_register_switch+0x964/0xab8)
> > >  r5:9efe194c r4:9ee26d38
> > > [<8080548c>] (dsa_register_switch) from [<8059b734>] (mv88e6xxx_probe+0x730/0x778)
> > >  r10:80943e64 r9:9fbf77d0 r8:00000000 r7:80d07088 r6:9e410040 r5:00000000
> > >  r4:9e40e800
> > > [<8059b004>] (mv88e6xxx_probe) from [<80582da8>] (mdio_probe+0x40/0x64)
> > >  r10:00000012 r9:80d5eccc r8:00000000 r7:00000000 r6:8141f358 r5:9e40e800
> > >  r4:80d5eccc
> > > [<80582d68>] (mdio_probe) from [<80518858>] (really_probe+0x100/0x2d8)
> > >  r5:9e40e800 r4:8141f354
> > > 
> > > The previous code was careful to balance mv88e6352_serdes_irq_setup()
> > > with mv88e6390x_serdes_irq_free(). I _think_ your change broke this
> > > balance, and we now try to free an interrupt which was never
> > > allocated.
> > 
> > What do you mean by "balance mv88e6352_serdes_irq_setup() with
> > mv88e6390x_serdes_irq_free()"?
> 
> Hi Vivien
> 
> It never called mv88e6390x_serdes_irq_free() unless
> mv88e6352_serdes_irq_setup() had been called first.
> mv88e6390x_serdes_irq_free() makes the assumption there actually is an
> interrupt to free. I suspect your changes now call
> mv88e6390x_serdes_irq_free() unconditionally.

OK I think you meant info->ops->serdes_irq_free and
info->ops->serdes_irq_setup, otherwise it's confusing.

I think I know what's going on, I'll look into it soon.

Thanks!
