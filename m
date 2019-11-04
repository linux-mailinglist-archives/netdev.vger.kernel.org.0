Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580C4EF0B4
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387403AbfKDWod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:44:33 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42644 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbfKDWoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 17:44:32 -0500
Received: by mail-lf1-f67.google.com with SMTP id z12so13517738lfj.9
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 14:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=TMitnYxNTsPQULpLbuqoTA5ssxhT+R53DmxvKYFIaQo=;
        b=DVovJ1Cps8EjnaLzU2fOhQX6bJA3ohlE71fiaI37MgtvhRQFPfQTqhYeAEqKu5v3ax
         Y5RT8P5IIGsqmYVxtWz7fZcu416jVehiPNr6SOC7IQoke9sshK4cK3TIGtBHw0CvzALr
         NRfXuWEhLBAETG9EvkOtttIRDYGn706mgNZYNX4VE24cN8Ssd3IR4hM4pvwyvZCO0pPk
         NqSTV+KVX/zK5CdExHHVvNO4fFV1OPwPyhIuRnri5gD0zphy1xmun2ThF1Ull7DLS6ys
         ilK3cXbQjbaPWC9Fnn1OJw863epkdr/dynQZAIBjG2EFcSTp+bHpRuC5NRh7yFM7Cb/2
         cPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TMitnYxNTsPQULpLbuqoTA5ssxhT+R53DmxvKYFIaQo=;
        b=gkRc9PglP9n5nwNP1Gr3FSBJ2LBzDWvHAWgS10exKtcb7ggZ7piz16BL8YTJzQwUe3
         P6439r1HvteFjkaO0Wl6kr106bL+niCTiwS2ncsVFwlmoBNyPgmqQuykRNVj+GHEQ6Tm
         0REZdABlNb9k8tpLA7ys6223BsuUARfW4a+GU3SCFM8Lpg8l/SowZSONLZZsVewhBZcm
         Zfnqi3zDDrVnS5XsUYWt3B3asOsCdoHTnReCDjLmQriZz3VadNnPh0QhL9js1kK/nB4l
         Dt7Yp0T/sXz+4fevsmn8nDexzJy/cuV05PTWAXMA+VHwYfe610Yf4byElqpm2Ok5L0i+
         OXRg==
X-Gm-Message-State: APjAAAXh9iMw5lv8woBL6zjf+TiDNPoMX1SrfN8S5PiIIqiYMfqtBzhN
        oOZdso9K3ckK0QExKyq52gffWA==
X-Google-Smtp-Source: APXvYqyU3a6dWnse4flrUdIhmYUNneeBWjNyjgCmGnXAmaWfD8PBU8PDMSEBQE9UnNlGVpkOFwv6OA==
X-Received: by 2002:a19:ca13:: with SMTP id a19mr17986751lfg.133.1572907470954;
        Mon, 04 Nov 2019 14:44:30 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n1sm2536150ljg.44.2019.11.04.14.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 14:44:30 -0800 (PST)
Date:   Mon, 4 Nov 2019 14:44:19 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191104144419.46e304a9@cakuba.netronome.com>
In-Reply-To: <20191104210450.GA10713@splinter>
References: <20191103083554.6317-1-idosch@idosch.org>
        <20191104123954.538d4574@cakuba.netronome.com>
        <20191104210450.GA10713@splinter>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Nov 2019 23:04:50 +0200, Ido Schimmel wrote:
> On Mon, Nov 04, 2019 at 12:39:54PM -0800, Jakub Kicinski wrote:
> > On Sun,  3 Nov 2019 10:35:48 +0200, Ido Schimmel wrote:  
> > > From: Ido Schimmel <idosch@mellanox.com>
> > > 
> > > Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
> > > the driver and device's firmware. They are used to pass various
> > > configurations to the device, but also to get events (e.g., port up)
> > > from it. After the Ethernet header, these packets are built in a TLV
> > > format.
> > > 
> > > Up until now, whenever the driver issued an erroneous register access it
> > > only got an error code indicating a bad parameter was used. This patch
> > > set from Shalom adds a new TLV (string TLV) that can be used by the
> > > firmware to encode a 128 character string describing the error. The new
> > > TLV is allocated by the driver and set to zeros. In case of error, the
> > > driver will check the length of the string in the response and print it
> > > to the kernel log.
> > > 
> > > Example output:
> > > 
> > > mlxsw_spectrum 0000:03:00.0: EMAD reg access failed (tid=a9719f9700001306,reg_id=8018(rauhtd),type=query,status=7(bad parameter))
> > > mlxsw_spectrum 0000:03:00.0: Firmware error (tid=a9719f9700001306,emad_err_string=inside er_rauhtd_write_query(), num_rec=32 is over the maximum number of records supported)  
> > 
> > Personally I'm not a big fan of passing unstructured data between user
> > and firmware. Not having access to the errors makes it harder to create
> > common interfaces by inspecting driver code.  
> 
> I don't understand the problem. If we get an error from firmware today,
> we have no clue what the actual problem is. With this we can actually
> understand what went wrong. How is it different from kernel passing a
> string ("unstructured data") to user space in response to an erroneous
> netlink request? Obviously it's much better than an "-EINVAL".

The difference is obviously that I can look at the code in the kernel
and understand it. FW code is a black box. Kernel should abstract its
black boxiness away.

> Also, in case it was not clear, this is a read-only interface and only
> from firmware to kernel. No hidden knobs or something fishy like that.

I'm not saying it's fishy, I'm saying it's way harder to refactor code
if some of the user-visible outputs are not accessible (i.e. hidden in
a binary blob).

> > Is there any precedent in the tree for printing FW errors into the logs
> > like this?  
> 
> The mlx5 driver prints a unique number for each firmware error. We tried
> to do the same in switch firmware, but it lacked the infrastructure so
> we decided on this solution instead. It achieves the same goal, but in a
> different way.

FWIW nfp FW also passes error numbers to the driver and based on that
driver makes decisions and prints errors of its own choosing. The big
difference being you can see all the relevant errors by looking at
driver code.
