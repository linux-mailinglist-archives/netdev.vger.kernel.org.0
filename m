Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F1011F5CA
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 06:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfLOFL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 00:11:57 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45771 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfLOFL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 00:11:57 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so67783pls.12
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 21:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=j0T/vKPvakM+ooHUDGww5rBNB0+BC5vZhBXRccoD8Bg=;
        b=C/AVyZKz2NnNuvQwzOfT2KWTpWXjYGsLDOsoxE6OFtIuob/avofWN6rrrgcdyjiS23
         iGtgnPF+0B1wOomsaOBzh3AiJyWwnYdTSs7QcuD6gzcb7NGbwX0Z5Yf+Z05EFI2w82/D
         xMTxrJ9gBH7dmRxQiL+4qbacV2leo6J2hA0M4lgHD1i9QLU3Ff4Nj1f1+edvVcbCzzWY
         tHvL1Mr8AwJRI3l41Gzp9w7AsBE4S7n/YAeLF4nrTeVJRU54Ly2i0KE/4rktEB5WkNbL
         as3UO9BNF+YhZFxhaVsqSHPV/EqzUjxguUppSCLolrN2cNM+/MZbJDWh4BHpZAc+t6TW
         ob5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=j0T/vKPvakM+ooHUDGww5rBNB0+BC5vZhBXRccoD8Bg=;
        b=I/E5e9xAuNEnHxYg+UH6Q8SVXj57bunS/ZAvQ29cx3JNBWC3yqqkJlgA2s44OR2Cmv
         UwPP2RgvWze12WFwViwR4Hnm1vNxZZ8OGThWvqqdFovbexQ5kGdtO/C/AOXIcY6T0coP
         bi6thJrNkfq0dPOrGw3NteG8Zw5/p8a+sp0/zlrwMGuHZaZwDSzcuCCc5RMfs/Jo0wDK
         oBVXk5fSudqOGyi+IZE4x5Pwbk4ifwoOHIXIA2EasWGMrzIhLKIJxeok0VYBrSZazKsZ
         SaxHRxEE5p59hNabwJRvu186jy1LX6UwiKiWHDjs0UFcflzy+eP6cJkBTtGof/KNKpIn
         edNA==
X-Gm-Message-State: APjAAAWNrCoQa+wzvDnxdUAF9YkgxmT7engB49RW/8w2uiNvojVla+nH
        nJfdd9NyE9E/6bfbnu2bGRRAZF+Ula0=
X-Google-Smtp-Source: APXvYqxkipZKzXvhyv2WRH1vJ/BF4pri7a4+VzkeeGcRfLj9hcj+FJ2BFl02HKMf/4hW9u6cOEYzdQ==
X-Received: by 2002:a17:90a:d344:: with SMTP id i4mr10488206pjx.42.1576386716149;
        Sat, 14 Dec 2019 21:11:56 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v16sm16998336pfn.77.2019.12.14.21.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 21:11:55 -0800 (PST)
Date:   Sat, 14 Dec 2019 21:11:52 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/9] Add ipv6 tunnel support to NFP
Message-ID: <20191214211152.5b77cc13@cakuba.netronome.com>
In-Reply-To: <20191214204151.55c6e4c9@cakuba.netronome.com>
References: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
        <20191214204151.55c6e4c9@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Dec 2019 20:41:51 -0800, Jakub Kicinski wrote:
> On Thu, 12 Dec 2019 18:16:47 +0000, John Hurley wrote:
> > The following patches add support for IPv6 tunnel offload to the NFP
> > driver.
> >=20
> > Patches 1-2 do some code tidy up and prepare existing code for reuse in
> > IPv6 tunnels.
> > Patches 3-4 handle IPv6 tunnel decap (match) rules.
> > Patches 5-8 handle encap (action) rules.
> > Patch 9 adds IPv6 support to the merge and pre-tunnel rule functions. =
=20
>=20
> Applied, thanks!

I take that back:

drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c: In function =E2=80=
=98nfp_tun_neigh_event_handler=E2=80=99:
drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c:524:20: warning: un=
used variable =E2=80=98dst=E2=80=99 [-Wunused-variable]
  524 |  struct dst_entry *dst;
      |                    ^~~
