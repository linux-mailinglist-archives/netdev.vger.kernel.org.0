Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0797E99B1E
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 19:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbfHVRVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 13:21:21 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34510 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730997AbfHVRVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 13:21:21 -0400
Received: by mail-qt1-f194.google.com with SMTP id q4so8616726qtp.1
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 10:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=yLEzBXLRaub+cTtqGjbIzr44IubJ819PlFLJThMu1i4=;
        b=hcxb+1cPbJtlfHe7UaZeZl3HwYB20Golj2CaYQ6A7A0CZVEXIfvkfsFeowMLHdTGmw
         p/JRa/iqRc6RE0DXHKnX2GN9N0b89cxBSTHgiKqbVoq7tkpgWeIgAG2nDb/OZGm6Nllz
         8lBpvlRkI0iRp33VGsA7f/zFKi+k3bOPL/cQIE8EAvU8+ypbtiDmdAWwSxBhJ0ticZLZ
         lwIF1VCcst5Gzt8xTS6cvoKMyQWT5iuDS+BFPE/mHVMQ+xUEGbNzKkGW5lI2welKOxZG
         St1t9wI+u41FNlt87JpvtbKMz0pYsysDklx0v178b6nNPZB2bDweYy7E2MqYIqqYmoDe
         YYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=yLEzBXLRaub+cTtqGjbIzr44IubJ819PlFLJThMu1i4=;
        b=dJdsvRtkGaBycx4A2+W4xox4fAGuIQSjk5IGsyqvjPhMuH7yA6LsKv5TwIjm7VPfzN
         o7QH90gTzqiEHC4S6n6ShHAh3fAjkWPH7OYo1riu5HRJGk+gOaZG/PkIiPGtugbOG51d
         KtUTdNBpCrQqPuRGyEUVEQwVLBbt8hHZtJcdGFJYm1fHZ3Y3RMClg+qAdMM10bg0cYMs
         Fs8vzJiDHVDBL/9jFc9iz9VAN+M7ZVviA0ofPsTwJsEJnuzPsU/IONrdQgSL9tPbQDrI
         yoxGPnn3YyaeWciAytFAGNut1WPLEduoYv8FSXXq0AefRA2AwpOK/x5mUmePD5vLaltq
         2GEg==
X-Gm-Message-State: APjAAAXLLP8X6AV523PuRzcBRAY01lDpXLTgp33OF9MegQd6Yqjyv2vV
        5fRndgy5HRSac4hCEj1aMBsGu4vj
X-Google-Smtp-Source: APXvYqzbTaeEYTTXQJcx0ulRkkyGZAU+t5iKhsfjevHfJRIOsSxhh/dDTnoZaax7q4RkGMIsrDAZgw==
X-Received: by 2002:ac8:6c48:: with SMTP id z8mr773169qtu.58.1566494480228;
        Thu, 22 Aug 2019 10:21:20 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o200sm163269qke.66.2019.08.22.10.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 10:21:19 -0700 (PDT)
Date:   Thu, 22 Aug 2019 13:21:18 -0400
Message-ID: <20190822132118.GB20024@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 03/10] net: dsa: mv88e6xxx: move hidden registers
 operations in own file
In-Reply-To: <20190822131047.GE13020@lunn.ch>
References: <20190821232724.1544-1-marek.behun@nic.cz>
 <20190821232724.1544-4-marek.behun@nic.cz> <20190822131047.GE13020@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek, Andrew,

On Thu, 22 Aug 2019 15:10:47 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Aug 22, 2019 at 01:27:17AM +0200, Marek Behún wrote:
> > This patch moves the functions operating on the hidden debug registers
> > into it's own file, hidden.c.
> 
> Humm, actually...
> 
> These are in the port register space. Maybe it would be better to move
> them into port.c/port.h?
> 
> What you really need is that they have global scope within the driver
> so you can call them. So add the functions definitions to port.h.
> 
> Vivien, what do you think?

Andrew's correct. Code accessing internal registers in the mv88e6xxx driver
is split per internal SMI device. An internal SMI device is a "column" of 32
registers found in the datasheet, accessed via its dedicated internal SMI
device address, like ports, Global 1 (often 0x1b), Global 2 (often 0x1c),
and so on. Each internal SMI device has its unique header file, describing
all registers it contains. Then if the corresponding .c file has a portion
specific enough, it can be moved to its own .c file, like global1_atu.c,
global1_vtu.c, etc.

So keep these port registers definitions ordered in port.h with a naming as
closed to the documentation as possible, prefixing them with MV88E6XXX_PORT_
(or the model of reference if that is specific to a few models only), and
please describe the bits with an ordered 0x1234 format as well. The port.h
header is fortunately already a good example of how it should be done.

Then you can include it in a new port_hidden.c file, which implements
mv88e6xxx_port_hidden_* internal helpers (or mv88e6789_port_ if specific to a
model again) to access these hidden port registers, and use them as convenience
in chip.c:mv88e6xxx_errata_setup() or wherever a feature is implemented.


Thanks a lot,

	Vivien
