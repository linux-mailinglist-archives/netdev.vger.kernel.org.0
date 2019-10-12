Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66919D5229
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 21:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfJLTZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 15:25:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41394 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbfJLTZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 15:25:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so7698487pga.8
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 12:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bTRD5qPw9WifRQmYZW6iKqCth6nognNUuVkzjQ/7l4U=;
        b=ejUxOjt0KQ06GoQ/FHtmI5F7z46hVcBTApDcUfP/b7A3FLPFXOuSxYvMfgytio47Ag
         6GEEBIE20qRVZoW/o/GmzeFatY+CVQ9reY5Zn0Xoyl1iFFAYG2O7RB0k828VqXVlUXD7
         T3VKsfF6Ri9QJSl5jKFbXeN9ZyvHa8Qc1Vr6PboY2ZjGXOinTGDhE4nvWY4Deh9p4j48
         hlC/rZhQTiaPg8Ys3pkR5TX9X9nd2lyw/gDK9dmhfRd426RhMNASiB1ZswfL+E9u3ic8
         JkQcEFdA4WsfaT0p/ZoXfQjbkwX1Fw2lk3B15s+ywl8c8CkWiehk5pq7xeTalfWOMm2p
         /Kmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bTRD5qPw9WifRQmYZW6iKqCth6nognNUuVkzjQ/7l4U=;
        b=G1a5jt/NH3MERzWxaDGPPgP0TIEojScDNV0n3iyKVHpPwr4wCACedqJ1cBzwBckdc8
         IAE6Gq4mY71r8loYEdq1QdIS7FOvn1W+tklLR9tImlPryXboZima8mSFBekvINuxhqrC
         J15GPguHg5YbnC9g1y6Osy9ChMqRUPKVWo8IxgcQuDbBgbbJcr712xxdqv743RL3Eupv
         gU2o3eNj66K2tZ2Wv3ilKH/aoPZbJksa68NjouoTZEeZPfdbFPeYUs2cni/H7Fbrihhw
         KNsNHxvyao4bT1HNAzYOB6nuIrt536wc9xB0rYgahZkYBDIVQQX0HLnBjm+9gxcUPai+
         xjUw==
X-Gm-Message-State: APjAAAWvHlmdCnwuTq7yklNhj3S3An8apSSeMugbWWP+REj23I4DqrqB
        rxy88t7vH7TroLNp8LwzG2U=
X-Google-Smtp-Source: APXvYqwGPu+0LwGqDWinhEhtF1e63H66T7naZQVp2AjV1Yp1mPPImEQrOnN97BYUqU4IwuW7Pxzahw==
X-Received: by 2002:aa7:9a0c:: with SMTP id w12mr6975990pfj.81.1570908325818;
        Sat, 12 Oct 2019 12:25:25 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id i6sm15697364pfq.20.2019.10.12.12.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 12:25:25 -0700 (PDT)
Date:   Sat, 12 Oct 2019 12:25:22 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH v2 net-next 11/12] net: aquantia: add support for PIN
 funcs
Message-ID: <20191012192522.GA5113@localhost>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <0142dcd43c84ab7bc26076c3eb48d43e67d195cc.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0142dcd43c84ab7bc26076c3eb48d43e67d195cc.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:56:59AM +0000, Igor Russkikh wrote:
> From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
> 
> Depending on FW configuration we can manage from 0 to 3 PINs for periodic output
> and from 0 to 1 ext ts PIN for getting TS for external event.
> 
> Ext TS PIN functionality is implemented via periodic timestamps polling
> directly from PHY, because right now there is now way to received

there is no way to receive the

> PIN trigger interrupt from phy.
> 
> Poller delay is 15ms.

The polling interval is 15 milliseconds.

Thanks,

Richard
