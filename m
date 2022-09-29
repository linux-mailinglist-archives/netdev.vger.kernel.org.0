Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38AE5EF795
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiI2Ocd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbiI2Oca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:32:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B49B1BBEDB;
        Thu, 29 Sep 2022 07:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD3CEB824C5;
        Thu, 29 Sep 2022 14:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064E8C433D6;
        Thu, 29 Sep 2022 14:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664461946;
        bh=cxn2DgfDQ233Xhnr134IizVkoqPegCX3GcPZTQwl73M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A49moiKyp5qBTbeiDDARfJukzoJob4+2VY/LsBQTQ3fBlKv+rOiRNZG6DC81Yrt3n
         JCUvd1hwm44xQRjOYXnYDwvvQ2hMkb4kT0vMFanDHSL9HpyXTm9JyigSJSxhpYMpxR
         2MaCy9x1jmwv0JFVIRMu3HtaoQIeN9+LbbNSrna/vvvabgn+K/nVFVUSmIzYaPcLWs
         rWSWqOBZfRbQNgzbYrUsEYXo+X2M4byQzpgkLTCW9tYWqQXBAeXWivxLk5k52nJHvq
         0bGSA0D+1S3xSBl2E5AAMCfOpkjjqhllJyvn4/I5iR+/H+NFUJONsjdn2eSUabUcFy
         BjxRriRLDqa8A==
Date:   Thu, 29 Sep 2022 07:32:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 1/6] docs: add more netlink docs (incl. spec
 docs)
Message-ID: <20220929073224.2f3869ca@kernel.org>
In-Reply-To: <20220929133413.GA6761@localhost.localdomain>
References: <20220929011122.1139374-1-kuba@kernel.org>
        <20220929011122.1139374-2-kuba@kernel.org>
        <20220929133413.GA6761@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 15:34:13 +0200 Guillaume Nault wrote:
> > +Make sure to pass the request info to genl_notify() to allow ``NLM_F_ECHO``
> > +to take effect.  
> 
> Do you mean that netlink commands should properly handle NLM_F_ECHO,
> although they should also design their API so that users don't need it?

Yes, ECHO should be supported but as an extra, not something that
is crucial to write a basic script without assuming full ownership 
of the system...

IOW support the logging use case you mentioned but don't do the NEWLINK
thing.

Should I clarify or rephrase? The ECHO section needs to be read with
the one above it to get the full answer.
