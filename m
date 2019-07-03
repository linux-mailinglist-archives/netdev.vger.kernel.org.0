Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 872B05D9B3
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfGCAvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:51:06 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33275 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbfGCAvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:51:06 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so467424qkc.0
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7y5iZQP3NTaiHOlf5e5QnS0Wr91efRpdAU0ZahQuhe4=;
        b=1e5izaO7WUOLXlZXdLiKDz6Ch5Ybps3H0361nHRXaUzMOmxyYe3eTa813FKCBSsWeE
         9CqJ4NmmAaCVi3UNYgpCeiTaQFhOos87bBNoeh7HM8MHm6axU8Bt5bWp/nxuXAZJI+3b
         AsXncE2ECuMh/oP1MZusFq7Y7qq+rF/cYSzH2bE68JLmffuJvkbwCShWn+rwkfr+HuCI
         r7TbGcEcDWYICSn0ieoYQAIEdn7Km4prfcgNWaQbnfRYuO4Yvb+XmNbc8JhFR4rGr3Az
         GFN4EbaJr+ZfJPubbkv0SL/fiC2kDiPw6Qw8EWjfnolQhiZx6XjsWe3CXNd3ZglFlPQU
         BhXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7y5iZQP3NTaiHOlf5e5QnS0Wr91efRpdAU0ZahQuhe4=;
        b=UUk7U25pVSIEVB3/S7wJRXrto8HCSQQggMErURjZFdoLPAogghPwHALzdS65Xl8/t6
         pbReUvCbPx7DshLfNWWViLTBlb3sch8nZCwWauNUrbRhEFF4z7G0Ty87UWNuomjFNIgl
         pgl4uSUgV1JU4kOFLyHTU5ag/rUOXj7LrQoOVb9cEHK78/IFIQEuFmoxM4MaYn/7f2hu
         JTlfBg51xlJ6EAektu5KrR0O2+FhN+P+Taxk4chV2+pU/GtzaQRe9zunF5KsLcHSD6Wr
         836jg6pK3GNYKIl4qJYNP/1uxNHAPVy5s1SMZvCJF1mnc6KOsmxSAFK9+/tAYiziAcO9
         YKiQ==
X-Gm-Message-State: APjAAAXM3mFDUY9RlqK+U3WrLhsAiVTCkRYfUl1mIXAu5nC6z815Pwr7
        rvq9dLe0/k8f2KrehoOy4ISKgb9CH8I=
X-Google-Smtp-Source: APXvYqzAWLm4Z6LJuRydxiIbb8ho5QK8qBj0LyABzU4FjGkH9rS5R1VTKdvve0mu7uyMLkwCMKWiIw==
X-Received: by 2002:ae9:de81:: with SMTP id s123mr27911887qkf.339.1562115065437;
        Tue, 02 Jul 2019 17:51:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f132sm222695qke.88.2019.07.02.17.51.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 17:51:05 -0700 (PDT)
Date:   Tue, 2 Jul 2019 17:51:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Mellanox, mlx5 devlink versions query
Message-ID: <20190702175101.67bdffa9@cakuba.netronome.com>
In-Reply-To: <20190702235442.1925-1-saeedm@mellanox.com>
References: <20190702235442.1925-1-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jul 2019 23:55:07 +0000, Saeed Mahameed wrote:
> Hi Dave,
> 
> This humble 2 patch series from Shay adds the support for devlink fw
> versions query to mlx5 driver.
> 
> In the first patch we implement the needed fw commands to support this
> feature.
> In the 2nd patch we implement the devlink callbacks themselves.
> 
> I am not sending this as a pull request since i am not sure when my next
> pull request is going to be ready, and these two patches are straight
> forward net-next patches.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
