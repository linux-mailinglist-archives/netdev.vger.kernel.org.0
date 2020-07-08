Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A2E218C4D
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgGHPyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730260AbgGHPyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:54:53 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DF0C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 08:54:53 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j19so15002119pgm.11
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 08:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vlhc23pGLTmQpRyyA094Gn/bmVXqB+tFJHwoFer0vTg=;
        b=Ors03V8sNrfmypp3bb7UKchAItV1dEUFRAWJPqaUcuXalQpK/L+e9qf7pCHOcO9r8j
         EJmpXlOy4avwQ62mFQVd1HRp10RSTeiqx6UY8uSepu6EhWfzSted1lj1sh0/aKMujJeV
         BcLZJTjSMb9K+7YZBI9L3y/eiVQgYOnKEkEV8fpR4IWBQv9/t4cCYnMvuzxQ0K669z1t
         rlN/3X+DVMOZD7V7n3YBAgpi+hWQ0FtoD5LZrDi87sY2C/WSTH1qjyBGfhPNjpUNSJg1
         uT7yeMj0ONaKQQB0GJNGnOKLjeJRF7FjxKf30TAXhxP5mxwF/NP45BouoVvaj3/rRrva
         bw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vlhc23pGLTmQpRyyA094Gn/bmVXqB+tFJHwoFer0vTg=;
        b=nGlo+oMNSN7KKpJLrZitvy3pNC44FWCqAYTobZ37kKWnLHBVZuAaenTkomVTM2jpeD
         V94UF9JrUOnxUkGWKMJU2lsXsO8PA/8wF/wwActZJOgpniXyS+EZVOvw6qFQSoxRr84K
         nqMI4sawhNRvgK26TPrCSauL/Aew8DJSPBPlb7qG2PFTXkaNdEO5NsHSl4rX3kGUwhIH
         Hsf6fYPfmsl8yeREYuHARVylJBjCitNRVUpccUVLHv9T8XoVKClydi5VkPpqqv45irLQ
         fW6FPpv1aA95iA4nd5l3qUoed2ymqVHQBBEb7TSN860HldHw9B76PwdKvuN2sEDMOgiD
         i36g==
X-Gm-Message-State: AOAM530LDh5CEwWAzWbG9j9AFQRlRfjXXTHDK52vZ1Gdd+6T8ZaoFv4w
        t7Yfh5gohGugcdNESO2LyHMCsA==
X-Google-Smtp-Source: ABdhPJzMPjAllIUTNZEJxN1mKpKXdCoBiG5ExjisaV2aQfxYm7cVhtaCp6Qi/7eLcZ5XZ+isGeAXYA==
X-Received: by 2002:a63:d208:: with SMTP id a8mr49280179pgg.351.1594223693007;
        Wed, 08 Jul 2020 08:54:53 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 15sm73236pjs.8.2020.07.08.08.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 08:54:52 -0700 (PDT)
Date:   Wed, 8 Jul 2020 08:54:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip xfrm: policy: support policies with IF_ID
 in get/delete/deleteall
Message-ID: <20200708085445.26673615@hermes.lan>
In-Reply-To: <20200706104756.3546238-1-eyal.birger@gmail.com>
References: <20200706104756.3546238-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Jul 2020 13:47:56 +0300
Eyal Birger <eyal.birger@gmail.com> wrote:

> The XFRMA_IF_ID attribute is set in policies for them to be
> associated with an XFRM interface (4.19+).
> 
> Add support for getting/deleting policies with this attribute.
> 
> For supporting 'deleteall' the XFRMA_IF_ID attribute needs to be
> explicitly copied.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

What about man page? That needs to be updated.

PS: disappointing that ip xfrm does not display all
the attributes of existing policies. But that appears to be something
that has always been broken.

PPS: ip xfrm needs to get jsonify'd
