Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABE123EB56
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 12:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgHGKQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 06:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgHGKQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 06:16:45 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33153C061574
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 03:16:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id c16so1485162ejx.12
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 03:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bj6XkRfy+n0NLJ+1/b2q3wovGFyWFBGpsChspXzhOks=;
        b=lVBymRO3ImxTFh/BAzr1e6xyu0EBd3OAy74rv5jf1I0inKmdza6liA2Gkg0JqRIHQl
         rN4AvhFQJD4UROQIxb3O/mXrwFpHHB8a969OOpQowtqps28en+gTn1uPT331st6AxMoX
         fWeN6M7uqyKnBRpEVahb51QPvEXYMH33eP3zYAmn/IH8+8FULkKfzFDC2vRzG/0x8ApM
         bSwKMn176CyCRkSqgIIiXR4HxIV/64RJHoJUl+1RqnxDAMG8pjHqWA59EGx40Qln/a4e
         SL6sBlQgXoEN/UZBc9ld4CQn/506RJCqlwSA64AS0tnk6k4ecYq124ne5f4S/zQEGGGu
         a9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bj6XkRfy+n0NLJ+1/b2q3wovGFyWFBGpsChspXzhOks=;
        b=XO6s+l/ZXEWLms1mqpFUMpgmkJKTQ/u+GOCxJt2XDOQj3U7fgriJ/qAOCu7urlzZeB
         NteXpwTqIVvWo3NhPbu12/PCx/htbk4gAZRQt6D8Ajy/Q1DFE+Wm6lWIxqZ8vTmzGB1C
         bPcC6+E+FU8E/Gp26jPmUc0du5HMzzj//x7F3BVcbHeKrTuYov8ENACyAq9ssJPZFFrr
         VFQD+baCuQSBruuU6rtp4o3ZC8WhVHKmzqkCg1s1c2BBv4saFKsZo1lRrCDzsKfXuEjV
         uLdVY8UYVH/6cXelv3f+BpCjdhpbYfFLQL9AclW3NUFYZBBseb7cSF2RDqLHi0i0dLAh
         s2Qw==
X-Gm-Message-State: AOAM533tKetGQvDkiP7a07g4lvHqt+GdB0Ev9tNTGLY2fj/kMuvW2w+8
        hwZXrf0rOFNoyWpxfmwmJRbM0g==
X-Google-Smtp-Source: ABdhPJzuYTQz1EaudqoJJzIM3zmEx6wyDMaG1bWIVyWfZ1laK1wTAujBaAOP0djKkQB7WSZdhuV20w==
X-Received: by 2002:a17:906:2b8e:: with SMTP id m14mr9013670ejg.249.1596795403716;
        Fri, 07 Aug 2020 03:16:43 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id sd8sm5672902ejb.58.2020.08.07.03.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 03:16:43 -0700 (PDT)
Subject: Re: [MPTCP] [PATCH net] selftests: mptcp: fix dependecies
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        "David S. Miller" <davem@davemloft.net>
References: <781f07aa4d05b123a80bf98f5839e1611a833272.1596791966.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <0892801f-c5d0-4ec3-361c-617208c8e5ec@tessares.net>
Date:   Fri, 7 Aug 2020 12:16:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <781f07aa4d05b123a80bf98f5839e1611a833272.1596791966.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 07/08/2020 11:32, Paolo Abeni wrote:
> Since commit df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
> the MPTCP selftests relies on the MPTCP diag interface which is
> enabled by a specific kconfig knob: be sure to include it.

Good catch! Thank you for the patch!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
