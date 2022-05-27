Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB41535ABA
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346469AbiE0Hyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiE0Hyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:54:46 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35B35C662;
        Fri, 27 May 2022 00:54:41 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3E48022175;
        Fri, 27 May 2022 09:54:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1653638079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33lYILGRuiVfPkwlkuuikbqZRKTsKIKcjBlbAFtRFVU=;
        b=wDBO5b1/Ittfa7JBluPhZvCUSn/ul50Jkfy+qQbrWP8xe7FT2CJjOViLR9aIubkVZo8k7a
        zstNGzk3l8qtgPEM9EKc7E4HTdUtIwg4JlPqDAIK9BK04v5v+vqdUaR2RmRlL/G1Y/tB09
        nfm/rb0Z90EKe6RbdODDr0ISGrHYkbE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 27 May 2022 09:54:37 +0200
From:   Michael Walle <michael@walle.cc>
To:     kuba@kernel.org
Cc:     horatiu.vultur@microchip.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] net: lan966x: check devm_of_phy_get() for
 -EDEFER_PROBE
In-Reply-To: <165362691349.5864.17166538440351301920.git-patchwork-notify@kernel.org>
References: <20220525231239.1307298-1-michael@walle.cc>
 <165362691349.5864.17166538440351301920.git-patchwork-notify@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <9448805c13354f053ece2919dff44adf@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This patch was applied to bpf/bpf.git (master)

bpf tree?

-michael
