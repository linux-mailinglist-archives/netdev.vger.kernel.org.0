Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607A8201F88
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 03:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731530AbgFTBrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 21:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731506AbgFTBra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 21:47:30 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A97C0613EE
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 18:47:29 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g10so10028342wmh.4
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 18:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RRI80pA92+WHPe9JHb6RmDr21aTeoF611uNGQOBLC6U=;
        b=HF6GUPMnU7PJza0RCjFsXIUBRgrINKzJIF85lCW72p84EM7R/7KrucBsh20kjrvDUN
         xemgR8iT9cYQM+EL++L6aGp/PEzm4ZUBSAOfmm5ByD5ALMkpf0R2/Iq2C97vqML+81/a
         oHf5BBnhheLu1zAt5mIe6MhpGxlxcsXC38u34HQ0WvdglzzMVXT1xc7NcgAjbl8NqbQ5
         wWftD7wWylDbY2gY6hb4wVrvBn1c7akZGxlVJ4wHnIJbt7tOr6YpOLaB4ZVgN9lLTMd/
         kfgHZ1Gr2DoqIsBalOPZjNCc55qFtdLRV8SVbz0ZWJS4+HUBahXLolxTfbp75HXiymlx
         u14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RRI80pA92+WHPe9JHb6RmDr21aTeoF611uNGQOBLC6U=;
        b=jVZlkA0WK19URslIW4NGvVYMBHLqjbsqazu0lOOEiFMBdArymjgfI1qsKOYANCpYaN
         VFl5cfcsNWVZOO0+7F4ZH8mf6WEgUf2/0Nz8WpkdU2UCMx5jdhS/LPVrwaqSZfHYlib1
         Jee/vBlOugFCbIj0tMS68VBQ5t+LnngLBIIyUVb2ob1wrynLZkfY1N7ty1amM8BXHP2U
         z7Z/IiGVhF0DJbHEepBYAmEq85QihZ+W+0Js7jOj3hXkB8m8nUGjUAnDxD6Dx0HpXc+K
         mvK4WspFtgfBnZOrqFkbE2w+94UGl/694p8Cs3Li6oNU7L8W7KPOF0Gb+MMw+4Ds/us0
         f44g==
X-Gm-Message-State: AOAM532yCjZgVFZIoIYb74W+bge/jM7YKQwekUo9drzwsmXiZJeWr2/q
        EmEV4jZ/isvIBFxzMvqBp+GiaQ==
X-Google-Smtp-Source: ABdhPJwr/DxFHYX7yqC/YFIi3AclIK7SUR4dWewKjzMchrhWDMSNhDWeCOIjHFtcZQL7ViaeJY3MhA==
X-Received: by 2002:a1c:4105:: with SMTP id o5mr6293936wma.168.1592617647867;
        Fri, 19 Jun 2020 18:47:27 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.184.63])
        by smtp.gmail.com with ESMTPSA id z16sm9034442wrm.70.2020.06.19.18.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 18:47:27 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 9/9] tools/bpftool: add documentation and
 sample output for process info
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>
References: <20200619231703.738941-1-andriin@fb.com>
 <20200619231703.738941-10-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <03d5040d-eb51-1984-4042-c6f461828063@isovalent.com>
Date:   Sat, 20 Jun 2020 02:47:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619231703.738941-10-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-19 16:17 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Add statements about bpftool being able to discover process info, holding
> reference to BPF map, prog, link, or BTF. Show example output as well.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks!

