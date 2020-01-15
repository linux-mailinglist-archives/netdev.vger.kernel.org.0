Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13AAB13C5A2
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgAOOPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:15:43 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35418 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgAOOPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 09:15:40 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so28629wmb.0
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 06:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/w9UFtxT6olUE6YcGQxHO8cmKa2SlzJGPvO1D4HVFrY=;
        b=BPIMuO5Q479N9v9RULq6gHcX/fuKvCx/b5uGCdfKg7TrDWrffH5Onai1h9Y12LetPr
         4sRgPXwCqONMYM+Ah0B76OTaCuvUx81BeiB7DxGkZDzyeCoeS7agZcnP9zFCUDtHR1GB
         0E2gBzUSCklOLt1YmN9cL/sI5CANTB7mTVO0/+NPN3c5RpHQIZTdGlZEb15VzewuIE6F
         imWhE+2ZrW5q3PB8S2a5OLgIG1zAEItbne2DoIfYhJFbyUuqG4ZGGZFk0sNPkRrGXyTK
         bxdWFxS+fTDn0hecyKdOuIBXPxJk1k661S1KeD32XF5cx0W8N2xcZkmfal8DWPkWWlvQ
         Og1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/w9UFtxT6olUE6YcGQxHO8cmKa2SlzJGPvO1D4HVFrY=;
        b=Q9kbp4gpJovjtiyxQItZ7TPEKCmHKPHAkZZg7kI++CsagYH2DEkQd0rGAFExwHbmnt
         JRNCdnoRXE6ruDBVcv/HqZMPd1pe02u2u/qA+lvd/lo159Gw/MNtbwk6KxHUOkuxejDn
         WBTZ5g+bZfY4KGfXLsaYDU6UauoDyV1uPCr6/a8OSl36sBU7uxcvH4ACFSOeyc/MNDST
         4Hnms0WNf25O7IUAzZPBVmZifFJxR6UQGM4ZTS0mBKJmHuy4bfCDz6OVujYnilEuo+gr
         GfNCv6PhwUzb/ptb6xoJSmkxlLY012AGJZ9vK8ETi2d3Xt6Sa9DUiEvE2uZcbpJbXyJ6
         u5ag==
X-Gm-Message-State: APjAAAWrakjmgP/p/hVnamL/KzZy7/1FKbDVIebMdLB6kL52Pen1IUkr
        WbQrPwssdG9gNL9dtZIVEbX4aQ==
X-Google-Smtp-Source: APXvYqxAchId4Gska8a0Jvi5IY8UCUzpVYmEG1Cm5gWKtLF940Y95bnMNlwnU7bKq9qTiwieMC/nUA==
X-Received: by 2002:a1c:16:: with SMTP id 22mr34649342wma.8.1579097738108;
        Wed, 15 Jan 2020 06:15:38 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id z187sm24428036wme.16.2020.01.15.06.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 06:15:37 -0800 (PST)
Date:   Wed, 15 Jan 2020 15:15:35 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
Message-ID: <20200115141535.GT2131@nanopsycho>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 15, 2020 at 02:04:49PM CET, maorg@mellanox.com wrote:
>
>On 1/15/2020 11:45 AM, Jiri Pirko wrote:
>> Wed, Jan 15, 2020 at 09:01:43AM CET, maorg@mellanox.com wrote:
>>> RDMA over Converged Ethernet (RoCE) is a standard protocol which enables
>>> RDMA’s efficient data transfer over Ethernet networks allowing transport
>>> offload with hardware RDMA engine implementation.
>>> The RoCE v2 protocol exists on top of either the UDP/IPv4 or the
>>> UDP/IPv6 protocol:
>>>
>>> --------------------------------------------------------------
>>> | L2 | L3 | UDP |IB BTH | Payload| ICRC | FCS |
>>> --------------------------------------------------------------
>>>
>>> When a bond LAG netdev is in use, we would like to have the same hash
>>> result for RoCE packets as any other UDP packets, for this purpose we
>>> need to expose the bond_xmit_hash function to external modules.
>>> If no objection, I will push a patch that export this symbol.
>> I don't think it is good idea to do it. It is an internal bond function.
>> it even accepts "struct bonding *bond". Do you plan to push netdev
>> struct as an arg instead? What about team? What about OVS bonding?
>
>No, I am planning to pass the bond struct as an arg. Currently, team 

Hmm, that would be ofcourse wrong, as it is internal bonding driver
structure.


>bonding is not supported in RoCE LAG and I don't see how OVS is related.

Should work for all. OVS is related in a sense that you can do bonding
there too.


>
>>
>> Also, you don't really need a hash, you need a slave that is going to be
>> used for a packet xmit.
>>
>> I think this could work in a generic way:
>>
>> struct net_device *master_xmit_slave_get(struct net_device *master_dev,
>> 					 struct sk_buff *skb);
>
>The suggestion is to put this function in the bond driver and call it 
>instead of bond_xmit_hash? is it still necessary if I have the bond pointer?

No. This should be in a generic code. No direct calls down to bonding
driver please. Or do you want to load bonding module every time your
module loads?

I thinks this can be implemented with ndo with "master_xmit_slave_get()"
as a wrapper. Masters that support this would just implement the ndo.

>
