Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991595267F9
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382787AbiEMRNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382785AbiEMRNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:13:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70033A1BA
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 10:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86751B82E1E
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 17:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10620C34100;
        Fri, 13 May 2022 17:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652462014;
        bh=rKkyaLtuydpNqobWkDljovm5Kx35LUOT4XZ3soRqVxQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qd9XUCSFwnOK4M4omnkorhHIvOKYBhw3kgpniIkXxIj5APCTXBtAwG+p3gRVtMBbA
         DpjNCaxb02W5883POMeghQPFS+99s/BotAdnfer2GXtrVH02W/e/SpkMzyqUeirlD6
         J4proiClDaNNdX0BLy38CTM22EBfFXK4GzsmX5xLbqG227cEOg3YPNbQ5ALLWejTX4
         fGERPV31lI4jz6CQVsbRa4Xk+Ky1F0ruqi6MoVP+v7YwimbgPtmIsJRH6/RMHZNPhi
         o2InYjmJWG4/qBOt5Fuh189FIiBWPaRr0wYVQFVL+ZWrrsz+isNwtRHmJnhwlg5J6c
         Rnlws81cx8wFw==
Date:   Fri, 13 May 2022 10:13:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saranya_PL <plsaranya@gmail.com>
Cc:     netdev@vger.kernel.org, Saranya_Panjarathina@dell.com,
        g_balaji1@dell.com
Subject: Re: [PATCH net-next] net: PIM register decapsulation and
 Forwarding.
Message-ID: <20220513101325.53ae1cb2@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220512070138.19170-1-plsaranya@gmail.com>
References: <20220512070138.19170-1-plsaranya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 00:01:38 -0700 Saranya_PL wrote:
> PIM register packet is decapsulated but not forwarded in RP
> 
> __pim_rcv decapsulates the PIM register packet and reinjects for forwarding
> after replacing the skb->dev to reg_dev (vif with VIFF_Register)
> 
> Ideally the incoming device should be same as skb->dev where the
> original PIM register packet is received. mcache would not have
> reg_vif as IIF. Decapsulated packet forwarding is failing
> because of IIF mismatch. In RP for this S,G RPF interface would be
> skb->dev vif only, so that would be IIF for the cache entry.
> 
> Signed-off-by: Saranya_PL <plsaranya@gmail.com>

You need to use your real, full name for the sign-off, and please make
sure you CC maintainers (scripts/get_maintainer.pl is your friend).
