Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6774759F07F
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 03:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiHXBE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 21:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiHXBE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 21:04:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990FD62FD
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 18:04:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 339B161751
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 01:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F503C433D7;
        Wed, 24 Aug 2022 01:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661303095;
        bh=87h4MW5QsaJOdqWBKSwlLDePnh/xJKk2EAa+q7bx8vo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aGHVuOTDDwJqQRfTAPMuQ+uZR/jXBBFO81BL5OBbTI3dL8AsQJD/y1MY2VLAKmSxc
         1RLMrhpKj3Du4Vs1OgCiBbkburwLBinkt9S+vLwPVnrcla6qHLat7aasdEfWT1LHjB
         iq1CiimhbG0PTjMaVl8yBbflF7kzJ8htxzGYhSdzGzH+zQrIhS67nFDKepZTEX27G9
         7fwdhiTqAbkHX7qQ8OISzwBPPpVzJsfFnKZX1DHdFNRgVcaU7fR9LJnbNi4QSh5Qnc
         XT3GrV7+yVErh/zXwOF9QwBgtI38T8MmJXJMr8nrS5EKrXIQnvamCXUQwSep3ZwnSi
         tnMezg5pSDTdQ==
Date:   Tue, 23 Aug 2022 18:04:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next] docs: fix the table in
 admin-guide/sysctl/net.rst
Message-ID: <20220823180454.463f8a8b@kernel.org>
In-Reply-To: <20220824104144.466e50b1@canb.auug.org.au>
References: <20220823230906.663137-1-kuba@kernel.org>
        <20220824104144.466e50b1@canb.auug.org.au>
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

On Wed, 24 Aug 2022 10:41:43 +1000 Stephen Rothwell wrote:
> On Tue, 23 Aug 2022 16:09:06 -0700 Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > The table marking length needs to be adjusted after removal
> > and reshuffling.
> > 
> > Fixes: 1202cdd66531 ("Remove DECnet support from kernel")
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > --
> > CC: Stephen Hemminger <stephen@networkplumber.org>
> 
> How about this instead so that everything lines up nicely:

Thanks for reviewing, seems like I misunderstood the warning
and fixed it accidentally :o

Should I trim the first 'Content' column to the min required length as
well? Commit 1202cdd66531 (which is in -next only) reshuffled the
entire table anyway so we won't be preserving any history by not
trimming.

> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> index 82879a9d5683..871031462e83 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -31,18 +31,18 @@ see only some of them, depending on your kernel's configuration.
>  
>  Table : Subdirectories in /proc/sys/net
>  
> - ========= =================== = ========== ==================
> - Directory Content               Directory  Content
> - ========= =================== = ========== ==================
> + ========= =================== = ========= ===================
> + Directory Content               Directory Content
> + ========= =================== = ========= ===================
>   802       E802 protocol         mptcp     Multipath TCP
>   appletalk Appletalk protocol    netfilter Network Filter
> - ax25      AX25                  netrom     NET/ROM
> + ax25      AX25                  netrom    NET/ROM
>   bridge    Bridging              rose      X.25 PLP layer
>   core      General parameter     tipc      TIPC
>   ethernet  Ethernet protocol     unix      Unix domain sockets
>   ipv4      IP version 4          x25       X.25 protocol
>   ipv6      IP version 6
> - ========= =================== = ========== ==================
> + ========= =================== = ========= ===================
>  
>  1. /proc/sys/net/core - Network core options
>  ============================================
> 

