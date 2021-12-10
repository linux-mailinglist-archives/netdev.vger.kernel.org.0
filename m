Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E9D47036B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 16:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbhLJPFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhLJPFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 10:05:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047ADC061746;
        Fri, 10 Dec 2021 07:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC428B82874;
        Fri, 10 Dec 2021 15:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255DAC00446;
        Fri, 10 Dec 2021 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639148495;
        bh=HaSDOMZa7OpKNgjF0pJquOCb6/AT3yapHchpQryfnH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nJea+h8Ylkf/0vnQ1RbndpD86Qd3m07YctI8KAC2OebpJ9bTMqLdniYOv8F27MZZc
         hFniIc8gLD5vGLojA17LIyGtCzSwQNda1XhAtB10fQ7llzkrwoZ/1Qx8uL5vDgIJ0w
         PNdZfFZ7mZOFmrywJJEMjKV0wMNKpS3FTFGDZSSYG0oEN9eWC45cHH7wdhJNFiEETp
         6ArU0FJAkvElUkAM4en16GB4S3bF9NtyIiuaWAVoUezLsUfE5bl5Mz7WtnuwKnjnZw
         5xth/yFue4hM7AGcURr7aiSp7gX5cKcrWEdEn7p84o3MSTNtdBhcmI8EEQNIHQ/jLL
         FbJGfn3vocxwg==
Date:   Fri, 10 Dec 2021 07:01:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     JosephCHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3, 2/2] net: Add dm9051 driver
Message-ID: <20211210070134.08977685@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210084021.13993-3-josright123@gmail.com>
References: <20211210084021.13993-1-josright123@gmail.com>
        <20211210084021.13993-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 16:40:21 +0800 JosephCHANG wrote:
> Add davicom dm9051 spi ethernet driver. The driver work for the
> device with its spi master.
> 
> Test ok with raspberry pi 2 and pi 4, the spi configure used in
> my raspberry pi 4 is spi0.1, spi speed 31200000, and INT by pin 26.

Please rebase on top of net-next, this does not build because
netdev->dev_addr is constant now.
