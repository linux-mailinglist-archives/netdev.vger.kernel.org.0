Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E9811EF19
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfLNAW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:22:27 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35435 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfLNAW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:22:26 -0500
Received: by mail-lj1-f195.google.com with SMTP id j6so581263lja.2
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=giiBxdvWgaNqH68xnv3JmWP9dzCBTdZ9klmH0YITisE=;
        b=moDlCKvuxDXDzEEAIiXkhQpF42yemoKEbL0AZF9wNsfDWxNqQ6PAyC79TcuJE7Mkc9
         Zd8qEd4kDdalk1yWC0H+Rr1MJ1/Yx0Hzhn7Tx0fCPyejRdP0cH3t3Jq5V7nYVWtI9cTR
         S7EOX9jtd1eh7m3Y6RLy5trfH8sioerQknIUhEUlEwtfb3Rtt9vMYdIm0xtLws8vyLIo
         8Wz5AZza9+t2BnITvbK6kvG+AWHbDFu93SVokmMiCVY0e3lv9bI1cVEarTCu+TarLpw3
         brGJ7zEjLhMXpGfaQjutJUx6HNe/0vR1nl/rzpmdY6cIp+tWFtL5Bbuhd7ElwsD/eF6b
         WE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=giiBxdvWgaNqH68xnv3JmWP9dzCBTdZ9klmH0YITisE=;
        b=jC80p+dySM2bxlv8/zcFV6IOMrakfvfTLXF8LDlAgZpPX4HWSYzSN5PbxN5JEZJrUN
         PgAmrb6Th8zVT8fMLeL1kbWc4BHber3xGVBlptyyVRAnMBCypG116iFILZkqriMVf/9h
         LRD6NSYPQoHo5zxqvz9AJhWr57kNM/dNezKXjfqcR+RXERAOoosiKlWN/ViKOI5nQyrO
         Ing0Mo/8fCFuf0xKQ67PB5377MP+aPuU0oxC9ic+2crfZOP9+STGcOPzREbILRqhsRGA
         KCQmfS+edHjYHYgvVPGlOOBiN2+ptxrgZuy+ib1VkcE9LoQOXNXIyp2zAfAG7Xse5x0g
         RCOQ==
X-Gm-Message-State: APjAAAX+6RuLkiuGeFT4SH+UZmuSNWdsyOxaLANGcIjEgwv+WJURMuJm
        q0zrN9vpBrIOrOwzB7iw8eGecQ==
X-Google-Smtp-Source: APXvYqxk4KifralwNEGO507iNNuOIWFqTEHw/xBJIq1aHCZdSobUATGCeEfnlG0VPQmTb1fbDwOe/Q==
X-Received: by 2002:a2e:9a11:: with SMTP id o17mr11430388lji.256.1576282944630;
        Fri, 13 Dec 2019 16:22:24 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k25sm5583547lji.42.2019.12.13.16.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 16:22:24 -0800 (PST)
Date:   Fri, 13 Dec 2019 16:22:16 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/8] net: stmmac: Fixes for -net
Message-ID: <20191213162216.2dc8a108@cakuba.netronome.com>
In-Reply-To: <cover.1576005975.git.Jose.Abreu@synopsys.com>
References: <cover.1576005975.git.Jose.Abreu@synopsys.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 20:33:52 +0100, Jose Abreu wrote:
> Fixes for stmmac.
> 
> 1) Fixes the filtering selftests (again) for cases when the number of multicast
> filters are not enough.
> 
> 2) Fixes SPH feature for MTU > default.
> 
> 3) Fixes the behavior of accepting invalid MTU values.
> 
> 4) Fixes FCS stripping for multi-descriptor packets.
> 
> 5) Fixes the change of RX buffer size in XGMAC.
> 
> 6) Fixes RX buffer size alignment.
> 
> 7) Fixes the 16KB buffer alignment.
> 
> 8) Fixes the enabling of 16KB buffer size feature.

Hi Jose!

Patches directed at net should have a Fixes tag identifying the commit
which introduced the problem. The commit messages should also describe
user-visible outcomes of the bugs. Without those two its hard to judge
which patches are important for stable backports.

Could you please repost with appropriate Fixes tags?
