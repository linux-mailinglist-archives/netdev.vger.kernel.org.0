Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E933A68A805
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 04:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjBDDsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 22:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjBDDsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 22:48:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5276174A69
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 19:48:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F99BB82AD6
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 03:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748BCC433D2;
        Sat,  4 Feb 2023 03:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675482514;
        bh=GcpXHAER4B1DZGNOAFOBXsSPpintxnJPDQwVZezObfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iCKdjVsv/wt3LLTICFbEYtEZkUbuiPs09CzG9yLNuTHwXtqD0OhIkSISwjLijsiDk
         CWOxBaJ2jfh3UPh/tHirHAf7PfvgaHea9meppJKrTNfEqnaYFry8eotBmGAsRdQUt6
         tjf91GXchtc8cIA7XbghChi/AqqitrpKDX+/AJmF2JmrCuiEGRUcQ6hidMNWcLBeys
         OHRleznDpZCkbFxqtSDQj+fpusIke5L+7E3VwJ1m8B5m4x/WxhyyrmjhfzpZyfBkyT
         SCB37tl56tYwgnp9j/SWVGFF1fVXcY6o0uTlRzW9lgu3J0sCiCy67cwXIwzm3fMocn
         UnhhFP8SPBjag==
Date:   Fri, 3 Feb 2023 19:48:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jeroen de Borst <jeroendb@google.com>
Subject: Re: [PATCH net-next v2] gve: Fix gve interrupt names
Message-ID: <20230203194833.60ca697b@kernel.org>
In-Reply-To: <20230203212045.1298677-1-pkaligineedi@google.com>
References: <20230203212045.1298677-1-pkaligineedi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Feb 2023 13:20:45 -0800 Praveen Kaligineedi wrote:
> IRQs are currently requested before the netdevice is registered
> and a proper name is assigned to the device. Changing interrupt
> name to avoid using the format string in the name.
> 
> Interrupt name before change: eth%d-ntfy-block.<blk_id>
> Interrupt name after change: gve-ntfy-blk<blk_id>@pci:<pci_name>
> 
> Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
> Reviewed-by: Jeroen de Borst <jeroendb@google.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
