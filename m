Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356D15710B1
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiGLDQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 23:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGLDQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:16:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DC22DA94
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 20:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D633E616C5
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1085C34115;
        Tue, 12 Jul 2022 03:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657595760;
        bh=MOA0XUXEC0xTIoipP5O0fKxLeR3KLX2IomJD1Rksbw4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TwbMQ332bYoCBVch+znPVVm6uJVQFhlEVcoIqVzYGlnxupQ9Vg58r4sZcEoVfLyuG
         jdEG8l0iOmbGcaEv9riUvjgUQIa+0VwNW+BOKN725PDCXL0Lxy9m3lhPapLk9/9NBL
         Oyoy4Pttw1fWhsuRsgFkBWf9+U3KlMT0DOiTXaFyW8JmnRLPqq75SrGGuow1u7jDw2
         pheysfQzM7l0vpZYzDqwlg/pDFeF/s8K+J+vMLSTHDQFsHrVjTukysiZfRbxnIbt+r
         vFGtdTBG0hy9jEXwWNXxiGjjMCYCgL0M3wniHI00Rn863t2ztqqbpDEnNK+yikDIzw
         0bWuDsngHPf0w==
Date:   Mon, 11 Jul 2022 20:15:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>
Subject: Re: [PATCH net-next] nfp: support TX VLAN ctag insert in NFDK
Message-ID: <20220711201558.559d7c06@kernel.org>
In-Reply-To: <20220711093048.1911698-1-simon.horman@corigine.com>
References: <20220711093048.1911698-1-simon.horman@corigine.com>
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

On Mon, 11 Jul 2022 11:30:48 +0200 Simon Horman wrote:
> From: Diana Wang <na.wang@corigine.com>
> 
> Add support for TX VLAN ctag insert
> which may be configured via ethtool.
> e.g.
>      # ethtool -K $DEV tx-vlan-offload on
> 
> The NIC supplies VLAN insert information as packet metadata.
> The fields of this VLAN metadata including vlan_proto and vlan tag.
> 
> Configuration control bit NFP_NET_CFG_CTRL_TXVLAN_V2 is to
> signal availability of ctag-insert features of the firmware.
> 
> NFDK is used to communicate via PCIE to NFP-3800 based NICs
> while NFD3 is used for other NICs supported by the NFP driver.
> This features is currently implemented only for NFD3 and
> this patch adds support for it with NFDK.
> 
> Signed-off-by: Diana Wang <na.wang@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Interesting exercise.....

Acked-by: Jakub Kicinski <kuba@kernel.org>
