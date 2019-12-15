Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A517A11FB10
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 21:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfLOU1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 15:27:51 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44488 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfLOU1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 15:27:51 -0500
Received: by mail-pl1-f195.google.com with SMTP id az3so3527408plb.11
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 12:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Dx8PGzua2mEFts+NSIP1exfPCn9I/ZJAV+I6JDILguU=;
        b=jqTvciCpe69MWOynmw9mRNNWp46FsXRXmGoeOGldki/igzCDhEYgbRBwYIzrQdiVu4
         scGEg/HEtpCBgcePMWjtShmd5Zko2SpRrVgXJ+lwdUA3bLeK3qKKrg21t9Yq/lysJpNj
         bd7ZzJXjwh9mfLknw6b/0mnh78sOoxR55SC3F2Di9wtMCV7syC5mF8XRkCrn0cTDFpll
         4Vi4d93MtuqSKCEvPp/+UBCvbyO+tcG0on69xZRjf72yWwtl1q/hvfSW6sFgPEdwPoZ7
         FIeKdNqR1/r6NG+Nb0YVzdGkDd6xLL19hH2MxGA7Ji8KAQ7lP4nktFxvJK6NkqBEfenY
         npRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Dx8PGzua2mEFts+NSIP1exfPCn9I/ZJAV+I6JDILguU=;
        b=haFcTbBzVsF+sUrdexqY6RQPjLYHojCxtd34wJqOTFaTaYfJPS9pFdxcEfRU3+pat2
         MNX0NZyoRj4Sexrk3FupIlPCeY7SE1P2AZV2YwHiMmUvDe9eI572i3QD4mHNymO7/XPw
         LEle6KAYUviNpG8BKobunZKRScJibIcCSNYFOgRaDZgocmFhkHIIDTcbMPHFPqc2tp8k
         NTjLQqUfTbUIpCPpEEEofs36vZ6Abyxw0W8pII0zROq+BA9/gKoP+APnKcbllQfSIi9i
         HQihCImPn+74olAauGnMz4HKWXXoghl5LIYRo/LcHQOJC99KGPmViK6RJU6rtjvXc076
         6hdw==
X-Gm-Message-State: APjAAAWbtJGQIlIjRHTTV5n6SGVB4Zjgu/2ox1QmBSVswRCy0JTBs8XT
        VIKnZLm+BnLldv0kBKAeJEkJrj3kcQk=
X-Google-Smtp-Source: APXvYqz0AuBYtAFMOje12kZHJsE8Pbr1nw4xMXUdzQdINfu39wu+UVyYzAST8FeTYTNTqr3419aSnw==
X-Received: by 2002:a17:90a:250a:: with SMTP id j10mr13861013pje.134.1576441669294;
        Sun, 15 Dec 2019 12:27:49 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id d2sm16762068pja.1.2019.12.15.12.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 12:27:49 -0800 (PST)
Date:   Sun, 15 Dec 2019 12:27:45 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v11 net-next 2/2] mfd: ioc3: Add driver for SGI IOC3
 chip
Message-ID: <20191215122745.219fa951@cakuba.netronome.com>
In-Reply-To: <20191213124221.25775-3-tbogendoerfer@suse.de>
References: <20191213124221.25775-1-tbogendoerfer@suse.de>
        <20191213124221.25775-3-tbogendoerfer@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 13:42:20 +0100, Thomas Bogendoerfer wrote:
> SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
> It also supports connecting a SuperIO chip for serial and parallel
> interfaces. IOC3 is used inside various SGI systemboards and add-on
> cards with different equipped external interfaces.
> 
> Support for ethernet and serial interfaces were implemented inside
> the network driver. This patchset moves out the not network related
> parts to a new MFD driver, which takes care of card detection,
> setup of platform devices and interrupt distribution for the subdevices.
> 
> Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

For networking:

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

I think you wanted this to go via the MIPS tree, so consider this an
ack.
