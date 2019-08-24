Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6179C083
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 23:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfHXVgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 17:36:11 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37722 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfHXVgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 17:36:11 -0400
Received: by mail-qk1-f196.google.com with SMTP id s14so11323934qkm.4
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 14:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=q/nxXLGr1ZP0ejARRy1PegMHG6OoDL0gTwhq7Ab3R3s=;
        b=NheKrNyKYZ5DHm0jZQO7PSjqBxIlHili12BOvRsxMb7+kC564p3st0SHEziwxY7Nn6
         zcHsRPJfbYv+uUYYddP8uEdz6EoizONC9wGJUAznbM5wp0/rFKLjUQSxxQaR1Kavb24m
         +lMkBIDJvK/gEPj8LokOMyyYgfDUI6BY4BBKililmkbsNIUh6giRQ3pSvVIQmLlyL1hu
         yLCdFPflpenYgihbZ5xDdpUObpNsT7FRWPZL8k7suhX+cJf70N9q4+juE8TNzthWFkEW
         erAMhMiwA+YIAuiybCTG04XH0KfClFxF2XQ/XOj7S4oCBZWWxzlqSapgqW7INQQ37hL4
         evKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=q/nxXLGr1ZP0ejARRy1PegMHG6OoDL0gTwhq7Ab3R3s=;
        b=pZwst0dsv2IjRhWWEx7FXjiq7Myx4+g9KJvfoR1NQHNzloh0hy7UlWz/aGodtrnyOj
         x9rYP61jB4YJeH9+vEt+PqbeIchnL1kfCztQyf6yf4gSz1BoW11mbJSdns1qbNRicGvz
         CM7xSIdxU53BIY6uSmarivxHLt2G0xeK76OVleKmqUt8sP0rokeYS7Ta2H90NbeogwPx
         jbY6Oe26n79oE0tbvOhOJGk+Gzngcb+k3xJe2VXRF8Crr9OAjZRh/KJgFzYp6wJuk4Bi
         YK8hS/ToFEjFRih00flmSCDVDuj/4CC9S7xDeHmmcEmtHKhoA3w86+A4lX5QQFcxa8lW
         QFjQ==
X-Gm-Message-State: APjAAAXF47bAr5+ebGardlBqNY1/HiI8mrVgkoPZnIGKV8cPakAYDwiZ
        0i0bGVZB4iMhDB2Ff4fnFio=
X-Google-Smtp-Source: APXvYqyQQXTJB+uRX/j+U26Y8oIAcRiQIXAI7WSUSyktcm7b94mZwJnexCp3E9FrInkrkZPv80n6Sg==
X-Received: by 2002:a37:c247:: with SMTP id j7mr10504072qkm.94.1566682570024;
        Sat, 24 Aug 2019 14:36:10 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y188sm4174622qkc.29.2019.08.24.14.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 14:36:09 -0700 (PDT)
Date:   Sat, 24 Aug 2019 17:36:08 -0400
Message-ID: <20190824173608.GB2860@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 8/9] net: dsa: mv88e6xxx: support Block
 Address setting in hidden registers
In-Reply-To: <20190824225216.264fe7b0@nic.cz>
References: <20190823212603.13456-1-marek.behun@nic.cz>
 <20190823212603.13456-9-marek.behun@nic.cz>
 <20190824161328.GI32555@t480s.localdomain> <20190824225216.264fe7b0@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sat, 24 Aug 2019 22:52:16 +0200, Marek Behun <marek.behun@nic.cz> wrote:
> > There's something I'm having trouble to follow here. This series keeps
> > adding and modifying its own code. Wouldn't it be simpler for everyone
> > if you directly implement the final mv88e6xxx_port_hidden_{read,write}
> > functions taking this block argument, and update the code to switch to it?
> 
> I wanted the commits to be atomic, in the sense that one commit does
> not do three different things at once. Renaming macros is cosmetic
> change, and moving functions to another file is a not a semantic
> change, while adding additional argument to functions is a semantic
> change. I can of course do all in one patch, but I though it would be
> better not to.

You add code, move it, rename it, then change it. It is hard to follow and
read, especially in a series of 9 patches.

I think you could do it the other way around. For example implement the
.serdes_get_lane operation, its users, the mv88e6xxx_port_hidden_* API, its
users, remove or convert old code, etc. Atomicity has nothing to do with it.

> > While at it, I don't really mind the "hidden" name, but is this the name
> > used in the documentation, if any?
> 
> Yes, the registers are indeed named Hidden Registers in documentation.

OK good to know, port_hidden_ makes sense indeed then.


Thanks,

	Vivien
