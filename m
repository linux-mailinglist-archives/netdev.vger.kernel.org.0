Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB1D3FA213
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 02:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhH1ARF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 20:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhH1ARE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 20:17:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE6B60E8B;
        Sat, 28 Aug 2021 00:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630109774;
        bh=ZivaSMoXKo0ylOmfyd9EPClyYJ05Y4UMr8ry4ONkTAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QfE47VBF/ZCq8eIZWAEyzKy6cIikPY1j0hFYIsgMs8kifjw9CEg2d/glVWwm1psJR
         h3l0AbMWZsUEfp7/z0AXCdaybq0ILjlyCsMJDRmoPjcra0dKaAKaEDEm6qbH6st2d6
         aeCqQNl8+LdRO1IMdSCEknp/zzWdrImrSPUFv0p5WwybNIeDgKPrOIq1n9jSmbsrBS
         qYmZmKLQBgVkDhxT0xvzW7H+j0ReZ2b6D25bHYVeER9vcrrepiULYGCWVvswSBDIDf
         WgVoeX6cGifr7Cp89/+w9h9PYW/5puDxE9mfP1ytB6mjleUSwZgPdNXiZTIn3dwue9
         yZLbYp7GjU10g==
Date:   Fri, 27 Aug 2021 17:16:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: Re: [PATCH net-next v4 0/2] bnxt: add rx discards stats for oom and
 netpool
Message-ID: <20210827171613.48cae8b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLinT15_9wZuzv2pH66PXr34y5HSdx9DBsXY6nA6Cqdoz+Q@mail.gmail.com>
References: <20210827152745.68812-1-kuba@kernel.org>
        <CACKFLinT15_9wZuzv2pH66PXr34y5HSdx9DBsXY6nA6Cqdoz+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 11:23:47 -0700 Michael Chan wrote:
> On Fri, Aug 27, 2021 at 8:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > Drivers should avoid silently dropping frames. This set adds two
> > stats for previously unaccounted events to bnxt - packets dropped
> > due to allocation failures and packets dropped during emergency
> > ring polling.
> >
> > v4: drop patch 1, not needed after simplifications  
> 
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thank you for the reviews, applied!
