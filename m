Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B0536B823
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhDZRhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234794AbhDZRhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 13:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33F5961007;
        Mon, 26 Apr 2021 17:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619458597;
        bh=DMDiyQiUq9S2ovcdjlL5DjP7XYZvKJ+1P1fA9IVwDmg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oBTlkgyj8iH7V798emC4Kbb+CLJlcFV1BNQyw/PTsVEB9ZlZNqxQTNdESJMQkP/kW
         V7I+0rzXBJdB+Rb7IVQbxxfhwY1YoJHssjONPnSripFlKx5/zS3pSNRasUn8Cd6pkU
         LRsWuAB6latHRlrf3jdXX5Zy9fhHzRKPN9LnZXIYrYvDx3tz342VYGF5w/WUE7tz1o
         hW5Uu8eTyr30324Tx8I+LJAqpUNS+7bteQ8EogfG3+KLReDWklSJ0+g3UYywy1/ZfV
         Iw9f1hIbhk+m6SNKtPSr0I1+8bOXMxoWhC3ZxHyJqgQ3Unwq6hvd54TLvoWPeJh13V
         /Ce78rW70h6XA==
Date:   Mon, 26 Apr 2021 10:36:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>
Subject: Re: [PATCH net-next v2 10/10] bnxt_en: Implement
 .ndo_features_check().
Message-ID: <20210426103635.2ccd9d77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLikyML+t3p_qhn-MGG4jbZppvp2pVBk-95B+0maVSKB1Qw@mail.gmail.com>
References: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
        <1619372727-19187-11-git-send-email-michael.chan@broadcom.com>
        <20210426092935.728fda80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLinRRcoaxsiHZyYcywgRtOs0E5hJdQ0gjHPAj3991gMzHw@mail.gmail.com>
        <CACKFLimdhTTD-vmfjkFDME_uHUBZTEMbUgA0WvSzjhPMjOPn_w@mail.gmail.com>
        <20210426100019.53a82b13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLikyML+t3p_qhn-MGG4jbZppvp2pVBk-95B+0maVSKB1Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Apr 2021 10:09:29 -0700 Michael Chan wrote:
> On Mon, Apr 26, 2021 at 10:00 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 26 Apr 2021 09:45:17 -0700 Michael Chan wrote:  
> > > Sorry, hit send too early.  If it is not UDP, it could be GRE or IP
> > > over IP for example, right?  Why do we need to turn off offload?  
> >
> > All supported protocols can be included in the allow list.
> > That's one of the costs of NETIF_F_IP_CSUM, the driver needs
> > to make sure the device can understand the packet.  
> 
> Only UDP encapsulations have the 2 port limitations.  The rest are supported.

AFAIU you claim that other than certain UDP formats your device can
parse _every_ possible packet encapsulation. To which I have no reply.
