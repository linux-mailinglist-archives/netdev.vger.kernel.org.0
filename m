Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8571109595
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfKYWnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:43:49 -0500
Received: from mail-lf1-f44.google.com ([209.85.167.44]:38087 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfKYWnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:43:49 -0500
Received: by mail-lf1-f44.google.com with SMTP id q28so12373619lfa.5
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 14:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2oz+E5MyCLlXYMGvVyc+sBuUE6ogyJv//PySTsxI1SE=;
        b=wZQ9nnqXO+zBLlF8G9A/c3K0m+hqYHBY3XYmGoi6FKlUe38Y/ADUgoVSzLSMTxMSJY
         nnADZ0d92dt+TMQCdMPMs33J3dTF8ebWKSd4jrkwk8iSYvy1jabAlLcfSw1G8GV1ySin
         +E+47YVjkGwY5yQK9I/zkuvVCnyFRLsWLbbeeC/WHMXCE2AQ4FF93G5w2Jr7QSlyOhu+
         SoimwvcwKD6Zt8e5P2so8JuQarMrkQYo4c/fao11x6cSJ/68NQhyiEjrShDwqrN0owCX
         KvVUNKNVbwVCXmdhH287bo750/UT8zlANxPqkQSgqK6T5ZNhftI4BnNCiAF0AKLLS3Iu
         FvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2oz+E5MyCLlXYMGvVyc+sBuUE6ogyJv//PySTsxI1SE=;
        b=AjG0ipJ34swAqSPXuFEGlo200MeE4CIwK2LRl2d+gOc+F2+b2pelrXIBLeAvIYGOJk
         SxnsFOWgSLDbN5YA++8KQ3nNWMm+UHIrD5e7kG6PpjqPpWP3kvQ8Ym6kwmwbtKzqrv9r
         e4N5W2z7ycXKNIZ/WUiAVWzWAvqE68nw8pjggJ52mgo3a54CSdoetSOp9DP2yVVSpPYe
         d9D91U97ntJDJv+d3IVPHJtP+vqT5PPVE6dm1aOPxTV0uAGKsZd2XNjY6L/NoxRFM+OS
         5kSUpI0V9q4ld0AHNCHjZRQmoEj0Qh0mM10D2sH0KEU8F3Qry2I7hepZUoeuRjT+Nod8
         HHzQ==
X-Gm-Message-State: APjAAAVe1y58q7Y4PG9+qUcuscgC1N8aV06/uA4fs0BZXozWeJUWNEff
        2tNKvk6/X99nDDNKTA2za96+TgO+nyA=
X-Google-Smtp-Source: APXvYqyF4Wpo18vJZvzKoLi/Nw9XYJiFe6iFiSpFL63sNXxD0FA/pgeYl3jAWDLIYHHgMFiOUSpTdw==
X-Received: by 2002:ac2:5df4:: with SMTP id z20mr21939056lfq.2.1574721826086;
        Mon, 25 Nov 2019 14:43:46 -0800 (PST)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n19sm4238914lfl.85.2019.11.25.14.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 14:43:45 -0800 (PST)
Date:   Mon, 25 Nov 2019 14:43:32 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: Fix a documentation bug wrt.
 ip_unprivileged_port_start
Message-ID: <20191125144332.23d7640e@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CAHo-OozSDsE843nAgwmLsN7M6otXGpUT5Y5LRkYUqLOvZ+7rHw@mail.gmail.com>
References: <20191122221204.160964-1-zenczykowski@gmail.com>
        <20191123181749.0125e5e5@cakuba.netronome.com>
        <CANP3RGcWkz+oR3qW4FAsijPSMrAGtUpcdfSbXvpcR9rT-=qQpA@mail.gmail.com>
        <20191124160955.3cf26f53@cakuba.netronome.com>
        <CAHo-OozSDsE843nAgwmLsN7M6otXGpUT5Y5LRkYUqLOvZ+7rHw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 14:35:11 -0800, Maciej =C5=BBenczykowski wrote:
> I'm not entirely certain what would be better.
> It does seem sensible to me... but perhaps, it would be better if
> 'may' was 'must' and 'it' was 'they',
> since it's referring to the 'privileged ports' which is plural.

Ack, sounds good
