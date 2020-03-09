Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAB917D933
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 07:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgCIGSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 02:18:24 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33412 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIGSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 02:18:24 -0400
Received: by mail-pf1-f196.google.com with SMTP id n7so4357038pfn.0
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 23:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=faQgft+xi22Xd4EC1l6GP40WmOyk5PxPX4e9jzqia9U=;
        b=mv9l3wYRYJI/sB1AywOLvMDxvAwBXPXSchCj5lKT/5MEoFhx3vwor6hQF4ZP82lUEC
         16coWVl0VdCwtYSlixLv0h84zM/vqBQKyjRN74ys5OMhesWUqvFSz2SkJsCvQ3rkM1nS
         xKxt0iYc1F/t/pOKRf0nlrntPJlIIHhHSrURNF6ZTeI7bfyd9yIwTkFXaZxtIwekhASj
         xhRmscJuGqUNtsYwt5O6Sw8kQc5NwxJsu3ED+cXQcw8fwJeGE7xRzgOYHom4Y/3PZkPU
         xupi0Odi4ejDHsjyPOUO6JoPtoW+9WZM96VJHb1GFhMPwBgk5vPvNw92RkzP3hGB8Oau
         xfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=faQgft+xi22Xd4EC1l6GP40WmOyk5PxPX4e9jzqia9U=;
        b=ZQkJcysr2+dlBNJbeCo8XlKrNlrcGBC8hagocpHzHUD86ane2OGxDr8P/1wtCgFdC5
         dpV3XjldJyR5rl55sFF6A/jaGrh4BSmVCrruygJ3aZVt78G0VcvkrmIepg+B3J1YJkgZ
         oWrduqCDhZk7CNG02PA7UhS6sJgZOOoti707PeJRky/pQRwzRqnYy154J/1DDX4C51jB
         pXLC7FLFYZtsNDl+cdlTOrylQuR0qulmfxikV/JmmfmX7WcDFukjr70O9kJlYzJY4fS8
         +k/DIuEhXaSu1+k6rctrFMRKHZdBQTep1WaCWb9YMUCyR+V47ISAk+cidGlVWlzFcKV8
         8uOQ==
X-Gm-Message-State: ANhLgQ3a49zmLVasSMjh3Bk4AwTFGhd8hl1IugzXynyW7jnYUwKxCJJ2
        dcjcNvdL3+lB/daTg3Z17Rc=
X-Google-Smtp-Source: ADFU+vt1OK3qJSrxveYKl8FXzx9irDQxxWTifh1K4KwO3lccSaljOy4GSYDvx3REegwGM/A2C5nOZA==
X-Received: by 2002:a63:34c8:: with SMTP id b191mr15581157pga.220.1583734703308;
        Sun, 08 Mar 2020 23:18:23 -0700 (PDT)
Received: from f3 (ag119225.dynamic.ppp.asahi-net.or.jp. [157.107.119.225])
        by smtp.gmail.com with ESMTPSA id q20sm630006pfh.89.2020.03.08.23.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2020 23:18:22 -0700 (PDT)
Date:   Mon, 9 Mar 2020 15:18:18 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Jarrett Knauer <jrtknauer@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/10] qlge.h cleanup - first pass
Message-ID: <20200309061818.GB24692@f3>
References: <cover.1583647891.git.jrtknauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1583647891.git.jrtknauer@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-07 23:23 -0700, Jarrett Knauer wrote:
> This patchset cleans up some warnings and checks issued by checkpatch.pl
> for staging: qlge: qlge.h as an effort to eventually bring the qlge TODO
> count to zero.
> 
> There are still many CHECKs and WARNINGs for qlge.h, of which some are
> false-positives or odd instances which I plan on returning to after
> getting some more experience with the driver.
> 
> Jarrett Knauer (10):
>   staging: qlge: removed leading spaces identified by checkpatch.pl
>   staging: qlge: checkpatch.pl CHECK - removed unecessary blank line
>   staging: qlge: checkpatch.pl WARNING - removed spaces before tabs
>   staging: qlge: checkpatch.pl CHECK - added spaces around /
>   staging: qlge: checkpatch.pl WARNING - removed spaces before tabs
>   staging: qlge: checkpatch.pl CHECK - added spaces around %
>   staging: qlge: checkpatch.pl CHECK - removed blank line following
>     brace
>   staging: qlge: checkpatch.pl CHECK - removed blank line after brace
>   staging: qlge: checkpatch.pl WARNING - removed function pointer space
>   staging: qlge: checkpatch.pl WARNING - missing blank line

It seems like this cover letter made it to the netdev mailing list but
not the actual patches. Please double check and resend.

> 
>  drivers/staging/qlge/qlge.h | 42 ++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 22 deletions(-)

Also, as discussed earlier and looking at the diffstat now, a single
patch would be fine I think.
