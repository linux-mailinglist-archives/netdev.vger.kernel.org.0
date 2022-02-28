Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4524C61E8
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiB1DoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiB1DoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:44:06 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC853A1AA
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 19:43:27 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id j10-20020a17090a94ca00b001bc2a9596f6so10142752pjw.5
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 19:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TmIn0vl+wQIL0hn6QDnwHjOHMijLSEmLnqSYD60fvQY=;
        b=Tda1OhespAbalOt0LRTu2xmmjqhAPe2CYmib/UzONmVjYDTOjuxuUtr59UCGVyeUFC
         4XmjEyJUqOkVMvokcrTsePZO9sLBXuOYvuLdX6/PRZYg83cI+ofgDP+mo3djFP5GvoMg
         bWw8Hi3jCTDRTObYLD2dZK3kROKOi76ztm/axB4vunZpyO3RKrESX0xuFCXcccVVEP1U
         0cIh6zA5miSROBGtfB2Hg3hKDB+gS6g9tml9n5ws1yN5dNPAkP7veOayDGRARYyUh3hY
         nm12YeDG4YwDr4PMFaO+Y7sLFngk+kNwt+/dghu0fNCZ2bWjojjmsU24Vsdi/v1GImUJ
         fwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TmIn0vl+wQIL0hn6QDnwHjOHMijLSEmLnqSYD60fvQY=;
        b=sluKwexERHjQNdTr0FH9wcn0H8KAlAxOJ8qrPGg+CcqQIDunDE4XrDCEa3PHh/3q2l
         Lu9sltpI/vo/r7xjgYYxKTRld4mpPcAjxT4Q2GrzPzP60ilL8Te+JFKtZqc0gb8DoOj7
         O1uPNOfeu1VYsUG5Ak/3MhmxFweH/BYS7emjKLPShLPFsR2DxKIdudgtCWbub5JrfJHx
         FD4I5iYkZ+IzBEBv7vlntOvbbEZ23IxLP1cAQxWcPnB7EkGc6wcz7RtzBGL07K3yF0v0
         oalG0gT1QZs8e/Db2hdfz4eyL1jqstb/h2Xs7ZZCTZKFVataKQPL18rKOdA/3V9QMDTJ
         QO/A==
X-Gm-Message-State: AOAM5316qi/7QPzk1VIa7jGqh62gQFajBF7TuY0e3oOzMLk+O41CP2yt
        So91oWv0wdJO/+MjK1yzrqnVlEhtL1FfVw==
X-Google-Smtp-Source: ABdhPJy9KGqOapamTvbou/68CWrdgTTJPL+SgKGh8H1FK47cVxcGAVXcQglv5a1k8wzvUvJuggkxnw==
X-Received: by 2002:a17:902:ab5e:b0:14f:f73c:821d with SMTP id ij30-20020a170902ab5e00b0014ff73c821dmr18193826plb.161.1646019806977;
        Sun, 27 Feb 2022 19:43:26 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l5-20020a056a0016c500b004f140564a00sm11209077pfc.203.2022.02.27.19.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 19:43:26 -0800 (PST)
Date:   Mon, 28 Feb 2022 11:43:21 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCHv2 iproute2-next] bond: add ns_ip6_target option
Message-ID: <YhxE2fwJWHkNzR90@Laptop-X1>
References: <20220221055458.18790-1-liuhangbin@gmail.com>
 <20220221055458.18790-7-liuhangbin@gmail.com>
 <243fb2a1-f8d5-c427-a0a7-44ac3d71af58@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <243fb2a1-f8d5-c427-a0a7-44ac3d71af58@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 27, 2022 at 06:32:41PM -0700, David Ahern wrote:
> On 2/20/22 10:54 PM, Hangbin Liu wrote:
> > Similar with arp_ip_target, this option add bond IPv6 NS/NA monitor
> > support. When IPv6 target was set, the ARP target will be disabled.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> > v2: define BOND_MAX_NS_TARGETS
> > ---
> >  ip/iplink_bond.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 52 insertions(+), 1 deletion(-)
> > 
> 
> > +		} else if (matches(*argv, "ns_ip6_target") == 0) {
> 
> changed matches to strcmp and applied.
> 
> we are not accepting any more uses of matches.

Oh, my bad. I forgot to change match to strcmp when copy/paste the
arp_ip_target code...

Hangbin
