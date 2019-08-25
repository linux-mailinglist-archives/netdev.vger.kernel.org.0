Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6D99C496
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 17:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbfHYPHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 11:07:16 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36865 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfHYPHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 11:07:16 -0400
Received: by mail-qk1-f194.google.com with SMTP id s14so12212467qkm.4
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 08:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=QuuMT/j/a6pnxIXBp0S5vdHQrhvPCKqLsCxch2UrDZs=;
        b=Ac+8hcPtdpRdefcHbM0dPo9FgjiYGPY0n0wJONzOt5dXveysvlMdW0AzZBlLJYhQO5
         LBXe+rqAUzC1swJahLcgeD+1l+H5AWvjiv/N+XWmNisoedHNiRfgryWGwfxdDp/JzuaN
         emKHpZX7hvbK8CJbmr3D+9IDt1+/FKRWUon9ngnnKEoDCbeR16cTcdkl3YeWjOX617q1
         oD37uYloP1TgTZ+LJjVVsr1Sd/92+zTfrptvYXijB10fBxTCC0/J8thaTjbz8w1SvJci
         NHbW0w3svvrJ3363hGFyQnCHfrULRivuxZb5GeR2v1Ygas7rxhoOn7ifyPxA3KZStQed
         WgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=QuuMT/j/a6pnxIXBp0S5vdHQrhvPCKqLsCxch2UrDZs=;
        b=EL3GcXWrWFC9M197lh2V5FGpOBF+MWrZENmnkA6hmrf0hU5foFkBXBgiCgMju3HWrp
         L/jLum+lxDDcrxZ/8Cm17mfjIu6sJG+8zgeaUIJk3iR4u5BwFmvqLliHTyzRk6ELRSEL
         BCRdz3hrDEKstw5lglQKmRzgwjnens567DCCPKklgfzH1xDJWSSeYtBUH0rWE0YeI/qG
         NgEwjCCEck2ra0TgwwlL8vytBSeXX3xkhpEOt0AgNcW/9WRNgELaNmRdr1UTkEFOhgpu
         pSYZV2wK+ExJKbRCREDfFg+sbqxu5VlyX6w1bF6axhEjdnMobdAJNxvXrEJaYNQdhwhj
         tezA==
X-Gm-Message-State: APjAAAV3PqBK/0vksZe9Mgx7VVyqcpyCf6jyxfj5ghAJd9mldh4bGY2C
        j7Ov+rOZgjno1mcRHMfOAo2OKAif
X-Google-Smtp-Source: APXvYqzwhUYGTX1kK7VH5cxxteilLBB1DxlW+ECFYdXPRklr0122cauRxpEv1HKdtvGDmvCId3twuA==
X-Received: by 2002:a05:620a:14b8:: with SMTP id x24mr12379007qkj.419.1566745634833;
        Sun, 25 Aug 2019 08:07:14 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d2sm4746126qko.26.2019.08.25.08.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 08:07:13 -0700 (PDT)
Date:   Sun, 25 Aug 2019 11:07:12 -0400
Message-ID: <20190825110712.GB6729@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v3 2/6] net: dsa: mv88e6xxx: update code
 operating on hidden registers
In-Reply-To: <20190825035915.13112-3-marek.behun@nic.cz>
References: <20190825035915.13112-1-marek.behun@nic.cz>
 <20190825035915.13112-3-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sun, 25 Aug 2019 05:59:11 +0200, Marek Behún <marek.behun@nic.cz> wrote:
> This patch moves the functions operating on the hidden debug registers
> into it's own file, port_hidden.c. The functions prefix is renamed from
> mv88e6390_hidden_ to mv88e6xxx_port_hidden_, to be consistent with the
> rest of this driver. The macros are prefixed with MV88E6XXX_ prefix, and
> are changed not to use the BIT() macro nor bit shifts, since the rest of
> the port.h file does not use it.
> 
> We also add the support for setting the Block Address field when
> operating hidden registers. Marvell's mdio examples for SERDES settings
> on Topaz use Block Address 0x7 when reading/writing hidden registers,
> and although the specification says that block must be set to 0xf, those
> settings are reachable only with Block Address 0x7.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Even though there are several semantic changes here, bisectability is
preserved, and blaming the new functions will easily show which commit
introduced this new API and why. Much more readable and well documented:

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
