Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E338222FE24
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgG0Xoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgG0Xoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 19:44:55 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F431C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:44:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z3so9925042pfn.12
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Om3PeHm95TiusECPcil+ewLmHBswBVIl+DZCloI5edc=;
        b=hYHLvIz/R44/bz8fMS8gd60lfvcwdQ1bX9DE1R7XxEoeKV7+WzKjMObV3VDlc/ql9n
         xsdvRo7WRT+Emhhj0fZ7Koj1xxAI2bMsexhlr7FNZugsPtC1Q6bKUI+OUWOX2s7LQv0C
         fNdhj2wStb/rSYYAs0dt8QUtSNC+BIdKLD7LdiZPojpUyFC+rj8OVc2hwn5OGiQStAMg
         LDW1cJGH1895RSSGPiYUxnZoYyUjBAUmm9F5eJnihIu1+2pjkk/gHGTrfu2LG/+rlBes
         0CcbwwznIJxfGvH9hp7mUCZQUa5vC/fOKp9+kLTCJ3O6a9Re4hbDKtdfXMrtFRqUG+OL
         Qt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Om3PeHm95TiusECPcil+ewLmHBswBVIl+DZCloI5edc=;
        b=GqUjw3IYa4o3AZxBlLUf7+j9GzqIkZGKKq1tbfyoRtVpaAZlyXPhMMBv0ewvgcrezS
         M1dxeDQMh41JxVmauMW5h8O7LLeCmPKFOszSOFjHNVFGqkmgm+h6ceP5TqIAqgJMk29x
         YwUyHxUJr55E2GkM1AOj53gATXB1HBitOIbEWZFXAjbKvk/AOWTKsTpI6I9/ELCPKvZy
         kDpOgTvctwcFHO6g+zytNTZqel2ts+Nyev21x8iOfo6NCjntEUv4W1I/3WJV/ZvVWqpb
         gokamQm/vmgf24m9z0yo5QmIRBMZvT5s/XK/zL5zK/XtVt+Xz0xHEiZmME7lCGkn9CsV
         pQqg==
X-Gm-Message-State: AOAM532eBV5BsGRyNis+IQy37yAzn+HdhkM6Ek6NqcHcXazl7Z8dDiWW
        cDbctY3Vw2szp+lwBnYMiN4Gmg==
X-Google-Smtp-Source: ABdhPJwou91SSbpeg4Lo086ecogVsBkLCoATJLkGfJf1I/JymZihDdODmuMsbQVrMbwz9WMc/dx8Cw==
X-Received: by 2002:a62:8f4b:: with SMTP id n72mr8164263pfd.5.1595893494826;
        Mon, 27 Jul 2020 16:44:54 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s8sm3819126pfc.122.2020.07.27.16.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 16:44:54 -0700 (PDT)
Date:   Mon, 27 Jul 2020 16:44:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] bridge: fdb: the 'dynamic' option in the
 show/get commands
Message-ID: <20200727164452.3a1b3ec7@hermes.lan>
In-Reply-To: <20200727132606.251041-1-littlesmilingcloud@gmail.com>
References: <20200727132606.251041-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jul 2020 16:26:07 +0300
Anton Danilov <littlesmilingcloud@gmail.com> wrote:

> In most of cases a user wants to see only the dynamic mac addresses
> in the fdb output. But currently the 'fdb show' displays tons of
> various self entries, those only waste the output without any useful
> goal.
> 
> New option 'dynamic' for 'show' and 'get' commands forces display
> only relevant records.
> 
> Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>

Looks like a good solution.
Applied
