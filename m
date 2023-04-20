Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635A56E8783
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjDTBhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDTBhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:37:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B277B1BF0;
        Wed, 19 Apr 2023 18:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C50B63E9C;
        Thu, 20 Apr 2023 01:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79534C433D2;
        Thu, 20 Apr 2023 01:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681954659;
        bh=7cH2zRhR59zp/D07mZkxwHxPzmQt9+7nFDK8wxJ1aXw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gwh4FrmAlJwXvRGhCLM0YSWgf/eu/ROm+eZq297nwgqhuL+7X3bCgQiAo/3U/4amx
         IP0O864wuu7HU3namoB8DWPYwWXHcYcJAHFOhufZuzWPMNcDWpXDzcC7MVmlU5D1mn
         JWLIj7CDwnKK9LI0LO0ykejw959ulhF2kZWcx9qQSRtCwhaFYiRn20J57gAdYBW/hM
         OQ+7nXFqVimBsjUrCffbF8+l1csfiTyH7Ot4OT0z9G2KIxuT5XObLDrBelCbZp7zpn
         dG78dx5BIe0wQgoQIsxZiOjZszm8uCQo2aVg+dN3xRY/5RPW906Ldhh5t6SAHvxLb9
         Q+0TY8K1zpg1w==
Date:   Wed, 19 Apr 2023 18:37:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever <cel@kernel.org>
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Recognize control messages in server-side TCP
 socket code
Message-ID: <20230419183738.776928ec@kernel.org>
In-Reply-To: <168173882205.9129.1071917922340260936.stgit@91.116.238.104.host.secureserver.net>
References: <168173882205.9129.1071917922340260936.stgit@91.116.238.104.host.secureserver.net>
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

On Mon, 17 Apr 2023 09:42:14 -0400 Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> To support kTLS, the server-side TCP socket code needs to watch for
> CMSGs, just like on the client side.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
