Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1317768A201
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 19:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbjBCS1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 13:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbjBCS1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 13:27:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174468C1CD;
        Fri,  3 Feb 2023 10:27:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B018361FA7;
        Fri,  3 Feb 2023 18:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962ACC433D2;
        Fri,  3 Feb 2023 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675448826;
        bh=/gGZ9DwGLZg6jeLZ/Wca9dGvDkPShPONk1yE/DS5X2U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ibou1Av0ziWyc38GTlFFW39X3zPS+WgBGY9WIaLThXolJ3efOkr1EZJyJrLrfw1xT
         tPsjJ/HXBfiaQcE1GBWhcrL8Rl1gsTqdryBHtoKSWn4o/Ol4cTUff2ZSDvxDx37Q4z
         ZvpU1Bp1cXCImIzgi1toeJwkkesVNjWXqL4x9qHsDlAQFwI05qkVMLiTIpLW2zXEzN
         8tLSKve7+4BAMp3k+ovNYkyjt/5/ZBXsIcV6zS+u2yYXoCvmhVeR2+vYS4nL2Yc5Fv
         rkrNOFcSc1NWGPXwfQLQ2FDwTw/eESW8T4AM5WzPYH3ePz61OZdqYDnz8DqCcHB6vS
         9JJBRxDMSQS+w==
Date:   Fri, 3 Feb 2023 10:27:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dawei Li <set_pte_at@outlook.com>
Cc:     mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        linuxppc-dev@lists.ozlabs.org, linux-ide@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] powerpc: macio: Make remove callback of macio driver
 void returned
Message-ID: <20230203102704.66f6b59a@kernel.org>
In-Reply-To: <TYCP286MB232391520CB471E7C8D6EA84CAD19@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB232391520CB471E7C8D6EA84CAD19@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Feb 2023 22:36:19 +0800 Dawei Li wrote:
> Commit fc7a6209d571 ("bus: Make remove callback return void") forces
> bus_type::remove be void-returned, it doesn't make much sense for any
> bus based driver implementing remove callbalk to return non-void to
> its caller.
> 
> This change is for macio bus based drivers.
> 
> Signed-off-by: Dawei Li <set_pte_at@outlook.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
