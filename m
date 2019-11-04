Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03151EF135
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 00:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbfKDXdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 18:33:55 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33802 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfKDXdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 18:33:55 -0500
Received: by mail-lj1-f194.google.com with SMTP id 139so19653681ljf.1
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 15:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ki3XfMLkatGCh1MpVolr1kkV+eaP6HVaNE12+UBPzog=;
        b=O33JE36Oez5dnq2/GoCmdP8t2vXD2zkLpmFPruThGScaZT/TOgZHv2dz5CZQUDZzF2
         VcWRDsFk7+nbPMNVz4bGR0oxYHA/N1cJ1S+X3T7JHXIVYI4DDg8zIC7TgnMkk8hwRXqx
         yuGbx7pHsY/w+n/SyT4QuwI+yXHxKUlKVGqM5zXQBf/mrgiJAeEUmuHIfiENj3EVIzCJ
         k166cGfPsG/VxNbc+TNNr7KcrB6qi3qn6IO6bKCYfGN+7nN1sp3tMZ7oY9wo3p49sWOx
         6ktTQwEVL+cRDewdoNFZ1jJGdqxi7d0cIxz8mnCoN1J6pg/S/nu7l7tNiv9kaFJ2wBsT
         fA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ki3XfMLkatGCh1MpVolr1kkV+eaP6HVaNE12+UBPzog=;
        b=C5cDXSQYN/Qo+9r+FzdHVzv1TOgyYAoh5VJr/bVAengbAxPqIS5+thb1bUTH6UYExO
         j/8EHh5Ky+q7J/yeUyyFJNy98ThYZ8cbqgXeq5pkFuoUTPHzJmXX5NUP34OkBtDYWywa
         qBFV/p1d2WrmKfzp+tpMfBkMkJVtZA8G66Ruo66jUA34lPHvy/EqMos7W3yCD0oNFDp2
         gnvnAV/dcGyTpyDwKpUTGYXpwQWc7bcC0Mm+iUxleJrjfYIiFOAA9wl9ArvVxDJgqCTx
         gjl5GF8M80LEWQJ+W9ipsTHvbkKF4C8B/EEn7/VdaQlqFeZ7xY5TUI1uEzpZNOnAz6Er
         zoTg==
X-Gm-Message-State: APjAAAXFw3P+/Uc2Kx7NRbwmaIm5obk8Kzeh88GJQMPburBQ/j6xMncT
        rZWvesGYx3gy35AfcCgVfrbyLc/Le2c=
X-Google-Smtp-Source: APXvYqwnZzIzSGG8XEAAheAMOqj1VOwZAyopdJ9fOGzvMb8whK/yyZvnu3Zm0Y298MJQsH33UNSG/g==
X-Received: by 2002:a2e:8654:: with SMTP id i20mr21044725ljj.238.1572910431592;
        Mon, 04 Nov 2019 15:33:51 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e2sm7786964lfc.2.2019.11.04.15.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 15:33:51 -0800 (PST)
Date:   Mon, 4 Nov 2019 15:33:42 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191104153342.36891db7@cakuba.netronome.com>
In-Reply-To: <20191104232036.GA12725@splinter>
References: <20191103083554.6317-1-idosch@idosch.org>
        <20191104123954.538d4574@cakuba.netronome.com>
        <20191104210450.GA10713@splinter>
        <20191104144419.46e304a9@cakuba.netronome.com>
        <20191104232036.GA12725@splinter>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 01:20:36 +0200, Ido Schimmel wrote:
> On Mon, Nov 04, 2019 at 02:44:19PM -0800, Jakub Kicinski wrote:
> > On Mon, 4 Nov 2019 23:04:50 +0200, Ido Schimmel wrote:  
> > > I don't understand the problem. If we get an error from firmware today,
> > > we have no clue what the actual problem is. With this we can actually
> > > understand what went wrong. How is it different from kernel passing a
> > > string ("unstructured data") to user space in response to an erroneous
> > > netlink request? Obviously it's much better than an "-EINVAL".  
> > 
> > The difference is obviously that I can look at the code in the kernel
> > and understand it. FW code is a black box. Kernel should abstract its
> > black boxiness away.  
> 
> But FW code is still code and it needs to be able to report errors in a
> way that will aid us in debugging when problems occur. I want meaningful
> errors from applications regardless if I can read their code or not.

And the usual way accessing FW logs is through ethtool dumps.

> > > Also, in case it was not clear, this is a read-only interface and only
> > > from firmware to kernel. No hidden knobs or something fishy like that.  
> > 
> > I'm not saying it's fishy, I'm saying it's way harder to refactor code
> > if some of the user-visible outputs are not accessible (i.e. hidden in
> > a binary blob).  
> 
> Not sure I understand which code you're referring to? The error print
> statement?

The main form of refactoring I'm talking about is pulling out common
driver code into the core so we can make the drivers less gargantuan.

> > > > Is there any precedent in the tree for printing FW errors into the logs
> > > > like this?    
> > > 
> > > The mlx5 driver prints a unique number for each firmware error. We tried
> > > to do the same in switch firmware, but it lacked the infrastructure so
> > > we decided on this solution instead. It achieves the same goal, but in a
> > > different way.  
> > 
> > FWIW nfp FW also passes error numbers to the driver and based on that
> > driver makes decisions and prints errors of its own choosing. The big
> > difference being you can see all the relevant errors by looking at
> > driver code.  
> 
> This is done by mlxsw as well. See:
> $ vi drivers/net/ethernet/mellanox/mlxsw/emad.h +50
> 
> But by far the most common error is "bad parameter" in which case we
> would like to know exactly what is "bad" and why.

Right, when intelligence is placed in the FW, and the kernel doesn't
know which parameters may be bad then there is a need for FW log
reporting.. I am painfully familiar. FW engineers like to use terms
like "forward compatible" and "future proof".

> Anyway, it's already tomorrow here, so I'll be back in a few hours
> (IOW: expect some delay).
