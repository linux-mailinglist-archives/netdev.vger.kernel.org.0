Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5510E50C4FA
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiDVXV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiDVXVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:21:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43CB1BA7BE;
        Fri, 22 Apr 2022 15:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46C69B832E2;
        Fri, 22 Apr 2022 22:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF74C385A0;
        Fri, 22 Apr 2022 22:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650668246;
        bh=eHLSXrt72i6TaH/+If0ihwqLZQ/LBVXgDxHiWMQEzuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iXFl9zY2I5UHRGR7OaF1h6qlAK5mPZxdv+O0/pAngV8myikt1Swc/85KxvGyNVcfO
         c+CJWtfaiXl8iS4eDwm1tYLL7mlGL2OJEbQRIyx9Oxnmwt2nYscDdw9pUFUKju5Rc3
         8Smqu72LB7YDpmuwjcwdikHO/+HwAQLvXA/jK7PevxaApA0vXIIT+xAvp6YNrYwW6z
         q1/aUsGP3jl+P0ELlTWntjHg6xRI0iccI6aJTjuD8V03kr63SrpkSJD23r6yezDvk8
         TT4cjRbKMoXPFsOx4c8XKhYFXss7sxjKe8fuaZ2qJtOjsu9QfpIkpihlggl0InOGdM
         4UfcD6bK0Sc2g==
Date:   Fri, 22 Apr 2022 15:57:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     akpm@linux-foundation.org, x86@kernel.org,
        linux-alpha@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: unexport csum_and_copy_{from,to}_user
Message-ID: <20220422155725.5347ca6f@kernel.org>
In-Reply-To: <20220421070440.1282704-1-hch@lst.de>
References: <20220421070440.1282704-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Apr 2022 09:04:40 +0200 Christoph Hellwig wrote:
> csum_and_copy_from_user and csum_and_copy_to_user are exported by
> a few architectures, but not actually used in modular code.  Drop
> the exports.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Judging by the To: I presume the intention is for Andrew to take this
one, so FWIW:

Acked-by: Jakub Kicinski <kuba@kernel.org>
