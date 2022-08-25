Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB92F5A07CE
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 06:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiHYEUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 00:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHYEUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 00:20:52 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F911A39C
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 21:20:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso3594168pjj.4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 21:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=UpJd1vboMHCSiIKB1BSnbmN2RgQ0C3s8jg9eVBKHTHM=;
        b=cA9vQpFN68fzTDnbKY3lDUPyxnRDb84jwl/b1jDCidRr/+g0kLgH5k4nh+HsDS7UON
         pk7ormswvUb4Zcl/m7bbivF6gdXji0UM7OdaKggMoZZlpL9Iy1LO0WlF1UUefb9MgMWr
         mmVHkeKOG0Dm7S9H19Tq85AGVxuODD8s9LITsLDnRownb8hqjzSyuNArcwaji+bQ+1J8
         qnVJ0GfVSntk2gYl30C+WXdukpx65W3J7bHhykN2esf7xvvzVDGJeBnaxyZjOQ0+54iu
         hZPICyyBSg3E0/3vDFnE38GATM2UkLfdI9gSV57g7adqIM9mSO+02+DqucrTSwBhAui/
         OFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=UpJd1vboMHCSiIKB1BSnbmN2RgQ0C3s8jg9eVBKHTHM=;
        b=lIpOxHJKZ8uuvbgsCjxZRNg57WhK/A3cwWiMRHvuL30v/XkU78swZfGu1Q9xdI/dBM
         mlM+7TYsKa5LIM9o1gisv3rJIQlQQCt8vKMzQ7l9BkSu5Fv2wLKnoL3tHTo9RPiYmApu
         lguLTKuSQMJC7oBVhR55sm9EqK4bvZMxJC+YfBT2lJHPYg2A3RDRIWPif0r6cKWTjm2P
         PUf3IiFXhd3gEweq4BAEuPm82yyGuKD6bnyuPX0Kv1RMKuarNNNIPDHKyipmNGd+SMdX
         s48+jJSVcsABgakG+QmsgaoMG019TL3Sn4X5PXDrQYGezAXyYVr40ggsDiBY9E19v0u+
         tJcQ==
X-Gm-Message-State: ACgBeo3HQ5JX1Q4ZI9bs6+0Ps5GXGxJ9h86AUKvoBNLEvI4maYMw77Q2
        jaq2tqr44SWmTSpfOBEJTmUQhdKaXjs=
X-Google-Smtp-Source: AA6agR7TXwbc2uph4eM7Hs0kWJ+BS9hCaXyEH5OAMbCWs+tys5T+OD+ou5TlaoQ4Y6/HiXbm/nqASg==
X-Received: by 2002:a17:90b:4c0b:b0:1f5:b72:3b0b with SMTP id na11-20020a17090b4c0b00b001f50b723b0bmr11479077pjb.227.1661401250629;
        Wed, 24 Aug 2022 21:20:50 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 22-20020a630d56000000b0041c66a66d41sm11945632pgn.45.2022.08.24.21.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 21:20:50 -0700 (PDT)
Date:   Thu, 25 Aug 2022 12:20:44 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Arkadi Sharshevsky <arkadis@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Question] Should NLMSG_DONE has flag NLM_F_MULTI?
Message-ID: <Ywb4nCoi24S5iAtx@Laptop-X1>
References: <YwWY8ux/PyMWQBWr@Laptop-X1>
 <20220824183945.6ce7251d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824183945.6ce7251d@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 06:39:45PM -0700, Jakub Kicinski wrote:
> On Wed, 24 Aug 2022 11:20:18 +0800 Hangbin Liu wrote:
> > When checking the NLMSG_DONE message in kernel, I saw lot of functions would
> > set NLM_F_MULTI flag. e.g. netlink_dump_done(),
> > devlink_dpipe_{tables, entries, headers}_fill().
> > 
> > But from rfc3549[1]:
> > 
> >    [...] For multipart
> >    messages, the first and all following headers have the NLM_F_MULTI
> >    Netlink header flag set, except for the last header which has the
> >    Netlink header type NLMSG_DONE.
> > 
> > What I understand is the last nlmsghdr(NLMSG_DONE message) doesn't need to
> > have NLM_F_MULTI flag. Am I missing something?
> > 
> > [1] https://www.rfc-editor.org/rfc/rfc3549.html#section-2.3.2
> 
> Looks like you're right, we seem to fairly consistently set it.
> Yet another thing in Netlink we defined and then used differently?
> In practice it likely does not matter, I'd think.

Yes, thanks for the confirmation. I have no plan to change the current
kernel behavior. But for my later patch, I will not add NLM_F_MULTI for
NLMSG_DONE message.

Thanks
Hangbin
