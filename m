Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB3122D7DA
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 15:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgGYN3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 09:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgGYN3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 09:29:20 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712B6C0619D3
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 06:29:20 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id g11so896890ejr.0
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 06:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PNeX8rp0fnfypsD5r37mLhkd2nF+UHVbTOOGfQPh/cc=;
        b=j8r84MWswwWjfMREzZj+5bLwIX9Dl/wylpzDGfRqeOG6QVANtlw5U+728l+LKu7xe0
         um1JM+uWgUFygF6KV3X3KGIBURjS+o32Veh1h9XXr2Z42rnEQFaTbvo1x8HB/gh05bm7
         rLs7XYYoH6DyGA2KdkKdNUEMeOSJkX/dCqre1C46/JIv5X+35gJupEfH78cZEODEim46
         812cJ8HSN9IHOcUgqWRBhb9B0zZhXkV8l8fFWlEgWReuR16LZ+vDoPdUfoxRN2riJVc5
         VKyp+HxTkVC/j7cpYRMJunsfgFT0m6M7/IVQCo22Fm74/K7CXbtJV/Sc4BjNn9fHltBl
         Fo9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PNeX8rp0fnfypsD5r37mLhkd2nF+UHVbTOOGfQPh/cc=;
        b=Ph2owlvBkJjEQ8c/R7mmDYku2i23+OxYtaFPrqM47MaTa3muS8Xapjl9CChzguHaAr
         zBqmLLiRrHP3/Qse9J35vZBj0alYsn0ZGauo/pz8FV/RZa4WMNoiVkHxzN3cSdwfCd95
         ZZzWLNbsFtYlfWfG/aGXL0vVn80D9O+O5q4rriMEvzFjMw/40M4suqhSEtk6bJWwQRzg
         6jjNFR26mDQTbXRN6v4vC3SP4ktRd0BE9zCmtQJNblTpcqVr7KPFmo8zyzoTsRyg4Hic
         JaSqs3vNa0q5sl1zdD2wXTkFEIutyP6HpqMvaBH1FQLRJ8FnRsWOvzPjgtXV1I/zIgrB
         egmA==
X-Gm-Message-State: AOAM531o98XZPo2smw/AVqdBcSPlsWRnx7U9kbbKgGy+jAnGuduoYHgz
        fvVI2mAPDggB1a4sHHK1pwfs9zSw
X-Google-Smtp-Source: ABdhPJxecihEbWoAlbxil24fUr5HD17Ek9pfQZevwTdKnByhFy9rzh9+EGT/r7p719AGi3cC2YppXQ==
X-Received: by 2002:a17:906:d8f:: with SMTP id m15mr3442612eji.494.1595683758834;
        Sat, 25 Jul 2020 06:29:18 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id ch2sm2905740edb.87.2020.07.25.06.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 06:29:18 -0700 (PDT)
Date:   Sat, 25 Jul 2020 16:29:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org
Subject: Re: phc2sys - does it work?
Message-ID: <20200725132916.7ibhnre2be3hfsrt@skbuf>
References: <20200725124927.GE1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725124927.GE1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 01:49:27PM +0100, Russell King - ARM Linux admin wrote:
> Hi,
> 
> I've been writing another PTP clock driver, and I'm wondering whether
> phc2sys is actually working correctly.
> 
> I'm running it with: phc2sys -c /dev/ptp1 -s CLOCK_REALTIME -q -m -O 0
> and I have additional pr_info() to debug in the clock driver.
> 
> What I see is the "sys offset" that phc2sys comes out with doesn't
> seem to make much sense:
> 
> kt: 000000005f1c273ds 371ce3f5ns t: 00005f1c273ds 374c6cf5.2ae8ac76ns
> kt: 000000005f1c273ds 377bf04cns t: 00005f1c273ds 37ab792b.4ef91e82ns
> kt: 000000005f1c273ds 37daf7ccns t: 00005f1c273ds 380a80c3.5d12653ans
> kt: 000000005f1c273ds 383a143cns t: 00005f1c273ds 38699d5c.cf1319f2ns
> kt: 000000005f1c273ds 38992094ns t: 00005f1c273ds 38c8a9c8.f4247162ns
> kt: 000000005f1c273ds 38f82d13ns t: 00005f1c273ds 3927b640.196edf5ans
> kt: 000000005f1c273ds 3957323bns t: 00005f1c273ds 3986bb74.1c28a8fans
> kt: 000000005f1c273ds 39b643e3ns t: 00005f1c273ds 39e5cd56.5b34c14ens
> kt: 000000005f1c273ds 3a155d5ans t: 00005f1c273ds 3a44e6bf.be0b79e6ns
> kt: 000000005f1c273ds 3a746fcans t: 00005f1c273ds 3aa3f943.001a4266ns
> phc2sys[127.224]: /dev/ptp1 sys offset      5788 s2 freq  -69793 delay 6229046
> 
> Here, ktime_real (kt) is behind the ptp timestamp (t), and we have a
> positive "sys offset".  This continues for a while:
> 
> kt: 000000005f1c2743s 0e1c25bdns t: 00005f1c2743s 0e4ba86d.91ebf06ans
> kt: 000000005f1c2743s 0e7b3801ns t: 00005f1c2743s 0eaaba44.601c1f30ns
> kt: 000000005f1c2743s 0eda4225ns t: 00005f1c2743s 0f09c4c3.0fa0d134ns
> kt: 000000005f1c2743s 0f395a82ns t: 00005f1c2743s 0f68dd0a.f8abbf48ns
> kt: 000000005f1c2743s 0f986abens t: 00005f1c2743s 0fc7ed41.c00f543cns
> kt: 000000005f1c2743s 0ff773cans t: 00005f1c2743s 1026f675.6a32920cns
> kt: 000000005f1c2743s 1056784ens t: 00005f1c2743s 1085fad9.003b24aans
> kt: 000000005f1c2743s 10b57fcans t: 00005f1c2743s 10e50267.a378bd3cns
> kt: 000000005f1c2743s 111481f6ns t: 00005f1c2743s 1144047b.2fde6accns
> kt: 000000005f1c2743s 117387b9ns t: 00005f1c2743s 11a30a5c.cc1d52b4ns
> phc2sys[132.536]: /dev/ptp1 sys offset      4882 s2 freq  -62617 delay 6227425
> 
> kt is still behind t, and we still have a positive "sys offset".
> 
> kt: 000000005f1c2744s 11d56067ns t: 00005f1c2744s 120473bd.c6a08dbfns
> kt: 000000005f1c2744s 12346f54ns t: 00005f1c2744s 1263806f.d008fce3ns
> kt: 000000005f1c2744s 12937d7ans t: 00005f1c2744s 12c28c2b.d57fe555ns
> kt: 000000005f1c2744s 12f29f00ns t: 00005f1c2744s 1321ab52.2aa69e70ns
> kt: 000000005f1c2744s 1351aedens t: 00005f1c2744s 1380b903.38258359ns
> kt: 000000005f1c2744s 13b0c614ns t: 00005f1c2744s 13dfcdef.635079dbns
> kt: 000000005f1c2744s 140fd641ns t: 00005f1c2744s 143edba0.70cf5ec4ns
> kt: 000000005f1c2744s 146ee8c7ns t: 00005f1c2744s 149debf2.8913fe8dns
> kt: 000000005f1c2744s 14cdf64dns t: 00005f1c2744s 14fcf6d6.8b147d37ns
> kt: 000000005f1c2744s 152d1233ns t: 00005f1c2744s 155c10cf.caf99eb8ns
> phc2sys[133.599]: /dev/ptp1 sys offset    -25014 s2 freq  -91049 delay 6229170
> 
> kt is still behind t, but now we have a negative "sys offset" ?
> 
> kt: 000000005f1c2745s 158f0f04ns t: 00005f1c2745s 15bd0ce3.e88dec93ns
> kt: 000000005f1c2745s 15ee1e79ns t: 00005f1c2745s 161c1aa9.0c161488ns
> kt: 000000005f1c2745s 16503ebcns t: 00005f1c2745s 167e3973.7b6c4843ns
> kt: 000000005f1c2745s 16b0ebb1ns t: 00005f1c2745s 16dee4f2.436c858dns
> kt: 000000005f1c2745s 1711806dns t: 00005f1c2745s 173f7822.7a65ccddns
> kt: 000000005f1c2745s 177215f1ns t: 00005f1c2745s 17a00c04.b57f3ef8ns
> kt: 000000005f1c2745s 17d15448ns t: 00005f1c2745s 17ff48bd.f1275cb3ns
> kt: 000000005f1c2745s 1830735dns t: 00005f1c2745s 185e6670.73b72a47ns
> kt: 000000005f1c2745s 188f95bbns t: 00005f1c2745s 18bd8724.082da8dbns
> kt: 000000005f1c2745s 18ee9e77ns t: 00005f1c2745s 191c8e4e.044592dcns
> phc2sys[134.662]: /dev/ptp1 sys offset    -98237 s2 freq -171776 delay 6227754
> 
> ... and an even bigger negative "sys offset" but kt is still behind t.
> 
> kt: 000000005f1c2746s 16ad1681ns t: 00005f1c2746s 16db503d.5a2783d6ns
> kt: 000000005f1c2746s 170f8b80ns t: 00005f1c2746s 173dc5a6.91660baans
> kt: 000000005f1c2746s 176ed88fns t: 00005f1c2746s 179d1366.45f7dc3ans
> kt: 000000005f1c2746s 17cdebcdns t: 00005f1c2746s 17fc2725.6da454bbns
> kt: 000000005f1c2746s 182cfb23ns t: 00005f1c2746s 185b371b.6ab43403ns
> kt: 000000005f1c2746s 188c0208ns t: 00005f1c2746s 18ba3e8f.07fd0ee9ns
> kt: 000000005f1c2746s 18eb07fdns t: 00005f1c2746s 1919451f.9b3f2f2bns
> kt: 000000005f1c2746s 194a13e3ns t: 00005f1c2746s 19785178.6fad0c97ns
> kt: 000000005f1c2746s 19a915c8ns t: 00005f1c2746s 19d753fa.d549cdabns
> phc2sys[135.674]: /dev/ptp1 sys offset    -77622 s2 freq -180632 delay 6226562
> 
> ... same story.
> 
> I added the debug (which dramatically increased delay) because I notice
> that phc2sys exhibits random sudden jumps in the "sys offset" value.
> I've noticed it with this driver (which, without the debug, reports a
> delay of around 5000) and also with the Marvell PHY PTP driver.  I had
> put the Marvell PHY PTP driver instability down to other MDIO bus
> activity, as the delay would increase, but that is not the case here.
> 
> There _is_ something odd going on with the adjfine adjustment, but I
> can't fathom that (which is another reason for adding the above debug.)
> 
> If I undo some of the debug, this is the kind of thing I see:
> 
> phc2sys[20.697]: /dev/ptp1 sys offset         2 s2 freq  -25586 delay 5244
> phc2sys[21.698]: /dev/ptp1 sys offset        17 s2 freq  -25570 delay 5262
> phc2sys[22.698]: /dev/ptp1 sys offset       -11 s2 freq  -25593 delay 5250
> phc2sys[23.698]: /dev/ptp1 sys offset       -14 s2 freq  -25600 delay 5265
> phc2sys[24.698]: /dev/ptp1 sys offset       -17 s2 freq  -25607 delay 5250
> phc2sys[25.698]: /dev/ptp1 sys offset        64 s2 freq  -25531 delay 5244
> phc2sys[26.698]: /dev/ptp1 sys offset        -9 s2 freq  -25585 delay 5251
> phc2sys[27.699]: /dev/ptp1 sys offset       -44 s2 freq  -25622 delay 5250
> phc2sys[28.699]: /dev/ptp1 sys offset        35 s2 freq  -25557 delay 5262
> phc2sys[29.699]: /dev/ptp1 sys offset   -433522 s2 freq -459103 delay 5256
> phc2sys[30.699]: /dev/ptp1 sys offset   -500029 s2 freq -655667 delay 5228
> phc2sys[31.700]: /dev/ptp1 sys offset   -369958 s2 freq -675604 delay 5259
> 
> Notice the sudden massive jump in sys offset.
> 
> Any ideas?
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Just a sanity check: do you have this patch?
https://github.com/richardcochran/linuxptp/commit/e0580929f451e685d92cd10d80b76f39e9b09a97

Thanks,
-Vladimir
