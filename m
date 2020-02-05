Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD8415353A
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 17:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgBEQa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 11:30:27 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:50732 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgBEQa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 11:30:27 -0500
Received: by mail-wm1-f48.google.com with SMTP id a5so3177749wmb.0
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 08:30:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BgtBpQ0rPqBXxJtk2kqAD5SKstAmMUuV7OwaT5fiB2c=;
        b=k5qULNi4Hdwrq8xvPj9dtgtta/kR6ooaEYwojiqaQZyxqbCt/ZPjSt0hxD37Aj+lym
         Bds9HYYI42KeUqf6yw+YOHSjhAUN0RGOs6+ShGwQC59JcFHmAt59fQIKFfgsWFKLlIIl
         rt/J7Ix7Ij7ZLs7tnk24YTwZUwXwTE/OxPpGYXs8FMWoZN4VxuY2dllr1Uy1a584sT2e
         j7yDH4XMyN3onBHZ/4S7EmDM2hObp1j94XkoENQRPpuN7ISy4TktfHqNKHq+5oF849QD
         aVOcC6sg0b8/Ar69svOtqzSDlCkBp5UuuAK0y8x5sBso1OCbYcxlq9Bx7SUfqOFNlrBi
         O8TQ==
X-Gm-Message-State: APjAAAVQnm3H705xVXn/pT2s+PzcMBdHyRn+7KBF4pWfPa1BGt9DHups
        XBIDuFv1WOUWFOB8FkS6MslAe2MN5B8=
X-Google-Smtp-Source: APXvYqwyMR8QSXxGvZMwBYGvCRzNYxs9Couf9NsKq3Apxbsjh0BIvRFzokfHuge6+eiAzMO4DjCsfw==
X-Received: by 2002:a1c:4c0c:: with SMTP id z12mr6494673wmf.63.1580920223487;
        Wed, 05 Feb 2020 08:30:23 -0800 (PST)
Received: from dontpanic.criteois.lan ([91.199.242.236])
        by smtp.gmail.com with ESMTPSA id b10sm413610wrw.61.2020.02.05.08.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 08:30:22 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        William Dauchy <w.dauchy@criteo.com>
Subject: [PATCH v2 0/2] net, ip6_tunnel: enhance tunnel locate
Date:   Wed,  5 Feb 2020 17:29:32 +0100
Message-Id: <20200205162934.220154-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
References: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While trying to create additional ip6tnl interfaces, I noted behavior
was different from ip_tunnel, especially when you need to create a new
tunnel in order to make use for x-netns communication between root
namespace and another one. It is an issue when you do not have specific
remote/local address.

changed in V2:
- splitted patch in two parts for link/type parameter

William Dauchy (2):
  net, ip6_tunnel: enhance tunnel locate with link check
  net, ip6_tunnel: enhance tunnel locate with type check

 net/ipv6/ip6_tunnel.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

-- 
2.24.1

