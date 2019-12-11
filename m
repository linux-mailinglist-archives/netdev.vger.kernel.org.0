Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54AC411A5D8
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfLKI2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:28:43 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:32853 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfLKI2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 03:28:43 -0500
Received: by mail-yb1-f194.google.com with SMTP id o63so8757511ybc.0;
        Wed, 11 Dec 2019 00:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gpuk/6fgFZEvalrQGg6avsB0dY+y51rwO2rD1UzUjgQ=;
        b=eNe13BCmYpqFXSSYVg/raEywCIw/5nPHLKm9U9qH8eornuNc3ym0k34KvrvgBTQT5D
         EORCrGYsxMd55hmo/ngIgqo7ckcbG0Nj9DXFUFsDY5i4u3ayPE1fS9bHSFQpSNbnUAR9
         0avaW0Hbs9D9XUQU5VOzwEwMR6bBhapPk/gJITbk4WzUeiE492ulHCFuu4JJjcLG66Df
         d0ZIckx5KBKVu27l/M8EdDMG7mYB3PdUtKjDvHHiSWSgEkktCics2RZKap3NM9/55Qc0
         VaHLXDOQ4PTa3KB/iY3hvvNNrPc0gcRUSNuOW1TFE0endihnaBmDqpvJQrQaySOWkMA9
         EoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gpuk/6fgFZEvalrQGg6avsB0dY+y51rwO2rD1UzUjgQ=;
        b=FrsaAPcM1CN/8VjvwuOo8V0VVR+kaVOxDpDQo9WssEWlOmEZFg+tmhNf2kwE25ei90
         2VozzUfM9e4pdq3VKGG7k4H7iGPE58AmuyhhqVHmXqIF7cxJN6W1ZJCxFHjo2j8dznhL
         B2lqFV8aWPGYhnh+jPZlfRWpO1UU2SZQeGlQ+R1D+PvM8BQVlm19aBf2EFv87VB7Fr0a
         zq4rLVtwcswK1+DW31BZXgNn61kys4vMKZhy04ObxD+vvoTc6ON8UtIjLUfDSR08H7Qu
         D5DjiA1qSeLMUdRimbqUSBehRQp4q2Bg0cdZ4ub4mzmMUsHBkHes2j1J2knTGUvbf/Ej
         +vow==
X-Gm-Message-State: APjAAAX5J5hYGfCcTulsa4Z9wnO02Vy84YhJ0Max6P9VtTPnDFQGacCg
        SKOEY2cjtgDZYQafsH2m6Kc=
X-Google-Smtp-Source: APXvYqwE10h3gNKTPZrfppPm75isVrI65WhKpiLDIwf4LT9LCSccHABY4gnhxmaNnubCz/3EWbMT6A==
X-Received: by 2002:a25:ac8:: with SMTP id 191mr1674636ybk.396.1576052922070;
        Wed, 11 Dec 2019 00:28:42 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id y9sm681643ywc.19.2019.12.11.00.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 00:28:41 -0800 (PST)
Date:   Wed, 11 Dec 2019 02:28:39 -0600
From:   Scott Schafer <schaferjscott@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, GR-Linux-NIC-Dev@marvell.com,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Fix multiple WARNING and CHECK relating
 to formatting
Message-ID: <20191211082839.GA13244@karen>
References: <20191211014759.4749-1-schaferjscott@gmail.com>
 <20191211073136.GB397938@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211073136.GB397938@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 08:31:36AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Dec 10, 2019 at 07:47:59PM -0600, Scott Schafer wrote:
> > CHECK: Please don't use multiple blank lines
> > CHECK: Blank lines aren't necessary before a close brace '}'
> > CHECK: Blank lines aren't necessary after an open brace '{'
> > WARNING: Missing a blank line after declarations
> > CHECK: No space is necessary after a cast
> > CHECK: braces {} should be used on all arms of this statement
> > CHECK: Unbalanced braces around else statement
> > WARNING: please, no space before tabs
> > CHECK: spaces preferred around that '/' (ctx:VxV)
> > CHECK: spaces preferred around that '+' (ctx:VxV)
> > CHECK: spaces preferred around that '%' (ctx:VxV)
> > CHECK: spaces preferred around that '|' (ctx:VxV)
> > CHECK: spaces preferred around that '*' (ctx:VxV)
> > WARNING: Unnecessary space before function pointer arguments
> > WARNING: please, no spaces at the start of a line
> > WARNING: Block comments use a trailing */ on a separate line
> > ERROR: trailing whitespace
> > 
> > In files qlge.h, qlge_dbg.c, qlge_ethtool.c, qlge_main.c, and qlge_mpi.c
> > 
> > Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
> > ---
> >  drivers/staging/qlge/qlge.h         |  45 ++++++-------
> >  drivers/staging/qlge/qlge_dbg.c     |  41 ++++++-----
> >  drivers/staging/qlge/qlge_ethtool.c |  20 ++++--
> >  drivers/staging/qlge/qlge_main.c    | 101 ++++++++++++++--------------
> >  drivers/staging/qlge/qlge_mpi.c     |  37 +++++-----
> >  5 files changed, 125 insertions(+), 119 deletions(-)
> 
> Hi,
> 
> This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
> a patch that has triggered this response.  He used to manually respond
> to these common problems, but in order to save his sanity (he kept
> writing the same thing over and over, yet to different people), I was
> created.  Hopefully you will not take offence and will fix the problem
> in your patch and resubmit it so that it can be accepted into the Linux
> kernel tree.
> 
> You are receiving this message because of the following common error(s)
> as indicated below:
> 
> - Your patch did many different things all at once, making it difficult
>   to review.  All Linux kernel patches need to only do one thing at a
>   time.  If you need to do multiple things (such as clean up all coding
>   style issues in a file/driver), do it in a sequence of patches, each
>   one doing only one thing.  This will make it easier to review the
>   patches to ensure that they are correct, and to help alleviate any
>   merge issues that larger patches can cause.
> 
> If you wish to discuss this problem further, or you have questions about
> how to resolve this issue, please feel free to respond to this email and
> Greg will reply once he has dug out from the pending patches received
> from other developers.
> 
> thanks,
> 
> greg k-h's patch email bot

I was wondering how I would go about chaning the patch. I know I should
switch to a patchset but how would I go about doing that? Also where
would I place the new patches? Would I, create a new patch series or
would I split the patch into new (smaller) patches and reply to this
thread?

Thanks, 
Scott Schafer
