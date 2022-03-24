Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4FA4E63AC
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 13:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343914AbiCXMyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 08:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiCXMyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 08:54:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23FEA997D;
        Thu, 24 Mar 2022 05:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61D64B82258;
        Thu, 24 Mar 2022 12:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1B3C340EC;
        Thu, 24 Mar 2022 12:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648126362;
        bh=ezgh3PFwzeMXQGQ2paFac2ugZ11or020vphgaLht7IA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6EdRmWdu3JxG+fMDs+6mIJ9uHOQ1hQWuYLtYoYkqbWZ4TdKvSXEguabUckbTVGMo
         LSnKjH6B3CZvx9hOjZboOCF8fRNVi4s1z9VHFi3YTBJ5ycKODgupH3xw/BF4x9YYTT
         HnkVNH1j7GFSmzjeVapl5COh6cAsDFuefHeRvZYw=
Date:   Thu, 24 Mar 2022 13:52:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: apply commit net: ipv6: fix skb_over_panic in __ip6_append_data
 to stable
Message-ID: <Yjxpl5GCHT3mA9XP@kroah.com>
References: <4a96a044-5743-5a33-9812-bda4c12f0a25@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a96a044-5743-5a33-9812-bda4c12f0a25@linaro.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 07:45:42AM -0700, Tadeusz Struk wrote:
> Hi,
> Please apply commit
> 5e34af4142ff ("net: ipv6: fix skb_over_panic in __ip6_append_data")
> to stable: 5.15, 5.10, 5.4, 4.19, 4.14, 4.9.
> It applies to all versions.

Now queued up, thanks.

greg k-h
