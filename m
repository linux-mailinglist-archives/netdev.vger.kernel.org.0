Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B162CCBEE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgLCB7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgLCB7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 20:59:15 -0500
Date:   Wed, 2 Dec 2020 17:58:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606960684;
        bh=XQZoLAN3s38jpF9PN2JGqByStnM6cmr+jF9FRNUrCSk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=B2JTJOWCE1oMPtqNr80UDQyQz5dvdwPUHxBVmPmuTd9uT6jEfMexuV3a1nobTV/V3
         NcjTVepD3ptzjp4HzPVVgmSCcrPWW8uVGzquuEz+URccE+om2kaIJTnrFV9eoxzeq5
         H8OeHvEVy5DeLo9vogAd2LWeKu5BbOl4GzVl0YbxsqwYY5jzPqyCNX5g3RM+gB22fX
         jxl9x5EkrJ1LONsHOdImnGx+p1nqenpusQTVMyr/VBKEcv9zFmsRhPGXoEUYfdh7SV
         CwvaIgsRxGnrj97/GJru/0EhZN1+rTex74aQhHFbGp4MUOaKTecOqNBFzYb67eAPMd
         Nrfc9clTbqPnQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     krzk@kernel.org, linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v5 net-next 0/4] nfc: s3fwrn5: Support a UART interface
Message-ID: <20201202175802.1dd9fb1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 20:47:37 +0900 Bongsu Jeon wrote:
> S3FWRN82 is the Samsung's NFC chip that supports the UART communication.
> Before adding the UART driver module, I did refactoring the s3fwrn5_i2c module 
> to reuse the common blocks.

Applied, thanks!
