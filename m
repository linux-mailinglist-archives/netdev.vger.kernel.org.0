Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D645D148AE3
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388266AbgAXPFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:05:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51492 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387432AbgAXPFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:05:20 -0500
Received: by mail-wm1-f68.google.com with SMTP id t23so1959432wmi.1
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 07:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cL4l7aG441iKVN0B9Fvf8lOPKoUdyBrLLhNkbllIVa8=;
        b=TKL3YBIAqfrHPTkFyEH04a4ZqUyZWIaW0mhH9BlGj7p/JL0ylX6gkNcXDQgQy4TRcP
         UIxTgZvv77AE58ONlicBi6JbxDUfhzxrCCapAKnBzQVqntC93i8cIZuQQLyqFT0FoxNz
         YsNjCRJNt53XisK45KbUdBHewUD6z3ZmAUTpXKjCYok18wyPM+B9GvyjZR50JQPWdeeo
         Q23J4WV4xt29u1ezDEii8N/DBCZMhgcRSF07nT5fdL2yldOgyn2KCUXNAZpdvJ78z2+d
         tUfyogTuDd81DspUmCTLEYYeNnv0PSwTLUMrNZFmTVnDnoCNrYeg3Oz2QPhfLp480RKG
         F6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cL4l7aG441iKVN0B9Fvf8lOPKoUdyBrLLhNkbllIVa8=;
        b=kTd8BOmW9L4jEwo9Z+5/tpVY3zj13lSGl02k2HW+byRDf3k3eo8gHPLpXPWaWu1MrB
         1+Z24hNso2++4OfAsiCfeAk3eqbl3bbg4XqKya2NSKvHqGVnRGLPrJy5JWFfnWnDJI3x
         4tyJgrZK8W5iyIlOE2hX7lCtHK6WkhtkHW2j3mAZ/Fvpcu3uyZDvtI9GgMAZ3RoHyaJD
         /hE4GTGZUssUD8ttreKSQcs8rz2CYWHU73AZVNaWbL7PoMr1r5QmZ+a2E7f64hdSTfzS
         hG4VWwcZuS54rSiud1vGkJTDELFA3l1JEw1qZtuvrHqFUNPBDtcJNSf0kP4Dwa7pb/1G
         Z/uw==
X-Gm-Message-State: APjAAAX6guvhCB8tB+vpUS87R7/77lN31+NuS403TDvNn8PMa6I4qTUD
        NM7gvKcVvN56X0KOGe284cKvdw==
X-Google-Smtp-Source: APXvYqwq9jXViy+ZGtW9+jHaeU/yrnIymqXG46im4Qa1n6nYGr600Yt+zVd/xxDrny0f3BELGDYu3Q==
X-Received: by 2002:a1c:ddc3:: with SMTP id u186mr3557044wmg.103.1579878318584;
        Fri, 24 Jan 2020 07:05:18 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w17sm7629914wrt.89.2020.01.24.07.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:05:18 -0800 (PST)
Date:   Fri, 24 Jan 2020 16:05:17 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 07/14] mlxsw: reg: Increase
 MLXSW_REG_QEEC_MAS_DIS
Message-ID: <20200124150517.GE2254@nanopsycho.orion>
References: <20200124132318.712354-1-idosch@idosch.org>
 <20200124132318.712354-8-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124132318.712354-8-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 24, 2020 at 02:23:11PM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>As the port speeds grow, the current value of "unlimited shaper",
>200000000Kbps, might become lower than the actually supported speeds. Bump
>it to the maximum value that fits in the corresponding QEEC field, which is
>about 2.1Tbps.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
