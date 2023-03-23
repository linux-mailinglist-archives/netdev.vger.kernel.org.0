Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0827F6C5E29
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 05:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCWEqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 00:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjCWEqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 00:46:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD57825E35;
        Wed, 22 Mar 2023 21:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58C5FB81EBA;
        Thu, 23 Mar 2023 04:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BE7C433D2;
        Thu, 23 Mar 2023 04:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679546776;
        bh=uqLzZeyutGc96xEzpzr4MwbPwi9QcMQR4Q8HcV02TXs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JeD3hsAT0JWq0EY2+v/XLBbIsoDrRigW60AZfRloPESjJtjbs/eCbEx6+FCbpb/sf
         B1PWl0ZUv17hDrX0j+VqQZi3uiN2B1yhH7SaK1JJ4ueG7qDELhK8czgnTZSzVPt3Ml
         XYvg81m2lqPNJdynVE2YKzjXM1zLrDufEExUpVE31bhz904nJBNwJO25mNJ9x0wmJN
         dGFmmgYu1sl+TYK0Z3CWOANB6p+Mdds17Er3uRfXvRnPA+22Dc+mF3uG+Qhu9Ju14U
         QPcXYzxFnPnS7MkFwv2QpVh7Cpl3En6vqaXEq7zXje8U9kAiepDl3h1aDEjo0leGcR
         ALVRzubT8zhmg==
Date:   Wed, 22 Mar 2023 21:46:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: bluetooth 2023-03-22
Message-ID: <20230322214614.0e70a4a0@kernel.org>
In-Reply-To: <20230322232543.3079578-1-luiz.dentz@gmail.com>
References: <20230322232543.3079578-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 16:25:43 -0700 Luiz Augusto von Dentz wrote:
> The following changes since commit bb765a743377d46d8da8e7f7e5128022504741b9:
> 
>   mlxsw: spectrum_fid: Fix incorrect local port type (2023-03-22 15:50:32 +0100)

Did you rebase? Do you still have the old head?
Because this fixes tag is now incorrect:

Fixes: ee9b749cb9ad ("Bluetooth: btintel: Iterate only bluetooth device ACPI entries")
Has these problem(s):
	- Target SHA1 does not exist
