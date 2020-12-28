Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471B12E6C63
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgL1Wzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729429AbgL1Ui0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 15:38:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41794222B3;
        Mon, 28 Dec 2020 20:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609187865;
        bh=jKsuQqJ9tD8ix6GIefAnDlAfbWqdefgsaGPxPfxb7JA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KmgS6pTUFXJgv3bPAxBSOf/ocpXNDqomPoD21MQX7n4RKxTEZzqT+43Iif/jNE5cj
         dEUPa26psd04wwyrR9ynaVkcXpp0jL3itOaUNyffgpcpRGtBx6VAg6XtVwPJu8jFNH
         8bUK//+r/GLj92Ok8AIzqBo3fyS3Q3T+MemfHwYuD/qQk5ELaKzLs2tGjjaFs5BdEq
         H9ZRuuzaNNgkNGaYrIK9sGAxizIzSlRwuSagL2lijxXVTXALpX/Ka4xauVjX3JDaCv
         Kga1rxs05/qJudhxIHoT6RcyYEvyVFKg+2X6wJ4XIcIcfFxFcSCDje3WxZ6UEBaIGc
         10ulu1Chb7jcQ==
Date:   Mon, 28 Dec 2020 12:37:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com
Subject: Re: [PATCH v3 0/5] dwmac-meson8b: picosecond precision RX delay
 support
Message-ID: <20201228123744.551d1364@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
References: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Dec 2020 00:29:00 +0100 Martin Blumenstingl wrote:
> Hello,
> 
> with the help of Jianxin Pan (many thanks!) the meaning of the "new"
> PRG_ETH1[19:16] register bits on Amlogic Meson G12A, G12B and SM1 SoCs
> are finally known. These SoCs allow fine-tuning the RGMII RX delay in
> 200ps steps (contrary to what I have thought in the past [0] these are
> not some "calibration" values).

Could you repost in a few days? Net-next is still closed:

http://vger.kernel.org/~davem/net-next.html
