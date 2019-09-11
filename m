Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0120B0017
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 17:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfIKPbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 11:31:51 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33105 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfIKPbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 11:31:51 -0400
Received: by mail-qt1-f196.google.com with SMTP id r5so25780939qtd.0
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 08:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=fcyFNHqbA8t2ouOnvXyDw8aeh23VL36IBxhbnb43Rjc=;
        b=D8Hx/fYz3OvsUUjqKx1EHL+4qGF/pg+7OpcRyX1lJcFh3TZoMmFOHNZXE7CW6gvw4c
         CC4Pf+Tew1I/hs/V/pgOhoOHL6mmg9iPZB3t8GHO0rR4yEnosnPWXo/DKjI8ajLLl167
         NnzmMa5L0anCckxryjfg/ZesxvUxH2NRDVBISxnRj/p0rTKmc++lQMSTea7zprJjbUKU
         yodHW9VtbJYsmtkeDH3j9+YMYK7hbuKBZ4/F2BM9cS/Iu8h1WnJLB7zOxUq4PVr/gaq6
         ucK+BOW4qD5n/zW38EUIDhBRHTcj3xHkX0bSor350FADHexoFQ8N6bjWSP1Pc8afM+iH
         NZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=fcyFNHqbA8t2ouOnvXyDw8aeh23VL36IBxhbnb43Rjc=;
        b=eoVyucG1UrK2n/xCPAorJFt+aKBUts4UFh+kVmYmeYvikrgFQimKH8fRpo60e1fLyY
         Yfypbf+AyPOrGbo+YiWfqyHQAG6lBWGvVlH9kwrBwAHwPvfisxES78VDjjHctoBlpdpO
         8eFASM9HUCTTDuo0EMO4IzbL7XMtCNUxNnnqs/s/mxoMEu7NQua1dK5mxJGk2m0HW6Ar
         1cS6TcVTlAlhMHgw4JYZlJere/8ksz3JE7/X1Zqm83RAoozt9omPUAxnWjVVNpO5KYEh
         v6imEdfMfyMWYXxrC8dYkMQ6AIqzVMKsgUJjDFvKN5G5iZsUQQT9xqfoZXC/EFFzmiMl
         dMWA==
X-Gm-Message-State: APjAAAW5Uk9CCJpOxWcrrtIvK3l9P9Jy/x7i/w/fxLkaUm0vfLKRgc5E
        ch9SpxfU/Rh2CzxJWVmM5F//xLRhX64=
X-Google-Smtp-Source: APXvYqwnng+Yhsjl3UQVJc3KS1KvPTszf5lH4jqC+jA1Bobn+VCSFBhkWvI8pjCzMQO6SXRYeMvBSA==
X-Received: by 2002:ac8:7b2a:: with SMTP id l10mr1200781qtu.115.1568215910184;
        Wed, 11 Sep 2019 08:31:50 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 8sm7410698qto.6.2019.09.11.08.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 08:31:49 -0700 (PDT)
Date:   Wed, 11 Sep 2019 11:31:48 -0400
Message-ID: <20190911113148.GB1435@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, bob.beckett@collabora.com
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
In-Reply-To: <3f265c5afcb2eea48410ec607d65e8f4e6a20373.camel@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910131951.GM32337@t480s.localdomain>
 <3f265c5afcb2eea48410ec607d65e8f4e6a20373.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

On Wed, 11 Sep 2019 10:46:05 +0100, Robert Beckett <bob.beckett@collabora.com> wrote:
> > Feature series targeting netdev must be prefixed "PATCH net-next". As
> 
> Thanks for the info. Out of curiosity, where should I have gleaned this
> info from? This is my first contribution to netdev, so I wasnt familiar
> with the etiquette.
> 
> > this approach was a PoC, sending it as "RFC net-next" would be even
> > more
> > appropriate.

Netdev being a huge subsystem has specific rules for subject prefix or merge
window, which are described in Documentation/networking/netdev-FAQ.rst


Thank you,

	Vivien
