Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE25215E17
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgGFSQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729647AbgGFSQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:16:11 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49501C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:16:11 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so18731718pge.12
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+0kLz7YDV9dOZwXi6SsDK6/1VwQJwAO8L+bSRM3NndI=;
        b=iYHgXIWWwjlnDinacIjGc6yYwrOiV0Bylkf2qS0DxyaeFcjcM2adM1vFfHEAFvAf8q
         Z64nkukTpGaC2/+nqlsQDie+QP14iEcHaOi+Qb3iSW6HaUUP6nhWTvIIDqKwKxleRFo6
         csNekh40B/hyD4bCIFI3LBbk7dvC2wlL76vff9KUXxRVKMoDBfMnsMdl3KlE5VTUo29d
         L4+ROjTfA9BRHMyZnBSOczP38EpExZe5UjgBSA/YYVp11YyFTgRmeztSGiS5albfzsqn
         VXKdJ5JjzuI1j6AKlbFpOI4YZ0bvFHW9P+Gyl3QyhXyf/rMTdjmAS6UGekqKUUcoeISe
         3wlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+0kLz7YDV9dOZwXi6SsDK6/1VwQJwAO8L+bSRM3NndI=;
        b=qi6QfnbG42kCEomo8IIMIQ/CrqPPnSCZwGO0RUCFxk6nm2uHd6SlS693Chsr0lhW5K
         XFYaR0zot91W9Ze1/dbGdmlGupDx1LDuvSgIwJzgouQvqF0aFvTTY+6JVcViKtVFlWyf
         /p6PNTEZZ5Kq3uQcXJYlDfLKQu+g1GhN+X6lmyIelIwVKnPsfXCji3fxburUbiEgh2lv
         08J9spCLd5F5x4zJFbrQEb+06WJ3i88OTCuTn4Bv6fSDcDHzYVtYDQz9c5pILmFKXKaj
         SakCwlNqF6YWB6nUJaO4H6Iyg+JUBNPDQ0+NN4wxPNZynaMDUM6/grxgVOX/naLGsD5P
         raSQ==
X-Gm-Message-State: AOAM531Hsl+v8bY5TYql4R8judkClsqLaddvR7EBn69dJ/vHv5Cci0hp
        R09SsLnTw3rBrqKjKwr4xLRgCO1/sgw=
X-Google-Smtp-Source: ABdhPJyfIWs8o563z7WNcaUQGmmijpHGTqUZucHQK3RwMe+AGVpqahkcHP8gbWDwQQhNjwU7a2Ejew==
X-Received: by 2002:a65:4bc8:: with SMTP id p8mr41183257pgr.418.1594059370847;
        Mon, 06 Jul 2020 11:16:10 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f29sm19905649pga.59.2020.07.06.11.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:16:10 -0700 (PDT)
Date:   Mon, 6 Jul 2020 11:16:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     louis.peens@netronome.com
Cc:     netdev@vger.kernel.org, dsahem@gmail.com, oss-drivers@netronome.com
Subject: Re: [PATCH iproute2-next] devlink: add 'disk' to 'fw_load_policy'
 string validation
Message-ID: <20200706111607.574c56dd@hermes.lan>
In-Reply-To: <20200619115007.10463-1-louis.peens@netronome.com>
References: <20200619115007.10463-1-louis.peens@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jun 2020 13:50:07 +0200
louis.peens@netronome.com wrote:

> From: Louis Peens <louis.peens@netronome.com>
> 
> The 'fw_load_policy' devlink parameter supports the 'disk' value
> since kernel v5.4, seems like there was some oversight in adding
> this to iproute, fixed by this patch.
> 
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Sure applied
