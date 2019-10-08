Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F28D03C2
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfJHXCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:02:36 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33000 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJHXCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:02:35 -0400
Received: by mail-qk1-f196.google.com with SMTP id x134so491781qkb.0
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FMMLRXtAe40zCMcCtxvdP8i9kT/PLF62chlFdNDSpa8=;
        b=ZFzM3Avgh1nIZ9kRcYhwKQbctGHGKBEN6jhP8dxhduJ+4EPcJfdb2kEs36EGwPKTgY
         GDu8aQ/hL/5/0pTwv3fuQIb7NEH80mv1qvtHUPcsc7IUlxs5BVnnMg1tTykwNYvNgV8e
         U6cvjWUrJCi32I4kQ9et1ar15nltNXj7yQLsGBAHP5fONJlcWrRWecoAIR0PCwqx/fah
         AohsRSAmEUBkgvOT6hpYM+z0EAqfUnvZowytJBkjh18ZY1GnBTSZJ5Jm4uRphbNrAzgv
         0249cyY1Six4SoTA371Mti6zSmwExvlG7oCD2Xv9qNzjaPKZVK7C7/2o2RoBWuVuYZO7
         CgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FMMLRXtAe40zCMcCtxvdP8i9kT/PLF62chlFdNDSpa8=;
        b=PsCpYypZVbJndqwHE2r1jstMlPgFCl5KCnSNgJ8lU1unRUoBsNqV8/IGW8s4FXweu1
         WJnC75vl6iLrq0AwxF9HWHHO9A9BNGLj+frCWR7tGqX6V5DY4dOw10Z8nSJkazFJBPFJ
         iNJ8aQVZQ8AdIzrywmADsqZRnVidW2tW5ki8p8uLxB5KSM37mgmXxiDWdalZ4M79/cJd
         Dz9dTWz8XqkF4ul83WdM2dVppizRqXA0tU6UKWml89UddGtbh8XXSdqV9dy4QvuAM6st
         /UQHomb5uIxDG4byD/7SlLsXqlQOHDNs87zLkYIq/7yPiE7lO532jRmngFOJnfsoRW53
         GmLw==
X-Gm-Message-State: APjAAAWMtCXAvFshZbwfCVH1D/kvaMM9DcYzCiroFtamU3C1XWRE72JC
        pqO8z8O3ldpTxDn+66wB/LMtpQ==
X-Google-Smtp-Source: APXvYqxvRqb+z5HpoQj48byKYFHJWFucwPuLS22/dDgDrpAZfGfXzGsk3d6nAPeBA6lls6A278C1Zg==
X-Received: by 2002:a37:a646:: with SMTP id p67mr569346qke.489.1570575754654;
        Tue, 08 Oct 2019 16:02:34 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a19sm204875qtc.58.2019.10.08.16.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 16:02:34 -0700 (PDT)
Date:   Tue, 8 Oct 2019 16:02:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     MarkLee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rene van Dorst <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net,v2 0/2] Update MT7629 to support PHYLINK API
Message-ID: <20191008160222.0bdb7f47@cakuba.netronome.com>
In-Reply-To: <20191007070844.14212-1-Mark-MC.Lee@mediatek.com>
References: <20191007070844.14212-1-Mark-MC.Lee@mediatek.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 15:08:42 +0800, MarkLee wrote:
> This patch target to update mt7629 eth driver and dts to support PHYLINK

Thanks for the patches Mark. The description of the set should probably
say that it _fixes_ some issues. Right now it sounds a little bit like
you were adding a new feature. Could you rewrite the cover letter to
give us a better idea what issues this patch set is fixing and why
those issues occur?
