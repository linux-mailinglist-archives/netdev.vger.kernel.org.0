Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9054F0113
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 13:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbiDBLar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 07:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiDBLap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 07:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E494F49FA9
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 04:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7501D61337
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 11:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4EAC340F3;
        Sat,  2 Apr 2022 11:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648898932;
        bh=ktWyNkXC39WtG/W+I40eNOjoEG+4dZ6D1lalcy8cRJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EvbvbffQJucew/yra885bGXUZ1P/rd/cXeJQ+xQea2AT1X0tvMTrImpUbgwSA7e1f
         tSbNm6H3RrcDJ7zjEnfvPT5a4fDm28dHNSYBqBWlgyErWsvNmrZtXFxf1GQnLGWi4Y
         8f5k5oKoUqwIe0jD+ZglVM31euHsLydIzK9xm0fA=
Date:   Sat, 2 Apr 2022 13:28:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     Xin Long <lucien.xin@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCHv5 net-next 1/2] udp: call udp_encap_enable for v6 sockets
 when enabling encap
Message-ID: <YkgzbTKdmAekAq6p@kroah.com>
References: <cover.1612342376.git.lucien.xin@gmail.com>
 <fc62f5e225f83d128ea5222cc752cb1c38c92304.1612342376.git.lucien.xin@gmail.com>
 <3842df54-8323-e6e7-9a06-de1e78e099ae@openvpn.net>
 <YkMKAGujYMNOJMU6@kroah.com>
 <e5553cba-c29d-0a22-c362-0ce1e1ef4b41@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5553cba-c29d-0a22-c362-0ce1e1ef4b41@openvpn.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 03:06:41PM +0200, Antonio Quartulli wrote:
> Hi,
> 
> On 29/03/2022 15:30, Greg Kroah-Hartman wrote:
> > > I would like to propose to take this patch in stable releases.
> > > Greg, is this an option?
> > > 
> > > Commit in the linux kernel is:
> > > a4a600dd301ccde6ea239804ec1f19364a39d643
> > 
> > 
> > What stable tree(s) should this apply to, and where have you tested it?
> 
> Sorry for the delay, Greg, but I wanted to run some extra tests on the
> various longterm kernel releases.
> 
> This bug exists since "ever", therefore ideally it could/should be applied
> to all stable trees.
> 
> However, this patch applies as-is only to v5.10 and v5.4 (you need to ignore
> the hunk for 'drivers/net/bareudp.c' on the latter).
> 
> Older trees require a different code change.
> 
> My tests on v5.10 and v5.4 show that the patch works as expected.
> 
> Therefore, could it be backported to these 2 trees?
> It can get my
> 
> Tested-by: Antonio Quartulli <antonio@openvpn.net>

Now queued up, thanks.

greg k-h
