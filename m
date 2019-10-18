Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB58DD539
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbfJRXNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:13:33 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:32906 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfJRXNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:13:33 -0400
Received: by mail-lj1-f175.google.com with SMTP id a22so7795258ljd.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qA1MFb6ei3BdfN2vhak/w0CToNVC5IC2ff3F1lbGgOo=;
        b=CqmloURng3cWouU++Esbgzufkbd8zUzuZbDW9h/wDW2ezWO9sVWljWz5dJeltTQdct
         nlaYmKX16PbWvkP+dniH+EJu5kbyfPruiS6iid1ffCpLV0u2zWnPcBMRHBgGVfcHmfJ4
         NGwy/iYZo8xYl/VwYBORjRFNSkiGov26a+V3Nu8U31t+7oWV+3XVr0QOeiT39tFIpNk4
         Ut0elUn7+vb93F2uNs2JZW8g9Z+Z0gJs4E4q8RlriBS3kDv1VvfwZNya4ItbvZNEXBKZ
         vti0WatdptYcEYxThCiAONKio5gHXNJOTJp2TENqrhMIUMHaI+3DFhsuLmqCNLx8FiAE
         xirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qA1MFb6ei3BdfN2vhak/w0CToNVC5IC2ff3F1lbGgOo=;
        b=X1R1Fs7YXnQvJb/bfNKRkZlwufa7EQIcNrtvg3NCFCGowT78l0/BQmQCWBhqq1ZwYI
         zru+BV3E2+y8o93BFoOdVSgXLxlCTzNX81eIxgi5OgQCMN5J3wcO7+z21mw0Ptw4O4pB
         7v1uWft1ASeAeptLhtGFASPfujxg8Ab6avzx8ohZKjK2UPEH3MF2bQ8lA8X3VC0N4WSN
         ZLnVMzUcHtMSghNQu4kOB2iXqdWAb/4xlwei0oYmqMjsHqq0shDQ0jeiwZEgxAKKFO9Q
         2i3C9OqiFWRl3QvkStcEX8cdJSOJ2ptVpepadmBvBFgjCf91erTlhMlidsZ+HHdq1vNX
         DXtQ==
X-Gm-Message-State: APjAAAWjBAXsAlxlJuNpSTShWla0Z9l3ndigpvMZnZFHCG62cKwN8jSj
        T9/WQp76htag68pMq0zbK5i5ow==
X-Google-Smtp-Source: APXvYqyP6RiApYvtA7W/z8i5qqzr78ZctQ4RNmJL2txCKCBvH0MQlBJM8vFw3MTKpUMBG4+vXyHlDA==
X-Received: by 2002:a2e:9a99:: with SMTP id p25mr7400313lji.171.1571440411709;
        Fri, 18 Oct 2019 16:13:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g21sm5741390lje.67.2019.10.18.16.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 16:13:31 -0700 (PDT)
Date:   Fri, 18 Oct 2019 16:13:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net 10/15] net/mlx5e: kTLS, Remove unneeded cipher type checks
Message-ID: <20191018161326.77187297@cakuba.netronome.com>
In-Reply-To: <20191018193737.13959-11-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
        <20191018193737.13959-11-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 19:38:20 +0000, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> Cipher type is checked upon connection addition.
> No need to recheck it per every TX resync invocation.
> 
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Is this a fix?
