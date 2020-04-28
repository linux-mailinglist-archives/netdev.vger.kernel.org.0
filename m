Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9861BB8BE
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 10:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgD1IXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 04:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726490AbgD1IXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 04:23:38 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680AAC03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:23:38 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k12so1703710wmj.3
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c2FzfYrSfRrMUN8OlD2ef4F90AQ5dT7xJzny8NDbZLc=;
        b=lVlB/D1PSWdgFCnnduhdgnSK+7L7NoUxkG75hjim/wBfv4+Uca7NmMJC7MxQ8Gts2g
         O0DB0Rs0BWgHRJGNg5dB8KfnaIhJyATmYGrGVGBepqP7ZvrvLL83Tp3u/wZ6TcaXFLGr
         hjhzd8KVqtPTlr/nvnFMoNHtjtVDc2CpC9z1+elaNyItRkvu1BfdNKKiZATf0CIcvybp
         uaeTqH5cPq6Uet1ajw/Oq2JjBPXeOfGJbNiTxumeisdziiRY2ki6XhuEfgjgR3g0e6RA
         NHUWKnKkO3O7cvdmOYrdBEgZkFO1zySv1UAJsDygNS90KiFUUS4XfokE0RZJEdmKTt4C
         ackw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c2FzfYrSfRrMUN8OlD2ef4F90AQ5dT7xJzny8NDbZLc=;
        b=Ipe70COcxnEZIWVtln8leNh22+tujYxVngplqZt1/t241AFLeExnzEETGiCunjn31J
         IhQZGV3FMImijB5F2ErrDwHoNkOoKsOLBFi0sbCFa/iZ3qHmg7WCS0E8hBrssUUxhKZS
         u9JYYZXoLdmtOGoLfaQRy6+Mj3cyZ/kO86pKtsPlhEN8yeGwWy2TOJhAXQP3sCPpdWxa
         KwzXANO+4/BSdP8dvDbiNC7HgGSqdVsMNatvQvl/cvZE72grnBZG9tL5x3h3yDTqq73W
         syJ42HMYKNrZtwNab2JaXfJtx4LzAbqYJpX2fyX6Sq/QKbR3jgyA94DJJX0K0vL3nbEv
         noMQ==
X-Gm-Message-State: AGi0PubvfA4RMBqfNca9u4vxluz1qsueay/z1OL9SHyjQPspA7ReVb6i
        AUyqihr54j6itTSJbcl46sX2Yw==
X-Google-Smtp-Source: APiQypI82QymK+2IDYedwuAmE/CPaV8T0IDfgVBVQyitLr2k4cOjySZJWEsg9BY5X6fkYEz71cTFaQ==
X-Received: by 2002:a1c:59c3:: with SMTP id n186mr3142685wmb.24.1588062217206;
        Tue, 28 Apr 2020 01:23:37 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.137])
        by smtp.gmail.com with ESMTPSA id x6sm26997569wrg.58.2020.04.28.01.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 01:23:36 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 09/10] bpftool: add bpftool-link manpage
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200428054944.4015462-1-andriin@fb.com>
 <20200428054944.4015462-10-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <e538432d-2a4f-465b-ea6d-48d58fdb94ac@isovalent.com>
Date:   Tue, 28 Apr 2020 09:23:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428054944.4015462-10-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-27 22:49 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Add bpftool-link manpage with information and examples of link-related
> commands.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

