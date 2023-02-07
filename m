Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921F068DC93
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjBGPJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjBGPJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0303C2AF;
        Tue,  7 Feb 2023 07:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C009BB8171E;
        Tue,  7 Feb 2023 15:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A548C433EF;
        Tue,  7 Feb 2023 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675782549;
        bh=b4M/oWjrAs+lLxDXSwk1Cbg0Dr8GvTL86D0seO3DAis=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=A2i4wmtZl6+K3BvUuMgidDdJB6t1lNDiAXhAO0iPyJ/JSk/oDDpsQtVIg42gUyZeM
         Zg941RsR/3VJBCQEG+kA4/z6lPz2CqGL9LoCAv5RoG4Q8Kua+7uuhjScoBYhhJWuB3
         SaJ6+W2ctGU8PtPFS485vXY4XC2JZ+QyS7u3IFLNCivL+HbMx5YJsDLtlqpHDu6hD7
         crrvJjZw3Dl6sBecl78yJ7pCBTE7VLTMd3IceT2kANGJfpAoCCpBQkaA7CiqbawHoa
         YlaZaXEVBpFyxdZlsQeGE+r1w/7Y8gx+q/FeKXTU449VfAbO4yqWsmgkwEMKseFZ98
         xBojwZ0+pdZxQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Bo Liu <liubo03@inspur.com>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rfkill: Use sysfs_emit() to instead of sprintf()
References: <20230201081718.3289-1-liubo03@inspur.com>
        <Y91bc2LWMl+DsjcW@corigine.com>
Date:   Tue, 07 Feb 2023 17:09:02 +0200
In-Reply-To: <Y91bc2LWMl+DsjcW@corigine.com> (Simon Horman's message of "Fri,
        3 Feb 2023 20:07:31 +0100")
Message-ID: <87pmal7bsh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simon Horman <simon.horman@corigine.com> writes:

> Hi Bo Liu,
>
> On Wed, Feb 01, 2023 at 03:17:18AM -0500, Bo Liu wrote:
>> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
>> should only use sysfs_emit() or sysfs_emit_at() when formatting the
>> value to be returned to user space.
>
> Thanks for your patch. As it is not a bug fix it should be targeted at
> 'net-next' (as opposed to 'net'). This should be specified in the patch
> subject something like this:
>
> [PATCH net-next v2] rfkill: Use sysfs_emit() to instead of sprintf()

rfkill patches should go to wireless-next, right?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
