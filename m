Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4CC5BAE3D
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiIPNe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiIPNe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:34:56 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103F718E1B
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:34:55 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id ay7-20020a05600c1e0700b003b49861bf48so1065110wmb.0
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=wRlogq9cJ4jkthRtOk0OYOnjIHPZtt37jxY6SPGMSYE=;
        b=ne5V/0v+aS+IMzO8JlcDLPaIzBDzPG2A7DFYtEnb3F0xFZXKYJ6GMLxcNavCeegSqg
         dZ7m++laJJmWHfjF8/WDU6kc2gbUmA1V4KwRLjQHAu8zMaQCTGTpsWlqAtqIM6ale2dG
         THhA85dxXcE63U80cumeVXhFdy+vlTzc7YVcyCHytwHKAiFpfH0Lyer2JatHIIiZhSH7
         7ARbvcVEyaQj0Zkims4OQMnHRoy86V7TC0vFANGmUFpgCI4gpYws827KNk6HeITYGfxn
         kE5gJHtbdoJNL95knxCiM/6crRQWq5NAgTZJx4GJLYKNdvqJKds9Q8l7BMJZv0A/ACWq
         wFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=wRlogq9cJ4jkthRtOk0OYOnjIHPZtt37jxY6SPGMSYE=;
        b=LXJrBp/O4dR/pEESLG0OnseoyGz6Dg8ZIKE9XjH4YasqIb0VDpOMIFHN4zoM8ArjFV
         2VWLQuZPwF0qLVD/p4TeDxkTFV2JgTGpHnUUSGK0GaqBAAPTtP9ZvrPZQ7zBSQpsQ1Ft
         rk+YCDtX4OkKDa0YcQg1Z+gyQZg3fuffU8NmO7oKYY2RSIaEZoci/hNqFWAs4xFObHi/
         PALQcTguX7wMD8HoLJWEzoq9KKhILJxxhAT4jCF/LnVc0g8x7Bshm1nn5iSo02y11rro
         ehjpuzlvZL8zPvDCsofzZIKzof5TX/EDuaFLZL5hwcgOhKGnaO/Nzhvg+m6fJE+4jEjx
         WCXw==
X-Gm-Message-State: ACrzQf2/z/wiGUqZYLBcTKV7DpQXsMPpnc2ktdls2fjFIbFqfIWudyxp
        8r5WcgBdoYG557iM+znBd5k=
X-Google-Smtp-Source: AMsMyM5E4gKGjPNeW9W6xdPS5Waek2QkvCrh2ukGtbqyZdMFUohXx+UDV5o3gwRomS4wKy8xPNxpbA==
X-Received: by 2002:a05:600c:1c03:b0:3b4:618b:5d14 with SMTP id j3-20020a05600c1c0300b003b4618b5d14mr3273714wms.59.1663335293308;
        Fri, 16 Sep 2022 06:34:53 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id ay9-20020a05600c1e0900b003a5c7a942edsm2202333wmb.28.2022.09.16.06.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 06:34:52 -0700 (PDT)
Message-ID: <63247b7c.050a0220.6327b.5198@mx.google.com>
X-Google-Original-Message-ID: <YyQSKDszkPlH78SN@Ansuel-xps.>
Date:   Fri, 16 Sep 2022 08:05:28 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v13 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add
 RMU support
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 02:18:11PM +0200, Mattias Forsblad wrote:
> The Marvell SOHO switches have the ability to receive and transmit
> Remote Management Frames (Frame2Reg) to the CPU through the
> attached network interface.
> This is handled by the Remote Management Unit (RMU) in the switch
> These frames can contain different payloads:
> single switch register read and writes, daisy chained switch
> register read and writes, RMON/MIB dump/dump clear and ATU dump.
> The dump functions are very costly over MDIO but it's
> only a couple of network packets via the RMU.
> 
> Next step could be to implement ATU dump.
> We've found that the gain to use RMU for single register
> read and writes is neglible.
> 
> qca8k
> =====
> There's a newly introduced convenience function for sending
> and waiting for frames. Changes have been made for the qca8k
> driver to use this. Please test for regressions.
>

Hi,
I found time to test this aaaand it's broken...
I leaved some comments in the specific patch to make this work on legacy
custom completion implementation.

Ideally I will convert qca8k to the non legacy but I like your approach
of not enforcing stuff.

> RFC -> v1:
>   - Track master interface availability.
>   - Validate destination MAC for incoming frames.
>   - Rate limit outputs.
>   - Cleanup setup function validating upstream port on switch.
>   - Fix return values when setting up RMU.
>   - Prefix defines correctly.
>   - Fix aligned accesses.
>   - Validate that switch exists for incoming frames.
>   - Split RMON stats function.
> 
> v1 -> v2:
>   - Remove unused variable.
> 
> v2 -> v3:
>   - Rewrite after feedback. Use tagger_data to handle
>     frames more like qca8k.
>   - qca8k: Change to use convenience functions introduced.
>     Requesting test of this.
>     
> v3 -> v4:
>   - Separated patches more granular.
> 
> v4 -> v5:
>   - Some small fixes after feedback.
> 
> v5 -> v6:
>   - Rewrite of send_wait function to more adhere
>     to RPC standards
>   - Cleanup of ops handling
>   - Move get id to when master device is available.
> 
> v6 -> v7:
>   - Some minor cleanups.
> 
> v7 -> v8:
>   - Moved defines to header file.
>   - Check RMU response length and return actual
>     length received.
>   - Added disable/enable helpers for RMU.
>   - Fixed some error paths.
> 
> v8 -> v9:
>   - Naming consistency for parameters/functions.
>   - Streamlined completion routines.
>   - Moved completion init earlier.
>   - Spelling corrected.
>   - Moved dsa_tagger_data declaration.
>   - Minimal frame2reg decoding in tag_dsa.
>   - Fixed return codes.
>   - Use convenience functions.
>   - Streamlined function parameters.
>   - Fixed error path when master device changes
>     state.
>   - Still verify MAC address (per request of Andrew Lunn)
>   - Use skb_get instead of skb_copy
>   - Prefix defines and structs correctly.
>   - Change types to __beXX.
> 
> v9 -> v10:
>   - Patchworks feedback fixed.
> 
> v10 -> v11:
>   - Fixed sparse warnings.
> 
> v11 -> v12:
>   - Split mv88e6xxx_stats_get_stats into separate
>     functions, one for RMU and one for legacy
>     access.
> 
> v12 -> v13:
>   - Expose all RMON counters via RMU.
> 
> Regards,
> Mattias Forsblad
> 
> Mattias Forsblad (6):
>   net: dsa: mv88e6xxx: Add RMU enable for select switches.
>   net: dsa: Add convenience functions for frame handling
>   net: dsa: Introduce dsa tagger data operation.
>   net: dsa: mv88e6xxxx: Add RMU functionality.
>   net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
>   net: dsa: qca8k: Use new convenience functions
> 
>  drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
>  drivers/net/dsa/mv88e6xxx/chip.c    | 117 +++++++++-
>  drivers/net/dsa/mv88e6xxx/chip.h    |  31 +++
>  drivers/net/dsa/mv88e6xxx/global1.c |  64 ++++++
>  drivers/net/dsa/mv88e6xxx/global1.h |   3 +
>  drivers/net/dsa/mv88e6xxx/rmu.c     | 320 ++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/rmu.h     |  73 +++++++
>  drivers/net/dsa/mv88e6xxx/smi.c     |   3 +
>  drivers/net/dsa/qca/qca8k-8xxx.c    |  61 ++----
>  include/linux/dsa/mv88e6xxx.h       |   6 +
>  include/net/dsa.h                   |  11 +
>  net/dsa/dsa.c                       |  17 ++
>  net/dsa/dsa2.c                      |   2 +
>  net/dsa/dsa_priv.h                  |   2 +
>  net/dsa/tag_dsa.c                   |  40 +++-
>  15 files changed, 692 insertions(+), 59 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
>  create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h
> 
> -- 
> 2.25.1
> 

-- 
	Ansuel
