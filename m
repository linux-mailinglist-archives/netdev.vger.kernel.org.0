Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05381FD163
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKNXNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:13:46 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45437 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbfKNXNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:13:43 -0500
Received: by mail-pl1-f193.google.com with SMTP id w7so3348429plz.12
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 15:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x7lGPYlqUmx1bpu0rZO+QZMl/ndQB5NAw3ceTVvW0SM=;
        b=BIvsKEGpcuOvq5VgX6NnlKMrVEKeIxOFuaDLy1abFpECSL5Um1X4s8UcRGnbSUExdO
         p7MnQt96aTPYEQHLKHPugwwnY1DtpQSLHqISQv39rDnNGM8YZx9eOHNRTFU6gpOJ1Cy+
         h3D9ecvcltLgr2FYHHy7IusslHkck47BltD8DEmKC7qh++fjC+qoIr9UbNt1ga0nBD3m
         ssq5rVeNYU+BOpw9XCn4i62B3TKz+Sa8I3scLKbWOWsIZpb4BUPc25fLQLZ1uaBFQBQS
         7GCT4kT7NRZbSh+sJhUmURSFaAOgFsf1bXlf+5YBwpiOVszLk+UH2KCuR767VboA+gHM
         HUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x7lGPYlqUmx1bpu0rZO+QZMl/ndQB5NAw3ceTVvW0SM=;
        b=gykFufyIgR6IbLq1GrosuRfy2KKUo7karrnsupCj6QTGSHG2Jv072GvGQiPR/Itoqd
         QopPUTQ81RU7Hm3B+KuaBgRbK+ZlcISfL6nLzeBy5Yvmbq7DQl4PyIIK+aUyBLEyhXkC
         RYpvjFFRpWf2Yr8TdCvkqhfeb9LdFm0BUOomE9C95Ciw2Wxhezvpy4KrvcWyPQTjDM95
         G93g2oHyKdgGtHNBBn8cACmrwaNcculHyU65l3X6qgXsXxSacUYqq5fTKFObvLMfo/LW
         u9HbS8eqXAjpXXiprUfHX/jOV49TQkO4+z7tjMeG08HWDEgpDPmerDzEM6IajoZBxB6i
         RjxA==
X-Gm-Message-State: APjAAAVOEIe1P5cL4CpvZNK6gzSDVh5fVkiGwPN/nEnngoBvYXLIMD2I
        GCBfEGy9fXB0uPHvO1+yyE/aGQ==
X-Google-Smtp-Source: APXvYqyR2hLzrkKAXsFAXG0cNX2j2reLi4Zl2rc4/0YfaSw1EFt605JFZLIsFEHOUuMVPw1f1mnffA==
X-Received: by 2002:a17:902:8b8b:: with SMTP id ay11mr9746904plb.251.1573773222397;
        Thu, 14 Nov 2019 15:13:42 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s11sm7343951pgo.85.2019.11.14.15.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 15:13:41 -0800 (PST)
Date:   Thu, 14 Nov 2019 15:13:35 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH iproute2 v2 1/5] tc_util: introduce a function to print
 JSON/non-JSON masked numbers
Message-ID: <20191114151335.45fe076e@hermes.lan>
In-Reply-To: <20191114124441.2261-2-roid@mellanox.com>
References: <20191114124441.2261-1-roid@mellanox.com>
        <20191114124441.2261-2-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 14:44:37 +0200
Roi Dayan <roid@mellanox.com> wrote:

> +			print_string(PRINT_FP, NULL, "%s  ", _SL_);

Maybe use print_nl() but you don't have to.
