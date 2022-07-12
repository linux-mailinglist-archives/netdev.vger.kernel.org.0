Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21995716F3
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiGLKO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiGLKOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:14:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8241D2B259;
        Tue, 12 Jul 2022 03:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17634617E0;
        Tue, 12 Jul 2022 10:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD079C3411C;
        Tue, 12 Jul 2022 10:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657620860;
        bh=1Hk1K7MIGQQ/NBBXYMYfhRGqqYMTuBwZrjD/ggEX+lQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UB6gGI542whMEVgjsO8vJ7TUzstubiDd+if3KpmcMFjILhp2KnNjkk7VU1oj62dw7
         39FPAovqvSCrlQoAVNZRxDXsIJQyj01qLkrQN0ostsymUkgs6J6yy7he4//QoFNVrs
         /exXB157g3jO6M+b2tBzzyC/lj7L5iXvzTCa/Kmc=
Date:   Tue, 12 Jul 2022 12:14:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] selftests/net: test nexthop without gw
Message-ID: <Ys1JefI+co1IFda4@kroah.com>
References: <9fb5e3df069db50396799a250c4db761b1505dd3.camel@redhat.com>
 <20220712095545.10947-1-nicolas.dichtel@6wind.com>
 <20220712095545.10947-2-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712095545.10947-2-nicolas.dichtel@6wind.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 11:55:45AM +0200, Nicolas Dichtel wrote:
> This test implement the scenario described in the previous patch.

"previous patch" does not work well when things are committed to the
kernel tree.  Please be descriptive.

thanks,

greg k-h
