Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3013215057
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgGEXRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEXRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 19:17:54 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB3DC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 16:17:54 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id k17so8794138lfg.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 16:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bSbfdzjMfzsDw5L67RAccJo6SRS4CKHctCMHbmWsmx0=;
        b=W8bC4o5gDM17J81nle6Sn9FG10apqyw+G4xtG171VgbLFU1myaysARPb81c1asMazO
         UXKKOqmzIGZwocSfvGA+Pq4a5YhU89EWlV05ZhSEzyAQV1EVxfwkJ27ucp85DJ90PgDm
         MGkZV6VUrR5HICL+NVslQQX5OQDxwcVAb/WwlRqVevnA+DC5PE4og1U2hEGZJJzXppTB
         e57bTid7fnCIALNMzPrq5Ba+mV9Z9Z+naHnykwLGVphQn7sv5dkaDyNAcE4P/Ivo2Mun
         mJWkSZLCdAV6oF/F8Eo4/oYOZD3pbwBJYiRJO5LJ4iJmzf/OHKo3BtWP+++0YbzEAj07
         qAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bSbfdzjMfzsDw5L67RAccJo6SRS4CKHctCMHbmWsmx0=;
        b=N9iMLOikYxQ1AhoSMRHkXKtbZCKpD70L0GIUf0qThIoXYAHXEilub7nhvMpVKh+lQy
         n9Fb+4XE3gN4jDaKBLVaHINkvSMLdQJcfskys2b1A+9qpozl1XZXBSscV+3WZ3shYu/K
         NqjfmJBl2eg0+25CtgWEUBLpoWSIdiGK8tKNoUtJR2ua7q2jBJgQ88sOZEOB6COnIxe4
         GrHai9o8YicUgrPt1++0OzFxI6T9niNNwsrHRJzWFt6TV4Oz0xqC84B90SUxS6CGIOdP
         yjvG8+QBnwMZ5P6QsYZZQ0FJ1BFqPBXDEuCBRMqa0mQZZDEkTuE/+CLUoPxK4pqX5tsj
         Pr5A==
X-Gm-Message-State: AOAM5331xBoTwbpFftJADrDIQKyGmrw+q3Y+3xckGZvGTfjmDOAVzdHe
        k98FG6VyBALFoidpg7xnWTWgJ5TLrXJBZXBHfsdQoQ==
X-Google-Smtp-Source: ABdhPJx8wsnkL5ne/TJpgN5IVTlzTSi+I6vYrrqo2eTAIpX1kJ50LBGDBzhxzY3vR6hCmFkhqq2mW/QX+g8t+dYqqqQ=
X-Received: by 2002:a19:745:: with SMTP id 66mr28309774lfh.77.1593991072513;
 Sun, 05 Jul 2020 16:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200705204227.892335-1-andrew@lunn.ch>
In-Reply-To: <20200705204227.892335-1-andrew@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 6 Jul 2020 01:17:41 +0200
Message-ID: <CACRpkdaZ3Hz50wetewiUPYVAe_Lfuz7x_Xy0QLiMQEZnFLcRnQ@mail.gmail.com>
Subject: Re: [PATCH] dsa: rtl8366: Pass GENMASK() signed bits
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 5, 2020 at 10:42 PM Andrew Lunn <andrew@lunn.ch> wrote:

> Oddly, GENMASK() requires signed bit numbers, so that it can compare
> them for < 0. If passed an unsigned type, we get warnings about the
> test never being true.
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

I just resent my RTL8366RB series and I picked this patch in
front of the series so as to make sure it applies. (I also took
care to carry forward the same fix in the new code.) I hope there
are no other collisions.

Yours,
Linus Walleij
