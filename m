Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3714D0BAE
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 00:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbiCGXI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 18:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiCGXIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 18:08:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D448DE65;
        Mon,  7 Mar 2022 15:07:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 327CFB8173D;
        Mon,  7 Mar 2022 23:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF22C340E9;
        Mon,  7 Mar 2022 23:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646694445;
        bh=Fa9/hR5GpkZWTKIcWmw21gpKT3rPGyOC+oDkhNJLxkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HkQGJysvAlPT5rInm544njmDrm65VrbXaKnTAz91RRHlE5SYVmGzJm5xQ+KBXVDJ7
         lVFYaTuRb4sEmM+ZedbOIVVAB5ENBInb+Mx7lPEw7GByVhUrc/xsbY2s/e/Qkn+JwW
         qqWJNo9gxY2/8+3BuJIF8fiSs+Pi6RB6YNnamYDjrORPR54rcNklooJNKh+2uYJwjN
         d+E75TYYIsYp5rBJquYL5Hljzce1XB43H8ez3t0GQdZBkB/LE2p6I4IosQ0KjzQYQh
         8jFhpByv0bigKdvrfMSpVD9DKqMCS2P42zrofVz5dGgJvUnjbvkKQ57TrWbpB2tz/C
         SU79hKeOgh5/w==
Date:   Mon, 7 Mar 2022 15:07:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     <davem@davemloft.net>, <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] Add octeon_ep driver
Message-ID: <20220307150724.5bd97429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220307092646.17156-1-vburru@marvell.com>
References: <20220307092646.17156-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Mar 2022 01:26:39 -0800 Veerasenareddy Burru wrote:
> V2 -> V3:
>     Fix warnings and errors reported by kernel test robot:
>     Reported-by: kernel test robot <lkp@intel.com>

Try building each patch with W=1 C=1, there's more to fix.
