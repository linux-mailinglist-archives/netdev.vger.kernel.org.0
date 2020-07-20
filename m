Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A19226FBC
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 22:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgGTUai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 16:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728466AbgGTUai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 16:30:38 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A86C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 13:30:38 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x72so9636775pfc.6
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 13:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8NjQ5Y/ekRXHV+DO1T5Rvb3xD2Ig8hYNLYdly21N+YI=;
        b=nNmF7cPnuOAb6skHRUQUOIBVYLdOpYmtP2sK/EK6QLAx38+kkgJMSQQxatJy+G0+65
         lGMUGEaEXYaZqb63Id3Sl0F2Wha9y1w8cQJjHrfcrZIJrC+eNNdepIdE8HqO6QyEuQcc
         /8AmCTD7u4AFAONLF653VsUzc9s2GXTqynplALwZQREs4scm0aB8qirmLrpwZ393Hh2R
         Olsi8LWe/bjlPLgNnoPUIC8VxKPtDxzBT7hh2pe6B6cn78dLJTRVNQB9qLp4cycwz2AL
         GGb/9QGd5kD+P/jFBLp8pUC8W2m/+l5yhAL1rAeMSt1bZbLu/ax5idYYdsXZHw65AWVH
         beYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8NjQ5Y/ekRXHV+DO1T5Rvb3xD2Ig8hYNLYdly21N+YI=;
        b=Eig2h6tPNxDPtShqZ44B6MwFi4GhCDg4wXWVW2ANfRrTliEhcn+wW0wTTX1jfL4ai0
         jj8i7fnyDwPyKuTxNpjeCwicIEz35GDKRztjeaCatutkviEdbq6k2mhnUi57dcnKSyw/
         CiXosWlqPPOeDlJFBwm+JCWGhnKbfx4K8lsoubFRNW2Fr2jFiTAOATDpe0rM0kWlptQU
         P7YLD9BprKJ3zLxD7WSQZWmdj1bpGsTeV+DHa9Sp/83bU4sxCZKMVaDLe6YtxXBwsi3z
         4s6dj2leVO+Mu6RDA/n5lm1vcIPVtRlsRMKjTBDN7t2hRi9TzbMvD5d27sxdwcuSLMaw
         02KA==
X-Gm-Message-State: AOAM533s9eReLLbF2pc2xJfT74AHjeXdGv03SWI8s8wwC/Yo58PRKINH
        wDErcW3Z2+vpmgOMwiXoC8JIplOQzsa9NA==
X-Google-Smtp-Source: ABdhPJw95XmgG1k/GTMX6FG44MKW5633M37OIb7yMHdrPqaJBKD4rG4v7sXRizgiBvGeiwJV6mgtPg==
X-Received: by 2002:aa7:98c6:: with SMTP id e6mr21500978pfm.17.1595277037708;
        Mon, 20 Jul 2020 13:30:37 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w64sm16348470pgd.67.2020.07.20.13.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 13:30:37 -0700 (PDT)
Date:   Mon, 20 Jul 2020 13:30:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 iproute2] misc: make the pattern matching
 case-insensitive
Message-ID: <20200720133028.4d19acd5@hermes.lan>
In-Reply-To: <20200709150341.30892-1-littlesmilingcloud@gmail.com>
References: <20200708082819.155f7bb7@hermes.lan>
        <20200709150341.30892-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 18:03:43 +0300
Anton Danilov <littlesmilingcloud@gmail.com> wrote:

> To improve the usability better use case-insensitive pattern-matching
> in ifstat, nstat and ss tools.
> 
> Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>

Applied
