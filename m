Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E48100DC3
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKRVdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:33:19 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:37956 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRVdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 16:33:19 -0500
Received: by mail-lf1-f42.google.com with SMTP id q28so15088805lfa.5
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 13:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7H+HhxWe2cQ/xUkYPoM77qXj298BwjEOdAQIShEPsRw=;
        b=euGvQejHgvo8jcLSQHKVo1wxfaXpY9PI2iBnFtgUKDPC59Mx6XxhqyZO+bgOZVIZzT
         I/eXdv7ublsw4H9YM8Jh/a0jqaxOmoP0PvNmIv/IzeJ1J8lu/013Mjb9cory0/x1ybMo
         U4Sj2JY99OIqG+c3RLwA7g+C06XUtsEtH/LQvn6YjMBpaaJGr08GqUaRykdfRz88Sprz
         3uxveHERfjq2wfsVOlijFWL98Zkakq9qn9K+jZlvU/Beoun2Gy5Ar7LvO2/xxSpiRIXa
         vhISh0SXf9Qz9z/R1WvaO8i5vDKzDwJDyJfo/OHkqLuLNPgmcRQgnvYUe5Gy6WG/yD10
         TcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7H+HhxWe2cQ/xUkYPoM77qXj298BwjEOdAQIShEPsRw=;
        b=ln8/wArT5GWWoEraIgiOqkIVByVVXfXkbODYR1ejiuJ5RaatdDUxYHb1xocez+nzG8
         eT4bLz3O/H/XZugp5nQT7e9ISnipdgm0FnDcrUnsubrK4k3HW4NnKdMMATvDdoCWABMj
         aXoTyl6Fwg7z2iiXjhU/wcrt/qqLOpOJCRswvxJ02dJ7OMV+sZ3mYMy/8Ew0clItPGVA
         Nvdj23x/s9hs3gl5sIzL6Nucd+R57PESd1rSDUWn8dG1xcrrBcnFPqjQP8KPynAJT10B
         wmMHZ7aIASuSucMbRPgnZRL56/TRT6Lj3nDODTjmML0RMWO5WKT1GOdcZLGwVmaAFRQY
         kEbA==
X-Gm-Message-State: APjAAAXnu3MrE3tFBrRuLZSrREjwlLAheYjfMDvFB+uKE1xBPar0unDU
        Ldz6OJPYSh46S8s0GGJ5Ad4c6g==
X-Google-Smtp-Source: APXvYqz+SeZWs2hGSXqw/VCaywmGpCrxvRWfR4mv7VORbJx7CU6DdcH/bMVKwgypNRYrMzGqAYx2EA==
X-Received: by 2002:a19:48cf:: with SMTP id v198mr1002599lfa.59.1574112797016;
        Mon, 18 Nov 2019 13:33:17 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w11sm10533562lji.45.2019.11.18.13.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 13:33:16 -0800 (PST)
Date:   Mon, 18 Nov 2019 13:33:03 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 04/15] octeontx2-af: Ingress and egress pause frame
 configuration
Message-ID: <20191118133303.38d7bfbc@cakuba.netronome.com>
In-Reply-To: <1574007266-17123-5-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
        <1574007266-17123-5-git-send-email-sunil.kovvuri@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Nov 2019 21:44:15 +0530, sunil.kovvuri@gmail.com wrote:
> From: Geetha sowjanya <gakula@marvell.com>
> 
> Pause frames can be generated when NIX/NPA asserts backpressure
> due to insufficient resources. This patch enables generation
> of pause frames by CGX. Also enabled processing of received
> pause frames and asserting backpressure on NIX transmit path.


I'd expect pause frames to be configured via ethtool, you say:
 
> Also added mailbox config messages for PF/VF to enable/disable
> flow control any time.

Who's controlling the mbox? Do you have any public docs for this driver?
