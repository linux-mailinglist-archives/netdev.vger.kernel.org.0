Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046872CEEE5
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgLDNk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729606AbgLDNkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 08:40:55 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183E9C061A4F
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 05:40:15 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c79so3725368pfc.2
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 05:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vR9rDj5fnzCFIGSHtXyUEN5iCsnoZ3RVk9zxL+eNf1w=;
        b=P6u6uvTdH9otrCBGjJmMpc09lcowa26PsKvQRzMiX/3j+qzzyRyeVd5Ijr+whJ+8ul
         XTEn1foe0KUYP24Ra8csX3UIf6bnnKfKIhp6KYIVhmbU4cAH2xRUkZ0iywSHJ+2F0YF7
         bzO9Ipt/N70d54nHALU1RvDMKCYMbu4u4BWJPvMU1btJDfe66akeGBAN5/cTCnMQz4zB
         tdXXVcobvJbsJSX4JSKPLpn90xcHWd7rcenw9rMN9AMl2iO+GY3tBiGf6didA/qNW76J
         PHN/f7SwP3ZPdFnwALlHDuoftNc9YZmKae77FTpsIJmfr0Vax2umDVnSHGjIwyrsMR6q
         hG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vR9rDj5fnzCFIGSHtXyUEN5iCsnoZ3RVk9zxL+eNf1w=;
        b=r9gbWzVyw/I+dW/fQfvLCK+Ftt01vn+WzVyfoMGyQms3pnkmBvvJCENtXMsbcl9/yq
         hVnsHA3av+cn4Gg1Xi3q7VBqMVPFKsBXmxPDAMS6D4fCR+/FLwSZKLtJWwz1x7plqPiI
         ZwA71o84TnK4pMOqY9gXl0eqh1oe41ZBM+5Pxbx3maNfjf8OT9+37KzRrNE04cnFsWhh
         cG3r1hFeKqXKarlr6vAkC1zUwMNR0YyKyIfWrikcXpMq8joIN9ShMi98NGmL0ssOelx9
         cYbwHAt6YH+AnWaKk+t5camjirx2w9RCv7jAhxjvjgYSHipv9P5sUa2NkyLBX8YtH1Bl
         txGA==
X-Gm-Message-State: AOAM533uYQXNXwB3L+WZl2Frgtdu/GR/I5oSAVNtaqF5ze29P86IM4F3
        bAfB2ak0awaeT3Das0cGnpA=
X-Google-Smtp-Source: ABdhPJyC+N5oxRVyv047ZJfJv4vUYI38DmwvZs1Mbih7Fmwe3h/yVS/Ri8L6SC0N0ecyw3bdO4bGwQ==
X-Received: by 2002:a63:575a:: with SMTP id h26mr7636487pgm.228.1607089214680;
        Fri, 04 Dec 2020 05:40:14 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v3sm2350797pjn.7.2020.12.04.05.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 05:40:13 -0800 (PST)
Date:   Fri, 4 Dec 2020 05:40:11 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/1 v3 net-next] ptp: Add clock driver for the
 OpenCompute TimeCard.
Message-ID: <20201204134011.GB26030@hoboy.vegasvil.org>
References: <20201204035128.2219252-1-jonathan.lemon@gmail.com>
 <20201204035128.2219252-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204035128.2219252-2-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 07:51:28PM -0800, Jonathan Lemon wrote:
> The OpenCompute time card is an atomic clock along with
> a GPS receiver that provides a Grandmaster clock source
> for a PTP enabled network.
> 
> More information is available at http://www.timingcard.com/
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
