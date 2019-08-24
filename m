Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAF19C0EC
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfHXXMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:12:23 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:33075 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfHXXMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:12:23 -0400
Received: by mail-qt1-f180.google.com with SMTP id v38so14756447qtb.0
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 16:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=P+tzXi/TMkyHinW/18JyWvUDAKMYWUOaa34Yktl+gUk=;
        b=f/TUBwCtE4u/+TTGUT3n8BdcGPi4buUnI4FHNlzJfkMvaNmNG14AUPJnd6mMcQvnjj
         RsHw5dQdQep5VbZAFv5yvlu8GpIA0UTm2MuO/8V8nVH+6jvMBR06tD5QIMzayGP8M1R3
         B3HnlUMc7gr6wruEkAZcTIgcTYEmrnBnQWV82Xj7FeQ+YY+bqyiZJkcku9ghedDJnc/C
         neIqcAmMpy8IekdQDqYbeBnRuzK5EHxMJtRP22nvzljY4pQL/f04yFi6KluH8R8jDDMY
         LQNFLiCBOA9iDUTFlmUSeU4p/Sry9NanHsGME4vN3qg6aiDi5vH7NDCADH3tT3tOhwVu
         aJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=P+tzXi/TMkyHinW/18JyWvUDAKMYWUOaa34Yktl+gUk=;
        b=XnOaKKUqPOd8Z/mRjHlU2LTE/Adgo5x4yGqW5JbBKpgZ6/k0VrBnBD1QVU6+Oanmt9
         tjW2M5ffN3ITA35RcXUt94uhJ0eETI5JTLYysVnABgyZArKG0ETNJRw31qxj/j+r/rM/
         QsuRGuVQ+bZ57qpYJXfXNr9CKWHCQatfYi7j4NK4uWTE30MLUSVlLu4o4EX3aUkuEZ3G
         yg/o/z4ZuhElt05WD5LUGmcHpX81rRdTATQ4AXL9iydKh2xHa1RGTI3pMLn/HFFevbxh
         jusHAPY0ufFkQBFa5CfTKLhBjwr7z4Wdbd/0GFwM+MS8ZohFNzECV6CUwXmiYlp1VtgE
         X2ug==
X-Gm-Message-State: APjAAAXc+yAHjU8nKwIr17s+3y7iVemI1HV4Noyezqk3lWJlmele6UBP
        XnGMaj0TQHPy9t/3/LN0EUy9Z0QI
X-Google-Smtp-Source: APXvYqzQr5ydmRF6NwU6NWsE9pwm9sYhbQ+4ims4RjYZU1DmdT1Ig4TjO47j9vN2EuJqMdZC6UlrGw==
X-Received: by 2002:a0c:c201:: with SMTP id l1mr9612641qvh.31.1566688342305;
        Sat, 24 Aug 2019 16:12:22 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x3sm3707063qkl.71.2019.08.24.16.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 16:12:21 -0700 (PDT)
Date:   Sat, 24 Aug 2019 19:12:20 -0400
Message-ID: <20190824191220.GB1808@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: Regresion with dsa_port_disable
In-Reply-To: <20190824225306.GA15986@lunn.ch>
References: <20190824225306.GA15986@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, 25 Aug 2019 00:53:06 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> I just booted a ZII devel C and got a new warning splat.
> 
> WARNING: CPU: 0 PID: 925 at kernel/irq/manage.c:1708 __free_irq+0xc8/0x2c4
> Trying to free already-free IRQ 0
> Modules linked in:
> CPU: 0 PID: 925 Comm: kworker/0:2 Not tainted 5.3.0-rc5-01151-g7ff758fcdf65 #231
> Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> Workqueue: events deferred_probe_work_func
> Backtrace: 
> [<8010d9e4>] (dump_backtrace) from [<8010dd9c>] (show_stack+0x20/0x24)
>  r7:8016edf8 r6:00000009 r5:00000000 r4:9ec67944
> [<8010dd7c>] (show_stack) from [<8083b03c>] (dump_stack+0x24/0x28)
> [<8083b018>] (dump_stack) from [<8011c108>] (__warn.part.3+0xcc/0xf8)
> [<8011c03c>] (__warn.part.3) from [<8011c1ac>] (warn_slowpath_fmt+0x78/0x94)
>  r6:000006ac r5:80a8cbf0 r4:80d07088
> [<8011c138>] (warn_slowpath_fmt) from [<8016edf8>] (__free_irq+0xc8/0x2c4)
>  r3:00000000 r2:80a8cca8
>  r7:9f486668 r6:9ee25268 r5:9f486600 r4:9ee25268
> [<8016ed30>] (__free_irq) from [<8016f07c>] (free_irq+0x38/0x74)
>  r10:9eeb3600 r9:9e412040 r8:00000009 r7:9ee26040 r6:9ee2404c r5:9ee242c8
>  r4:9ee25268 r3:00000c00
> [<8016f044>] (free_irq) from [<805a244c>] (mv88e6390x_serdes_irq_free+0x68/0x98)
>  r5:9ee242c8 r4:9ee24040
> [<805a23e4>] (mv88e6390x_serdes_irq_free) from [<8059bc94>] (mv88e6xxx_port_disable+0x58/0x98)
>  r7:9ee26040 r6:00000009 r5:9ee2404c r4:9ee24040
> [<8059bc3c>] (mv88e6xxx_port_disable) from [<80806f70>] (dsa_port_disable+0x44/0x50)
>  r7:9ee26040 r6:9ee26d74 r5:00000009 r4:9ee26040
> [<80806f2c>] (dsa_port_disable) from [<80805df0>] (dsa_register_switch+0x964/0xab8)
>  r5:9efe194c r4:9ee26d38
> [<8080548c>] (dsa_register_switch) from [<8059b734>] (mv88e6xxx_probe+0x730/0x778)
>  r10:80943e64 r9:9fbf77d0 r8:00000000 r7:80d07088 r6:9e410040 r5:00000000
>  r4:9e40e800
> [<8059b004>] (mv88e6xxx_probe) from [<80582da8>] (mdio_probe+0x40/0x64)
>  r10:00000012 r9:80d5eccc r8:00000000 r7:00000000 r6:8141f358 r5:9e40e800
>  r4:80d5eccc
> [<80582d68>] (mdio_probe) from [<80518858>] (really_probe+0x100/0x2d8)
>  r5:9e40e800 r4:8141f354
> 
> The previous code was careful to balance mv88e6352_serdes_irq_setup()
> with mv88e6390x_serdes_irq_free(). I _think_ your change broke this
> balance, and we now try to free an interrupt which was never
> allocated.

What do you mean by "balance mv88e6352_serdes_irq_setup() with
mv88e6390x_serdes_irq_free()"?


	Vivien
