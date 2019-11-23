Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC10107C36
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKWAzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:55:12 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44422 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfKWAzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:55:11 -0500
Received: by mail-lf1-f67.google.com with SMTP id v201so5808180lfa.11
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 16:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EpYOmdm0LXrat1oph8gz7jn+01VNakCsBMtGL3Rg//I=;
        b=PRAkLROqVO1Rul125rRqMrVXzmaaFEljTPaJKaj22HB++RvsYDYs8Yr4PufPZIUvXk
         llX0iygyy9EKlhNScexv0dO7NAmBeVGTyFfO10yqizTzep+iur1c8tX/dgmhdsyk3wyk
         AbSbhidW9GKgydpz7E8UlyY7RNP4yV0YW+W5z6w/RFsPDhPA1lyGQlk2msXNu7Y5rhAL
         d6Q3i+Z+PoaFkNl3PvikB/HOSqul7mrACG5+mUNu+3nzDHBeOeFpusw/Wr6OHLXglYRX
         uGHUM2nXR3uJ/BFzSEQB+UxnzzyKku9CKeQeq+dJdwO0p82hosMrCMSNUNUvv7vJylHW
         eafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EpYOmdm0LXrat1oph8gz7jn+01VNakCsBMtGL3Rg//I=;
        b=ElyjUtpUCDClXFgfYV+ggWx4/gD1Qvz2wQX1lWQuxIwnZGJw8pSylDHh+mtSHew8j8
         P/O7+Tluf/P7p+tzVepq6fCpzGiuG4rnx8xpZ9YD4Hd3Xv8o71H8g1grho6wlNWDvkut
         vsVxu0oPqx1XVugAXJ2+vkPE/CSX3EM72xkYkCH0fqeCSY/sYg6Q7rT903nHQy3vMneK
         YnXS685Sc5znPaF9h9Btd4wFrrvfsoMbTDS5XHdNTW4ByimSd2k/+SUZHdH74aQHT5dP
         8F2eVX6tVt+/lPmZmGu9d7M/j+FbTBdXPkStoQLV4GcCViKTRrVPFCYgFt+C/mCm1hfz
         Eo7Q==
X-Gm-Message-State: APjAAAV4Szi08BgLEHhDr/bA31UmJsG7vzLjV38xDhUG+bmUxU9vRPOT
        nl2QL/kblGfbDy22QeuyqMYyeQ==
X-Google-Smtp-Source: APXvYqwghTr2/+hchlXtQhFIi69HfVfSM4TY9UCi86b1qrP80wFRFcDGgZxMSXkT6bWn4+A2cJjuSA==
X-Received: by 2002:ac2:5589:: with SMTP id v9mr9504603lfg.188.1574470508278;
        Fri, 22 Nov 2019 16:55:08 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n83sm3882127lfd.70.2019.11.22.16.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:55:08 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:55:00 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: inet_is_local_reserved_port() should return bool
 not int
Message-ID: <20191122165500.4eeac09c@cakuba.netronome.com>
In-Reply-To: <20191122215052.155595-1-zenczykowski@gmail.com>
References: <CANP3RGfF9GZ-quN-ijM4A_A+cP3-tzhA174hFjsYbXPRiTMSLA@mail.gmail.com>
        <20191122215052.155595-1-zenczykowski@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 13:50:52 -0800, Maciej =C5=BBenczykowski wrote:
> From: Maciej =C5=BBenczykowski <maze@google.com>
>=20
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

Applied.

It would had been nice to see net-next in the subject and a commit
message, you know :/
