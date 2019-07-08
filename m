Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431B462552
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbfGHPPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:15:09 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34395 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732253AbfGHPPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:15:08 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so8451242plt.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 08:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JxUQURsKuRML9kY6UhtzFtnOQHOYUvHcx3HxeIXuQBA=;
        b=u273nrBnzw4ft6QG/68VVqOCnmvyVqTEGF/MXRllZCzWQpYsq8RhpBmtcNa+UPvRNC
         nz899bKe2vMGGXYI3Pqgl2rZkpG7MzP+xxk1xtSuRRibjjGMCMU9h3muaJ0f8fVdqDMI
         EoiRGzNZ3noxYv2puMxIvGJ/LUwScP/m1I1TecWyO+RZMOWYOgD43HkBlsG6Nzn++RUA
         s26QDXMLoRkkYNP+BZngMwfTq9di/6OO0IkO3IC54N+K6QSdDClia/ZmA7V8WOKHMOwv
         d4/iN41jcXByCY+FcttVka0740BXRF2DY+be8o3bnLE1+lVmNVN9zK7sRtunQTrnzfYO
         ru+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JxUQURsKuRML9kY6UhtzFtnOQHOYUvHcx3HxeIXuQBA=;
        b=cNaeRFDfx13l0oo1SX1kBmZy0+PZu8mV+T03tLCA0k5p6HQdyn4lRHnScy8KtQEfpa
         x2QnGqSlwqqetUjNIKSgloe4CY9kEMWgegymugeSXcDxu+/N0+nVJXnWhVpL1PmGGfsD
         Ie1GP+voy77XPvbjKoc5JrIeLN1CWP2yCidiSMr3orv4KV2o1NMd13Sw3ThKWpzIfDNQ
         BKnC1WiIuO99fSWkafojNPG7TAkGm4uV/+Fq+YMupr4GcXRJsvQH8aG0snfg+TDKnLfu
         Deur1XH11tBJGw0ggcxrC5lhy1Svon9AERO3GwotLaQPlbr5gtgIVPOTQkjd66ycJbWc
         G0yA==
X-Gm-Message-State: APjAAAUmpTTtq3n/mpOo8CZWdVnaCs6XzKNRrItnzAza20xn60A3rA+E
        evYqvi8x3hLgnDTxeFM3TE5d1Q==
X-Google-Smtp-Source: APXvYqyjsDn6bi10c1cBDKg2WMNJIA2iqOrHw7qZOOnSzE4t1Xm80ZoVpvbjalxfbU0dPzAi4OQVWA==
X-Received: by 2002:a17:902:2b8a:: with SMTP id l10mr25545714plb.283.1562598907966;
        Mon, 08 Jul 2019 08:15:07 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s66sm23363661pgs.39.2019.07.08.08.15.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 08:15:07 -0700 (PDT)
Date:   Mon, 8 Jul 2019 08:15:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2 1/2] tc: added mask parameter in skbedit action
Message-ID: <20190708081501.665e7ddb@hermes.lan>
In-Reply-To: <1562195132-9829-1-git-send-email-mrv@mojatatu.com>
References: <1562195132-9829-1-git-send-email-mrv@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Jul 2019 19:05:31 -0400
Roman Mashak <mrv@mojatatu.com> wrote:

> +	if (tb[TCA_SKBEDIT_MASK]) {
> +		print_uint(PRINT_ANY, "mask", "/0x%x",
> +			   rta_getattr_u32(tb[TCA_SKBEDIT_MASK]));

Why not print in hex with.

	print_hex(PRINT_ANY, "mask", "/%#x",
			rta_getattr_u32(tb[TCA_SKBEDIT_MASK]));
