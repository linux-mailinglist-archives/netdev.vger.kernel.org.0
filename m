Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21933625D7
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390322AbfGHQK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:10:28 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33260 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbfGHQK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:10:28 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so21531945iog.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=4/cAHY9CswFMxHmGkROgr5n3C7ZgXdkwUp/kaLByq5Y=;
        b=tgF9BNXlvQlGZme/zHOLvOjU2wA+h8mF22gXkaHnjBq9UIvKfn3tmQKg8l2YnDnbNz
         wBldhi7KTxI+1MGcUvBdNrzbCh/A9YBCE3yCwU0PyC9AHATRcSvetXwxg1EBt7tHkbog
         q/Xp6llyDHK1/H5DMByfXNrquhxQ4MSWmcaCg2attUIW85I/GrZVsgnwwtjL7SRYryJr
         nr1VaXDSslw3ARMLrylHPUqNR9UlBZ1SfEK0W9PtzivAmwQIM3q9MH0gF+A9dC3f/q8c
         23Z/Z8BfK5hmDGQen0Zcgb9fHSexy6kQ+Ebv9TWnj5P3Kp8pmj7Q3+jNQl/9aZWtlbMY
         OA4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=4/cAHY9CswFMxHmGkROgr5n3C7ZgXdkwUp/kaLByq5Y=;
        b=stE12DxtIaRnCIXcChPRH9BY3QV3OwskULCzkb0XJTAJI42FZCjHpCb74yRoPfKwoR
         by8xq/Pq1rvQA4ddhbBbke0oi3xSHIl0M8uMRLzVbWEmxY4AZDE2uwqu5Lzo9O2L51wf
         ecpuPREKnTZ2posWjjpybhdytnjxhsaqC2VjW8t7TTZ4Qmo2NiYoaP+/Z22SRR06tl6S
         Uw3Rbu30rTRAS61fceD64OoVPfC3nX1k8qEfcTZ54jQeyYX0GXE8XaNpHTedO6N7LviM
         PaDBtiJatGrZ9tnrq47B/u/W2SztWFijf9gYAYBVWqCB86vl7Zy6FgVcL9hx2vT/THUS
         IK9Q==
X-Gm-Message-State: APjAAAWXATQpcazNHNwTZT5U0Cj+UPfQG3nzv4+/5CuIzH4VjAKHlBF+
        NCia17vYY5iEb1+L3jidouI=
X-Google-Smtp-Source: APXvYqwYyuhtXIY07Zl/AllyHfzp17Xu6+KiOzMHbnaGPFsPH7DplHh1WSvYLFsErZRm63ZbAgcZEQ==
X-Received: by 2002:a05:6638:cf:: with SMTP id w15mr16516800jao.136.1562602226995;
        Mon, 08 Jul 2019 09:10:26 -0700 (PDT)
Received: from localhost (mtrlpq2848w-70-48-16-149.dsl.bell.ca. [70.48.16.149])
        by smtp.gmail.com with ESMTPSA id b14sm18752102iod.33.2019.07.08.09.10.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:10:26 -0700 (PDT)
Date:   Mon, 8 Jul 2019 12:10:23 -0400
Message-ID: <20190708121023.GB17624@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] tc-taprio offload for SJA1105 DSA
In-Reply-To: <CA+h21hoZ-ZgweMEDSBjANVhkVTNDONA+YkSz5y6TAJWByHHzDg@mail.gmail.com>
References: <20190707172921.17731-1-olteanv@gmail.com>
 <20190707174702.GC21188@lunn.ch>
 <CA+h21hoZ-ZgweMEDSBjANVhkVTNDONA+YkSz5y6TAJWByHHzDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Jul 2019 23:28:24 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> I thought the dsa_port_notify functions are just to be
> called from switchdev. I'm still not sure I fully understand, but I'll
> try to switch to that in v2 and see what happens.

dsa_port_notify is used to forward an event occuring on a given port, to
all switch chips of a fabric. For example when programming a VLAN on a port,
all ports interconnecting switches together must to programmed too. Even
though mainly switchdev objects or attributes are notified at the moment,
a DSA notification is not specific to switchdev.


Thanks,

	Vivien
