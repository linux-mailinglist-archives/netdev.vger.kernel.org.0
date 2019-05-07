Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723CA16958
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 19:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfEGRhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 13:37:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59934 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEGRhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 13:37:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73B951491A2C3;
        Tue,  7 May 2019 10:37:51 -0700 (PDT)
Date:   Tue, 07 May 2019 10:37:51 -0700 (PDT)
Message-Id: <20190507.103751.167341559794722180.davem@davemloft.net>
To:     hauke@hauke-m.de
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/5] net: dsa: lantiq: Add bridge offloading
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505222510.14619-1-hauke@hauke-m.de>
References: <20190505222510.14619-1-hauke@hauke-m.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 10:37:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Mon,  6 May 2019 00:25:05 +0200

> This adds bridge offloading for the Intel / Lantiq GSWIP 2.1 switch.
> 
> Changes since:
> v2:
>  - Added Fixes tag to patch 1
>  - Fixed typo
>  - added GSWIP_TABLE_MAC_BRIDGE_STATIC and made use of it
>  - used GSWIP_TABLE_MAC_BRIDGE in more places
> 
> v1:
>  - fix typo signle -> single

Series applied.
