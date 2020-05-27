Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9979B1E33EA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 02:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgE0ADk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 20:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgE0ADk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 20:03:40 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B95C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 17:03:40 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id v4so17836693qte.3
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 17:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gCXeG/AdZkdX9wVQAod6CoxJsYVIMHX6W75WOp8vTC8=;
        b=SFli7Lpms90WbLh6tATGrwPjpxAAdaOurnykCcRz/MapBsH/bZHBgMu0VfZsXDyohV
         d92lnbrF5vKJH3MZDIgYdUPtudKu3PM0ugtGXDCf/84RJz9h5Go71ms153eBMKknIR6O
         CO0+rJyuDLzgJv98xIXM8QH3R1oTJ4AHGq6G590+SjL9nLDmpobCNEkSXtbb1wPDdIZh
         jaW9cbvwkU+H2H91xNSsroyxiHvzVzobNkenY4JuQqoTAwJHrtEhNxw/Zt1lzL/4mRz9
         /wLamYbTLKN6R05jgTwkJKbgabteFGi9J72xibzqumtkZwVjSGhS8DoQlxjTlsCTvQgI
         At7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gCXeG/AdZkdX9wVQAod6CoxJsYVIMHX6W75WOp8vTC8=;
        b=E4iFvvMXzosQvPQTECZSvkLWGqhaoRtMEHyPi3wus66k9squzC3W8B4KirFOZrHbmy
         fjY/28/PZrbMcjas4pvvGEwX7raFz0STz2Bud3DA3XvDTKsA4opk3EPEGiBlaKFagZMh
         MYK6NFMQ5030NfsYHJRidEGQUMpZh9MMCez4fQ+MylXRnKJX1lBEgA+bVdx4MDLpu5Xq
         4LrdBNAnkPz/XIa+DSe3HemTYthTkoF3Ygx4p5vbYci/TkpCrwj8HwiNdrLhBqyC93R7
         BzAWQgIEDIITHgMfJG/RxGD8VwlY0TVyf0+iHWWHff7Qef9BkDe+EYdkQgkriLcDKj9P
         VJ4A==
X-Gm-Message-State: AOAM5319KUiTXMHIFqYgyuUYYQQMd307vYivA88CVtpkKoML/mOgVcvA
        4rPRjFePaqo5WxdVFSuW0AI4F0HR
X-Google-Smtp-Source: ABdhPJzFx3Vh3ttdY7vGeNEB5lmE6lGLwk/PH35nqGNDyIqrkGqGAmCr3zFmuy4VG4MRw+Q1a56Ffg==
X-Received: by 2002:ac8:5241:: with SMTP id y1mr1584925qtn.165.1590537818876;
        Tue, 26 May 2020 17:03:38 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id 79sm988993qkf.48.2020.05.26.17.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 17:03:38 -0700 (PDT)
Subject: Re: [PATCHv2 iproute2-next] lwtunnel: add support for rpl segment
 routing
To:     Alexander Aring <alex.aring@gmail.com>, netdev@vger.kernel.org
Cc:     mcr@sandelman.ca, stefan@datenfreihafen.org
References: <20200520235727.28045-1-alex.aring@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f2402d63-6ab8-08ab-2fad-5ad2cd480ce7@gmail.com>
Date:   Tue, 26 May 2020 18:03:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520235727.28045-1-alex.aring@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/20 5:57 PM, Alexander Aring wrote:
> This patch adds support for rpl segment routing settings.
> Example:
> 
> ip -n ns0 -6 route add 2001::3 encap rpl segs \
> fe80::c8fe:beef:cafe:cafe,fe80::c8fe:beef:cafe:beef dev lowpan0
> 
> Signed-off-by: Alexander Aring <alex.aring@gmail.com>
> ---
> changes since v2:
> 
> - change output to display segments count and nice segment brackets
> - fix json output, sorry.
> 
>  ip/iproute.c          |   2 +-
>  ip/iproute_lwtunnel.c | 121 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 122 insertions(+), 1 deletion(-)
> 

applied to iproute2-next

