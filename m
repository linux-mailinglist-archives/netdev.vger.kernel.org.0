Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7041190E2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfLJTlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:41:16 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33037 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLJTlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:41:16 -0500
Received: by mail-ot1-f66.google.com with SMTP id d17so16658064otc.0;
        Tue, 10 Dec 2019 11:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R83QtXeO25iJn8IIxnah9iFn17pE1UtDQO4xFZfF6uY=;
        b=cG5STPDbLQSxbyR1qFBtw0bm8F8a+PZv4SlrIwwgoIhOh87cC39hofilNVzE6l87gR
         pvJe8RsQB5yKofwnt0nmWhQ1r8XDDHK/S74AbpArymg5/6++VKraI6CNa/VB4SXqWGNP
         J7+gjQZpbV7CnqnfIWxsqOyT3891pAf2SjkTTlohHLSn8MnJhx3C1xFosPGTBcEXkAHm
         Mdve8NsOcbpVJc36EdqCRzPVUpLA4O4gFEJmTulj+KHRXXxqYTkZM3fCRs6f2SL+BAvw
         YDv5ibI77J2z3lXSkPfem+cQrGZg6pu1XUXyrMUfpEPXsW2cLqYLNh5H2r0z2fQF+VEH
         yIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R83QtXeO25iJn8IIxnah9iFn17pE1UtDQO4xFZfF6uY=;
        b=e9lYDabNL2j+4jCE/xG9M9kgVjwrxrNq3qRBwl/22EUHdiA7RqyKBoTpnMukL93RD7
         ldlo3W4WvC4D8SDjFoj20LykgUC7yh6xfGhjD5FHueFyzVEbVHwdfSWSwm+2ogUCSqyO
         6v8kFWx6U16EI6NjvxzjECE2JoIPyJIw/s8IE++/qQEiyGQhRpNBEvUXxffali3UMkyj
         aUsIm+t/S0rkitsN7lW6JHPW1VwlFLXYSSXJtVPBPbgibpU3FhTpVV23wAvEQqJEljgr
         Wuon5dV0/Xugc6M5/tulc/gRiyxxoyzEq54TBry0RLx9fgZHnDtTYsURr0ln1pCGlhZ/
         ZefQ==
X-Gm-Message-State: APjAAAXSCEufAGcVWN78qtpN+wF3l9Y5SyvtmHcJvsjNrX12LyRlmwfL
        RaB/9QmkPLrqAo30Fqu2mhxO64lfeqI=
X-Google-Smtp-Source: APXvYqwj7IlFzd7fTg//b46vTz/Bnh16nomGJYdN53u03HEpszXsPKwNobIL27/F2dZstEw06Uwqgg==
X-Received: by 2002:a05:6830:1492:: with SMTP id s18mr27774328otq.285.1576006875389;
        Tue, 10 Dec 2019 11:41:15 -0800 (PST)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id f85sm1758884oib.38.2019.12.10.11.41.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Dec 2019 11:41:14 -0800 (PST)
Date:   Tue, 10 Dec 2019 12:41:13 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: tulip: Adjust indentation in
 {dmfe,uli526x}_init_module
Message-ID: <20191210194113.GA10106@ubuntu-m2-xlarge-x86>
References: <20191209211623.44166-1-natechancellor@gmail.com>
 <20191209.202920.1031568566965416683.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209.202920.1031568566965416683.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 08:29:20PM -0800, David Miller wrote:
> From: Nathan Chancellor <natechancellor@gmail.com>
> Date: Mon,  9 Dec 2019 14:16:23 -0700
> 
> > Clang warns:
> > 
> > ../drivers/net/ethernet/dec/tulip/uli526x.c:1812:3: warning: misleading
> > indentation; statement is not part of the previous 'if'
> > [-Wmisleading-indentation]
> >         switch (mode) {
> >         ^
> > ../drivers/net/ethernet/dec/tulip/uli526x.c:1809:2: note: previous
> > statement is here
> >         if (cr6set)
> >         ^
> > 1 warning generated.
> > 
> > ../drivers/net/ethernet/dec/tulip/dmfe.c:2217:3: warning: misleading
> > indentation; statement is not part of the previous 'if'
> > [-Wmisleading-indentation]
> >         switch(mode) {
> >         ^
> > ../drivers/net/ethernet/dec/tulip/dmfe.c:2214:2: note: previous
> > statement is here
> >         if (cr6set)
> >         ^
> > 1 warning generated.
> > 
> > This warning occurs because there is a space before the tab on these
> > lines. Remove them so that the indentation is consistent with the Linux
> > kernel coding style and clang no longer warns.
> > 
> > While we are here, adjust the default block in dmfe_init_module to have
> > a proper break between the label and assignment and add a space between
> > the switch and opening parentheses to avoid a checkpatch warning.
> > 
> > Fixes: e1c3e5014040 ("[PATCH] initialisation cleanup for ULI526x-net-driver")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/795
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Applied, but it's really crummy that the tool gets tripped up by the
> fact that a space preceeds the TAB.  It's what the code visually looks
> like, not what exact kinds of SPACE characters were used to get there.

I agree. There is a follow up patch from the author of the warning that
claims to alieviate some of these but that is still in discussion and as
far as I understand it, it won't fix all of them so I'm just dealing
with all of them on the Linux side.

https://reviews.llvm.org/D71037

Thanks for picking them up!
Nathan
