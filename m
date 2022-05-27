Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA761536908
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 00:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355067AbiE0WxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 18:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355065AbiE0WxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 18:53:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359B7126992;
        Fri, 27 May 2022 15:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59909B8262E;
        Fri, 27 May 2022 22:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92C7C385A9;
        Fri, 27 May 2022 22:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653691979;
        bh=IZBk2jtd4mb88nM4/dL/VsEJauYKpYF2FahdjtiMDns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qhQTAbYzTrgRlF7Im+hcCeSRuobzc9gEgA2VsCcmv2xctk9g28rocaX4NYNr89Pb2
         XtmG4NRUlnfL7omUd0Klkk0qmeuQ6fjhpqVFufHV6C8yLNEiyNRcgzv3Vr4V1umm/G
         yvHn3mejZJEEr/cANdGpzwrxtd8nEnRyhI+WuvDHPwFugUZa7CXobIEQRZn+Rq/xQy
         gZkB90lvA/E53mfkNpocUpX2wwbHr9Q0jTjHMvmWv2OaRqqsxVG2oTW6iGuJdz/wBM
         kwmRXX4KVOavjbvb034HFdPGvYQh8ZzYh2VuTrQRj4QDcvguItFIe1JsktGdfBbCSm
         xPGkawEC/gPiA==
Date:   Fri, 27 May 2022 15:52:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     horatiu.vultur@microchip.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] net: lan966x: check devm_of_phy_get() for
 -EDEFER_PROBE
Message-ID: <20220527155257.3c4f2e02@kernel.org>
In-Reply-To: <9448805c13354f053ece2919dff44adf@walle.cc>
References: <20220525231239.1307298-1-michael@walle.cc>
        <165362691349.5864.17166538440351301920.git-patchwork-notify@kernel.org>
        <9448805c13354f053ece2919dff44adf@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 May 2022 09:54:37 +0200 Michael Walle wrote:
> > This patch was applied to bpf/bpf.git (master)  
> 
> bpf tree?

Nah, treat pw-bot like a toddler who occasionally says the darndest
things. BPF and netdev share a patchwork instance. The BPF maintainers
probably forwarded their tree around the same time I pushed this patch
to net and the bot noticed it in their tree first.
