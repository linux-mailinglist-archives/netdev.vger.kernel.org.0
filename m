Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3EF1B121A
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDTQn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726013AbgDTQnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:43:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0443CC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:43:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u9so5196030pfm.10
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lTdaVitjoamzduqiKstesy7cZ6fQU0C3RwKaxAsOYE8=;
        b=mNGhRRGumA5VrX6P27+2Cn4npd1dcI7m1t+oxI/wH2kr4q5TfLfQ86uhs5AQ5vU/To
         qQl8o4BeFuHAqc539fJ5W29wTP8MN3o6BNxG01v8a1mOI9siXfHpJNYXSpVPZJwFqN3r
         2rGZ7GS+SQwobDgEIXG4nEkt1zq9bPtaqfKQ1z0eVD2ocFfyfU/JUL+n8MAvLnRXcoux
         PSQiX2Jpgmk5q9L7aIi9LWm363ctq7nmJtsc1dQBo6C51y86cliOeFvKMH18empzklBT
         qm26qhwnUV5hNVLz1PiSa2kNINeCBJt2LgWzhcKAGSMy2VlXoFjHD+0lgSo9R1ZEvpTV
         pMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lTdaVitjoamzduqiKstesy7cZ6fQU0C3RwKaxAsOYE8=;
        b=mWNUH2lPBR5tgkRa0ntz75ic8y0RNixczX58lir7AGpvlXJOGLbs5NxfF2KSFuTbZR
         EDm3KmwzLQDz5yY+cZ4Sd1paOXmTDlr4qOjymW6rPO7Of+I84IzpjY/pMUp4IndONljD
         Lq+YOT3bUP8x3jFGdKpoBM7sMCBScHDhUYiB7cEq7FY3f2M0P1lqBdpdpVr+9WY4RnVN
         x3IAl6L+nzUsymcsTiLbAt+ZM/JsLaHnk43TXgA/PB+EuDwmxtpQggXJ33QbtzHkQQxL
         ITdY0L2+PCM3BuwaruOEeogvhR0L+oFd16LuzAQzZot2HrfSibLKLYlFgqVL5vde+EeU
         Z9JQ==
X-Gm-Message-State: AGi0Pub51ivC4vsv5mWYqr94sHaqfpMP2XRoTXsH3y89tU5yZmDI8514
        et/SfDYYRD/R516+uG3p7RlU6g==
X-Google-Smtp-Source: APiQypICI98Hl76xGID+3ziH8O60mRlQcxKADmhFRHykQgiSNe7BtA3ki/siU/5Lu7zEkphzaSgQjQ==
X-Received: by 2002:a63:4c1d:: with SMTP id z29mr15261069pga.243.1587401034570;
        Mon, 20 Apr 2020 09:43:54 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t126sm4081pfb.29.2020.04.20.09.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:43:54 -0700 (PDT)
Date:   Mon, 20 Apr 2020 09:43:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     roucaries.bastien@gmail.com
Cc:     netdev@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        Bastien =?UTF-8?B?Um91Y2FyacOocw==?= <rouca@debian.org>
Subject: Re: [PATCH 1/6] Better documentation of mcast_to_unicast option
Message-ID: <20200420094351.0fadab71@hermes.lan>
In-Reply-To: <20200412235038.377692-2-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
        <20200412235038.377692-1-rouca@debian.org>
        <20200412235038.377692-2-rouca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Apr 2020 01:50:33 +0200
roucaries.bastien@gmail.com wrote:

> +.BR mcast_to_unicast
> +works on top of the multicast snooping feature of
> +the bridge. Which means unicast copies are only delivered to hosts which
> +are interested in it and signalized this via IGMP/MLD reports
> +previously.
> +
> +This feature is intended for interface types which have a more reliable
> +and/or efficient way to deliver unicast packets than broadcast ones
> +(e.g. WiFi).
> +
> +However, it should only be enabled on interfaces where no IGMPv2/MLDv1
> +report suppression takes place. IGMP/MLD report suppression issue is usually
> +overcome by the network daemon (supplicant) enabling AP isolation and
> +by that separating all STAs.
> +
> +Delivery of STA-to-STA IP mulitcast is made possible again by
> +enabling and utilizing the bridge hairpin mode, which considers the
> +incoming port as a potential outgoing port, too (see
> +.B hairpin
> +option).

It probably doesn't make difference but seems like inconsistent usage
of Bold and BoldRoman macros

.B mcast_to_unicast
works on top of the multicast snooping feature of

.BR hairpin "option)."

