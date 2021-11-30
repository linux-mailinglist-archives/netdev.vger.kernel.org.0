Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6098462BBB
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbhK3EeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238251AbhK3EeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:34:06 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B1FC061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:30:48 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b13so13929035plg.2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EYZWkbiKufepL5DUsrvws3kLv1gbN7FERZNQT6oMhvo=;
        b=dFJSHbJp0h3r+W30bZfsS0tg+IIlBLJYaA9d3vjwej9k+0IAcYY6Rh1yP3WZhWtFhl
         K7X5jZI/5BNsU+ks6BzUsVbZFksH0feq+oIx2+ma6L8ubbdOKQTV3SXJy/0AXz8P5Cf5
         BdXUC/r01Tb6KCSz1uuXxwRBr3niVIktPobU7X+8jwShlcowdWCb78hOCZ69HIw7Forf
         uYz9WztI38WGOkQ/isSsVBjJahCW2ParpVWfrQvTnmZl5ZlIgb1G89CQS2hVzCoS5/vL
         XG/kms/9xdYf4ut7mE5S1P4Maq2SSOJj1BPcseRFmhZH+TETIgCsJokuOU1mmgV5wDMN
         JjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EYZWkbiKufepL5DUsrvws3kLv1gbN7FERZNQT6oMhvo=;
        b=Qtocbcj6ml3ih2C3/sy55BKIPgIuSB/JItBskRxF+dtPvspVTmz4jSAdMHDL6YNWNK
         FuUuqlJUJmRB3Vt8hyi5W+JE43J/3teIXNOQl9sCjnlrrydHZIEgNJks8pcvCE/Nr3wE
         S8brM1+Ot7FY9Mu78HCMOyPYa/2Rt8o3STh/Wbj+ZOnFy3bP0szQj0DmFl4m8+CyiBBl
         6ZOEj4wevJ8eeaK+WZ1g7nw8txeR5JJtUjXTGiPHToz+u8nHplpZe2OACRJquvMDL9iX
         EFojXc8TyLa+7hsZkjcOgz95vYSc+kfzgaBP1ZO4XRMZ2jCu2376SLcfDkorEFNazxnD
         HlQw==
X-Gm-Message-State: AOAM533Mqz6m4r4BOaigLWMAv9swO4rWot06It+CF8Gv9AJ10QXY2Wb6
        eoVtXaXBsUkQbi+/W9DCEOA=
X-Google-Smtp-Source: ABdhPJw7TBiALIQBq3imbrjTIE3jX6NO0LoT/uToSEQU7CORKDGmaAgKSE5a9lp8PklijEpstOmWHg==
X-Received: by 2002:a17:903:18d:b0:142:8ab:d11f with SMTP id z13-20020a170903018d00b0014208abd11fmr65201013plg.47.1638246647797;
        Mon, 29 Nov 2021 20:30:47 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id oa17sm833372pjb.37.2021.11.29.20.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 20:30:47 -0800 (PST)
Date:   Tue, 30 Nov 2021 12:30:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCHv3 net-next] Bonding: add arp_missed_max option
Message-ID: <YaWo863zUUEj8nlU@Laptop-X1>
References: <20211123101854.1366731-1-liuhangbin@gmail.com>
 <17186.1638211801@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17186.1638211801@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 10:50:01AM -0800, Jay Vosburgh wrote:
> >+arp_missed_max
> >+
> >+	Maximum number of arp_interval monitor cycle for missed ARP replies.
> >+	If this number is exceeded, link is reported as down.
> >+
> >+	Normally 2 monitor cycles are needed. One cycle for missed ARP request
> >+	and one cycle for waiting ARP reply.
> >+
> >+	The valid range is 1 - 255; the default value is 2.
> >+
> 
> 	[ Apologies for the delay in responding, I was out for the US
> holiday last week. ]
> 
> 	For the documentation here, since deleted code commentary from
> many years ago came up in discussion (re: backup interfaces get one more
> cycle), I'd suggest we rewrite the above as:
> 
> arp_missed_max
> 
> 	Specifies the number of arp_interval monitor checks that must
> 	fail in order for an interface to be marked down by the ARP
> 	monitor.
> 
> 	In order to provide orderly failover semantics, backup
> 	interfaces are permitted an extra monitor check (i.e., they must
> 	fail arp_missed_max + 1 times before being marked down).
> 
> 	The default value is 2, and the allowable range is 1 - 255.
> 	
> 
> 	With the above caveat,
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

Thanks Jay for the review. Patch v4 posted.

Hangbin
