Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188E03EA885
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhHLQ10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhHLQ10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 12:27:26 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66FFC061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 09:27:00 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so16069320pjb.3
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 09:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XsGbZaOqPow69mmUyP4DIG9PuKKlZimPoOSNdQ5uQ7w=;
        b=xhkSm+uxyPla0C3mzdgQXlOzE/G5cvMBWiWZJ38VeIADwbQdSXj9RkE5L55J/6UQsv
         uJyKuNdGwkfNbnE+c8CmOcI7dfpP8baGXBjSN2oNBK2Xtqc1WQnbOjIcTikFB5Jx5KB8
         5GwLiWoFOQYUoImWr2OWLq8XZ/6YqKzeqq5zaisuofFP4Xl/uz7P146aGhVwPmYVLDax
         Sc99991IKXsOFOHl9+da4le1zZrnU8im2brVRxqWq8TL11vx5NRHaSCingV3Sdsb+F1N
         Z61/CpI5Nfxs3MRHqED1v1RXqEqYlaBDbL8F8IKpeWpX6y7Zms9q2dmWX3t2JzO4S9wr
         /j/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XsGbZaOqPow69mmUyP4DIG9PuKKlZimPoOSNdQ5uQ7w=;
        b=DbqYvhjquYKosQ3XS6HeTSSLRazaq2OaVzsved0pF9xOCFaFdDETh9+26yy1v+WSIm
         m8PGYf8Au736Ek0UnV4LicvMnbcp0+dSndY1abkn1ZxRVqBkYsRmEFDBGK/XHc0i0XbJ
         IW83+dD50erEHuMNkfTub4ldwTZJ40cfl0HUDkcjzvRsG/ReMMzET40c4B9bQFPNot33
         cO7IvwOnywi0T+t6r/FcXWQtAFMlBm6aQdHdbj/0Sm/BBrjBCfLJ9UyNc9aSpcJDl6WI
         waul/yMlfUOkh+EFz1cwZIX2AXl6gOsd08j8Q3OaiaHmr82EuKqZR5Jrqj57QYPAbO33
         wvaw==
X-Gm-Message-State: AOAM532ILI4uOwHV4vJKI3Tma8/XGsfvcbY8r5CQO7T8SBerXFMdMA1O
        dmjAK5RmVCE/wlsZHs/bvKfiHA==
X-Google-Smtp-Source: ABdhPJxUpYgG0xt25dVsMBw87TlqbT9JuZx2QQHjY/wSdMJvJjhmAApz7Pn1WuXToCQEeqYiz5uo5A==
X-Received: by 2002:aa7:8159:0:b029:3bb:9880:d8e8 with SMTP id d25-20020aa781590000b02903bb9880d8e8mr4899443pfn.3.1628785620257;
        Thu, 12 Aug 2021 09:27:00 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id n185sm4294898pfn.171.2021.08.12.09.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 09:26:59 -0700 (PDT)
Date:   Thu, 12 Aug 2021 09:26:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, haliu@redhat.com
Subject: Re: [PATCH iproute2] lib: bpf_glue: remove useless assignment
Message-ID: <20210812092656.2b9167fc@hermes.local>
In-Reply-To: <YRTjdoGzNBzLvCdn@renaissance-vector>
References: <25ea92f064e11ba30ae696b176df9d6b0aaaa66a.1628352013.git.aclaudi@redhat.com>
        <20210810200048.27099697@hermes.local>
        <YROUi1WhHneQR/qz@renaissance-vector>
        <20210811090815.0a6363db@hermes.local>
        <YRTjdoGzNBzLvCdn@renaissance-vector>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 11:01:42 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Wed, Aug 11, 2021 at 09:08:15AM -0700, Stephen Hemminger wrote:
> > It is bad style in C to do assignment in a conditional.
> > It causes errors, and is not anymore efficient.
> >   
> I agree with you.
> 
> There is a large number of similar assignments in other parts of the
> code; I can work on a treewide patch to address them all, if you think
> it's a good idea.
> 

I am looking into this, checkpatch seems to find them
