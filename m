Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203371E8351
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgE2QMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2QMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:12:07 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E144C03E969;
        Fri, 29 May 2020 09:12:07 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g18so2309389qtu.13;
        Fri, 29 May 2020 09:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Hm4Y+BJ4D4CDaqRSBoPJgH15jAjD9VDDckblAz9nbU=;
        b=Rqj+JqwnLWRZO0jBT2Kjr4dplZYMLkOst8UiABhnGmWh5cFT+cuWfa87C78/NL7zyL
         GB8mZ+lZqJG+wZYrMkI6q/k27fjzfBG9b1HPi0y8yx0pcrFDH262UFXb8U7LYYOMM1ht
         Edjq47HSSFd9icFSKm3M9DTiLwyu4Xv7wCPfTYe8Gks00dxqAN4QuLy/mW2BZpUMN1c6
         5Nj7rAocFphIuUAvPOK3WrlQiAYb0rAblxnKKbJzuOdZWGOyH+CCXPMzbR/a7vyQorvN
         RN7pmlalI8p6bb5PFbX/ipk/AHXToMKexyY9/bk/wUisBXWzyk+58l1WOX0iyy1CAHrf
         TKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Hm4Y+BJ4D4CDaqRSBoPJgH15jAjD9VDDckblAz9nbU=;
        b=f58zMCIYGOTLD36B+vXjwXG/2YiUUhxHoteKNB5xNiFnZrLxcmSbZG8UObqmMv7zbq
         HGZJi4pjo1GZj/v2vEUMjjdjQHoyukGxk6uXZ0k7XjoOUsNmhC4uAqWFW5dtLJSVKe5c
         Yh4AwTuKBYTwRGkdAVF8Vau72R9pF4lAE/3NGEsu+InACERoMW43T0HzaJoc+V9IgdFE
         4Px1HORNF1ii1jjL8+IJzmz4Xr9LSXhCFI1Gk7zzeJ2yuDLUrcX+6j4Ce0vBmIU5QE7R
         zYPoAKtM0JRTDYCk/SErX++NPp7Vglwco9ZuXWHHOJElzTT+LWoHmtPwD2BZz1KIIMyL
         polQ==
X-Gm-Message-State: AOAM531cLaL6q0k7zGldl33vQpb51KeJrrbAL2fADWBKN9VIARdUNPGr
        S1jyZoW/kUm62JIuH9ikYN4=
X-Google-Smtp-Source: ABdhPJxJ9vHZyhS/fIlONrPd0OT9YzlS6kVi1Vtvqh7UtUjOkglBDKPjjROOo7MQ34l79/0YBwscWw==
X-Received: by 2002:ac8:7007:: with SMTP id x7mr9451446qtm.238.1590768726505;
        Fri, 29 May 2020 09:12:06 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id m10sm8195646qtg.94.2020.05.29.09.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:12:05 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4060FC1B84; Fri, 29 May 2020 13:12:03 -0300 (-03)
Date:   Fri, 29 May 2020 13:12:03 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     David.Laight@aculab.com, vyasevich@gmail.com,
        nhorman@tuxdriver.com, kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v3 net-next 1/8] sctp: setsockopt, expand some #defines
Message-ID: <20200529161203.GL2491@localhost.localdomain>
References: <bab9a624ee2d4e05b1198c3f7344a200@AcuMS.aculab.com>
 <8bb56a30edfb4ff696d44cf9af909d82@AcuMS.aculab.com>
 <20200526.153631.1486651154492951372.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526.153631.1486651154492951372.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 03:36:31PM -0700, David Miller wrote:
> From: David Laight <David.Laight@ACULAB.COM>
> Date: Tue, 26 May 2020 16:44:07 +0000
> 
> > This should be 3/8.
> 
> David just respin this at some point and with this fixed and also the
> header posting saying "0/8" properly instead of "0/1", this is really
> messy.
> 
> Thanks.

I don't know why David's workflow is that cumbersome. I'll try to
respin this myself, on top of Christoph's latest changes.
