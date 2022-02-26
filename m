Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975274C541A
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 07:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiBZGMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 01:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiBZGMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 01:12:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA1512B756;
        Fri, 25 Feb 2022 22:11:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBB6360B72;
        Sat, 26 Feb 2022 06:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4881AC340E9;
        Sat, 26 Feb 2022 06:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645855887;
        bh=arWZMptuuPhYsu/A/SMhY2H9PbdvLtktOw5hrYbzwvU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PBG7+hH1GZBZf2dNYmbeL1VgZ0wFiUEzLXux5yw6hR4iH/B2ABnGZMkggLa3Pqcob
         NkvD1dPOLuiqNZ5b2BWX683xjy+mjHw6FeRNmUH3YFArCkmFwd3AQNFdvhhenUJs7t
         z7ijeacR8fnzG6LJCP4ZRMh6C12BZHzp3DsPKWFzr0pn/nzeaZ3NxMKBzT9aZDx4ms
         eWKaG2alUiKPH5Tr70jyRjDbGz0+EiG0tvERFh3tYkCIiYBX6O5ehyu9uqN5iJci+F
         +ZfjiSFkMesdIGppdiwEPSFoVD0cLSo+lQI4EhPh2e6x7HAqxvpm+CI33ouriugLQp
         sq6QB7LpmRrtg==
Date:   Fri, 25 Feb 2022 22:11:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@collabora.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] kselftest: add generated objects to .gitignore
Message-ID: <20220225221124.4757c156@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220225102726.3231228-1-usama.anjum@collabora.com>
References: <20220225102726.3231228-1-usama.anjum@collabora.com>
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

On Fri, 25 Feb 2022 15:27:25 +0500 Muhammad Usama Anjum wrote:
> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index 21a411b04890..c3a6dc45eff4 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -36,3 +36,4 @@ gro
>  ioam6_parser
>  toeplitz
>  cmsg_sender
> +cmsg_so_mark

You probably have stale objects in your tree, cmsg_so_mark was renamed 
to cmsg_sender. This is incorrect.
