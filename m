Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04B013617A
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 21:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgAIUAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 15:00:31 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34574 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729655AbgAIUAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 15:00:30 -0500
Received: by mail-pf1-f193.google.com with SMTP id i6so3872726pfc.1
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 12:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lpx7b2JdiwqneUF0zUtsDvZpIyyVuyUstXB+Hb6sBNE=;
        b=u30KBfjf+wDX2OREYY4MnZmjt3gwuZYHAel0xGKkalFrN4t4DFZXgy0Vl6+uP1p7XE
         4Qm7g9pm8sWQ8nstHi2G6Ut7sGPHYKRkn6ZgBUfBryA026wxfDIWxrrLNK9zgFZHJqpt
         /N4l9yFM01E+XgskTU6VPAn3/zHshV+zIFE/7MoEryFPV4FRxCe0VY2CKAmqJCDaM1T9
         cp1+qaV9wYb1h+lFFrnWvDEpgh7PnEedUc4uLPG1Cc+PpbjthuRWFzcY71tz3N+6BIGy
         OQpBVwfUFrVMQOg9q2XyMuaYry1Od9iljUAYVTc6TB6OvNVVyCGBv4Jc52mNng9qexO+
         SF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lpx7b2JdiwqneUF0zUtsDvZpIyyVuyUstXB+Hb6sBNE=;
        b=NqGhL5Uz9sVbe9Afn6kFNKZQ3Iaxne+FpsusOSAdhgcUpuOwskCCBCS06fCG/WhVH6
         i7xmxMOQdPSCs8XQ6hpnodp3bxiAUT4cDPW6FpyOJ9N/entyx0tCDVyeoYa0YRvtbV23
         gy5MBt5HPvLw4+1E82qDFXoDmVzbopFHnhbAxs+5zyzyIvjiDIGALTpU2Gxttw5Rk78O
         o5UHfGAgGHqvq4fleEbpqrCb00LgZ/2nAd6WubTuiSM86DpPqcHlJOHqV+3U4mIQj+V3
         3t8KqfgLY06tq1ou8wb/JENPXnjTXTkzD8PTcACQtmpByrZbNtUc9q1ukzb8h7I1Mlol
         ZdIw==
X-Gm-Message-State: APjAAAUBFOFLhKSANU/BJCBE5OtTS/hGVNF/2gwfw+TLkJbbhbhDEL1z
        z3ZpJz1wSAu+5+KiFnPiLKmPI0K5RCY=
X-Google-Smtp-Source: APXvYqzMMyR8gd1eQAGOkjo7kVn6tRhhW0nG/6+DJLQtIFRlpCExv0vOPhIYs4mpC+K5/BqVhfvcVg==
X-Received: by 2002:a63:213:: with SMTP id 19mr13449086pgc.160.1578600030076;
        Thu, 09 Jan 2020 12:00:30 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i4sm8638826pgc.51.2020.01.09.12.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 12:00:29 -0800 (PST)
Date:   Thu, 9 Jan 2020 12:00:21 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, jiri@resnulli.us
Subject: Re: [PATCH 2/2] doc: fix typo of snapshot in documentation
Message-ID: <20200109120021.66a46535@hermes.lan>
In-Reply-To: <20200109190821.1335579-2-jacob.e.keller@intel.com>
References: <20200109190821.1335579-1-jacob.e.keller@intel.com>
        <20200109190821.1335579-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jan 2020 11:08:21 -0800
Jacob Keller <jacob.e.keller@intel.com> wrote:

> A couple of locations accidentally misspelled snapshot as shapshot.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  Documentation/admin-guide/devices.txt    | 2 +-
>  Documentation/media/v4l-drivers/meye.rst | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
> index 1c5d2281efc9..2a97aaec8b12 100644
> --- a/Documentation/admin-guide/devices.txt
> +++ b/Documentation/admin-guide/devices.txt
> @@ -319,7 +319,7 @@
>  		182 = /dev/perfctr	Performance-monitoring counters
>  		183 = /dev/hwrng	Generic random number generator
>  		184 = /dev/cpu/microcode CPU microcode update interface
> -		186 = /dev/atomicps	Atomic shapshot of process state data
> +		186 = /dev/atomicps	Atomic snapshot of process state data
>  		187 = /dev/irnet	IrNET device

Oops, irnet is part of irda which is no longer part of the kernel.
