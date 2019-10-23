Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4568DE25A0
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 23:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407630AbfJWVpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 17:45:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34029 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389405AbfJWVpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 17:45:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id k20so12924004pgi.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 14:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wVv/gko2xWydu1JLZtRsll56bUGrw+ROcPrNQCSfTJI=;
        b=ZFx94vzJn0d4VhTBSKl8pZ3cNITWuInv0ZaLrw6HzWUHawi5zY1iz22K6DjYKMZvi6
         lo0pPFvEXMrus2Q/Tdj/o3HC+LG48K4X2VX2jLGEzZUInOqGhZqXVmOXrQq+VsG0XXqs
         xVNHsCMCxYeHtDA0qciVh1+6Pvr4uzjH/8iPs4rqwdcqIOHyQn0A1w42t6Cnf6/tU5/v
         kyym8hCzWKvi3iG19FKp1cde3d2f7guP3IpAtuQyLg2/1dkDOLpBcpK8bYsDEXSjzhbi
         GsMWfQ9b/NdoBrTlwh/kd4bsTewF/8tAhN+CyvP1EJAzoM4X5YDrJg2v46v5EQnNTnov
         UaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wVv/gko2xWydu1JLZtRsll56bUGrw+ROcPrNQCSfTJI=;
        b=R0cET77q0ecdzORTbZvUisRMDFeONQF1PpIT7gVLH1QH3JRcAKs+ngxMWbGkv2X34p
         ilV6NJsO2sI4NhnHtqokoabY6zNFo/sLVroVq5ldKtNqFNxQG+ijj85YVCuHY4o3s/wB
         lWCOgNDD+ULlHxsTKVN+NXL3Ay+bSOiag8UcUSnCH4g1o8tzlxm3sKOZfdzxv73C+nKW
         TZrsZVCRxqnaSCQpYmns99H8KiVvoqFwZSnbgRX8pTMip7HWe8+UZBUu2mQj98SaFPob
         1QPK6GU4M2dER1G6OzNCtrZp1ddLWLE8K0WHaEIuSrvTFYzic5gVdQsjVhCI/1vMBzPU
         5l3A==
X-Gm-Message-State: APjAAAXkzZ64cwo5hpAgqk4G4WIyizW1as6faupZu0pboTbTYX/6RkW8
        budscMilMrKCUDiA0sMbEHQ1nA==
X-Google-Smtp-Source: APXvYqyBUlroWXdDEK+9x99Nvnz4DuIfDVTK1gervfMMHpetGzPNRKsRT97RUlND/2P1ksbJTbqNIQ==
X-Received: by 2002:a65:5603:: with SMTP id l3mr12522428pgs.56.1571867111673;
        Wed, 23 Oct 2019 14:45:11 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id r185sm25445780pfr.68.2019.10.23.14.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 14:45:11 -0700 (PDT)
Date:   Wed, 23 Oct 2019 14:45:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, roy.pledge@nxp.com,
        laurentiu.tudor@nxp.com
Subject: Re: [PATCH net-next v3 0/7] DPAA Ethernet changes
Message-ID: <20191023144508.548edd4f@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
References: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019 12:08:39 +0300, Madalin Bucur wrote:
> v3: add newline at the end of error messages
> v2: resending with From: field matching signed-off-by
> 
> Here's a series of changes for the DPAA Ethernet, addressing minor
> or unapparent issues in the codebase, adding probe ordering based on
> a recently added DPAA QMan API, removing some redundant code.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
