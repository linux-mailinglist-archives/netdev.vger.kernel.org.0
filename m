Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F298FD3483
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfJJXnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:43:47 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45569 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfJJXnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:43:47 -0400
Received: by mail-qt1-f196.google.com with SMTP id c21so11262290qtj.12
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 16:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aFjEeCPpwDGtcFUfAvGRLWSs9tH0pWhYeK49/qAEe3w=;
        b=KqdPkeo8pFmDW24GOBQi3MFrZBR50xxIPsw3zut895oLeKyesfTjZ5OyBn6VJjdZZW
         2TVlPK/ESi0IfXamFQE/w7TAZ1YLW8NCs1OPfnshiVpVuPUIxJgsC5qzApt2udqgpwp6
         HoXJmev6WO+XUAjtzYeOZ0oJAj6Id1/Pb8fqrdjyQ1QU+Z7woS7HC7TcvCy8JRfc1FVI
         /bqTabzLAD80xSKAWs9gzCMS8aU0uhsrO40flKbCwUR2VQ7+jhDH+2owx7d5wzkRmDSs
         4oOy7lL9lih14RCeZKYlUfejYI3lunATzkpGPAtPeT5PaPSsKAzGwdbLjxt51+69+eq9
         Y6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aFjEeCPpwDGtcFUfAvGRLWSs9tH0pWhYeK49/qAEe3w=;
        b=XhhCXDVlXNZvE/NRUKTNQYHPLXvHOfEiW1hBqmKE8goHecDoeeX//yAC6cvd3cAuF9
         msve+Oo0jH1RXtvIHMshf5QEtsZeFFrFzk8AcFmXw+jWCUD442nWGfosfrTx/n/UDu7v
         /AG073VUUBmCwXHQFLJ1Lckm5aznbNfB5iIrIHVujQZQoG/KxgbV2iu73qyM/sJ/Aqqd
         CrgpTuzWmpyQL5Gqh8YOfVR3A+X7r0JXrU04x7G4oDFVSBIBEPaJQt8/G0dBJLTOvgtI
         WJgyCnSROUNqxinpk22QbNvA6AlP8FnfVXdI6YN2CvaXyGGqBDCkOpisr318icUAXODJ
         BSKg==
X-Gm-Message-State: APjAAAUNJY7KdcyRWCBiG941RVYwe7fLdgkiVPTtejLKgyzjK01XdcG+
        NEQVuuFBxOK30pCZJ6zAcyzbZw==
X-Google-Smtp-Source: APXvYqw8Hc+8L1GQG4lY6/pcoTCQNnKLlw5AKApoAsLLd2wnwOv+bVSzax6biHkYD73Us9QGNzUG0w==
X-Received: by 2002:ac8:237b:: with SMTP id b56mr14146612qtb.264.1570751026225;
        Thu, 10 Oct 2019 16:43:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m125sm3343405qkd.3.2019.10.10.16.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 16:43:46 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:43:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Tal Gilboa <talgi@mellanox.com>
Subject: Re: [net v2] net: update net_dim documentation after rename
Message-ID: <20191010164330.68c5dbf2@cakuba.netronome.com>
In-Reply-To: <20191009191831.29180-1-jacob.e.keller@intel.com>
References: <20191009191831.29180-1-jacob.e.keller@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 12:18:31 -0700, Jacob Keller wrote:
> Commit 8960b38932be ("linux/dim: Rename externally used net_dim
> members") renamed the net_dim API, removing the "net_" prefix from the
> structures and functions. The patch didn't update the net_dim.txt
> documentation file.
> 
> Fix the documentation so that its examples match the current code.
> 
> Fixes: 8960b38932be ("linux/dim: Rename externally used net_dim members", 2019-06-25)
> Fixes: c002bd529d71 ("linux/dim: Rename externally exposed macros", 2019-06-25)
> Fixes: 4f75da3666c0 ("linux/dim: Move implementation to .c files")
> Cc: Tal Gilboa <talgi@mellanox.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> Added 'Fixes' lines for the relevant patches and a CC to Tal Gilboa to
> review.
> 
> Updated the alignment and additionally fixed the example to use
> DIM_START_MEASURE instead of NET_DIM_START_MEASURE.

Applied, thank you!
