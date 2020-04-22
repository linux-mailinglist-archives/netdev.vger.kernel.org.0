Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA641B4DEC
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 22:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDVUC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 16:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgDVUC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 16:02:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AFEC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 13:02:54 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f20so1628090pgl.12
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 13:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=up7Ghj2X9fexnI6THoiRpxPwb3cn/4j24Lf4RpcbZ+s=;
        b=MYiOgTynkmHXAJRAPBgMjfpWwCIoUvw6todL5ANGSC83z63E4tiglnScLvyze8bTNS
         BBuinKccHoLQlnoVpj9TOsuSavydlW+fs1IK1ThhRJc4AAn3UfECFYOWXeOHxtKf4sJf
         uuCV1EmxvRUJyLhr18zhPy67WbXliRUVNTcueN8BUhqBhk/FvyNiLFgNtM6ETqGuj0Nu
         0Da/gqUst2kjkByAtHtrcRgkIE5lXRwdhwqhYwNb8Ql+vjNHx4yUtVUxKMpmo/BQwEkx
         OfcKdPRMzi8WX66sNcqN8/zIiTtym+QLtSvYINlAFue79t0GmQXxP32oruILi9ZWH4d2
         vGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=up7Ghj2X9fexnI6THoiRpxPwb3cn/4j24Lf4RpcbZ+s=;
        b=XD7tlqPSAOfF3G3kZ1vrvXaDFZwDGiY/9G1J49Ey5zFcaURy8KOAKLctezEp8JrhaJ
         wYuYy/kaqWjgO6EkUYIov5usFcm5xXYbernQJVMHGqKb2l0+b1GDNPRhLFQNn+fl2Q0A
         VcGXxXEOM6ps4BY/tb1/3oPmiRy+9ED/V+y+nhOAZg/Q/CegwZ1MnUV3M2Rk8j1HhIsh
         qwr0J5WW9eJzQWgLnH/0EVdcauFD5epkc12qieZNy5lX/HiXqyPYfjn/rYApgcG/87V2
         KBkpzlixCyLeZaY4c/sIXD1XvrDwbTbkQ/rXPm48l7zxkFqhUx6yGZC/uR+UgX8tMiOc
         aVFg==
X-Gm-Message-State: AGi0Pua0emOImx0SfVc/N+Ef+TbB2wOqffRQ4VTwqPzYo09LsEuCUbms
        /O5FYtezn77iHCaONc3IttyNNw==
X-Google-Smtp-Source: APiQypKXe5xq/ATd/J9XzeFqTOQezkpVJ6GYaoTFtXVLoRd6xxgxPMLMwOqqrthNwqwtULkyUdlSWA==
X-Received: by 2002:a63:62c1:: with SMTP id w184mr704279pgb.296.1587585774085;
        Wed, 22 Apr 2020 13:02:54 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d5sm328067pfa.59.2020.04.22.13.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 13:02:53 -0700 (PDT)
Date:   Wed, 22 Apr 2020 13:02:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2-next] tc: pedit: Support JSON dumping
Message-ID: <20200422130245.53026ff7@hermes.lan>
In-Reply-To: <19073d9bc5a2977a5a366caf5e06b392e4b63e54.1587575157.git.petrm@mellanox.com>
References: <19073d9bc5a2977a5a366caf5e06b392e4b63e54.1587575157.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 20:06:15 +0300
Petr Machata <petrm@mellanox.com> wrote:

> +			print_string(PRINT_FP, NULL, ": %s",
> +				     cmd ? "add" : "val");
> +			print_string(PRINT_JSON, "cmd", NULL,
> +				     cmd ? "add" : "set");

Having different outputs for JSON and file here. Is that necessary?
JSON output is new, and could just mirror existing usage.
