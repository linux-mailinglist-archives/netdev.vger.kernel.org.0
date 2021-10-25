Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB144398AD
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhJYOfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbhJYOet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:34:49 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4B0C061243;
        Mon, 25 Oct 2021 07:32:27 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id l13so244626edi.8;
        Mon, 25 Oct 2021 07:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OvHxVdBiq3d0CEHZOgKJHqAMPLyqFUfAkg1FgJZBk5U=;
        b=FuTwxA7YU4/jmi9fqEtV1A6jZEvWOXDHdkw+YVVk6VZQsr8Xh5BHOQhKz4kZ+p634T
         G17MmUWoT2INkiYnXywpkfp1UvWfuARIwqp4jnMLA14kmB4wiZDE93qtqcBUEYG8UUbI
         qLCGYDacT4whWwcU0WF/Nk2cBXGYFNzpy4VrMPnvVJVq9xBRPzKhRFeG8TT2zHq1bH+7
         gV5JoEocHxz+I6cbe/q66bB4bVc21LwhNn4nmsHmgFrRrLgQLceY5gmaqpqmi264iZ45
         d5jlZEOHVuU5PINSf79fDlj3tVggczIJ2WYO9wCFKNlLLi8JzBHpNVlnGyungpjiMjYI
         JonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OvHxVdBiq3d0CEHZOgKJHqAMPLyqFUfAkg1FgJZBk5U=;
        b=OW2WAvZS8TBBk7aawN9D/Mat/XpraFUJ5xn4IoGnTppbmNTlyEeUXv5Bcwhr0bLg+l
         oK72+3MqERpCLcPaywKLC9Jy3se2EchowGobkbKV7kfLyIS8GDEKURUWQe1OAHUvHCmt
         vRO1zN1AiIyFO9nxjeD0KGZnWq6KK7gxJ+Q8ufCTR6Lkw2jk0JSglh8HNgS77k5nf1cD
         57pXadKokPiEasxhDnDA2jcn6proCmv3/y+B2AZ+bFLDrTetD8KW5Ns/Em3+Gu6dxWYy
         JSsWoMCbHCUEbBEN5Z6w562z0pJRZfb9pEDlC+zqUc8+kDVMbzFgVGLFvAk6ThYbD4fc
         kYZA==
X-Gm-Message-State: AOAM532QQp3/v3H8vgQwZ5BpYdfFC/URUkkv4WvFa/vJkio4Sduy3g72
        9QtULspSzydFn4U0d0A4UAo=
X-Google-Smtp-Source: ABdhPJzlp2Ahx4Ltr2Ak6WT06DgmlcVqLiqGhNKXwxlx8Tb160yQctirUyz0zKe5yCc4pwPM92+2HA==
X-Received: by 2002:a17:907:764c:: with SMTP id kj12mr8373378ejc.290.1635172340010;
        Mon, 25 Oct 2021 07:32:20 -0700 (PDT)
Received: from skbuf ([188.25.174.251])
        by smtp.gmail.com with ESMTPSA id k6sm1078863eds.55.2021.10.25.07.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 07:32:19 -0700 (PDT)
Date:   Mon, 25 Oct 2021 17:32:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net-next 6/9] s390/qeth: fix various format strings
Message-ID: <20211025143218.tedvthmjddi4ecgp@skbuf>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
 <20211025095658.3527635-7-jwi@linux.ibm.com>
 <20211025132229.4opytunnnqnhxzdf@skbuf>
 <1285bc39-b3fc-55b1-5422-a1474cd31c28@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285bc39-b3fc-55b1-5422-a1474cd31c28@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 03:35:25PM +0200, Julian Wiedmann wrote:
> On 25.10.21 15:22, Vladimir Oltean wrote:
> > On Mon, Oct 25, 2021 at 11:56:55AM +0200, Julian Wiedmann wrote:
> >> From: Heiko Carstens <hca@linux.ibm.com>
> >>
> >> Various format strings don't match with types of parameters.
> >> Fix all of them.
> >>
> >> Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
> >> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> >> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> >> ---
> >>  drivers/s390/net/qeth_l2_main.c | 14 +++++++-------
> >>  1 file changed, 7 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
> >> index adba52da9cab..0347fc184786 100644
> >> --- a/drivers/s390/net/qeth_l2_main.c
> >> +++ b/drivers/s390/net/qeth_l2_main.c
> >> @@ -661,13 +661,13 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
> >>  					 card->dev, &info.info, NULL);
> >>  		QETH_CARD_TEXT(card, 4, "andelmac");
> >>  		QETH_CARD_TEXT_(card, 4,
> >> -				"mc%012lx", ether_addr_to_u64(ntfy_mac));
> >> +				"mc%012llx", ether_addr_to_u64(ntfy_mac));
> >>  	} else {
> >>  		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
> >>  					 card->dev, &info.info, NULL);
> >>  		QETH_CARD_TEXT(card, 4, "anaddmac");
> >>  		QETH_CARD_TEXT_(card, 4,
> >> -				"mc%012lx", ether_addr_to_u64(ntfy_mac));
> >> +				"mc%012llx", ether_addr_to_u64(ntfy_mac));
> > 
> > You can print MAC addresses using the "%pM" printf format specifier, and
> > the ntfy_mac as argument.
> > 
> 
> Unfortunately not - no pointers allowed in such s390 dbf trace entries. See
> e19e5be8b4ca ("s390/qeth: sanitize strings in debug messages").

Is this because __debug_sprintf_event() saves just the printf-formatted
string and evaluates it only when the trace buffer is shown? Sorry for
my ignorance.
