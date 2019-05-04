Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AE513B16
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfEDQHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:07:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41014 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbfEDQHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:07:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id d9so4193198pls.8
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 09:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=89jH98lOa/OYSsEz8DyT+x1rCRjXFUvom3wDoF5JI20=;
        b=qZYVrf7QL92bq3ngEpoiZ92ZppFbx8LmTbDoXu+SH/bSSQvD5uZVExGJk0xLtoRqP7
         qIFbcJ27hugd2/HaT/qbYpz9aX2QheqBWnNT4SlL2aCozd3VFdkKPQLTSeDOf5gaPGXL
         RdamY+ADbG0f4qy8exOyfX2wognS9hCKCWk1DJaLCC6G1ICFAN7P57WaaZVeF//PRDIo
         Xsd8dSpXj9v02cY4ZQV+OmBspDaestD2ODaVnqCk2aYjsjjCSexCjWjIlpp7OyWZkh61
         uvzCDfSeqnuSWIyNfdjVumLLN4wPGdRRxCJLCzzJVrkEHVfXdfP8uF8VLNCeHodJdNfd
         xyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=89jH98lOa/OYSsEz8DyT+x1rCRjXFUvom3wDoF5JI20=;
        b=ssDVIZMS37HkeIlns48WjYr2Vrzi0SQuG9C7gscMfp54X+F6p7lkBH7K0wbHSGNYLY
         TSv2AZi8c/2jWioHgy/uEulyHkGIsi0qXY/RdmTbNWpwKG0QuYa88bGKnLHgbbbg/ROW
         idvN1ppDav3BwMr7DtQbFkPyQX+wKaSsNyt1KO3MDgldGLzbLbF6xWJLnwXUvIjlOSB4
         lx51xsHl+SBDDOEESrTdbH3aZkghNwyukEhaIk9EFq1KdB3Xs0vTdXXn/pZUx/MVK420
         8JN1m0KiQ8e8suksF5jZgA/L5DuIJ2ryQ6VeIQAI/brZRIVgCMdGXI9pfjJzVd9UPa2q
         vqBw==
X-Gm-Message-State: APjAAAXn2PMWdziT3ejYC1Qt00p/l392H3yHNKoi1BJkrJEmZbtqvxBM
        jLA1hxFqiLPk2N0zCzACiBOCbERX
X-Google-Smtp-Source: APXvYqz9PdjuRNYZQak1VMF7V5ZR8kQnm8MBcfjhDpvC6XzzUECtk150v2B91HSsKVjpB5qJBN6BPA==
X-Received: by 2002:a17:902:e58a:: with SMTP id cl10mr19161404plb.226.1556986022081;
        Sat, 04 May 2019 09:07:02 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id h20sm12769715pfj.40.2019.05.04.09.07.00
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 09:07:00 -0700 (PDT)
Subject: Re: CVE-2019-11683
To:     Reindl Harald <h.reindl@thelounge.net>, netdev@vger.kernel.org
References: <7a1c575b-b341-261c-1f22-92d656d6d9ae@thelounge.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0ca5c3b7-49e5-6fdd-13ba-4aaee72f2060@gmail.com>
Date:   Sat, 4 May 2019 12:06:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7a1c575b-b341-261c-1f22-92d656d6d9ae@thelounge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/19 11:49 AM, Reindl Harald wrote:
> is this fixed in 5.0.12 and just not visible in the changelog?
> 
> because if not there's no poiunt to reboot a over a long time randomly
> crahsing firewall setup which *appears* stable now after replace "LOG"
> with "NFLOG" and remove --reap from the xt_recent rules
> 
> ----------------------
> 
> https://www.openwall.com/lists/oss-security/2019/05/02/1
> 
> syzbot has reported a remotely triggerable memory corruption in the
> Linux kernel. It's been introduced quite recently in e20cf8d3f1f7
> ("udp: implement GRO for plain UDP sockets.") and only affects the 5.0
> (stable) release (so the name is a bit overhyped :).
> 
> CVE-2019-11683 description:
> 
> udp_gro_receive_segment in net/ipv4/udp_offload.c in the Linux kernel
> 5.x through 5.0.11 allows remote attackers to cause a denial of
> service (slab-out-of-bounds memory corruption) or possibly have
> unspecified other impact via UDP packets with a 0 payload, because of
> mishandling of padded packets, aka the "GRO packet of death" issue.
> 
> Fix (not yet upstream):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=4dd2b82d5adfbe0b1587ccad7a8f76d826120f37
> 
> ----------------------
> 
> https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.0.11
> https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.0.12
> 

The missing part in this CVE is that this is not remotely triggerable as-is.

UDP receiver has to opt-in for GRO, and I doubt any application does this currently.
