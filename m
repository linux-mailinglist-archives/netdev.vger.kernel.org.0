Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D041D6D17CA
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjCaGv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjCaGvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E68171E;
        Thu, 30 Mar 2023 23:51:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F1F66227B;
        Fri, 31 Mar 2023 06:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FFAC433D2;
        Fri, 31 Mar 2023 06:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680245483;
        bh=BKN1E6mxUpzd76ipq7ScVipYTsmqvTHBrAfGzhRaKs4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oo5ms+XZ3sEq/7agX/q21Mfw0T1OqzLGhxzs0QBG4lK1P41QNLjsFYlQ6/KQV8Os3
         1xHey3sw3qxcG8JVj459OSExWw9xRmMN/3+ClLKa4xyDdUZVjoCgs8ZXrlc2loq4H0
         3MsS+PUugY/oZCNZdI4v+PqrY3HZZnF6TWadguippCDNjZLfWQBnjEPNitd5BcFQS+
         7AVxchskbkOcmtaDb3yqV4QoGnS3Raxal6ZUrEj5gqsGuWoRE89ExaMEKVYGUEM9ca
         xkHDe1imKlRoSwo2h4XVq2LfBTpQs27O03UPqPrbXdcTvM32d4vwzb3h2Tk+hWl7Om
         a6zj7Z+vuMRGQ==
Date:   Thu, 30 Mar 2023 23:51:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: wwan: t7xx: do not compile with -Werror
Message-ID: <20230330235122.250571d0@kernel.org>
In-Reply-To: <b26331de-da68-afd2-b895-14dd219902e3@kernel.org>
References: <20230330232717.1f8bf5ea@kernel.org>
        <20230331063515.947-1-jirislaby@kernel.org>
        <b26331de-da68-afd2-b895-14dd219902e3@kernel.org>
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

On Fri, 31 Mar 2023 08:36:06 +0200 Jiri Slaby wrote:
> It should have been [PATCH v2] in the subject. Do you want me to resend?

It's fine confusing seems unlikely, thanks for respining!
