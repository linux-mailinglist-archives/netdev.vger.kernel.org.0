Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253F4DFCBB
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 06:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfJVE0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 00:26:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35795 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfJVE0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 00:26:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id c8so4330140pgb.2
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 21:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=PGDb+bezf3zSJ3QRa/0khRpkqy3UpsugULOYSjkle8w=;
        b=EfrjsvLAvaQTSkNbKEXS+sTsFFHe5NnD6nKg4d5efSr5jgJxwdwZ/5N2p1MpflWr/y
         oe+8SouNQCvWCwRRN+8fBrSLbbduVCvxL1NCeatSRAdJCfe+v9UIk1CXm6kH+eDlzS2y
         isYXHXCU1dGHOtW0aHzeuyQmiHASyxn4LeVp4Cte9cTQYgQgVniGUHiMiQJfF3/a/be8
         H+44WZztQtdVpvOCD6OAXd94VJX0ELAkuICaG2mrwrRfkCJ18wRPV2mRetTat9DYtP+t
         jg5QnKbQSYTiV01ULm8Chd/932NnrMdN7msF0/EdF2HVg+kvMK1dy3g0dW3ogK7/V+89
         NW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PGDb+bezf3zSJ3QRa/0khRpkqy3UpsugULOYSjkle8w=;
        b=FG4M9aFpOpmI1w++x752MO79BN0eFN4EMISqaVe3umTyWQqOdRkYtR3iPB52jh9YWZ
         vss1lWuH8Xk7zh19dXaPqb2y9NsKB1yv0BfPmeChcTZjGL7REe3EG0CYkTWFYHRw0Q3g
         L21bZLgVIYHmyKZ1E0E0pq0GctRQg7AmEJituv+ukcjzBN9XhM4yW7sADQ8MqOZAby1B
         QdgOglm1F1AcqRuPHjienhw33wgRwJzKnWyl6Ta5gwd9Qv1KhdkatASPUXMASW7qfYdj
         mjjOs76fmuk5bqhpnLdCKopjVj/7DtMedIBLY2QtIq4TW3I9gxaxcqMicJbpSfgG2qfg
         PH4A==
X-Gm-Message-State: APjAAAU/tXFpgl/T/n+KbUjQsU5bWFJXlQAoAIlf00a8q349jYx4TVEv
        v7pKTDFdvIS7P9BK4G4YP8DCQ7qFGOM=
X-Google-Smtp-Source: APXvYqxWRTeiBlW0DyPLLwT3GzD1X1T3t/h9vU9knhxk30dFLfil0OHXWmG0/sZ1ByF5jl73FHRL3A==
X-Received: by 2002:aa7:956a:: with SMTP id x10mr1862040pfq.114.1571718381758;
        Mon, 21 Oct 2019 21:26:21 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id c16sm17816190pja.2.2019.10.21.21.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 21:26:21 -0700 (PDT)
Date:   Mon, 21 Oct 2019 21:26:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [PATCH net-next 0/6] DPAA Ethernet changes
Message-ID: <20191021212618.32e31755@cakuba.netronome.com>
In-Reply-To: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
References: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 12:27:51 +0000, Madalin-cristian Bucur wrote:
> Here's a series of changes for the DPAA Ethernet, addressing minor
> or unapparent issues in the codebase, adding probe ordering based on
> a recently added DPAA QMan API, removing some redundant code.

Hi Madalin!

Patch 2 looks like it may be a bug fix but I gather it has a dependency
in net-next so it can't go to net?

More importantly - I think your From: line on this posting is 

Madalin-cristian Bucur <madalin.bucur@nxp.com>

While the sign-off on the patches you wrote is:

Madalin Bucur <madalin.bucur@nxp.com>

I think these gotta be identical otherwise the bots which ensure the
author added his sign-off may scream at us.
