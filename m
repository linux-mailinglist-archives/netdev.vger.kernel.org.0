Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937866D9CEB
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 18:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbjDFQAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 12:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbjDFQAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 12:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DD5AF3F;
        Thu,  6 Apr 2023 09:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA6AF648E8;
        Thu,  6 Apr 2023 16:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFED1C433D2;
        Thu,  6 Apr 2023 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680796819;
        bh=ELdjobZUwN0S5iaF8cGFZlGAlFMZltDdUslPPwoMRqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RI+sEZ+T7zfkRdxytqpk96uESK7eouKgArnPeVGmDbSoHakLqZytXiFeRgu5IWVBG
         7w5sE0XfNBW2tnBEUjLGJrVZjd6M1OiPVXV9xocnb8OsJjar9+PjlHh0tANjre8n/A
         u70ByU3DRny44T3fAhjA2Vn6zPI+0kkRJ451ocmoZup1lrmf4Td1Yfp8qgyVP77lYd
         /QcDqPJYWvfFNN4Co0jhhZ5u6BcnyDI8pH+fP9uQFE3j40uXwqFGhP5sTUi6DITUWp
         nKdJS8pRjt2c/eIopdzno7ANzxFKNCJRBZFI9qrFJPMLvyxLsPzS+pJHmeBZBylW6S
         6IAZY1UgQmUWw==
Date:   Thu, 6 Apr 2023 09:00:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <horms@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH net-next 2/3] ksz884x: remove unused #defines
Message-ID: <20230406090017.0fc0ae34@kernel.org>
In-Reply-To: <454a61709e442f717fbde4b0ebb8b4c3fdfb515e.camel@redhat.com>
References: <20230405-ksz884x-unused-code-v1-0-a3349811d5ef@kernel.org>
        <20230405-ksz884x-unused-code-v1-2-a3349811d5ef@kernel.org>
        <454a61709e442f717fbde4b0ebb8b4c3fdfb515e.camel@redhat.com>
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

On Thu, 06 Apr 2023 15:37:36 +0200 Paolo Abeni wrote:
> On Wed, 2023-04-05 at 10:39 +0200, Simon Horman wrote:
> > Remove unused #defines from ksz884x driver.
> > 
> > These #defines may have some value in documenting the hardware.
> > But that information may be accessed via scm history.  
> 
> I personally have a slight preference for keeping these definitions in
> the sources (for doc purposes), but it's not a big deal. 
> 
> Any 3rd opinion more then welcome!

I had the same reaction, FWIW.

Cleaning up unused "code" macros, pure software stuff makes perfect
sense. But I feel a bit ambivalent about removing definitions of HW
registers and bits.
