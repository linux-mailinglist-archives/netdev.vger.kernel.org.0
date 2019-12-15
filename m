Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109D911FAC9
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 20:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfLOTcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 14:32:12 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46091 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfLOTcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 14:32:11 -0500
Received: by mail-pg1-f195.google.com with SMTP id z124so2386047pgb.13
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SD6710XuCGfLCRjEaTIYpMnkGtQ6zZzJk7TYgaQ/Siw=;
        b=xJxXeatCAJCU30I9wwZmedY0avOrIT77KoTok0JQ/JbFO9lmaK+0DfZ89kJwB0PnQH
         vuqLgph7k+ofwTsPyEL9u2khQekl5nD5+qrkeNIqdcOguBAfTjcQsMOuQ3Gq4fdzpp50
         2uwVakow0BOR4CG59dBrETZ2NnXytgiVlYinqOvoy8gANeId4a4KH7WxV1aHKvk1zbyT
         n7LuQeeW+7Y1v1j9HVLAbRjTt0poRRMSVVpQ7lsQUyZL86mK6mCiEzrioyaGxJT9Cs6H
         y9jM9vZnshGS8Ay/Xhicf9E5k0Kk7JKMW5CvYpLz36LKYETiZL81fF59+LD3MStjEGre
         dd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SD6710XuCGfLCRjEaTIYpMnkGtQ6zZzJk7TYgaQ/Siw=;
        b=kwLb3uOEwvcteSMs+ZHQi7L0nPLJ0spys3dY/H/IOm4P36A+ja3V+qvaT659Yw37z1
         EBlfNMJz0erm7LPB2I/8TjWSZnjVradefReC/c7P9Juryise+woT+hjXe5ucfgfVsVLh
         NQeUPlq/3OdQQLjIu9ObHp4Dud8EmHuFA9b9HSDw4ABxtxtPklRZuakF/hDlqKBKnaUh
         UINtw3IRH25soveJiKRA9pEql49FbQMdI91n2LjJXKkT686GUxzoYflCqNUy57KgiNI8
         O+W3r5FdD6gH25CaG16EoC4ISjbIP4DHBuG1Qp4/NcBPuztiMwSEBjrot+PbGnvLn/np
         t2ZQ==
X-Gm-Message-State: APjAAAWuy6IC7nU7xfJShDhblx1A4HPUSPE3C9UL9yFEiP976L5rEKzU
        24Zh3o/lfpwQYuMVSTC9YpdRLgSAWow=
X-Google-Smtp-Source: APXvYqxYeiVnRfIk5g9EJ6vrTN8Y+jTHPgtnkXSmDuJTA/McKpsjUR7LQKN3ZfU+1S+Sk+mQAszwLg==
X-Received: by 2002:a62:fc93:: with SMTP id e141mr11845222pfh.262.1576438331400;
        Sun, 15 Dec 2019 11:32:11 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id d23sm18846406pfo.176.2019.12.15.11.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 11:32:11 -0800 (PST)
Date:   Sun, 15 Dec 2019 11:32:08 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Cristian Birsan <cristian.birsan@microchip.com>
Cc:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: lan78xx: Fix error message format specifier
Message-ID: <20191215113208.7378295b@cakuba.netronome.com>
In-Reply-To: <20191213163311.8319-1-cristian.birsan@microchip.com>
References: <20191213163311.8319-1-cristian.birsan@microchip.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 18:33:11 +0200, Cristian Birsan wrote:
> Display the return code as decimal integer.
> 
> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>

Applied to net, thank you!
