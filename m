Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D456B03B2
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 11:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCHKFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 05:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjCHKFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 05:05:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ED5A7684;
        Wed,  8 Mar 2023 02:05:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A349061735;
        Wed,  8 Mar 2023 10:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79050C433EF;
        Wed,  8 Mar 2023 10:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678269929;
        bh=MmiTsHntaJyehIutVGRtkFnut+D5sSE4rcagwe+mD3w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XQ0uhZrU8baw7o9Pho1ZLeOPov0MsQ6Wiw1lsrNvBNJEpdwcOz5U5O4/HgEF+Fhmb
         5evFrVBRpQ1MKPpz0OI15DbEY4d5yGMG1dzLBZ43BY089ylFLKAIaw0l5oLxwtnFPl
         EKp9PoJ4FQvWd6+ag/87Ja8d0opv0/pkyP91XbWx9yV9VwsA5MAN0cKzIIFPY2CjD5
         52O8z5KULQJ9StF9FftW6rJH1TUXgr9Z9dFyJUcVjzJSbWqvtA1n6AvqKbIEzkyUiM
         SxW2hOET7UDN2Q2vGaIdIfSmub/jAIoWABtoQ/AtG6nWopU/FN7ZAUlf+j4A4B11UU
         htyL6sqrL4afQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 0/5] mac80211_hwsim: Add PMSR support
References: <20230302160310.923349-1-jaewan@google.com>
        <ZADgBqP57XcW3/tH@kroah.com> <87cz5mz04t.fsf@kernel.org>
        <CABZjns4xYjcn4CQzEoiozz9j7mKF0py0WE+AZ2Koi9Vz3khVLQ@mail.gmail.com>
Date:   Wed, 08 Mar 2023 12:05:23 +0200
In-Reply-To: <CABZjns4xYjcn4CQzEoiozz9j7mKF0py0WE+AZ2Koi9Vz3khVLQ@mail.gmail.com>
        (Jaewan Kim's message of "Wed, 8 Mar 2023 08:02:32 +0000")
Message-ID: <87lek7pnh8.fsf@kernel.org>
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

Jaewan Kim <jaewan@google.com> writes:

> Sorry about the inconvenience.
> I checked all patchset comments and also got internal reviews,
> but forgot to double check in the cover letter.
>
> Should I send another patchset just for cover-letter?
> Otherwise let me keep this as of now, unless I need to send another patchset.

Please don't use HTML, our lists drop all HTML mail.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
