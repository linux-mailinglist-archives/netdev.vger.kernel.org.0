Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4E760D55
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 23:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfGEVtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 17:49:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46362 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGEVtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 17:49:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so10355498qtn.13
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 14:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=h/A4tEl2mtBha7cHiuEYdkY3q6oP12EZ6C0/Om+AD10=;
        b=WSx2lsXJMKNctZUo8/bf87Uvk5Fi7zcXw+qV0e6Q8AQjzRrwOAT528YRawwec7hge7
         mVfSRjx3YMBkeTx24cG51ppvVAONcixhZgueA7zPAJYNLo1l8mtOvZT00ESxovvB9rfU
         a5I50JSemGPaPw5hbCg61YbXa83GNjX8pWkpr8S6bySjaysb++e8WyOfrbAn/43XZwvg
         DRUgbYcSEXRlJWM7/cQiIh6d4/a2IQdwhOMBSi//5JKIPKQpuuTKf8ZAcXr/nvftPYPj
         OdKpHerRNb5SMMggJfG2ZVdyU8MUDdeZws0SbOF7JdZSnBEkJrLTMkbym1Y1uRtsSSgX
         nQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=h/A4tEl2mtBha7cHiuEYdkY3q6oP12EZ6C0/Om+AD10=;
        b=TcEKYzwJGweOwaPeqrZQQnbxLotLlEerU0z7ZTKSvYkS/Zl608VNpC/xa1QZHlBLnl
         IcR1/M8N0740wF/1OYfQJN6SxA1+/ymIkOTU66Z4IQPEHOCr9W0ZzNhxDaNsNtLnmoRX
         JewZ0w8TX/6EwKa33hGpLa1YtQlLMS9G7KlzDu4vW3xOXyvmumIMxs8CNIn9n7hXA7nm
         qvgRegJrBIllNeiFs4lQrECpPpyupq2obJhwGQedLcJszN9gCyJFsFWjcOKleqSiAshP
         PYEfVVHR+mjGbdjTXVW+t6Dys9gSPN/1cTHK49/UIWSUtHbwc/Z1/P1BILnCSKJ4P0LU
         ZjbA==
X-Gm-Message-State: APjAAAVHuOu2pxhjpi5qKJWz2SYJ2Hb96dK0BjJ2NwCp9HFp2kITayRG
        srfGDQuQPo7qdXogWYqLwtIAbA==
X-Google-Smtp-Source: APXvYqwBlDfCbZo7ZTpdIz2bIqflSAvvdtH0vqRV0LSfiC8SoRw/HCmTSvtjef6ryWsNF3JJv6vNYw==
X-Received: by 2002:ac8:24b8:: with SMTP id s53mr4592196qts.276.1562363394280;
        Fri, 05 Jul 2019 14:49:54 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t29sm4699697qtt.42.2019.07.05.14.49.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 14:49:54 -0700 (PDT)
Date:   Fri, 5 Jul 2019 14:49:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com
Subject: Re: [PATCH net-next 0/2] net: mvpp2: Add classification based on
 the ETHER flow
Message-ID: <20190705144949.1799b20a@cakuba.netronome.com>
In-Reply-To: <20190705120913.25013-1-maxime.chevallier@bootlin.com>
References: <20190705120913.25013-1-maxime.chevallier@bootlin.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 14:09:11 +0200, Maxime Chevallier wrote:
> Hello everyone,
> 
> This series adds support for classification of the ETHER flow in the
> mvpp2 driver.
> 
> The first patch allows detecting when a user specifies a flow_type that
> isn't supported by the driver, while the second adds support for this
> flow_type by adding the mapping between the ETHER_FLOW enum value and
> the relevant classifier flow entries.

LGTM
