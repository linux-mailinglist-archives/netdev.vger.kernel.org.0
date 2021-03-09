Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464D5331BB1
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 01:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhCIAeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 19:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCIAdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 19:33:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59D576527A;
        Tue,  9 Mar 2021 00:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615250025;
        bh=1zIZ36SUoA3WcvIfkwns7M5pVMeogu0E9xYGKWlnvx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dYeW7/38Iez7QGnuvaL5QcZ28f5m7s7Pdj4X26eeej27xN3NDszi0HDe1UajzJS9H
         l4LUDUQuuVbbC4FoW7i6NRJ+795RlA3u1oeuxVM8klhKOCjZ4U61dryeIk3tTgaN4F
         AS7gfzYUPGc/eUcuudufYbouyYclzCMKL0bccJv+WAqUu8kStBGaPf+a691CygLiD9
         8epWx/ZscM3DbNmrdSYrt9/tIqc2M//aBj3dvvvAiNhY8W+h0QsryHC1isHowqZer9
         dvy1Kecvlro7Ip39yVA3+8VOLtVlsGn2HH/6Gw41Pk3NBwP+Ks1KPJTM6ErfV23Qba
         u61AqJe8rqfJA==
Date:   Mon, 8 Mar 2021 16:33:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org,
        gregkh@linuxfoundation.org, linux-arm-msm@vger.kernel.org,
        aleksander@aleksander.es, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH v2] bus: mhi: Add Qcom WWAN control driver
Message-ID: <20210308163344.3b69fae4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615237167-19969-1-git-send-email-loic.poulain@linaro.org>
References: <1615237167-19969-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Mar 2021 21:59:27 +0100 Loic Poulain wrote:
> ---
>  v2: update copyright (2021)

Please look again at my reply to your v1.
