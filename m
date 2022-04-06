Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DEB4F5FB2
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiDFNUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiDFNSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:18:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8B24EB1B7;
        Wed,  6 Apr 2022 02:58:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E16FB82202;
        Wed,  6 Apr 2022 09:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319CCC385A1;
        Wed,  6 Apr 2022 09:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649239118;
        bh=jbHPSkJfWymWcChZS9h8IsoHjPzPs3UEKYf8YDD44QU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gOaTY3IkTaYcWOddj01CvigmJljeODuL+j74KW3JyGr76gT2Zs/gOc8as7j0TaIAG
         l+1wS29mcylE2ykOj0teWzTHERgF0bMuevRnPiN/emFdeg6Litz+hPIRZtFL/BxL9W
         NvXvBr+jhZde2bGrTw7iYtWL1BMeI7Tb7z7Qx4dcHKpuekVoPTuJ2QHZjo0ve6WI4z
         9klE7u08b8XBzXGk9BA5EejiDbJKDOAUCokQoXbJc+vqyk+2IktWNZFtlrOq6x4xSA
         GZ/XZp5tQvI03ztK/icrhxTazSrVccVLwlbczSbqGB7Qz36lpEy8KlUcFncthba6WL
         CZw2+JferEjKw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ipw2x00: use DEVICE_ATTR_*() macro
References: <20220406015444.14408-1-tangmeng@uniontech.com>
Date:   Wed, 06 Apr 2022 12:58:31 +0300
In-Reply-To: <20220406015444.14408-1-tangmeng@uniontech.com> (Meng Tang's
        message of "Wed, 6 Apr 2022 09:54:44 +0800")
Message-ID: <87r16apm7s.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Meng Tang <tangmeng@uniontech.com> writes:

> Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
>
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c |  64 +++++-----
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 119 +++++++++----------
>  2 files changed, 90 insertions(+), 93 deletions(-)

You have submitted a similar (or identical?) patch earlier:

https://patchwork.kernel.org/project/linux-wireless/patch/20220401053138.17749-1-tangmeng@uniontech.com/

If you submit a new patch mark it as v2 and include a changelog. Please
read our documentation:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
