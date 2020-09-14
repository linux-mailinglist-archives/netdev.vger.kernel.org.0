Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B51526971D
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgINUxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgINUxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:53:01 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED79C06174A;
        Mon, 14 Sep 2020 13:53:00 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id x69so768725lff.3;
        Mon, 14 Sep 2020 13:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k9w40fAnLY062DMttTVJypXtcuo4iA/0LGX2IcAd/MI=;
        b=cbLoY347WEUFQ/2F80MACLTGh4YGNLevV0n/fJQJUfDubvmCJx78be4uM3jmZXbWHC
         M2irQ86Kor0wWoWnRG04iqN5OopRKi2mk4qLLlCeqFGuc6A+HI06YhZSSFsXJj63YN2K
         rNCXP+6HtBtYz1dMPChKez+lUsXzRn4bI6zWFdmamQCggBhyChx1dbEwarOBxNzZQJ8J
         UnYrVbfogpi9YbRTeiqI2Inv9Vv5LSIoRnguwL6ftjakcyV26TXjrPWmyeh5ZpYHrg2n
         IVEcoY12xolokBXcpYxq5ZuRVIb7KOV7ICKZSgt64VX2eGtRtpV09YyfByQcj2xRts3Q
         41lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k9w40fAnLY062DMttTVJypXtcuo4iA/0LGX2IcAd/MI=;
        b=dL8dsx7FpxTVUu33dhaD4r9UUGi8IZ3JcwOiWTtyPm/ctIKceTArCaobcM3hcJnH/1
         nMGvdz0oJ1CGXhr/H779aKzgOF02Up+51buPi5Zqn89xh2S5Iz/Mg7UoN8A3lICxZY8a
         AmFo0HRrbSpkAFVEvGpaYb4bFHyQGOp2pRBTU/o0zKec0H5axnIRsMLllUniNWxs2T/o
         NRvfDxD0J34uNMpUEuyW6F8zMW/QAS9ZPV5fb7IQlGm5D1qhxRSbAYerjblxkRTePtgB
         y6aRFsgV58rGk0yySbo7YaIVH18J7yL1v6eO82dx5s1Xc3+SF7GrPsJWXGURpzy1jR5u
         CMRA==
X-Gm-Message-State: AOAM531UdakyRcSZlVv6IP3EOKEmovSko5AVuEVeuMggPOA8aYvDZ0mf
        0uPhRSUnsWqlI8R32Tj4fbs=
X-Google-Smtp-Source: ABdhPJy4xq1x+Ok9MTO3aOkhQn4b5cKP1dRhezK6UAtVP9Tj6L046bypMLRhCP8otdAboMiM0sSE9w==
X-Received: by 2002:ac2:4a73:: with SMTP id q19mr4724484lfp.532.1600116779262;
        Mon, 14 Sep 2020 13:52:59 -0700 (PDT)
Received: from rikard (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id t1sm4248730ljt.21.2020.09.14.13.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 13:52:58 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
X-Google-Original-From: Rikard Falkeborn <rikard.falkeborn>
Date:   Mon, 14 Sep 2020 22:52:54 +0200
To:     Joe Perches <joe@perches.com>
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jerin Jacob <jerinj@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] octeontx2-af: Constify
 npc_kpu_profile_{action,cam}
Message-ID: <20200914205254.GA2677@rikard>
References: <20200911220015.41830-1-rikard.falkeborn@gmail.com>
 <c6568e2e4450633136c6e7d85f29ed68aa01a32f.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6568e2e4450633136c6e7d85f29ed68aa01a32f.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 10:27:01PM -0700, Joe Perches wrote:
> On Sat, 2020-09-12 at 00:00 +0200, Rikard Falkeborn wrote:
> > These are never modified, so constify them to allow the compiler to
> > place them in read-only memory. This moves about 25kB to read-only
> > memory as seen by the output of the size command.
> 
> Nice.
> 
> Did you find this by tool or inspection?
> 
> 

Inspection, aided by some semi-clever greping.
