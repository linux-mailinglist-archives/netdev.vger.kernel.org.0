Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855031AF46A
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 21:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgDRTxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 15:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727951AbgDRTxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 15:53:11 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85990C061A0C;
        Sat, 18 Apr 2020 12:53:11 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h205so3023144ybg.6;
        Sat, 18 Apr 2020 12:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oN/swMoM8H/0UNKPqrkT/bcy9j0GVDm0VW4M633/9q4=;
        b=Kan8r+1WdU9fvLczn+6hQXY7yNfA9YW2YXU9og4kDOt46aKh1VrXuzkvomzvRoMcJI
         4te4QKQa36qfvAuRhJvR2BW3ksrc4+wJqM/5VfCFmHpaDjgUzmbCpInWWvzIyR/EAPiN
         cJ9qsTpIfk/JfplUSeTXGUzotNJIR65bXnjMMLRu833sOK9QzZqda66Z2cqogZvRYfZa
         DGGpfzZSJiNTqgSdx+moCwEXyFaW9kov1RWkMnHE3RlDuqvt9AYL3JSbp9S50Ena0kOb
         h7fINamfAadrnDmyoQsbRS6v9litETGdAHqV6zbNUAaiciZvKTjp26zLD1gXaU80dEAt
         4xQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oN/swMoM8H/0UNKPqrkT/bcy9j0GVDm0VW4M633/9q4=;
        b=G4sYOhq7jwz0DQcADvjKMwGsma62PoOTrTBZd0fEcohI5XzGFGS1+5RMfYZDfQMGgq
         dTIhyUwA+Ot7sN+mshWrVr8fmv9e+/vmXbMvzkut7r20FdUbALD2wBIecwBaFEHrRIlo
         Fd89k5+t708IoNvJzxA543F41vr2/phMXGcALgtWARzIreT4FWQ0fttNlhfROR3Zzvqr
         q0d/DFybupjPe2yabnVPDDnZX8+jJJ1klDcsMxS7WY7RKM7qLljyVy21+k1o5/OL6t2S
         7sNBjvyCKM8l/9PbP4VXTX8toidWFbyqLEbXDu350LEUEshXLTsdZm63HB/MTZBdFMXa
         vJ1Q==
X-Gm-Message-State: AGi0PuboJXLeQtg183t8uEfllNW9m1MwD963jC0zxkwnlmfZmseOZObD
        VIC8ob2ZO1qiw8jxozBWOwMyc7orCTnsM+3WFXc=
X-Google-Smtp-Source: APiQypKVFnFO8mZhTArIuQ0CHlq0ZL82vMqUNd/CgIgLt24zwRtHxo1XNzZECgX0y2fblOhmQl4PGaEIc06WKoOXfGE=
X-Received: by 2002:a25:d047:: with SMTP id h68mr8061830ybg.257.1587239590655;
 Sat, 18 Apr 2020 12:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200415114226.13103-1-sashal@kernel.org> <20200415114226.13103-6-sashal@kernel.org>
In-Reply-To: <20200415114226.13103-6-sashal@kernel.org>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sat, 18 Apr 2020 22:52:59 +0300
Message-ID: <CAJ3xEMjKozXW1h8Dwv96VzCegOsyvyyeZ4hapWzwStirLGnAqg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 006/106] net/mlx5e: Enforce setting of a
 single FEC mode
To:     Sasha Levin <sashal@kernel.org>
Cc:     Stable <stable@vger.kernel.org>, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 2:56 AM Sasha Levin <sashal@kernel.org> wrote:
> From: Aya Levin <ayal@mellanox.com>
> [ Upstream commit 4bd9d5070b92da012f2715cf8e4859acb78b8f35 ]
>
> Ethtool command allow setting of several FEC modes in a single set
> command. The driver can only set a single FEC mode at a time. With this
> patch driver will reply not-supported on setting several FEC modes.
>
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 ++++

Haven't we agreed that drivers/net/ethernet/mellanox/mlx5 is not
subject to autosel anymore?!
