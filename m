Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C6028BE9E
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403928AbgJLREu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 13:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390355AbgJLREu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 13:04:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B2BC0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 10:04:48 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j7so4140577pgk.5
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 10:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/YRyxiBlnnmPiKDTUrcrLjbGfbEC/ethjvoeOjNFlCI=;
        b=I/CEFok0tqy4QNEObTCbQPKqcAO9Jz9gvuThr7dY5LTunUijDPG7cyy3HpDUqe6BWL
         ekeFs4ynT3EwJHO0Xpbo1kGz/jyZ5fIgquoGjxyyosxua1YiyxZE68RIsxBZzyLWAyeo
         P7f0vygABbqM/ki0QsAzmkASaFaUvW/pa0Wybz2Ee/6IoPWEgELd3pmc2GKQehq5Xvxj
         gfm0y6b154QvsCVSvRnoDUmfRHA1zF/xiARZ6UmV5FAGwC1x/X+LFcxY+t2Knc9mOiNA
         +5iqCT7R7FVQALd6+QffObRaQ6wXc/Rbp6PEwH38oim/JiOM/lgrUMnKyJ0WTk194DWq
         APIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/YRyxiBlnnmPiKDTUrcrLjbGfbEC/ethjvoeOjNFlCI=;
        b=HU/QSTyefyfYRFk8Ha0IU9tqNtJP79gTrvp+qLQKie/fhyh3pVzejgjCv/ZDfiy2Zn
         VQgO+itTAOdrCQD2YxK37YOz8qGgkVstiS96x+tf+3ojcx+DNBOXrpkdQd48a2OfqDpT
         xiA+v1xzUO674cHxZUVeL4YxKMI1gzWYsXnQOe0YZwdPcPcCvDvrPljGS3MQkdHbajg1
         f3S2l44/Y6OEW8wkkNwmmoaEdfuSBWj5F905j97K+Wlc/yE4q2KpQCbyyRxixpHB2clY
         c5G1FNys5oVoJw67sG93ZN+8NaAL2dOhMggnGaABGhyRgSXLlr7IzIfwcQRQcRUqog0j
         xtDg==
X-Gm-Message-State: AOAM531yhauhrZdGAMxC5mp5R28/0LRVfsgDTWG6vOq5771+iUyIwWwD
        8K5MINyZxGk0TKNtMaJZNk5Clw7TbVK6PQ==
X-Google-Smtp-Source: ABdhPJwOUtbzqE2fikrDNL8baVLww/xaV94eLkA9fcEjOGHaC8fufZd4lvkg2aIUSij+facYB37WpQ==
X-Received: by 2002:a05:6a00:7cb:b029:152:94b3:b2ee with SMTP id n11-20020a056a0007cbb029015294b3b2eemr24172547pfu.58.1602522288327;
        Mon, 12 Oct 2020 10:04:48 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n9sm19869428pgi.2.2020.10.12.10.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 10:04:48 -0700 (PDT)
Date:   Mon, 12 Oct 2020 10:04:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute PATCH v2] lib/color: introduce freely configurable
 color strings
Message-ID: <20201012100440.0de0be16@hermes.local>
In-Reply-To: <20201012164639.20976-1-jengelh@inai.de>
References: <20201012164639.20976-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 18:46:39 +0200
Jan Engelhardt <jengelh@inai.de> wrote:

> +static struct color_code {
> +	const char match[8], *code;
> +	int len;
> +} color_codes[C_MAX] = {
> +	{"iface="}, {"lladdr="}, {"v4addr="}, {"v6addr="}, {"operup="},
> +	{"operdn="}, {"clear=", "0", 1},
>  };

Probably better to expand the initializer here to be safe in future.
Also if each match has = that maybe redundant.

static struct color_code {
	char match[8], *code;
	unsigned int len;
} color_codes[] = {
	[C_IFACE] = {
		.match = "iface",
 	},
...

