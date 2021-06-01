Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6AD396C6A
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 06:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhFAEin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 00:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232846AbhFAEim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 00:38:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C276261027;
        Tue,  1 Jun 2021 04:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622522222;
        bh=kPtEIgbfm56WXOuMDC2FLhxTo/MrMRaAqSfdqfTqOL0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PtEkwUUHxWqWB1cAVYnYx2HDK+FcJqqgYQ6J/3Q31NNefKK1QJn7fJWCUmK0iGQiL
         I5iD2m+J6K+eimL8Yjv3m1ayGwxkyr3lgtSnFdYFT/Gz1/sjOZjq4p+fPgGneGrD2/
         pmHSBTxWCrcPf+K0E1OmPaSsj73lAtRCg7jfJ8V/jPiY7mSfI/BWCdrzvHkKWzjejG
         jR9g/Pk8bGRuNBaQ3Qaw29zBJF0lxjYsVVBnjnFkOvFOY7ffBGYQ0IfLJwgt9/Dl9K
         IclVyJmroYHyiyI8hKHZWp5qQ5cJlgSs1x5B+hbn67ub24QpsmB66ZhtJPk+LFjdDM
         rUNLjNWs8Vhig==
Date:   Mon, 31 May 2021 21:37:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 04/11] nfc: mrvl: correct minor coding style
 violations
Message-ID: <20210531213700.24d9148c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210531073522.6720-4-krzysztof.kozlowski@canonical.com>
References: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
        <20210531073522.6720-4-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 09:35:15 +0200 Krzysztof Kozlowski wrote:
> -void	nfcmrvl_fw_dnld_recv_frame(struct nfcmrvl_private *priv,
> +void nfcmrvl_fw_dnld_recv_frame(struct nfcmrvl_private *priv,
>  				   struct sk_buff *skb)

Realigned the continuation line and applied, thanks!
