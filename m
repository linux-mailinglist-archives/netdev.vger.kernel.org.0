Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCC24FEBE9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 02:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiDMA0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 20:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiDMA0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 20:26:37 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9FD1DC
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 17:24:11 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id n22so184148pfa.0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 17:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FgyYp5VcoidQ5XbfndPuDkccCsmpD6ZwuN3H0CutGCY=;
        b=ldUuYwzP3gD/rj7ALLtG+rGst+MSW0eFQKuy35D0bSdRsQBpS//HqjbyviqsQHhkvA
         fs0ojuosBvGohhltxkgUUvr6kv7EuIjYUAFaJpmR9VP43JRS7qY7Vg83HR6QMHVZfHno
         6Nw1CHQV1PtyjJZCd4cPCdaXzqEoaf9KgR8Xs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FgyYp5VcoidQ5XbfndPuDkccCsmpD6ZwuN3H0CutGCY=;
        b=uy+uo/CQEDZoRMkia6yeBgegALeaCp1v/db8HnESUvRYPNk3VyZcgzL9byfW2k+4mD
         x73CT52ydZ4B3vrd6t3Ip5tU6Mx1ZJ2FIENlTL2QVoA3VqGgUu9VHflIHnF2nEKDHcJZ
         yERtiVOz+KawnEjwrASl92qW8gYMyVU0g/ri6w8IeV1/N+2hxnVYgAKzychXmbp29lg2
         er6DDv6nvlwhApc9cZjr6sfcSGvKN0RLto8U7KDQhPxKjp9aC9In1Nn2V/DjFg5TTA43
         e5vQIl8kdZz6dRqXOsZHWuIq/KFZ8n5kIWu9dHVqGvuXM4FJJv+EIFYLrR24pH7rOcNP
         fVIA==
X-Gm-Message-State: AOAM533SGGQcSYN2UEWZcLlDzucuW7Bqf5k1Er6LOVnykxJoiKmFZQcE
        SSlftbQeE8mN9XFfmp5J6JHOdw==
X-Google-Smtp-Source: ABdhPJy5FJY6Q6VWd+fk6QfKqME9E6j1FuWrwXXcbGKZvBz/6FWlvHnd3hcZqchTrqP3gllEJGM/cg==
X-Received: by 2002:a05:6a00:1c63:b0:505:cc7f:a21b with SMTP id s35-20020a056a001c6300b00505cc7fa21bmr10818937pfw.9.1649809450783;
        Tue, 12 Apr 2022 17:24:10 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d6-20020a056a00244600b004f701135460sm42471329pfj.146.2022.04.12.17.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 17:24:10 -0700 (PDT)
Date:   Tue, 12 Apr 2022 17:24:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Tom Rix <trix@redhat.com>
Cc:     luciano.coelho@intel.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, emmanuel.grumbach@intel.com,
        ayala.beker@intel.com, johannes.berg@intel.com,
        colin.i.king@googlemail.com, gustavoars@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: mei: clean up comments
Message-ID: <202204121724.6EB95414@keescook>
References: <20220410142733.1454873-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410142733.1454873-1-trix@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 10:27:33AM -0400, Tom Rix wrote:
> SPDX
> *.h use /* */ style comments
> 
> Spelling replacements
> commnunication to communication
> adsress to address
> procotol to protocol
> addtional to additional
> kown to know
> negotiaion to negotiation
> mssage to message
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Looks good; thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
