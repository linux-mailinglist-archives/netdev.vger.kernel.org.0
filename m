Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9039A5D48
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 23:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfIBVDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 17:03:07 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44029 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfIBVDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 17:03:06 -0400
Received: by mail-ed1-f67.google.com with SMTP id c19so2754122edy.10;
        Mon, 02 Sep 2019 14:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DiN3XUwEyWuVguvm3uea8it2JK7pQhMrwbT1bWvvbSI=;
        b=HtkLDWjRjEb4yj4xw+UwrQaSDsmAzlj4JTHeRXU8o3a8vDDL46gfQ4a8mRd1ongvjP
         70YSB9qYB8I5jqkD3LhBW4HXXOHRnbEbbXzqXhtISLkvBvujhEmdmUF+2upqsjUYAPqH
         IFireVQTQR7Lxi6MB1VhoSUJ0nVnrIlK0WFY1aevs2QYMCT7GbV7ZobxG+apGNtic2ug
         m+Umt1EDp1nA8rucntv9Or5/HzE1LGG+ML6sbLesn6BXyaTSZ2zMHFhZvS0VO22egN03
         nbJ9Yoswq9wH+d6/qdQNLwWvofUgZFQqMB2/CoDNy2J6Zb9y2ATIF+Q2zsez4SKcWnVY
         XPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=DiN3XUwEyWuVguvm3uea8it2JK7pQhMrwbT1bWvvbSI=;
        b=QwAPycc5/plMp1bogIf18M2wniJYUTMuKljG0xrmpQOdvpAkN3gmLBqnRbEgiFPRwy
         pJ1Fz0Tmvb4ZJIuXYvEEO8CDV0elznOh4Y/+tAeS3CtRgve17kY1VfeT8g8X60YU/8TZ
         2KglaYxHIw9Lg1+rfTOsRljm869QsWnjRP4hITmyb4Wq/auxKyDed41uOqAY3OZt+wJ6
         d2qWMEg4DIMdafDo7ajnW+JnS2VtEKqaSjJjchymBzWablDoYuujyDPzdlJ4MCXc64j5
         8WuYR5S4QCSvXtc219JXyRUFEbECF8JiVIFREjhsJSqQKl//AJFF6IDrXRCrNIW3b3+B
         PhKw==
X-Gm-Message-State: APjAAAX9mQ1XStXEP+iGIETIqAqtwCX2up5yF18rHj24ipO7HbnywZXf
        +nruYr9axYmpk4LaP+nOg/Q=
X-Google-Smtp-Source: APXvYqxkCeIQUQMnPqh16Z8FXBzr1esY93hV66aFNGmk7+B4ffm4Y6lPGy4bvc73J3A/SW1NNAEuag==
X-Received: by 2002:a05:6402:658:: with SMTP id u24mr8722914edx.102.1567458184831;
        Mon, 02 Sep 2019 14:03:04 -0700 (PDT)
Received: from rocinante (ip5b4096c3.dynamic.kabel-deutschland.de. [91.64.150.195])
        by smtp.gmail.com with ESMTPSA id a11sm3139323edf.73.2019.09.02.14.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 14:03:04 -0700 (PDT)
Date:   Mon, 2 Sep 2019 23:03:02 +0200
From:   Krzysztof Wilczynski <kw@linux.com>
To:     Luca Coelho <luca@coelho.fi>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: mvm: Move static keyword to the front of
 declarations
Message-ID: <20190902210302.GA3046@rocinante>
References: <20190831220108.10602-1-kw@linux.com>
 <c22d4775fdad4e34fdc386e2cf728b63dfe13ffe.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c22d4775fdad4e34fdc386e2cf728b63dfe13ffe.camel@coelho.fi>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luca,

[...]
> Thanks for your patch! Though we already have this change in our
> internal tree (submitted by YueHaibing) and it will reach the mainline
> soon.

Thank you for letting me know.  I am glad it's fixed. :)

Krzysztof
