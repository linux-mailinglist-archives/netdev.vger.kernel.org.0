Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C3D58D37A
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 08:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbiHIGAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 02:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiHIGAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 02:00:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC49110A;
        Mon,  8 Aug 2022 23:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C338611CC;
        Tue,  9 Aug 2022 06:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E3BC433D6;
        Tue,  9 Aug 2022 06:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660024829;
        bh=ifiUPYbblJzn2/JbG65kiuriPNytr8++13jKGGc5K7M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=E5nUuuVBonoYap4YAIzOJOoZc/UVjqNI1mSg/rlN+uRGuJkmYdbscQ8WLlerMtkrW
         fGe8GmfHl+5Kk41Rrp6iGL/cLOrwPFFNGT51YqrXKyOVL/MfobK/5/CKVJ4udtd9oI
         RUjiqSeA9/L+i3XkV6olsezwo/kgdg6ZVrNQMdvZgq7WRJqURzVFiRF/1xi+xkeaAO
         Lzvu8MP0bAh8mMYjMl2hsBNzKWMln6GVDLEQpfpzE8pfpEqmwuA0PGa5ptYYBQmq3h
         vgixr6gtB9bl2mzudPfbpmtSi07TQzNfes33uSfjwm5wSeuSHitFHgQI4GUj0Um75X
         PEmdej2XWZ2vw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [-next] wifi: qtnfmac: remove braces around single statement
 blocks
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220802045305.235684-1-mailmesebin00@gmail.com>
References: <20220802045305.235684-1-mailmesebin00@gmail.com>
To:     Sebin Sebastian <mailmesebin00@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        mailmesebin00@gmail.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)mailmesebin00@gmail.com
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166002482507.8958.9992440618598993380.kvalo@kernel.org>
Date:   Tue,  9 Aug 2022 06:00:26 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebin Sebastian <mailmesebin00@gmail.com> wrote:

> Remove braces around single statement blocks in order to improve
> readability. Also, an extra blank line was removed. Both warnings are
> reported by checkpatch.pl
> 
> Signed-off-by: Sebin Sebastian <mailmesebin00@gmail.com>

Patch applied to wireless-next.git, thanks.

6b013c3d47be wifi: qtnfmac: remove braces around single statement blocks

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220802045305.235684-1-mailmesebin00@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

