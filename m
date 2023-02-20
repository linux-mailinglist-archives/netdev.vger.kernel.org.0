Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC30869D71D
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 00:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjBTXdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 18:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjBTXc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 18:32:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECED974A;
        Mon, 20 Feb 2023 15:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 847A1B80E11;
        Mon, 20 Feb 2023 23:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BC0C433EF;
        Mon, 20 Feb 2023 23:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676935976;
        bh=GIPPVcB5VTYG52Qdb/wdYlg07yDLOtfdY2YyWMk1J+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=USFI+Hboak76sxlrry2vlxsTwopBLyP+AJFriQaBxL0Z/ST5JC5A0refvuUsu9jpV
         r8EsCOJzbO+OLwNu8iCcY/48Bm1X6yOAMTTL0aNWREzjaZiR0XfuQWUDo++UcWaUVN
         NE5jOIqd36KILB9dN0GOEj4ugUCuKApYDilTVnrE+nf9qBbpq+VPH6FzlGKS5nZ3W+
         4zjWD/Da22hFDTKJJilz3w4QVhR3hO/e907FrCVEkXg33BjsVZqNAx4LFK6Ega4YFN
         uIiZAK/1Iaf6Wn4u0gRC4x3PrFX4hNPQU8EQk4f63LASjNX0MzTWsSPle28o9m0mOZ
         5++W8JQmhJ8qg==
Date:   Mon, 20 Feb 2023 15:32:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2023-02-17
Message-ID: <20230220153254.66166403@kernel.org>
In-Reply-To: <20230217171430.0691DC433D2@smtp.kernel.org>
References: <20230217171430.0691DC433D2@smtp.kernel.org>
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

On Fri, 17 Feb 2023 17:14:29 +0000 (UTC) Kalle Valo wrote:
> wireless-next patches for v6.3
> 
> Third set of patches for v6.3. This time only a set of small fixes
> submitted during the last day or two.

Appears to have been pulled, thanks a lot!
