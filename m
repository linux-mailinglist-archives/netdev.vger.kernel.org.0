Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75E23DDDCD
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhHBQge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229945AbhHBQgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0F0661050;
        Mon,  2 Aug 2021 16:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627922184;
        bh=DhRIS4HKgw1I1UtpzKtxb/aWMU+HoQs0bsEmrC4Ta6I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N99yUTt8hwt07/BF2NkqggkvMvVB27gl4R+9qO7/g77FB7jJKae07evA6ZVv466F5
         oBqsEVoOSIcHTw8C3EvoBjB0F2JDIGLQD2tueJvxmV1Mjw8lRvMeQ9FTHa7Dar2Tw4
         KMd/K/p83BWXiRSbELCHu5KJizb544ozCYgBq+EBZ1O97vixvKDpnTDi63PyqeMqso
         B3dJwbq4JH1mmYtPmLH7WuyITZsgeUIaBVD3ouStnebyQ/iOTDPCDZ+id43P+hJnje
         7PiCnGaPlxHwPT9IdyvSk4QEanIsKkq+ruG/xWHDpfz2cNTMzhNAiuS56Hz5+nb/ZO
         6Z1wzjlainRuw==
Date:   Mon, 2 Aug 2021 09:36:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalesh A P <kalesh-anakkur.purayil@broadcom.com>
Cc:     davem@davemloft.net, jiri@nvidia.com, netdev@vger.kernel.org,
        edwin.peer@broadcom.com, michael.chan@broadcom.com,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 0/2] devlink enhancements
Message-ID: <20210802093622.17c29268@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210802042740.10355-1-kalesh-anakkur.purayil@broadcom.com>
References: <20210802042740.10355-1-kalesh-anakkur.purayil@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Aug 2021 09:57:38 +0530 Kalesh A P wrote:
> From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> 
> This patchset adds device capability reporting to devlink info API.
> It may be useful if we expose the device capabilities to the user
> through devlink info API.

Did you see the RFC Jake posted? That's way more palatable.

Operationally the API provided here is of little to no value 
to the user, and since it extends the "let the vendors dump custom
meaningless strings" paradigm present in devlink please expect 
major push back.
