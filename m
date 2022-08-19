Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564D659A9A4
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243193AbiHSXrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239441AbiHSXre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:47:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8994108B08;
        Fri, 19 Aug 2022 16:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46182618A0;
        Fri, 19 Aug 2022 23:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB59C433D6;
        Fri, 19 Aug 2022 23:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660952852;
        bh=rCl9QRXUMnLYXsHu+XO+YFhDCqGLDwvSnqJMQyLlcdc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k8ECeJijpj4hhTnwj9B7LW2Nh7vncc/ALfI88Bxd71nm6w9KDRIy79hHqd6dgJbGr
         VCd2LwO/mKmu6sbP4664rOcwEoe/RnbmwRMzCHQz9KOjoa36uaziJDNnWFEXTkcPqP
         9WcJulA1B8Rr7N1hKp/gDQ0a1H5wmSL9HZhJAlePElTsscdtsipvwnpq4TE8b9HQ1b
         6x/rfi6ZtvLiJK1tJ4WmRNy/eforzQKHeAl2+D/KnZG7tSDny2kAwdArNS2wQl3v7E
         G4pdRarY8SykR9I5xqUOEQ9VEIZ3a2XZikYkC8ZWE7nYD5dFdiqXFhnBnHg7Fttp/0
         F4y2KlX1kiGug==
Date:   Fri, 19 Aug 2022 16:47:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Gao <gaoxin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, tj@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core: Variable type completion
Message-ID: <20220819164731.22c8a3d2@kernel.org>
In-Reply-To: <20220817013529.10535-1-gaoxin@cdjrlc.com>
References: <20220817013529.10535-1-gaoxin@cdjrlc.com>
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

On Wed, 17 Aug 2022 09:35:29 +0800 Xin Gao wrote:
> 'unsigned int' is better than 'unsigned'.

Please resend with the following subject:

[PATCH net-next] net: cgroup: complete unsigned type name
