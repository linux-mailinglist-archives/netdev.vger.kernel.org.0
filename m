Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864504E7E27
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiCZAbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 20:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiCZAbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 20:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2F3130C10;
        Fri, 25 Mar 2022 17:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0C56B82A72;
        Sat, 26 Mar 2022 00:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB47C2BBE4;
        Sat, 26 Mar 2022 00:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648254574;
        bh=poGETAG+DQJ31NcrGPl7LcOyeM6AhqeGMqyfZs2gRLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=epZOOWmcpDs0p9MOFj+cVMezAqejQAfLPEtWKpR0plyEvjeKH0kv7EHTIcKWwbTvy
         bEMygfnBxIVJHkoaDhzo5Z+z1YFFa5hJVjcxerb3/f943HfDUAjbiw/65dvZrNPU7G
         J5CMm9lDDJX8hF/wv9b7tQRQu+v0I/Yi0yytsJN862Gyg3501bbUo44a5YDP/ytRt+
         EiSTq3kd7aaOxShfvfP5BuTWfXdZVAdyibXX07AoUvFfwhMKWpVz2PtNDSvP6+TbE8
         1WaUkG41bs8RLlU2g3uSlVW4LTs/+y2LH3uLfLUfuXinUttHQ00rL+2DfDiVQt0Sv7
         QD/fNp7kzVDng==
Date:   Fri, 25 Mar 2022 19:38:43 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] iwlwifi: fw: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220326003843.GA2602091@embeddedor>
References: <20220216195015.GA904148@embeddedor>
 <202202161235.2FB20E6A5@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202202161235.2FB20E6A5@keescook>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 12:35:14PM -0800, Kees Cook wrote:
> On Wed, Feb 16, 2022 at 01:50:15PM -0600, Gustavo A. R. Silva wrote:
> > There is a regular need in the kernel to provide a way to declare
> > having a dynamically sized set of trailing elements in a structure.
> > Kernel code should always use “flexible array members”[1] for these
> > cases. The older style of one-element or zero-length arrays should
> > no longer be used[2].
> > 
> > [1] https://en.wikipedia.org/wiki/Flexible_array_member
> > [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> > 
> > Link: https://github.com/KSPP/linux/issues/78
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>

Hi all,

Friendly ping: can someone take this, please?

...I can take this in my -next tree in the meantime.

Thanks
--
Gustavo
