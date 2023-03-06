Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9686ABA2C
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 10:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjCFJmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 04:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFJmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 04:42:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE53358B;
        Mon,  6 Mar 2023 01:42:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8916B80D5D;
        Mon,  6 Mar 2023 09:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BDAC433EF;
        Mon,  6 Mar 2023 09:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678095767;
        bh=fd4XiTFlUTlqP7rrzWivZQ2RqFXOTHM2L3uSmisj0XM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=n72SQFWC+Az2Hb/vmbgRiQO3PpcU2wmZ1IwVswEXej7bHXHkNFZevrfyxvLDb2lQZ
         M6krReakwWzTSwDFCusyypzcfMrViGTmX8l4cqer3yFumX8rfYBVt66fZ3GnL0mOEf
         YIIZrmV6OECRw2xUoVq2g1a0ENDOpYANMEtn2mNlE9zX0wpOq7Jwe0GI97BsZRwl3f
         c7N4VqPot6CI5aFFFj1Hi3LuxLRBlqzjbWti/Ol2Q2Pr5SBAJGhfvr+MdKLeSD9lZs
         4v0MU4RN1fa1oS8TzRRD3QsKe28cu7IzmEEkCKZwH7ZDbDawdmm8JcnI9Kthk3QDx7
         t3VRKDj/HyUXQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jaewan Kim <jaewan@google.com>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 0/5] mac80211_hwsim: Add PMSR support
References: <20230302160310.923349-1-jaewan@google.com>
        <ZADgBqP57XcW3/tH@kroah.com>
Date:   Mon, 06 Mar 2023 11:42:42 +0200
In-Reply-To: <ZADgBqP57XcW3/tH@kroah.com> (Greg KH's message of "Thu, 2 Mar
        2023 18:42:30 +0100")
Message-ID: <87cz5mz04t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Thu, Mar 02, 2023 at 04:03:05PM +0000, Jaewan Kim wrote:
>> Dear Kernel maintainers,
>> 
>> First of all, thank you for spending your precious time for reviewing
>> my changes, and also sorry for my mistakes in previous patchsets.
>> 
>> Let me propose series of CLs for adding PMSR support in the mac80211_hwsim.
>
> What is a "CL"?

Hehe, we are not the only ones asking for this:

https://stackoverflow.com/questions/25716920/what-does-cl-mean-in-a-commit-message-what-does-it-stand-for

Apparently this is Google terminology but in upstream we use "patch" and
"patchset". But the recommendation is to not say "in this patchset" or
"in this patch" in commit logs, everyone know they are patches anyway.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
