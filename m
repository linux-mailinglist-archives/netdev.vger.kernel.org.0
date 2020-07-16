Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBED222840
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgGPQ1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:27:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27966 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729178AbgGPQ1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 12:27:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594916840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JrkquwroxjkpMb9/0BTHyV8FI0xapwa83ZyOdmeOgjE=;
        b=DCh/J0GZNQPnL23gk1IE4TrJd+GzresIeyQIN3djNZZaj9tKvxh9Wix4WDdryyT+ZUSbHQ
        Q05mwQ7qbEmnViEz39ey5Iu2OHFSVsuDQKNswryrDlKd4gtxSP+7NJDG9Ny62Jjd3hO1C+
        79jm2TaedGbEZgs9TMB3pLeCf00ffG4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-C0AJjB53Oe6ciEWhYNK3Pw-1; Thu, 16 Jul 2020 12:27:18 -0400
X-MC-Unique: C0AJjB53Oe6ciEWhYNK3Pw-1
Received: by mail-wm1-f70.google.com with SMTP id b13so5414443wme.9
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:27:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JrkquwroxjkpMb9/0BTHyV8FI0xapwa83ZyOdmeOgjE=;
        b=br8r0AdUlK5dX+VORT3vY2QzGEQtQDuG9G/QMPlqM8Hah/N8/l4Qs4jk00ueS+jIgX
         bInh6GTWROsC6X78CWQbRgYsF+zUeJwVje9nhZVEC8BmjsuT4QTUTgeIZlJKbxGpqfBC
         obYryvRkur+BelEpQwNYHayZnUTOrzDhrOrMmCHtib6kHDPfazbA07KU+PWha+LDjRmQ
         yrh8NUNjjyJDQdv3nXtwQ8ghOYzAd+6YZtnkpusikeMjJkwRl0XzGoYANYHL51Ll8AKR
         kql0yJfwkldwAu9UQkCD1AtHdghf32n0YzsmrQb8amO6VgxrQuKAo2kdWt2f1u8pB/s/
         VyuA==
X-Gm-Message-State: AOAM532iGsy6Qfjl5+PQNkF+BhuM5eYLxDrbdjNPwOD1HtrJwE7U7UOL
        0iF2tVhKwXnBXkaa+iMLFSd9XgHuKuyQ4y63U1XwW4FlLgyuwb2MmKusr8avsNZ/9kLnHssEgJV
        rEzcAt0vawyfZw+yC
X-Received: by 2002:adf:edc6:: with SMTP id v6mr5826601wro.413.1594916837663;
        Thu, 16 Jul 2020 09:27:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydSdGffa57FIvjoq5iBYLfouUGxx7T6LYklRMaFS9nUyxqNKCEZG7oB4u6C/qeNJs3frRJHA==
X-Received: by 2002:adf:edc6:: with SMTP id v6mr5826584wro.413.1594916837393;
        Thu, 16 Jul 2020 09:27:17 -0700 (PDT)
Received: from pc-2.home (2a01cb058529bf0075b0798a7f5975cb.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:bf00:75b0:798a:7f59:75cb])
        by smtp.gmail.com with ESMTPSA id c15sm9240956wme.23.2020.07.16.09.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 09:27:16 -0700 (PDT)
Date:   Thu, 16 Jul 2020 18:27:15 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next v2] bareudp: Reverted support to enable &
 disable rx metadata collection
Message-ID: <20200716162715.GB30783@pc-2.home>
References: <1594915134-3530-1-git-send-email-martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594915134-3530-1-git-send-email-martinvarghesenokia@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 09:28:54PM +0530, Martin Varghese wrote:
> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The commit fe80536acf83 ("bareudp: Added attribute to enable & disable
> rx metadata collection") breaks the the original(5.7) default behavior of
> bareudp module to collect RX metadadata at the receive. It was added to
> avoid the crash at the kernel neighbour subsytem when packet with metadata
> from bareudp is processed. But it is no more needed as the
> commit 394de110a733 ("net: Added pointer check for
> dst->ops->neigh_lookup in dst_neigh_lookup_skb") solves this crash.

This patch looks like a complete revert of fe80536acf83, but with a
missing chunk (the rx_collect_metadata field in include/net/bareudp.h).

Why not generating this patch with "git revert fe80536acf83", instead
of doing it manually?. That'd make sure that no chunk is forgotten.

> Fixes: fe80536acf83 ("bareudp: Added attribute to enable & disable rx metadata collection")
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

