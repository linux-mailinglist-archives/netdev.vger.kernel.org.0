Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8695931486
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfEaSTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:19:16 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34603 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfEaSTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:19:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id h1so2056907qtp.1;
        Fri, 31 May 2019 11:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=TKc2cnZBuMVtSbHdM0Wpd2V3p1InwFaduQoNzQ9VIN0=;
        b=I4Lvm4I+LbtJLFQaAb2ijuRWfxN+nPP6FZPqOloSKu4AVsldGV3VJKYlCzMWo1k/qy
         wPIOJdnSjBq0kr5BwkqIwJEetcGKythEk4VcfoV+ENOl2qtdpMrL2E0gjRyxiqCa5hlZ
         op/8N8Lr93Vvwzh0OAb6OPLI2VhNsTM5Znky7YD4h2bMUoqC5grDBiBDshXOv+BtL9CE
         0l47vWAZ+CGPPQGGRkFWD79PXQYKjUaJzAESDCNFC9i5VF3LgDukSac7/4EuSZ85GYZ9
         C/XqCn+LEZLkLdLfuPSYBYvB1/2+IoOqJZuJrr2Ezv2YpgRvjUVNCp7XKRQtomlBlq6n
         eSzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=TKc2cnZBuMVtSbHdM0Wpd2V3p1InwFaduQoNzQ9VIN0=;
        b=qt3jP9OKv5TFqvA1869HEpQjVXkD+pdHXuK4HfFK5Z+hlQph7guqAGScmYr0syMOfy
         7lfEP4F3+ErDg6CRcy++5wUZIMdmNmPenG5wpEoZtMDARHCcQJRFRgXfoTWD8do2PPA+
         BhlM+8XQUT72CBfAvO9FvdNoGutbD2NgBF5orCVhEZ/XRcPjnRoqb4wuUVeG32Ufjq21
         0lA7EFRHGHQXX/0zSybgEgg9OK1xaNvC5bi7R5bXevn5Xu/MSWIDWwcAu98IXAeghwT9
         ZjTDThKylkFNEf3Vw3nz8rnB+GsUWbRrrf0emQcBT3xGmq17XAKCYl1Wastp5xAanJcU
         tqAg==
X-Gm-Message-State: APjAAAUiC/4xfN4JA8JvW0TCICnbtPQByuCoF1mntmREB8tSeUQlz4rN
        Hi9PuBSLkURioG0OEMqBZGI=
X-Google-Smtp-Source: APXvYqx6Z7MtPE6aQkimbbe4vX3hWDeLvfXBOdJhbsPqZQ/POlQgQpxHIf8W22nts8BiLIPECzJI1g==
X-Received: by 2002:ac8:28c2:: with SMTP id j2mr10348317qtj.103.1559326755427;
        Fri, 31 May 2019 11:19:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t187sm3475783qkh.10.2019.05.31.11.19.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 11:19:14 -0700 (PDT)
Date:   Fri, 31 May 2019 14:19:14 -0400
Message-ID: <20190531141914.GB26582@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from
 VLAN 0
In-Reply-To: <38a5dbac-a8e7-325a-225f-b97774f7bb81@gmail.com>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
 <20190531103105.GE23464@t480s.localdomain> <20190531143758.GB23821@lunn.ch>
 <422482dc-8887-0f92-c8c9-f9d639882c77@cogentembedded.com>
 <20190531110017.GB2075@t480s.localdomain>
 <38a5dbac-a8e7-325a-225f-b97774f7bb81@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, 31 May 2019 09:36:13 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > But VID 0 has a special meaning for the kernel, it means the port's private
> > database (when it is isolated, non-bridged), it is not meant to be programmed
> > in the switch. That's why I would've put that knowledge into the DSA layer,
> > which job is to translate the kernel operations to the (dumb) DSA drivers.
> > 
> > I hope I'm seeing things correctly here.
> 
> Your first part about the fact that it's the port private database is
> true, the fact that it is not programmed into the HW actually depends on
> what the switch is capable of doing. With mv88e6xxx you have per-port
> VLAN filtering controls, but other switches that do not have that
> capability need to program VID == 0 into the HW to continue maintaining
> VLAN filtering on a non bridged port while a bridge has enslaved other
> ports of the switch.

Are you saying that switches without per-port VLAN filtering controls
will program VID 0, and thus put all non bridged ports into the same VLAN,
allowing them to talk to each other?


Thanks,
Vivien
