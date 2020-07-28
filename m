Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12F6231334
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgG1TzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbgG1TzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:55:17 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343C0C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:55:17 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id c6so498804pje.1
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MdJ9fzkeAvtqLH9LF4xIRvajsjy5CcziOa0+iS6fnDQ=;
        b=CDu+PLlBYeVCAz9iqRoxdYOl0zhvbSNqhTNpTNFGp3dCaynmv3RjhGLfFi13wrMJNM
         43ROcR7hMGpDljQgrz5ZQXjpMu+pWFiKh6AsNwY3kZ0oXGOuH/0+wMDFzJTHWjDVCqWy
         vbvekSaRDedOXevXk/sYLZYhBu1rgMQ2e+o2V4Zr9w2EigRG0tI18HEq2AegGwkrtx1C
         +XmMW38e+qPFMrXLZIJoLxIycFfy9bwshQsopZO+9gNiFAH4Jj+6vIDJMyKxhv7TM6Rb
         f6rVdpfJEu+zqC/wTF0jt3tR3eXELP9tdLpK+dIMXV/7xr4lOTz70bzjyzBaJQ4KH4FF
         WXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MdJ9fzkeAvtqLH9LF4xIRvajsjy5CcziOa0+iS6fnDQ=;
        b=GcS2OV9ISc1n+j1RN6jcIjXKRZpSAE923OaPfJgFJziBCyBAaPhU8SCNWYlvYNw3BF
         V81m6JovOhHogH20WWEMYyXS+XVmEhA0HOgyuSb3Fekrlq5FI+WxtaqoDfLjgT5FuXmg
         /mygf4+iEscoUeLjlV38ObSgAHEx+b/pkCB0M6Uq7mGGFLihW2ZJK59u1euHFAgQaWDy
         FlX9gsngPaPfrHI9Ewq8KryfH+dqNEUoMP3gWbStC0RmoZzVuhavK2Ii36FmsrSsQ1w2
         sjKo9xa1AMeUqy3segLlDyttxM9g3x7Kd+rL9egnUBouvj3X0DtakNmRR2hLOG6T4toH
         /1hA==
X-Gm-Message-State: AOAM530P3GaaX7EdTzc8E3+hglicmnHRfLxfncMgNOEPLJ/9xy8jNI58
        RdTmzNuJuTOtmdWklMygXRdJXg==
X-Google-Smtp-Source: ABdhPJyUFoH5uUXzX/ecRZ5COyPt8t4grv6YMvAn3ASeq87yVxKBoaNfGpx1vrKUZAUrgnA3yyqY9g==
X-Received: by 2002:a17:90a:e96:: with SMTP id 22mr6162237pjx.135.1595966116792;
        Tue, 28 Jul 2020 12:55:16 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id lr1sm9817pjb.27.2020.07.28.12.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 12:55:16 -0700 (PDT)
Date:   Tue, 28 Jul 2020 12:55:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v2 00/21] netgpu: networking between NIC and
 GPU/CPU.
Message-ID: <20200728125513.08ff7cf7@hermes.lan>
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jul 2020 15:44:23 -0700
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> Current limitations:
>   - mlx5 only, header splitting is at a fixed offset.
>   - currently only TCP protocol delivery is performed.
>   - TX completion notification is planned, but not in this patchset.
>   - not compatible with xsk (re-uses same datastructures)
>   - not compatible with bpf payload inspection

This a good summary of why TCP Offload is not a mainstream solution.
Look back in archives and you will find lots of presentations about
why TOE sucks.

You also forgot no VRF, no namespaes, no firewall, no containers, no encapsulation.
It acts as proof that if you cut out everything you can build something faster.
But not suitable for upstream or production.
