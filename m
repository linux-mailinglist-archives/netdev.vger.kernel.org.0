Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06231AF060
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437012AbfIJRTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:19:54 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40836 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387907AbfIJRTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:19:53 -0400
Received: by mail-qt1-f193.google.com with SMTP id g4so21685920qtq.7
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 10:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=m2AsrlPVRrEdvPsHBIyHPjRkG5Nqycp7CXTyHNX1Cxk=;
        b=BxSfcvrbm8MfhPIWQvEritw+LLM34jqarTnVuBL2eBmrf8OJ0/wlfgY8nPYaWRVMMH
         B0l6Gy7xlQwr8Sj/F66wd8G6ynPymlOU9iODaQqbJagc+3B2uVuBVeFQEdYIWi7ezfS0
         YcZngEdO4A0X0ILeBiPMV1qjUosCglTz3+nuzXwjw4VrUcMWHaLaUb2SdUhFkqaNlXlp
         ZwCVf5TNRu4zJv++f9bPrQEPVCVRBzyDKB424QYwTBqg3P+E8eVjuBOgQM+IeNM7VMpq
         xMdRvW/qzwIYLmjxrlZIpfK+1PLWRzCm3hJ6Kpp06PxbsMsE5z35n4u7isnnXhADxzbe
         PolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=m2AsrlPVRrEdvPsHBIyHPjRkG5Nqycp7CXTyHNX1Cxk=;
        b=AIrwlDksFWmUo8pMaQlhqYZ2c+TbfCcUKkgFzJh3TAga+IR4Xcwwmb/F/HJj31OaDV
         9558zNT+pHMLwI5eEnTQgcqkjVYTP3JF5axpSEwzBCROjvYQUUTmbZS29yjrhKJg1/hF
         X08m8nzDYwtwWREgQuza2mWBCMbZ8kfglh397Nef/NleOJ57F5rTJM5vuTm6VwyE/Fsl
         jeHpzoOQnBNkFH984ZaM2MIUIngFKBIv0DSr1CKLUe4idvFUA3RJeD2ajVl16Tz2jlra
         QrMSO/BGHI+lR0gr+DPK2AUmeaDG783BReQuda2eSfUAgTk7ehrOBc+AF1eCHpplED1v
         /rvQ==
X-Gm-Message-State: APjAAAXB03zsrfUn16aDXXARKyMJNQofGcvIxaco4jF2mRl0E/zGoP6i
        Y/GqmWRYtLbt/xAJLUP6X9k=
X-Google-Smtp-Source: APXvYqz2oBQeKPDtA94Ds8nwx7mFfSgs2/HVaAUrACmcb67l7/XrY8Zpzn2UsKKfT8KEdlgwgSpNNw==
X-Received: by 2002:ac8:5548:: with SMTP id o8mr28007536qtr.163.1568135992971;
        Tue, 10 Sep 2019 10:19:52 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o124sm8864343qke.66.2019.09.10.10.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 10:19:52 -0700 (PDT)
Date:   Tue, 10 Sep 2019 13:19:51 -0400
Message-ID: <20190910131951.GM32337@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     netdev@vger.kernel.org, Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
In-Reply-To: <20190910154238.9155-1-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

On Tue, 10 Sep 2019 16:41:46 +0100, Robert Beckett <bob.beckett@collabora.com> wrote:
> This patch-set adds support for some features of the Marvell switch
> chips that can be used to handle packet storms.
> 
> The rationale for this was a setup that requires the ability to receive
> traffic from one port, while a packet storm is occuring on another port
> (via an external switch with a deliberate loop). This is needed to
> ensure vital data delivery from a specific port, while mitigating any
> loops or DoS that a user may introduce on another port (can't guarantee
> sensible users).
> 
> [patch 1/7] configures auto negotiation for CPU ports connected with
> phys to enable pause frame propogation.
> 
> [patch 2/7] allows setting of port's default output queue priority for
> any ingressing packets on that port.
> 
> [patch 3/7] dt-bindings for patch 2.
> 
> [patch 4/7] allows setting of a port's queue scheduling so that it can
> prioritise egress of traffic routed from high priority ports.
> 
> [patch 5/7] dt-bindings for patch 4.
> 
> [patch 6/7] allows ports to rate limit their egress. This can be used to
> stop the host CPU from becoming swamped by packet delivery and exhasting
> descriptors.
> 
> [patch 7/7] dt-bindings for patch 6.
> 
> 
> Robert Beckett (7):
>   net/dsa: configure autoneg for CPU port
>   net: dsa: mv88e6xxx: add ability to set default queue priorities per
>     port
>   dt-bindings: mv88e6xxx: add ability to set default queue priorities
>     per port
>   net: dsa: mv88e6xxx: add ability to set queue scheduling
>   dt-bindings: mv88e6xxx: add ability to set queue scheduling
>   net: dsa: mv88e6xxx: add egress rate limiting
>   dt-bindings: mv88e6xxx: add egress rate limiting
> 
>  .../devicetree/bindings/net/dsa/marvell.txt   |  38 +++++
>  drivers/net/dsa/mv88e6xxx/chip.c              | 122 ++++++++++++---
>  drivers/net/dsa/mv88e6xxx/chip.h              |   5 +-
>  drivers/net/dsa/mv88e6xxx/port.c              | 140 +++++++++++++++++-
>  drivers/net/dsa/mv88e6xxx/port.h              |  24 ++-
>  include/dt-bindings/net/dsa-mv88e6xxx.h       |  22 +++
>  net/dsa/port.c                                |  10 ++
>  7 files changed, 327 insertions(+), 34 deletions(-)
>  create mode 100644 include/dt-bindings/net/dsa-mv88e6xxx.h

Feature series targeting netdev must be prefixed "PATCH net-next". As
this approach was a PoC, sending it as "RFC net-next" would be even more
appropriate.


Thank you,

	Vivien
