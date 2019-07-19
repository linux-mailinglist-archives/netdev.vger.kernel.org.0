Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D206DC97
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 06:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfGSERO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 00:17:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40622 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388771AbfGSERL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 00:17:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so13855938pgj.7
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 21:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ycpPHNxqb5ySmdrFI4gF1EW+XlKwz3+7x6Ww0ox7ffE=;
        b=Tfvddlp1r4RVj3yKuiQ7DpfiZ+xy7aTJeMK3MQtlvbrzJUHiewspdyDj+ujTKfHGXb
         j+EzMGdEh2dCFdvYMmh9R78jvhFETpytpBRiqIHjVmYyLN/cqZ8o4z1gI1rXHO3yPRNd
         N/zglXtUAADMD4jPWuA31dSpWcBFv11wHWBvMwe8YeMnigixvHnkZRb70adkAOELP/EA
         TnDCJkP1iQjGcFNA68fxn0sZfayY6asV+IofqZMh9asxPIp1GugPT5IxoaPsmx5j7WaB
         TkTe950tRnflF54fheTNaZA6TxfpPO8dcs4nuLBBp69Aj337xCM+zHOnLG7S/wRUbhG7
         LBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ycpPHNxqb5ySmdrFI4gF1EW+XlKwz3+7x6Ww0ox7ffE=;
        b=lJbxP5s/WAUIgitngG8B3ecOagD2CuvKwiM4Of+QninEZV2SCl3gCC3GfZqmgr4KBk
         E1uFWgwWBB/NZApq+G6kI0ffM3WE28bPs1bPD4qMN1mKplSb3bHTKIdT0fpvnNx3w8Ws
         9HFQR8BY8iD1buG7suOBxi7QM4sJBPf9MB9bgt2aHl7wlSWMO4ZPQyPjaTLYNO3Pz64y
         VeC2igGLl46tzk1X1IGxlFQWuWqba6VAqgG1sFqEVmVyPPUTQebgoSLEiLcgoEDVV2vn
         Oopm8M804xLXISFr2vbRmy+ix6nMOzVnwBmJTUhScJbdygpF5evS56u4ZMhl/J7GsCrg
         HXgA==
X-Gm-Message-State: APjAAAXbIVEU+/ab18PsKTrv3pHUQNvHPPKLU8RI0UhyJqPxVb0KbgOI
        vBbcS7aZghMrDi7Sl63u8MoTE3RYQEVjOg==
X-Google-Smtp-Source: APXvYqzFWYSikpC4HxhT5Y8+R3irP1EbKLywvKw74azedsBI6HnP2qND1CNy/SwUAD8/wuAdsMp7/A==
X-Received: by 2002:a65:62c4:: with SMTP id m4mr50493954pgv.243.1563509830875;
        Thu, 18 Jul 2019 21:17:10 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s11sm383946pgc.78.2019.07.18.21.17.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 21:17:10 -0700 (PDT)
Date:   Fri, 19 Jul 2019 12:17:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jianlin Shi <jishi@redhat.com>
Subject: Re: [PATCH v2 net-next 03/11] net/ipv4: Plumb support for filtering
 route dumps
Message-ID: <20190719041700.GO18865@dhcp-12-139.nay.redhat.com>
References: <20181016015651.22696-1-dsahern@kernel.org>
 <20181016015651.22696-4-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181016015651.22696-4-dsahern@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Before commit 18a8021a7be3 ("net/ipv4: Plumb support for filtering route
dumps"), when we dump a non-exist table, ip cmd exits silently.

# ip -4 route list table 1
# echo $?
0

After commit 18a8021a7be3 ("net/ipv4: Plumb support for filtering route
dumps"). When we dump a non-exist table, as we returned -ENOENT, ip route
shows:

# ip -4 route show table 1
Error: ipv4: FIB table does not exist.
Dump terminated
# echo $?
2

For me it looks make sense to return -ENOENT if we do not have the route
table. But this changes the userspace behavior. Do you think if we need to
keep backward compatible or just let it do as it is right now?

Thanks
Hangbin
