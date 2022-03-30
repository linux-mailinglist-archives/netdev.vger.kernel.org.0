Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B4F4EBB6F
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 09:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243608AbiC3HHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 03:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239173AbiC3HHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 03:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1E2E389F;
        Wed, 30 Mar 2022 00:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 293B46174C;
        Wed, 30 Mar 2022 07:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFC4C340EC;
        Wed, 30 Mar 2022 07:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648623916;
        bh=VWuNt9MMq30h518JglbsrFsfm2iHhJHX8QEEqDJ+oME=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EEQYNvd7HoxsnIJuJj4H9DDPPJw2JEsCNS6GFlZEn9LkdTPgiyZ7ihwosYWPXjeS1
         fWpWJ9CiJPKAesSLVuH/qdtaVNtyj7xBUrUahqcPowCDnHWLVhR2NK89uEGQ6llA+P
         S+QHC30b4jEj3+hTDge/rbUlVzoIdrWi2z91MEyUM5MnuDwU4UIpEpAWHbbwlyKEXB
         bHMOw6HV1twNGFX9HPwBTneXccWdQ8fjmRYNzP9vqIMUbkfpUY1MdpIxRMY4FS2g5m
         hLrtTFB80UJiiPhWyexHSnv+NXqQZhwHAcVf/2uCiyOjPRUu42vBXm5ft5afiiT2zV
         gsKxmRlY2gxXA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Benjamin =?utf-8?Q?St=C3=BCrz?= <benni@stuerz.xyz>,
        <loic.poulain@linaro.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/22 v2] wcn36xx: Improve readability of wcn36xx_caps_name
References: <20220326165909.506926-1-benni@stuerz.xyz>
        <20220326165909.506926-19-benni@stuerz.xyz>
        <f0ebc901-051a-c7fe-ca5a-bc798e7c31e7@quicinc.com>
        <720e4d68-683a-f729-f452-4a9e52a3c6fa@stuerz.xyz>
        <ff1ecd47-d42a-fa91-5c5c-e23ac183f525@quicinc.com>
Date:   Wed, 30 Mar 2022 10:05:10 +0300
In-Reply-To: <ff1ecd47-d42a-fa91-5c5c-e23ac183f525@quicinc.com> (Jeff
        Johnson's message of "Mon, 28 Mar 2022 13:23:06 -0700")
Message-ID: <87y20rx6mx.fsf@kernel.org>
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

Jeff Johnson <quic_jjohnson@quicinc.com> writes:

> (apologies for top-posting)
> When you submit new patches you should not do so as a reply, but
> instead as a new thread with a new version number.
>
> And since multiple folks have suggested that you submit on a
> per-subsystem basis I suggest that you re-send this as a singleton
> just to wcn36xx@lists.infradead.org and linux-wireless@vger.kernel.org
> along with the associated maintainers.
>
> So I believe [PATCH v3] wcn36xx:... would be the correct subject, but
> I'm sure Kalle will let us know otherwise

You are correct. Also I strongly recommend using git send-email instead
of Mozilla. Patch handling is automated using patchwork and git, so
submitting patches manually is error prone. See our wiki for more:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#format_issues

Also I recommend reading the whole wiki page in detail, that way common
errors can be avoided and we all can save time :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
