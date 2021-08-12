Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBA33EA177
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 11:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbhHLJCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 05:02:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235975AbhHLJCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 05:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628758910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gNM/Fp932rysWOPAt46GwBPGPWNF09V2rzyGDSFgtNw=;
        b=R474ZPClheDsJBu8mENaHGynJbP8SZJn0y4kHeYfbpncGcyAVr4tdweWcvHmvR2/1FVl4j
        uM3aM487jxi45rFTElz/QJl8qK24JpdRkbmO5Wz7fF34YJwG1gRQSNyS7WGfyL3JUjdllK
        hYz9/Edf1xw+SlM8Cm45YVHx9FverIU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-xv41Wv9MO_WN8VFKZB2tPw-1; Thu, 12 Aug 2021 05:01:49 -0400
X-MC-Unique: xv41Wv9MO_WN8VFKZB2tPw-1
Received: by mail-wm1-f71.google.com with SMTP id k4-20020a05600c1c84b0290210c73f067aso1613760wms.6
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 02:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gNM/Fp932rysWOPAt46GwBPGPWNF09V2rzyGDSFgtNw=;
        b=mID6XqREnROTdIHHQP4XccD23hMa1fnMrdy1tAsQRHCxZo/cvbuu+EtcW7cGcl4ioB
         A8GmKND+gn5q/bMSZxzTKRZtWiqbb+4jO/crJmVZNXNr+bDmS7dugrEt9u3qBSB2rSku
         Rs+Gtoxqi5F3qBa7PwsUbGvz0BAElI3jRF1S7LjkMfZKoC9cyV1Wd29QKotDrO4xWZZf
         grRs04qKUwwhyKN9xn9cPogvHvWz3CWorJLB/UxJyOYp05MIewAPQwC8W3aYK8BlAHon
         RSTXO2dAhmyaZcJYjqcPytvkbt5DS3CcjzM9X8N619g+LAP2JFL2TFAg4L1VNCi04voD
         4tzw==
X-Gm-Message-State: AOAM5323379/WZ9EWwp+R/+WxbQ/EzXUhpF5t1c2dNy0mpFgOLmKyc2q
        SmfpZvfxxGy/85cCdePI4iDu2kDmHKy15TRgY4+NZ2JmHY/h+H489cDO2L6EDrl2z+RTP/0sciU
        OfCTuYI5ywzKWQX87
X-Received: by 2002:a5d:5085:: with SMTP id a5mr2938417wrt.62.1628758908108;
        Thu, 12 Aug 2021 02:01:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwJwabsyGrmswroQ0N4maK+UX141/0kr/EfyQwR0RHF1wNwpoC9lFoXoiy8r9Gqz1BfJH43A==
X-Received: by 2002:a5d:5085:: with SMTP id a5mr2938405wrt.62.1628758907958;
        Thu, 12 Aug 2021 02:01:47 -0700 (PDT)
Received: from localhost ([37.163.59.80])
        by smtp.gmail.com with ESMTPSA id l38sm8066935wmp.15.2021.08.12.02.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 02:01:47 -0700 (PDT)
Date:   Thu, 12 Aug 2021 11:01:42 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, haliu@redhat.com
Subject: Re: [PATCH iproute2] lib: bpf_glue: remove useless assignment
Message-ID: <YRTjdoGzNBzLvCdn@renaissance-vector>
References: <25ea92f064e11ba30ae696b176df9d6b0aaaa66a.1628352013.git.aclaudi@redhat.com>
 <20210810200048.27099697@hermes.local>
 <YROUi1WhHneQR/qz@renaissance-vector>
 <20210811090815.0a6363db@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811090815.0a6363db@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 09:08:15AM -0700, Stephen Hemminger wrote:
> It is bad style in C to do assignment in a conditional.
> It causes errors, and is not anymore efficient.
> 
I agree with you.

There is a large number of similar assignments in other parts of the
code; I can work on a treewide patch to address them all, if you think
it's a good idea.

