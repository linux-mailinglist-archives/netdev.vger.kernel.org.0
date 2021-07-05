Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF53BC1AB
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhGEQby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 12:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhGEQby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 12:31:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BCCC061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 09:29:17 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e17so1175760plh.8
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 09:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=joKYzf0RnEzbkvLHKSpz1OG8drIY2QwWffZcwa8hdMw=;
        b=HyzJ81OyQzfWTsdABVhAEzSnMp7d3/e+n1NB2LkDzwNaz6zPK/zySCUz/YwdxStOnD
         gqyojzVc/WmLlWLF5aglQWtss/rkGaw4zOyQT7HJhSRQZTl+bs+V5DxvMxFaucekC2tb
         F8Kgm5s4EnKm0nvmDpzj4i12yUJJIGE+CKSIhYV6oPvS9c2oz37HvMmVljQWMokawAVn
         B817Blk7JB0Zf8mk2ygqoVaudy/dIoMqdzKaQgw23IsYaOx7bqQtOr4pATDYt/FLrMla
         VAo4DxkbY8kMJjcjkRIsme7SxIq55We6H3KbOFt3DxbyHDAnvcEDLW9TjrQB1hmh2GhY
         MxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=joKYzf0RnEzbkvLHKSpz1OG8drIY2QwWffZcwa8hdMw=;
        b=d57k5KKYmqCkle4Dked7hYiYO+FksWiik7D9u2o5PV2HB8KJvz40IkM1Bx0WL/c7PV
         m9cuYCqUudcUPzElUWIHSJtQe2poozCVLbXTcqzUHLVZK+i2U3Q2iE3cFn3PYEf2j6eL
         VfE0jxpT8bQarhpnRtF/tgbUefc5UMS4QR2zRi6lSGhgxM1OMtoft5a/KvsBCpUHf4wP
         WuJTbX4aHBddEJi62IwqpwGJRVgJRtq08O9YydBn5v2xG57xsf3zUY2ncveC0smb5rQ5
         Gxj4LU3dKQlSidUpNvyMBf0sqTXp7BZZLixb1DLRmfZpmX5lwop2KKO36CANFcGszLL3
         acYA==
X-Gm-Message-State: AOAM531uX6km++7b1g4iPrcq6MSq9H2K0ww+bBG6zNTI3seVWDQp+hKH
        nezbnwKeJ0vdIpbER/y1TxOw4Q==
X-Google-Smtp-Source: ABdhPJw1GlhtCRHDBMx4z10B69iPixh+W/dHvHXOS5r8VRl+WQmz3nksv/bLa2N73Ywl78NJb0g0og==
X-Received: by 2002:a17:90a:7d06:: with SMTP id g6mr16174984pjl.91.1625502556696;
        Mon, 05 Jul 2021 09:29:16 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id v8sm13143187pff.34.2021.07.05.09.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 09:29:16 -0700 (PDT)
Date:   Mon, 5 Jul 2021 09:29:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json
 output
Message-ID: <20210705092914.1eca8997@hermes.local>
In-Reply-To: <20210607064408.1668142-1-roid@nvidia.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Jun 2021 09:44:08 +0300
Roi Dayan <roid@nvidia.com> wrote:

> -	fprintf(f, "\n\tref %d bind %d", p->refcnt, p->bindcnt);
> +		print_string(PRINT_ANY, "linklayer", "linklayer %s ",
> +			     sprint_linklayer(linklayer, b2));
> +	print_int(PRINT_ANY, "ref", "ref %d ", p->refcnt);
> +	print_int(PRINT_ANY, "bind", "bind %d ", p->bindcnt);
>  	if (show_stats) {

This should add newline like original by using print_nl()
