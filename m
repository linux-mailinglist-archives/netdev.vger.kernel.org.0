Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E953EEECE
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbhHQOzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238070AbhHQOzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 10:55:03 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788CFC061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 07:54:30 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so10332137otk.9
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 07:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JjT0LkGnsLqp00Z8pgbblZXTFWmZMmfJU/WNsKUX1uM=;
        b=hVPdGeEYIh1SpzE7By4NH/qFk2EmUKHVd7u5R1L/LwqCw/vGnBAna5bOTubKGh3Vwo
         tgj3QpdS21MEl3KdZMn1H8m/mnKOtSEvadRhenQpGbyS4MZLlQZ2gVSSvuBiSggY5mbm
         n2PtGYRPxkFVh+H0MG/l9BzrcvnVA4Ey+EHi9TfCiUA4knUSkw6ZJXvHE2496zlnCUbb
         ch8sNMbLtKzdN+Z2w3Qf4ut51F79/C70ILSJcxEnf8XgQdypGrKf8pq4+zTkISYVpnOJ
         wKYWWS1vVavWk/aY/f8O45OG5oqPg2BCypf86ILx7H8AjHj675n17keXOnojPC+kN6pC
         Uy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JjT0LkGnsLqp00Z8pgbblZXTFWmZMmfJU/WNsKUX1uM=;
        b=to5yZOaNK9rrkvRsqmORMsrZINsgxRRQL0TndE2a+BvNECGfYzemr1yUI+oo0unPjN
         oZ6OsSW7wq38sxQ957X/9z4Px+oP3p5xo8rUNMbN894G2JI1hn3tQQpZXP0C0Es8fibU
         aOV0uaTDaLAqofKqQGjbPtsHqsKsJ06PIh7T8NZG+8zfsYmtzZnDITEBayOO2hPT3i99
         bPM7JIF2tjCW0nE954RynerhOOY1QHgrsHA49zvpvAj/IIxu48APCCUDHIM3EV/S4TGR
         HfIWSMek5loOZ7oRuemv4JjyswY7hcxb1ewTiDwp8ALJKkut3L4ovTS58tyQiHkj51uU
         HMkA==
X-Gm-Message-State: AOAM531Cdw0j9lyIZ6tqLNZotF6G/zB8Lt9j6MiFuMm6FlZbXipNMTsm
        3DEnSySfOwAGGDWjl1GrqKk=
X-Google-Smtp-Source: ABdhPJwD02pUpuoQcjs/mf7HYgvhrlutu9nMw3JyZgPc2nLjvwmu8CHmneF+n9UOBA0hNyDWAmeKag==
X-Received: by 2002:a9d:6192:: with SMTP id g18mr2956915otk.314.1629212069937;
        Tue, 17 Aug 2021 07:54:29 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.6.112.214])
        by smtp.googlemail.com with ESMTPSA id bi18sm516150oib.54.2021.08.17.07.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 07:54:29 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests: net: improved IOAM tests
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org
References: <20210816171638.17965-1-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c4fa0370-7f32-cea1-cfab-ec49170a7653@gmail.com>
Date:   Tue, 17 Aug 2021 08:54:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210816171638.17965-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/21 11:16 AM, Justin Iurman wrote:
> As previously discussed with David Ahern, here is a refactored and improved
> version of the IOAM self-test. It is now more complete and more robust. Now,
> all tests are divided into three categories: OUTPUT (evaluates the IOAM
> processing by the sender), INPUT (evaluates the IOAM processing by the receiver)
> and GLOBAL (evaluates wider use cases that do not fall into the other two
> categories). Both OUTPUT and INPUT tests only use a two-node topology (alpha and
> beta), while GLOBAL tests use the entire three-node topology (alpha, beta,
> gamma). Each test is documented inside its own handler in the (bash) script.

Thanks for the followup!
