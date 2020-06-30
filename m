Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9313120EA3F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgF3Aa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbgF3Aa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:30:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4C7D206A5;
        Tue, 30 Jun 2020 00:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593477057;
        bh=0VFsdedWaOiWrlAEUt12l7plLbrsdzDI9N+vVr8+deA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lgj2kNNg2hG+xYO+tGZCWSRALZ9f45dn1DALLpRKtTSG67g/laq6ZVWn8nlyWIKnl
         Mg8z3Q1TGK+/3LCrD5MrLv7YPJp/6+1/t4CO5BrbN//qm64DPVg6mnnfrqMofLX0DN
         IfSB/RLLu0s6R/eNwzDwb5om/VCBAbxGby7F74Vw=
Date:   Mon, 29 Jun 2020 17:30:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 00/15] sfc: prerequisites for EF100 driver,
 part 1
Message-ID: <20200629173055.5b110949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 14:30:32 +0100 Edward Cree wrote:
> This continues the work started by Alex Maftei <amaftei@solarflare.com>
>  in the series "sfc: code refactoring", "sfc: more code refactoring",
>  "sfc: even more code refactoring" and "sfc: refactor mcdi filtering
>  code", to prepare for a new driver which will share much of the code
>  to support the new EF100 family of Solarflare/Xilinx NICs.
> After this series, there will be approximately two more of these
>  'prerequisites' series, followed by the sfc_ef100 driver itself.

I didn't spot anything questionable, so:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
