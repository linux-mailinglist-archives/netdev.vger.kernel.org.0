Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F594F630D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbiDFPNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiDFPMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:12:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66632F2F11;
        Wed,  6 Apr 2022 05:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDA446197F;
        Wed,  6 Apr 2022 12:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDDEC385A1;
        Wed,  6 Apr 2022 12:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649247179;
        bh=mfrOiVe2qGW+hUl/uXzHxRp8NkA4EpqMfhE7c7eK3YI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=mELaXt7+9b7epNwxgbsOZOjkDitpTd+r7vKUYipRZunk2LBc9XiDdAXSZA3movMgE
         a5YttnxG2+csIgAMTPKURxDcqmeITmVJGm5OPp3GNlKqazURpWqXlSvdTjNkp5Kzjt
         VaoukWDmbMR7VWrnxCdhj8Gv7Ncoylk9eGkzVWoGrVMW7EVk2BAfsg+9uRpHxDrFFT
         2yec9TNg1PydFJqZ5wskSGFrEUbMhE4flNrIhlj2ixZJzBM0UJCO4dVxr0r18Axzlf
         WSlogn2wOqxLuDM57lkk8cG2PV/dsAFsjXm8E4RXwj6jJeeudSPy/XosKpyJT9YM7L
         AUgWCSBpUoUrw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/2] rtl8xxxu: feed antenna information for cfg80211
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220325035735.4745-2-chris.chiu@canonical.com>
References: <20220325035735.4745-2-chris.chiu@canonical.com>
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924717526.19026.6597243014301524042.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 12:12:57 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chris.chiu@canonical.com> wrote:

> Fill up the available TX/RX antenna so the iw commands can show
> correct antenna information for different chips.
> 
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>

2 patches applied to wireless-next.git, thanks.

21338c5bdeb9 rtl8xxxu: feed antenna information for cfg80211
bd917b3d28c9 rtl8xxxu: fill up txrate info for gen1 chips

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220325035735.4745-2-chris.chiu@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

