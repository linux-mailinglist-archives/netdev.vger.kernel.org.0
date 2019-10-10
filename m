Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82299D1DA4
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 02:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732576AbfJJArq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 20:47:46 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:38170 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbfJJArp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 20:47:45 -0400
Received: by mail-qt1-f171.google.com with SMTP id j31so6222678qta.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 17:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wznvNInoHUq22/k5oPKxzLjeNaOYhNRdHr6CveCpDS0=;
        b=exYK3wL5Jua4g24AdeS0Mshqu7W1yDuftBfjrVUUUIZvybydsfWSQR5MecOl9Xmyaa
         oCtTHV1TLsN5bbVcwch4gTHEMmpmKilaAy3I5gqn4W5E5Hd2OTcoOZEmg9X0EQK8UnKo
         Wb9PPxA96QUI7madN8hN0j5wpaDzJgHiZueTCNejrjzd9reWvVOwOQ8xgvYgEeiUZrQu
         iE3LP3Sv80DxXnZmx8gxmJacqXJqb/GZZCHhF1p3pDr/B9E0BkFe+nQqRZ916N8A/EK4
         ruuMvwIFzZas0uXGBDi1elqB/V/mEF1rGM0UVjdzUma0Ge9oY/JKken63RAz4qXnRaCR
         OlFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wznvNInoHUq22/k5oPKxzLjeNaOYhNRdHr6CveCpDS0=;
        b=CXBQJM0s2JdFN4KM7NS31COBkzkJktEGiULnMzMLb8NwHrzNnVWJ7C4nk4j48REgxe
         WPczJMuAoKoHn8Q895PJLxGpBoGMKnevdaFuMHBIB6Dxun5bClFp5ltKvhyhxMnUqY2b
         wYO5NNBrn1jH77lQ2YXWUUR9I4wQVEV7DKtwsoJ+E5vCfrxzUbB89COOWWuoUcCea+H8
         jaWvf1N2Kazj8w7pFNXYK83DrFfka0ukZOYhAuX97SnWii9OtPmy6PtR/MWvhFXspnfp
         Fb78eg4lBVk9LqXS6UbkoMhQap/s9JCZLw8XFzZSx6VlIM6tSHk7Mla2fZJUFBpXDKtE
         FLkA==
X-Gm-Message-State: APjAAAWadGUm5Hcb/WVk5QgWkQqbE4P34+QVCFXUcOAGsFnoHXav1r7L
        NGZAzQitqK3g1MVaMwgX5hla7oN7IZQ=
X-Google-Smtp-Source: APXvYqwCFFnQWbRZwEqYVuzO+BaazIpnlaYASXnMfkzATTs+wa19BCCM7RcP4F5+n+FAZHFU/r92Fw==
X-Received: by 2002:a05:6214:4d:: with SMTP id c13mr6678669qvr.116.1570668464673;
        Wed, 09 Oct 2019 17:47:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y22sm1923224qka.59.2019.10.09.17.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 17:47:44 -0700 (PDT)
Date:   Wed, 9 Oct 2019 17:47:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH -net] phylink: fix kernel-doc warnings
Message-ID: <20191009174730.0c9b9ca0@cakuba.netronome.com>
In-Reply-To: <9e756330-80b0-e613-c9df-85b58af064c9@infradead.org>
References: <9e756330-80b0-e613-c9df-85b58af064c9@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 08:39:04 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix kernel-doc warnings in phylink.c:
> 
> ../drivers/net/phy/phylink.c:595: warning: Function parameter or member 'config' not described in 'phylink_create'
> ../drivers/net/phy/phylink.c:595: warning: Excess function parameter 'ndev' description in 'phylink_create'
> 
> Fixes: 8796c8923d9c ("phylink: add documentation for kernel APIs")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>

Applied to net, thank you.
