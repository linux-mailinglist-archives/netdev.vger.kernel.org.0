Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6232A311961
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhBFDDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhBFCy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:54:57 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84E5C061794
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:02:16 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id a14so2560870ios.2
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gn1oNPUt8nvKg4L8IQuJxo3ItPqw1Pp9dP3UEdFlsnw=;
        b=KZn95LUJ9txktXDozvtFRm5+TW+2VTONYEJDyg6QieKJl3x34oVwgzLKvT7wNDaJwJ
         4dag3d62fE59CkIGJx2aw4CLaBC/gAj/r3y9yS6QPqVu388tGzV7Hnpgff9+opScocqL
         mHZ7CGk0SkZhFmtnrbIDwTI/5jUUaFYApGJ3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gn1oNPUt8nvKg4L8IQuJxo3ItPqw1Pp9dP3UEdFlsnw=;
        b=W+B0Oyc8DGpGELXijIgppMJfvIWf2dYYJLQfQ0XWjpvw8xG1QEtYhYlSnW5um1a/Um
         jwvEUHD/Tvylj0h58KwuZCeCTPVf0nwoMF1ln7pJ3JoN17cADZ9g85TLqME90FeP1eXe
         PwLnw5ialbaKgutQZ82NpWpFgxMB3vGCFbPlBc1kVzP76FxXXNx2qV8sArvSpYopNCd1
         PK3fk+5meB71DHrJXSPJp1vcI78IyeyZc029DsXmxhJ7ABMh5IFhIn+LmMSHI7r/Elep
         k78onG2MhU02JvT9UqLohajZ44d8Jjb1P75DhRtK/IiV/KFQlBonLKkBPipX2QesaYaZ
         LOfg==
X-Gm-Message-State: AOAM5330ym0NlvkpCuEW0UzDJ1+h+qhSER2MpM//eyFUS8JtxYlHdhu9
        qMI/Jre9DeJj5kDWVvLhlAo1NeVHoi7hUTp4kJOFvg==
X-Google-Smtp-Source: ABdhPJzm1U46fzzVZVO4LDJ7oGLxGsIxOuGbM8B5KCv3grFD0fHVbdW8c8ZD7RfP3BSJaecLpRgAkvts/ULuG+Nq7Xk=
X-Received: by 2002:a02:1649:: with SMTP id a70mr6798927jaa.97.1612562534776;
 Fri, 05 Feb 2021 14:02:14 -0800 (PST)
MIME-Version: 1.0
References: <20201215173021.5884-1-youghand@codeaurora.org>
In-Reply-To: <20201215173021.5884-1-youghand@codeaurora.org>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Fri, 5 Feb 2021 14:02:04 -0800
Message-ID: <CACTWRwunEexmHm+Un35fJHnqSY_9oUhYcu6eS68H9eQLG3==zA@mail.gmail.com>
Subject: Re: [PATCH 1/3] cfg80211: Add wiphy flag to trigger STA disconnect
 after hardware restart
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LGTM! If no one has any objections, I would be happy to see this
considered for upstream.

Reviewed-by: Abhishek Kumar <kuabhs@chromium.org>

Thanks
Abhishek

On Tue, Dec 15, 2020 at 9:30 AM Youghandhar Chintala
<youghand@codeaurora.org> wrote:
>
> Many wifi drivers (e.g. ath10k using qualcomm wifi chipsets)
> support silent target hardware restart/recovery. Out of these
> drivers which support target hw restart, certain chipsets
> have the wifi mac sequence number addition for transmitted
> frames done by the firmware. For such chipsets, a silent
> target hardware restart breaks the continuity of the wifi
> mac sequence number, since the wifi mac sequence number
> restarts from 0 after the restart, which in-turn leads
> to the peer access point dropping all the frames from device
> until it receives the frame with the mac sequence which was
> expected by the AP.
>
> Add a wiphy flag for the driver to indicate that it needs a
> trigger for STA disconnect after hardware restart.
>
> Tested on ath10k using WCN3990, QCA6174.
>
> Signed-off-by: Youghandhar Chintala <youghand@codeaurora.org>
> ---
>  include/net/cfg80211.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ab249ca..7fba6f6 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -4311,6 +4311,9 @@ struct cfg80211_ops {
>   * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key installation
>   *     before connection.
>   * @WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK: The device supports bigger kek and kck keys
> + * @WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART: The device needs a trigger to
> + *     disconnect STA after target hardware restart. This flag should be
> + *     exposed by drivers which support target recovery.
>   */
>  enum wiphy_flags {
>         WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK         = BIT(0),
> @@ -4337,6 +4340,7 @@ enum wiphy_flags {
>         WIPHY_FLAG_SUPPORTS_5_10_MHZ            = BIT(22),
>         WIPHY_FLAG_HAS_CHANNEL_SWITCH           = BIT(23),
>         WIPHY_FLAG_HAS_STATIC_WEP               = BIT(24),
> +       WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART = BIT(25),
>  };
>
>  /**
> --
> 2.7.4
>
