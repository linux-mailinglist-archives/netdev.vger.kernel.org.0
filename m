Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38874B1C36
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 03:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347316AbiBKC3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 21:29:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347305AbiBKC3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 21:29:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B241167;
        Thu, 10 Feb 2022 18:29:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ADC7B82801;
        Fri, 11 Feb 2022 02:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A81C004E1;
        Fri, 11 Feb 2022 02:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644546570;
        bh=rA9JKNn6uy31FYJqU2BP9EbIsSatKcMCv+ra8A1VBNk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OVTnK/5oKNn7O4FFOCXz9Ne/67iNWZshSRCvLcInVbH9SQAxOdLu2jnm6hiZbdQcp
         SZEFVkeLF1QrqHGA/QCT0NwfJ7SrI4b0FR31b00ViFIhhNhYt1dtzZH48XdxAVV5hT
         HrEnmERQr5v8GqU5skcWqSRyl4mGM6uIfhhRgwcRGKogtU7fKVjn1gJnfgn4vhwBpT
         qQrlU1IwpHuafPO3jNE24uDUyPmGxq5nvNZUgXtAnJUUT1YXYT/qn+wsfP2GBZTMjn
         EqqXfY8XeF0YimkwPprojmEdx/yV7SGS/uDElC83nohOf2LC8LFv+eYpMlgPro/VQ/
         1GhXD42uRmsjA==
Date:   Thu, 10 Feb 2022 18:29:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     <davem@davemloft.net>, <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: Re: [PATCH 1/4] octeon_ep: Add driver framework and device
 initiazliation.
Message-ID: <20220210182928.0579d527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210213306.3599-2-vburru@marvell.com>
References: <20220210213306.3599-1-vburru@marvell.com>
        <20220210213306.3599-2-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 13:33:03 -0800 Veerasenareddy Burru wrote:
>  20 files changed, 4249 insertions(+)

Please break this down into smaller logically separate changes.

The driver must build cleanly with W=1 C=1 and with clang.
