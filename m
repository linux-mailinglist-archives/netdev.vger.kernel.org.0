Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469CD4AA890
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 13:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378784AbiBEMOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 07:14:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232479AbiBEMOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 07:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644063293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TyNPl/BS5Ojb0LAkSOubv8BDmPxJEZ5jeJYKCHOdoM8=;
        b=hTpWRmtV4hQW9Jmp5FfDHV2or29+AGtHpvMqsjVZHr3JTrsQKUK751BRY43vBVvbeK3Jt0
        yE8cvVClukohjLZ70s1KZJeXn8lQpw5HP8LZE28RB+KcvoH/qCw0AqHW7bUJagJX0c6gNM
        HXv5Pamm2mt1bva2z1fD0ncWBQ1qdt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-l4PPduCpMxGeq-HNVnP4pw-1; Sat, 05 Feb 2022 07:14:49 -0500
X-MC-Unique: l4PPduCpMxGeq-HNVnP4pw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4BCE189DF50;
        Sat,  5 Feb 2022 12:14:48 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-15.ams2.redhat.com [10.36.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 766EC28570;
        Sat,  5 Feb 2022 12:14:48 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 11698A8076B; Sat,  5 Feb 2022 13:14:47 +0100 (CET)
Date:   Sat, 5 Feb 2022 13:14:47 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH 2/2 net-next v6] igb: refactor XDP
 registration
Message-ID: <Yf5qN/AAv2gQLWyf@calimero.vinschen.de>
Mail-Followup-To: intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20220119145259.1790015-1-vinschen@redhat.com>
 <20220119145259.1790015-3-vinschen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220119145259.1790015-3-vinschen@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 19 15:52, Corinna Vinschen wrote:
> On changing the RX ring parameters igb uses a hack to avoid a warning
> when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
> clears the struct xdp_rxq_info content.
> 
> Instead, change this to unregister if we're already registered.  Align
> code to the igc code.
> 
> Fixes: 9cbc948b5a20c ("igb: add XDP support")
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
>  drivers/net/ethernet/intel/igb/igb_main.c    | 19 +++++++++++++------
>  2 files changed, 13 insertions(+), 10 deletions(-)

Any chance this could be set to "Tested" to go forward here?


Thanks,
Corinna

