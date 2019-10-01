Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440B2C3FA8
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 20:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731932AbfJASR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:17:56 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33895 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfJASR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:17:56 -0400
Received: by mail-yb1-f194.google.com with SMTP id p11so5948884ybc.1
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 11:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZknMp8m9v93W75yYroBtNlfIZBzgcPs43nxG5EutoQY=;
        b=Lewl8pA0B/sIfuJzP4yaTnYp7NbRoXjcm1WhhokMJZxEU2y9PwLh3jScj7j4ChcOzk
         p/n9qTnyh4YUcuga4CZ8nqemo4Z3y9dWqeAKHqvVC584kl5+Dw5XwdJVF51RyMIJbr+2
         VktX0kTKiG3mi/n3Gfn9rfXjxvSOh0ND6+hoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZknMp8m9v93W75yYroBtNlfIZBzgcPs43nxG5EutoQY=;
        b=unzJL5G4e1/pnY5rr/1xsgLu84eZtDKeyspUAioIL3gAL813fvlEp7DFEs/m/Lt/pB
         WD1X8jXOJ6EbBtNTkj6/5GjUqtUMmldYM6yIcZHhUqX7jSXDaa0iEwyuFgsBPSaPAfhd
         Cde03j4Gfjlij2bTqxNL2jexujF1E5UfxkLHNVQGZfIPMZZM/O7W7PKHRmMXXJosjyZp
         dgATqRd1l+A5ynYYX1JrDlCGT39V2fOfgdqmWI46uR3KGSkUpe8giErQQG9trk3Aogzf
         OD7dNRyvUf+jkwFDPXYa+GSTKoW4b7jFpIRm42ylLm2b6hubpRBwqb6SCAmkAlY0SOtz
         OFiQ==
X-Gm-Message-State: APjAAAXwKsqVDKDpbnjsw2iRsh7rajXX5ZwnHanx4TFaWLJ7Uz/WDglY
        GdAArr9T43V5QIX/teQQ1TQO4jTPko0dUUhiSalg9Q==
X-Google-Smtp-Source: APXvYqzuDDiAu8mTyAZsx5iA/7h+8ZlaOZqbN+PxPdG2npcOi9a17aQ1fBYFSt+JHZpZf8cxc4g6hzwx8kYahX4cHj0=
X-Received: by 2002:a25:68c2:: with SMTP id d185mr20173897ybc.186.1569953875354;
 Tue, 01 Oct 2019 11:17:55 -0700 (PDT)
MIME-Version: 1.0
References: <1923F6C8-A3CC-4904-B2E7-176BDB52AF1B@gmail.com>
In-Reply-To: <1923F6C8-A3CC-4904-B2E7-176BDB52AF1B@gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 1 Oct 2019 11:17:44 -0700
Message-ID: <CACKFLikbp+sTxFBNEnUYFK2oAqeYm58uULE=AXfCp2Afg3x4ew@mail.gmail.com>
Subject: Re: Gentoo Linux 5.x - Tigon3
To:     Rudolf Spring <rudolf.spring@gmail.com>
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 7:31 AM Rudolf Spring <rudolf.spring@gmail.com> wrot=
e:
>
> Hello - Since Kernel Version 5.0 (5.0.x/5.1.x/5.2.x and now 5.3.x) my BCM=
57765 refuses to work correctly. The same system configuration works withou=
t problems on the latest stable Gentoo 4.19.72 Kernel. So the changes from =
4.19 to 5.0 include some code that is responsible for the hick-up.

These are all the tg3 changes between 4.19 and 5.0:

750afb08ca71 cross-tree: phase out dma_zalloc_coherent()
cddaf02bcb73 tg3: optionally use eth_platform_get_mac_address() to get
mac address
3c1bcc8614db net: ethernet: Convert phydev advertize and supported
from u32 to link mode
6fe42e228dc2 tg3: extend PTP gettime function to read system clock
310fc0513ea9 tg3: Fix fall-through annotations
22b7d29926b5 net: ethernet: Add helper to determine if pause
configuration is supported
70814e819c11 net: ethernet: Add helper for set_pauseparam for Asym Pause
af8d9bb2f2f4 net: ethernet: Add helper for MACs which support asym pause
04b7d41d8046 net: ethernet: Fix up drivers masking pause support
58056c1e1b0e net: ethernet: Use phy_set_max_speed() to limit advertised spe=
ed

Most of the changes are related to PHY settings.  I suggest that you
check the link settings, including speed, pause, asym pause, etc
between the working kernel and the non-working kernel to see if there
are differences in the settings.
