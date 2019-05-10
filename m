Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6441A20F
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 18:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfEJQ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 12:59:26 -0400
Received: from secvs01.rockwellcollins.com ([205.175.225.240]:27534 "EHLO
        secvs01.rockwellcollins.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727796AbfEJQ70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 12:59:26 -0400
X-RC-All-From: , 205.175.225.60, No hostname, robert.mccabe@rockwellcollins.com,
 "robert.mccabe" <robert.mccabe@rockwellcollins.com>, , 
X-RC-Attachments: , ,
X-RC-RemoteIP: 205.175.225.60
X-RC-RemoteHost: No hostname
X-RC-IP-Hostname: secip01.rockwellcollins.com
X-RC-IP-MID: 278634083
X-RC-IP-Group: GOOGLE_RELAYED
X-RC-IP-Policy: $GOOGLE_RELAYED
X-RC-IP-SBRS: None
Received: from unknown (HELO mail-pf1-f199.google.com) ([205.175.225.60])
  by secvs01.rockwellcollins.com with ESMTP/TLS/AES128-GCM-SHA256; 10 May 2019 11:59:25 -0500
Received: by mail-pf1-f199.google.com with SMTP id i123so4522919pfb.19
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 09:59:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qCM2LTAoRdxdGnv1zix4bkNP0NUwPgqPAhkr/QIl0uM=;
        b=aGE0EAteMzYdtdGK92J8z0G8vI55Qx82CZ0hNYVS19SzGSfQSNv42u6zFo+UFbibQK
         DP1cueUl2X8+TGEvOQqPBDib6v5D6d2GBpEYkeXY3Z1Oq7keiXA9hb+jUOcSdJ2++W0+
         laeKojFL3LKOtpWRIZcq/p5O04K+9V8Xxfsm2/tAqd9GM3CkoiCD4FnsAMvltuj+fzYg
         sHUUhtqQCcT1AqjaSk91gXgTjBS5Bb03GujhQMjXhSLWky8Xl0mddc6HnBCJiEe8UDKH
         7VC9NbA5txyx2sZC2LhXTl6DiU1yGg4tnpjyo2qXD1OzpBIAGsEVRd+pLO1SXVRZy4XZ
         kpMQ==
X-Gm-Message-State: APjAAAXvm7nAzT59M0fX7oRkxybj4jauGl4Dvox3f7a0U4xNmJCk3sgR
        jZLV3M+3m4fHTnfzcD4G7nZp5QIDPMW2mpOarAXxwSZHuo64e+51q5UGkQ+gTBvk/sbYfRXmkcG
        EsQtOHPRpRHt0h0HT+3hAPSQwmSfxm1V6X8WU3Fp1OgNInozQ510=
X-Received: by 2002:a63:295:: with SMTP id 143mr15057802pgc.279.1557507564300;
        Fri, 10 May 2019 09:59:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyUeNOVVvxhkR6XanQRg3/P7Z9hDI7uYFVDM4xjlOQrmS9eAulNR19VzFbrRTvsEhNNGlSI+STSivR09mLUrl4=
X-Received: by 2002:a63:295:: with SMTP id 143mr15057743pgc.279.1557507563874;
 Fri, 10 May 2019 09:59:23 -0700 (PDT)
MIME-Version: 1.0
From:   "robert.mccabe" <robert.mccabe@rockwellcollins.com>
Date:   Fri, 10 May 2019 11:59:13 -0500
Message-ID: <CAA0ESdpYVxx6Ra94hV=1RWH1+OZHFG3_7B-bpEicgwHiYvTczg@mail.gmail.com>
Subject: Question about setting custom STAB
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Awhile ago I submitted this iproute2 patch:
https://patchwork.ozlabs.org/patch/784165/

And the corresponding kernel patch:
https://patchwork.ozlabs.org/patch/783696/

To allow the setting of arbitrary qdisc size table so that the packet
scheduler code in __qdisc_calculate_pkt_len charges the correct
bandwidth per my custom link layer.  These patches were not applied
because the reviewers didn't like that I added another enumeration to
the kernel's UAPI:  TC_LINKLAYER_CUSTOM.

My question is: why is the setting of the STAB not exposed to
userspace applications?  This seems to be a powerful feature that is
more generic than hard-coding the STABs for TC_LINKLAYER_ETHERNET and
TC_LINK_LAYER_ATM.  Or maybe I'm missing something and there is
mechanism to do this without my iproute2 patch?

P.S. Sorry for the apparent spam.  My previous email's "From:" address
was messed up.
