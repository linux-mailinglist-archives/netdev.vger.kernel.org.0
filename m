Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8DA4C7243
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 18:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiB1RMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 12:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiB1RMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 12:12:00 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFE37C177
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:11:21 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z2so11292926plg.8
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sdXbA7b16MYPyYs+ZVefPYCjpTDUh1QfsJOXq6pMyOQ=;
        b=bHJpOKk1FOEO/kFbHqpk/4O162kNx2cfqrMxgXmC1/YhobPvAD6lzfhr9sbWgOilqM
         +bVsiA4tKoDE36RDYp1fh9yHCrpqPlEo/USy6T+mioYi0lQL4Z+BBMR4lGQbdYRcjwWL
         Uw8cZN23KPRmFQloLww6PaSH4y2zalAxaEPM7C+soT1V2VY4POnRZ/D8c+O5Cz27DK6G
         LFZE3V4x9f+XXde94DJLl0gWpJ/H1IFhwDEPM6qhHkPJ4jXtKDWqo1BT5014haA8znH1
         QZcWmUFwcmeaipFYv9+MUA1Ido7nd3LRyFUvjeUodbyZYsJT7XeHsc7mK1HxWo2KTQG5
         V2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sdXbA7b16MYPyYs+ZVefPYCjpTDUh1QfsJOXq6pMyOQ=;
        b=6N7MSl3opbWtxPWSVO5erVmcaFO1KqIO5naOy18v6szN/5Jh2MA90/ffC6EABTjTQ5
         OR2PwDGzYpXVO/JMUlHu8XeUW8kyqGPpxvv9fiAMZzy/oUflWOJjXXyLFgkyePLuMX6R
         C9VktegoIa7X8jvWzLVlXowh/74In0R9p7TkEyRuqatNSfY4pOn1xmzIpV/9Vy8r4SFg
         4N9XJVKQ2jF7Eax/rimqcKBZOJtUZUElUkGPrtWPE3vIg0Oti8f/Wu6V+elNZD1XrhPt
         m6+pbqlH9pDbe5eyuvsNld4PkvjDStHv/RndOh0UQKJoTybYQbDae6RYRW9WXNo4nXlf
         R0pw==
X-Gm-Message-State: AOAM530ewa+zhQwejGsnw+TnTOT2TREtef+RROy/8tmOWjuHOFo5zAUo
        CKO7I+yrExr2O68Ky9aIOTmG25Bd0L8hcVC2
X-Google-Smtp-Source: ABdhPJweC20YhtVGB5591w8nifi58Hy6Z+HapKBhlANpOgtQCYyN/+d8Q2184RFfhnUuS03AUxZ5/A==
X-Received: by 2002:a17:902:b410:b0:14b:e53:7aa0 with SMTP id x16-20020a170902b41000b0014b0e537aa0mr21644785plr.101.1646068280980;
        Mon, 28 Feb 2022 09:11:20 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004f1335c8889sm14260609pff.7.2022.02.28.09.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 09:11:20 -0800 (PST)
Date:   Mon, 28 Feb 2022 09:11:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] configure: Allow command line override of
 toolchain
Message-ID: <20220228091118.480b35bd@hermes.local>
In-Reply-To: <20220228015435.1328-1-dsahern@kernel.org>
References: <20220228015435.1328-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Feb 2022 18:54:35 -0700
David Ahern <dsahern@kernel.org> wrote:

> Easy way to build for both gcc and clang.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
