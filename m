Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A9E570660
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiGKO7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiGKO7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD00248E9;
        Mon, 11 Jul 2022 07:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9CC9B80EB5;
        Mon, 11 Jul 2022 14:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E421DC34115;
        Mon, 11 Jul 2022 14:58:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Wbovc2+Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657551537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=raYE22deiWZyC2ij3n9yOytE9CpcUo4M8OAMvQofY4Y=;
        b=Wbovc2+QaFo0ndsELtP5W0Fjg/y5od3b6T9EXkkZ9MNJ3GnzyMkTeNjaj9DHCiTsHEJjyw
        mbh2NuldpCv3AUp8C33DuVjCEBsPi2aPVoLeNrmomvSxLrQpP4ZICxuLa5jwOlJ3D+tIsM
        0yEnVE4oMLtoeLXM0c6hsoUWlCv+pcQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0bbd100b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 11 Jul 2022 14:58:57 +0000 (UTC)
Date:   Mon, 11 Jul 2022 16:58:53 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: move lib/sha1.c into lib/crypto/
Message-ID: <Ysw6rRDaBvr2oDx5@zx2c4.com>
References: <20220709211849.210850-1-ebiggers@kernel.org>
 <20220709211849.210850-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220709211849.210850-2-ebiggers@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 09, 2022 at 02:18:48PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> SHA-1 is a crypto algorithm (or at least was intended to be -- it's not
> considered secure anymore), so move it out of the top-level library
> directory and into lib/crypto/.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks for this.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
