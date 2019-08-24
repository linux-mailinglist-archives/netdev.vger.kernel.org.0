Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1039BFDD
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfHXTc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 15:32:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40520 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfHXTc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 15:32:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id g4so4612501qtq.7
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 12:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=ChFiVpgNUHXBH4ccwxuDSDBgJt5YSkyXlQoT+Xu8vH0=;
        b=RyQADyyyJm13l2eobd+uWLGjjkczZgLjtqycg/25ABYDOnrNsecPJreNXhBStR/Q0D
         lYcDc/30DXa+hZyOdv/IPQPniDpv7cyiAbxVYzY6Vdtg/L0VJxhz48btUdPKnMVoxxI4
         9TagKu7jkddig6A46HHP5+tLinEw1GO6DHApTDDTtfipRAW6GcIm7PS0TBMRbJ/3Qpc2
         kvAgJbslq7QZU9KsM73F6n/9b34NGyYy/q21wklJeA9qcK7iO2V+AjXEkKzH3DRuIW1b
         60c1RrgPQV5ZnFMWSS6NBFCIww84/wn6ElgltbJFr29xQpNT7riT5yDke9ZHPiuVxCF8
         JIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=ChFiVpgNUHXBH4ccwxuDSDBgJt5YSkyXlQoT+Xu8vH0=;
        b=SIVynEEVDZtSMMZJntWJptXb82b9LevDnQlaWg5r4Egz8FKl29aYDl3IZyg055zmUD
         7Hn9kXN+9ZJx1aLUykNrs9jsc9s4+YxKnfp1ICwcNAc/x72urEHDsg+tv9EvBPxZIGuF
         wvK59HsIoIvRRdTJc55RtraN/9wWUODd4bQ+jGQKP+3L59CxH5voVibZSaWKxifNC46U
         F7V4AeBD3StKAmuDsfARLXCP15t/cJW95yMEFldtqjnvcfbk6/2zo+0izj+hnu89a41U
         cVAIWadvCRbx/cCzGOY7oCq4nyrIxG3wTKuNTB7uxx8QdpFBc2j7jYnbvU2lSu/Y9EGy
         ZWHQ==
X-Gm-Message-State: APjAAAW86htyHlbb8ujKTXQKz3Ew60thxLt4fQWlFKl9dqrhDqJzQASi
        xJj14O9f1pZ8xJVEezZC8r8=
X-Google-Smtp-Source: APXvYqymnKlP3oUtkwFwuezFVOmzY7vimv18prtwaZHYB0xGhY3egEoLhzrfdxKx2EhXF1xO8nQmyg==
X-Received: by 2002:ac8:31dc:: with SMTP id i28mr10936295qte.226.1566675176882;
        Sat, 24 Aug 2019 12:32:56 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 1sm4227602qko.73.2019.08.24.12.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 12:32:55 -0700 (PDT)
Date:   Sat, 24 Aug 2019 15:32:54 -0400
Message-ID: <20190824153254.GB32555@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v2 3/9] net: dsa: mv88e6xxx: fix port hidden
 register macros
In-Reply-To: <20190823212603.13456-4-marek.behun@nic.cz>
References: <20190823212603.13456-1-marek.behun@nic.cz>
 <20190823212603.13456-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Fri, 23 Aug 2019 23:25:57 +0200, Marek Behún <marek.behun@nic.cz> wrote:
>  /* Offset 0x1a: Magic undocumented errata register */

   /* Offset 0x1A: Reserved */

(nitpicking here, for consistency this other definitions as shown in docs.)

> -#define PORT_RESERVED_1A			0x1a
> -#define PORT_RESERVED_1A_BUSY			BIT(15)
> -#define PORT_RESERVED_1A_WRITE			BIT(14)
> -#define PORT_RESERVED_1A_READ			0
> -#define PORT_RESERVED_1A_PORT_SHIFT		5
> -#define PORT_RESERVED_1A_BLOCK			(0xf << 10)
> -#define PORT_RESERVED_1A_CTRL_PORT		4
> -#define PORT_RESERVED_1A_DATA_PORT		5
> +#define MV88E6XXX_PORT_RESERVED_1A		0x1a
> +#define MV88E6XXX_PORT_RESERVED_1A_BUSY		0x8000
> +#define MV88E6XXX_PORT_RESERVED_1A_WRITE	0x4000
> +#define MV88E6XXX_PORT_RESERVED_1A_READ		0x0000
> +#define MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT	5
> +#define MV88E6XXX_PORT_RESERVED_1A_BLOCK	0x3c00
> +#define MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT	0x04
> +#define MV88E6XXX_PORT_RESERVED_1A_DATA_PORT	0x05

You are already using these macros in the previous patch. I guess you meant
to introduce this patch before. But since you are moving and renaming the
same code without functional changes, you may squash them together.


Thanks,

	Vivien
