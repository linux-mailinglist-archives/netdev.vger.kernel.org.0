Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF23107C29
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfKWAsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:48:52 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36180 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKWAsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:48:51 -0500
Received: by mail-lj1-f195.google.com with SMTP id k15so9358827lja.3
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 16:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CO1PvkNBKC29DHOlapGJKqbdGQIw7CGnLoX3d7miUss=;
        b=b9dT9QGuKRAdsXfYMKphv0AIll/WvgeSmmKC+Bf6Ve9YF4POy2ijzM7FolFQQH28jR
         4BvrmLKml4dTaKl2qonDiVEcEGXkCgo5ET3NsZtKVo47RcDisp5UsN/hlaIS7lvaFYUp
         jbz7YNdzZJDRJWJQ4WWOu7t9zK/wtaNB2aI2buc7Nr18D/q63jWc3Z7mYUO089n4q563
         e4S2RN45QhhQLsuMok34eWMRFAH8kCUAvKXyKrNN6QB8HZHwKmlN9Yd/fYQAOqk/Y/Qc
         nVY1oYp4ojjPT9X/fPUq861WQKuzAGnHsn6b0C3fTo+/wLPOCfR7K9fHGRIXByTOnYHN
         93yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CO1PvkNBKC29DHOlapGJKqbdGQIw7CGnLoX3d7miUss=;
        b=L9u77EJr+mI++dXwBUwV7QyHdGkdBpt4zC2N+v5cnRqcltwKqiJk3LndRTnl2L9+dI
         vHCiuAn7MN/MxkhmJbgE1Tiq7y6DpvFAUux1ISKWLuaIbXTrnAfcdQqXzV4YXHdPsxaV
         45ERBxa8MQPFKqBcNlNLZSNERm4Q1d781dSzVJ4aBtannCh0iTQC1pv8rXaEAHB/RdTj
         NFndSVl7jpSJlCW/vdP2AMOmnNcQdPyx2EQC7ymJLR0WdeFk0/SrfOJwxsj9NK83f78N
         F/c4XGs8dz8lLSN+hIQ3Ehh8wuPcjqSuFFMIp6MbCkULA1eNvEyLXw63HJUwXvlZUx9e
         aILg==
X-Gm-Message-State: APjAAAWv6hZOHPW7zXNp/oUSpbqfCNv07NJ/n1H3lGkCh+4ZtEd7IAFz
        rb6lHtvlDWbnTGGbrqQsEInZzg==
X-Google-Smtp-Source: APXvYqzrhPo6DSbsP2edvEoJaffajmaT8DOabrty6HjlIS7HrmOkDHtSYMhG+4Bp+cvrQ18E9F69DQ==
X-Received: by 2002:a2e:c42:: with SMTP id o2mr113538ljd.222.1574470129738;
        Fri, 22 Nov 2019 16:48:49 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w11sm3786846lfe.56.2019.11.22.16.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:48:49 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:48:42 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v2 0/3] cxgb4: add UDP Segmentation Offload
 support
Message-ID: <20191122164842.1d040c81@cakuba.netronome.com>
In-Reply-To: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 06:30:00 +0530, Rahul Lakkireddy wrote:
> This series of patches add UDP Segmentation Offload (USO) supported
> by Chelsio T5/T6 NICs.
> 
> Patch 1 updates the current Scatter Gather List (SGL) DMA unmap logic
> for USO requests.
> 
> Patch 2 adds USO support for NIC and MQPRIO QoS offload Tx path.
> 
> Patch 3 adds missing stats for MQPRIO QoS offload Tx path.
> 
> Thanks,
> Rahul
> 
> v2:
> - Remove inline keyword from write_eo_udp_wr() in sge.c in patch 2.
>   Let the compiler decide.

Okay, these are good enough, so applied to net-next. Thanks!
