Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4223492BD9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 18:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237659AbiARRE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 12:04:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56630 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbiARRE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 12:04:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0E57B81238
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 17:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27120C340E0;
        Tue, 18 Jan 2022 17:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642525494;
        bh=3zHez4bLqpaFpMusqkjCf3+estfz7PihEyrtNMUkREw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ls7hrqcE1i/W6MsmwbnB3UjOHyIW7M+g8ZfeUO2pLn/vWf9kIu0iUpRjCnf8VPf+o
         MQVARIHrnkIMBG7SfiqPqYEvGOGRYUvYgb4RCj3P2Dx9VX+8tSdKJM+SmbNJ4OZrc3
         hqderv30WR3shQQlkmgcVud4xs6wjZZgVDjmFCPzTCj09GQcARBLdYU9n5IZrAdcq/
         f5oVt3fg4yN00DYpeNN1exlm0pQ4TK/cFXsBCOyi66MNa+Cy7QuykdsKrMRaaEBsYs
         1fyfiHB2FNY7jR+j8iKG2VaA61c+OD1dQ5rOF3K2hf0sf/aDUi8p+r5Qmr5EygLyr5
         cXK0sAq32tSSw==
Date:   Tue, 18 Jan 2022 09:04:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     Martin KaFai Lau <kafai@fb.com>, Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>, zeil@yandex-team.ru,
        davem@davemloft.net
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
Message-ID: <20220118090453.3345919d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <0F05155C-ED5A-4FC0-8068-B7A1738B5735@yandex-team.ru>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
        <20211103204607.21491-1-hmukos@yandex-team.ru>
        <20211104010648.h3bhz6cugnhcyfg6@kafai-mbp>
        <7A1A33E9-663E-42B2-87B5-B09B14D15ED2@yandex-team.ru>
        <20220118075750.21b3e1f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <0F05155C-ED5A-4FC0-8068-B7A1738B5735@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 19:49:49 +0300 Akhmat Karakotov wrote:
> On Jan 18, 2022, at 18:57, Jakub Kicinski <kuba@kernel.org> wrote:
> > 
> > On Mon, 17 Jan 2022 18:26:45 +0300 Akhmat Karakotov wrote:  
> >> We got the patch acked couple of weeks ago, please let us know what
> >> further steps are required before merge.  
> > 
> > Did you post a v4 addressing Yuchung's request?  
> 
> I thought that Yuchung suggested to make a separate refactor patch?

Unclear whether separate patch implies separate "series" there.

> > but that can be done by a later refactor patch  
> 
> But if necessary I will integrate those changes in this patch with v4.

Right, net-next is closed, anyway, v4 as a 2-patch mini-series may be
the best way.
