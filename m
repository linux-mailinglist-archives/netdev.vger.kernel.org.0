Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CD211F435
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 22:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfLNVSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 16:18:13 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45900 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfLNVSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 16:18:12 -0500
Received: by mail-pl1-f196.google.com with SMTP id w18so929642plq.12
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 13:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ehqT5HTXYbZLdvWPXduevfcCFqefStz2vAgJJNus00s=;
        b=igaL/w9kujyBmvxoLypkWczOZaqTbQ3887n15CFE4SH886RQ9bCpZgt6Bg0zJDc6lB
         DeQ2I6sX0nJ6cIlP4cVC4rpp8DeWbeELz3yGHxog5rU7ANSQcL3oQMizlRATwcyB61nY
         A5FE7CXRyr0BQnpkGc7gGaky1OcjavOJ67nbpXGCeTISRkWsHx6sPy95eVG3G8uzjyat
         DxiBzRY0tuLjb1Q1mdNQOBt1Jf9SZmwg1FHEU3SD7ZGSkX9AfF7VvKBs/ZjsCbv65AxF
         MezJKACX6AnGHwR0JfeW1j4hCI6CaeKywtxohxCWvkimShNEp2Up4oYgiF58ichonv36
         g1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ehqT5HTXYbZLdvWPXduevfcCFqefStz2vAgJJNus00s=;
        b=dgAU9wHHRk5M6UVRAzdbaqCBB/bL4tm7Yo1B/0m9lv4CuOrPxIDjkM/ZMn2exHOzk6
         1Jz0h8uquBiERf0gzyjfm3lJCX5/mHZs4HTheoWjIzJNj24VFIoBAV1vv0RPR5/TcxLV
         7XmOO2+41E2ISvs0u4mMBSqAPv3bnns+bfHj4bE53xzufRw3wUZV6rDWtelfJ9EUtwlv
         9mJY8wIM+/3OJA3lLXr8EgfLq1hIun8rWXi/OvxQkeodyeFEoVep+kvNLD+r6A39hzOL
         zTpveFCMfuVUE6YF6UzEqn30Xo8ifyt0kdXuiO7EWQxjuDwYNDFFUHDDuU5atim47z4q
         5IEw==
X-Gm-Message-State: APjAAAVlohmA0k4XXJ+GlWamF+zqbl0DpfTasWhhskqGUDCZsr7jG1jD
        XE0JG1Hg5FdSTUKFgfd84mIxwQ==
X-Google-Smtp-Source: APXvYqwAd7j8cg6OJ4TtWVOgByl6fUpKVII/Iifz0mo1fOO3g60pfDPYCXgzKFvFfjvFqjC2gIoXSQ==
X-Received: by 2002:a17:90a:2569:: with SMTP id j96mr7901372pje.79.1576358292247;
        Sat, 14 Dec 2019 13:18:12 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id b22sm16364524pfd.63.2019.12.14.13.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 13:18:12 -0800 (PST)
Date:   Sat, 14 Dec 2019 13:18:09 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andy Roulin <aroulin@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] bonding: move 802.3ad port state flags to
 uapi
Message-ID: <20191214131809.1f606978@cakuba.netronome.com>
In-Reply-To: <1576103458-22411-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1576103458-22411-1-git-send-email-aroulin@cumulusnetworks.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 14:30:58 -0800, Andy Roulin wrote:
> The bond slave actor/partner operating state is exported as
> bitfield to userspace, which lacks a way to interpret it, e.g.,
> iproute2 only prints the state as a number:
> 
> ad_actor_oper_port_state 15
> 
> For userspace to interpret the bitfield, the bitfield definitions
> should be part of the uapi. The bitfield itself is defined in the
> 802.3ad standard.
> 
> This commit moves the 802.3ad bitfield definitions to uapi.
> 
> Related iproute2 patches, soon to be posted upstream, use the new uapi
> headers to pretty-print bond slave state, e.g., with ip -d link show
> 
> ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>
> 
> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
> Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>

Applied, I wonder if it wouldn't be better to rename those
s/AD_/BOND_3AD_/ like the prefix the stats have. 
But I guess it's unlikely user space has those exact defines 
set to a different value so can't cause a clash..

Thanks!
