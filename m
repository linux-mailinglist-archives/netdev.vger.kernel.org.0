Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B195521AAA4
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGIWgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgGIWgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 18:36:24 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E14C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 15:36:24 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r12so3910560wrj.13
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 15:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2DbVkpWt/6WgE4Hg/5TLyDtaL17Qag/VHDQnsF5CrV8=;
        b=mnMWCtm+M4Do3Xx77klEEiZcL7PmMcAe+JmNR5bWTG33G0Gh2qkLzFSJ2WZa9yaUQ0
         suaeunHglbQgwQKMbLcNQPFgOb/1rGRXx2cU2+eY0yonP0ALQdHmBgd98pb9XdQ2fXhH
         T9ce+rCbFASgSrzqgvT7+ovm+RawxB77/AKr/Nt9wTpDuVqCEpwCmQcwWM84QIMvFXZN
         JPln5aoyroQMGVi4tS9L5CZL+FLVyfHPvZg5uZAWXpTfKCcTTO0wj9v0E4iCxwc96Nt/
         iJlsvEx+BBWXryPTk+3BbKx0sIegnhbeDCOz4NucacWoj5Sp3qbVjQuvjVD3dGhKxDmn
         9N2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2DbVkpWt/6WgE4Hg/5TLyDtaL17Qag/VHDQnsF5CrV8=;
        b=Rls0q/QE4t5LM4DbiKTFDJ8vjkuoko+iMYln/CKYwK55ugNDBYBM/8mKNpbdI1h9EU
         yJIR8fViFPZPlUzzubsz1sGnHqT03I3upQyOurhEqCssynp2f+ewe67dmVvDJ3XuIEDU
         1ggPhKnyjcyKH5yqWWHFqmotspphibx8xNCmJcqapmIZ7vsE8rBha1TkkOuA8aIppLXI
         IDuhQU4U0xhvSssEhoLAR2+xVVf22KInJzv8WThR7FbVLLJpwT/781wqG2Ytb6KzBsgs
         8IEMQ09vQpDEnKGZHAiIpC0brT4XiLmVuXw8V+BFJ5QxGDF1qYWD59YdAvKxWAlhnpjL
         GVqA==
X-Gm-Message-State: AOAM531LukysJuVHR+iLJzyooKEZdDsgWCMlJ9rd+ElEZxMEw0thuEKw
        tU0f8Q1HWw8wJHQycfSuNFuded6T
X-Google-Smtp-Source: ABdhPJxc6FoTB3mOegCIAYKxSpvjd4/GG4V7hYYR8BhTsIoaEXyqyi5qi2D+PUzjf9KfAch1O/E+xw==
X-Received: by 2002:adf:f04c:: with SMTP id t12mr61960506wro.382.1594334182679;
        Thu, 09 Jul 2020 15:36:22 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c25sm6123878wml.46.2020.07.09.15.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 15:36:22 -0700 (PDT)
Subject: Re: MDIO Debug Interface
To:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>
References: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9dd495d7-e663-ce37-b53e-ffebd075c495@gmail.com>
Date:   Thu, 9 Jul 2020 15:36:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/2020 1:47 PM, Tobias Waldekranz wrote:
> Hi netdev,
> 
> TL;DR: Is something like https://github.com/wkz/mdio-tools a good
> idea?
> 
> The kernel does not, as far as I know, have a low-level debug
> interface to MDIO devices. I.e. something equivalent to i2c-dev or
> spi-dev for example. The closest thing I've found are the
> SIOCG/SMIIREG ioctls, but they have several drawbacks:
> 
> 1. "Write register" is not always exactly that. The kernel will try to
>    be extra helpful and do things behind the scenes if it detects a
>    write to the reset bit of a PHY for example.
> 
> 2. Only one op per syscall. This means that is impossible to implement
>    many operations in a safe manner. Something as simple as a
>    read/mask/write cycle can race against an in-kernel driver.
> 
> 3. Addressing is awkward since you don't address the MDIO bus
>    directly, rather "the MDIO bus to which this netdev's PHY is
>    connected". This makes it hard to talk to devices on buses to which
>    no PHYs are connected, the typical case being Ethernet switches.
> 
> The kernel side of mdio-tools, mdio-netlink, tries to address these
> problems by adding a GENL interface with which a user can interact
> with an MDIO bus directly.
> 
> The user sends a program that the mdio-netlink module executes,
> possibly emitting data back to the user. I.e. it implements a very
> simple VM. Read/mask/write operations could be implemented by
> dedicated commands, but when you start looking at more advanced things
> like reading out the VLAN database of a switch you need to state and
> branching.
> 
> FAQ:
> 
> - A VM just for MDIO, that seems ridiculous, no?
> 
>   It does. But if you want to support the complex kinds of operations
>   that I'm looking for, without the kernel module having to be aware
>   of every kind of MDIO device in the world, I haven't found an easier
>   way.
> 
> - Why not use BPF?
> 
>   That could absolutely be one way forward, but the GENL approach was
>   easy to build out-of-tree to prove the idea. Its not obvious how it
>   would work though as BPF programs typically run async on some event
>   (probe hit, packet received etc.) whereas this is a single execution
>   on behalf of a user. So to what would the program be attached? The
>   output path is also not straight forward, but it could be done with
>   perf events i suppose.
> 
> My question is thus; do you think mdio-netlink, or something like it,
> is a candidate for mainline?

Certainly, the current interface clearly has deficiencies and since
mdio_device instances were introduced, we should have an interface to
debug those from user-space ala i2c-dev or spidev.

Can you post the kernel code for review? Would you entertain having mdio
as an user-space command being part of ethtool for instance (just to
ease the distribution)?
-- 
Florian
