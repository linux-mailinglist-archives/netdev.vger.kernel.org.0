Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905B8546749
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348404AbiFJNYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 09:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345689AbiFJNY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 09:24:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF4622B0F;
        Fri, 10 Jun 2022 06:24:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 844E661800;
        Fri, 10 Jun 2022 13:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E800C34114;
        Fri, 10 Jun 2022 13:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654867465;
        bh=O83tO7k3nkK8oTTJYTAFm6kt66zZTPX3D38kOBTnakk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HUrn66yt6vDbUUFqYxw4PCmRYevdmaw2uTD0fdn0UrOmmdsfWfcWLWFt4ytnPPsmY
         8+EKwdgYwqoWICm9KCZ9T8+m39aiBnNhnVmRANFVNjFL/7SLkdUO3KcwlkG0aDnim2
         +HjXfUU4raL2RCNZlEVL4PoWLzeywzBuh9lOM9Qc=
Date:   Fri, 10 Jun 2022 15:24:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        briannorris@chromium.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, johannes@sipsolutions.net,
        rafael@kernel.org
Subject: Re: [PATCH v6 0/2] Remove useless param of devcoredump functions and
 fix bugs
Message-ID: <YqNGB5VitXvBWzzp@kroah.com>
References: <cover.1654569290.git.duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1654569290.git.duoming@zju.edu.cn>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 11:26:24AM +0800, Duoming Zhou wrote:
> The first patch removes the extra gfp_t param of dev_coredumpv()
> and dev_coredumpm().
> 
> The second patch fix sleep in atomic context bugs of mwifiex
> caused by dev_coredumpv().
> 
> Duoming Zhou (2):
>   devcoredump: remove the useless gfp_t parameter in dev_coredumpv and
>     dev_coredumpm
>   mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv

Did you forget to cc: everyone on patch 2?

thanks,

greg k-h
