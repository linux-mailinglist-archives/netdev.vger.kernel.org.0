Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A363177727
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbgCCNbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:31:22 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40203 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgCCNbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:31:22 -0500
Received: by mail-wm1-f66.google.com with SMTP id e26so2834154wme.5
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 05:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wt7FYb07f5q30xBpDa77cnx/gqt+CmvnMfF6o6ueJb0=;
        b=ooJcWoRuIJjTSlHfhhuLEnq27TpRjQh3s14UKbctdhVZ3rEwq4IPvYIg5CZkL4/j4v
         S+0SkVN0Smvp/DTx74o/rdEnF43PzXwKKiEz5e9i/HfNeJ92LfRxOyS2amzBDHaxvnqp
         Ej8cJxu4YYL8IMl3lv7LZuWec6vbakeQg1Qex8uI8HmjOaoJt7nde0bYXfBvusrwor2B
         lmkNqEN/fVfUtKth4R74TnFqxxmXHh2CTPdrxss2Sap8MJyaa0eVvOqAjfJG2JSPl6l/
         xagBu8c5AF9CZvfRGE3eewXiZDMdzBCl++nZeAgsc+Jvdn3E2+ngBFWd1/jTL/IZd4S/
         YPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wt7FYb07f5q30xBpDa77cnx/gqt+CmvnMfF6o6ueJb0=;
        b=MrLhBdpY7AhuFLfFM6ZsteiptUSa4Wl1HJTSPYKx/QPA2//dlgtwrVE43Smh/jiQCB
         ZNbIVvbg8KDcxh8m1kXMbcs66Ji6YXDEPjAfUhMHWKDbQm7soTw/mDZUr8wSOMSn7Tn3
         6cEkDP9VrUpaVeyt/u5NqZ5WyZ4yxAIS0kecJhe1GIetdNrDtQiIwGxJc7zpRS04uehT
         xKPtm+1SMvYfJSXEyjkankdNhcIi22G1OmFtuLbaBGUg6ytTu6kim4zl1OQfcwjQvyzc
         aO3NhoqkpQOx6uaEjQKdf1XCmDk3AovpxLxONMlEgFTQe1yDRDtkjXh1d0k1KrOo06Rc
         l0og==
X-Gm-Message-State: ANhLgQ0GbysBO2B/qwneJ39r3p1e+QI/ynhs7VQTxkfHK3mHw9y+qV2c
        VaGrtRjwSeAp+60XyILeo6xbHw==
X-Google-Smtp-Source: ADFU+vs/CqIQgBVZQR0ELATCr46+QaQEBGSRtv7JgX2UfQsjE2Fe+NwYz5h+WsxXWKCf+XfKKoftZA==
X-Received: by 2002:a1c:ab07:: with SMTP id u7mr4141921wme.23.1583242281257;
        Tue, 03 Mar 2020 05:31:21 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id f207sm4878424wme.9.2020.03.03.05.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:31:20 -0800 (PST)
Date:   Tue, 3 Mar 2020 14:31:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] devlink: remove trigger command from devlink-region.rst
Message-ID: <20200303133120.GJ2178@nanopsycho>
References: <20200302222119.52140-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302222119.52140-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 11:21:19PM CET, jacob.e.keller@intel.com wrote:
>The devlink trigger command does not exist. While rewriting the
>documentation for devlink into the reStructuredText format,
>documentation for the trigger command was accidentally merged in. This
>occurred because the author was also working on a potential extension to
>devlink regions which included this trigger command, and accidentally
>squashed the documentation incorrectly.
>
>Further review eventually settled on using the previously unused "new"
>command instead of creating a new trigger command.
>
>Fix this by removing mention of the trigger command from the
>documentation.
>
>Fixes: 0b0f945f5458 ("devlink: add a file documenting devlink regions", 2020-01-10)
>Noticed-by: Jiri Pirko <jiri@resnulli.us>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
