Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01D15A5854
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 02:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiH3AQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 20:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH3AQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 20:16:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9747C1E3
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 17:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C816B815C8
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9535CC433D7;
        Tue, 30 Aug 2022 00:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661818601;
        bh=vVjr4LyMaIWY5GoZgHsSD8uu34YJVucOAk4ANZOXDT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZpQ8rwqfivXeLxnZXwYkcSuqlelTxMy/qEhObb3M3BP2O8ew+1OiXXVrcB8ddCIdO
         YWMrKEYZLCxZxIl+0mkwvSoNe0G3EehnSCzuMVbTzVN8IrUIAn++pt5bXVZP6p8kku
         N2lXefdRWpx4dgUFhyt0tEOxBMA3nlJvc0yKBRuuYFRerqhnWCVawBQhmC+zdEBPHq
         gjl8Uv8D/tMumKey4QP8+swnqQg0KrceH2AbvGctSfsjd/3LZ+LbgFp8LTlyq0PzpZ
         pTJtPa7SY4l1O4kDF6y2RlM9E6ZaMRoM7dVBgUEZiiM+Nk1HjrW4NT25/Ig2lF5KCT
         cqSUo2Kdhi8vg==
Date:   Mon, 29 Aug 2022 17:16:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     netdev@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: Re: [PATCH 4/4 v2] sunhme: switch to devres
Message-ID: <20220829171642.1244ba98@kernel.org>
In-Reply-To: <5854720.lOV4Wx5bFT@eto.sf-tec.de>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
        <11922663.O9o76ZdvQC@eto.sf-tec.de>
        <5854720.lOV4Wx5bFT@eto.sf-tec.de>
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

On Mon, 29 Aug 2022 15:22:06 +0200 Rolf Eike Beer wrote:
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

Please add a commit message with a justification, and realign
continuation lines.

Are you using this HW?

> v2:
>  -return -EBUSY in case the PCI region can't be requested

This looks like a fix which needs to be sent separately first and then
you can do the re-factoring on top.
