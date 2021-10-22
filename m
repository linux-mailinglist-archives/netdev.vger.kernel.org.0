Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B22437395
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 10:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhJVIWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 04:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbhJVIWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 04:22:44 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD896C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 01:20:26 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d3so3480966wrh.8
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 01:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=neYj3P+KpD7Ixifz+7FY5d/nurCJB3b5gZwG2Bu+tWA=;
        b=MQQ96Ad3GvUJIHBvb4Bvf2VBFIMn8/IRihE+Dup8572sBeDX7PGZnKtEoPMl2AIzjH
         /fssTrL3B4HWFp9S1nmlFsTck7Gn62GI8uwtWYWoUDTAS8XkiM2IUBi3hq13f6B+IE9f
         u5W0qTMUviS9DeSypiuEfQEc8431st8buHB7Tr3h3ipEVVULCF+ezW1enOvaE/o6gEb1
         j4J1eGRmoImbo0EVixMm3p4J+luaFw+zRdQaaRW2KMrhm/lL+wHuUodLi4/7UjTC8RUW
         STXZJXmNWGrh1CZpajcDz7onv0BeB4z2Sz2HCGW6Kcar/f2IireW6sYAtAL+aNk61qir
         UtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=neYj3P+KpD7Ixifz+7FY5d/nurCJB3b5gZwG2Bu+tWA=;
        b=Fqp2cjw2+pP08gNBzIf2313M7uvJ/7ugUcg1TPVdynqmiaeurRVOh7Q6rZz7Bx/vmL
         2SF6zcgKVSsMQSCDqt8Vq1AJXgzyYF9InN0z0WroA2zuD8xJBjPFbroEsBbKOqfAON3h
         iL24VmlXC6eUwkuva0CFthGGs/8VKRFk4j15CYIoQF0SKfAfU9wRgPSLhYZmQR5snL0o
         j8W3bxvKPKUI9NcxfdoWBJKAlsaD0xpcj46HXhnyOKELh5WFCLx8PyYQy13+YEbpNJQb
         greNfbZjPeD3tiUm92+ibTHzNL6+OANiHFc9TTxIuomL3nxcdDZv0jVaJgiWHVwhMRKE
         4IaA==
X-Gm-Message-State: AOAM530i2pXI94OR/X1t1NTJlfDpn92HEAkIYsqtZwjpI8ngCMdHKr7w
        V34QCkzvLUH4lCxblPjZYlB99cBAkAtTFP5K
X-Google-Smtp-Source: ABdhPJwwI2ntAGm8BDkW8fxgcUnYPYIusmCXdTeOURUv/D6LptPaPFSbmiraJ6C/sCdgDPXRRMQEfw==
X-Received: by 2002:a5d:4b51:: with SMTP id w17mr10585157wrs.47.1634890825468;
        Fri, 22 Oct 2021 01:20:25 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.66.22])
        by smtp.gmail.com with ESMTPSA id o17sm1372876wmq.11.2021.10.22.01.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 01:20:25 -0700 (PDT)
Message-ID: <0d4e18a7-4db4-a942-60ad-a9e5312a316b@isovalent.com>
Date:   Fri, 22 Oct 2021 09:20:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next v5 2/3] bpftool: conditionally append / to the
 progtype
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
References: <20211021214814.1236114-1-sdf@google.com>
 <20211021214814.1236114-3-sdf@google.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20211021214814.1236114-3-sdf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-10-21 14:48 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> Otherwise, attaching with bpftool doesn't work with strict section names.
> 
> Also, switch to libbpf strict mode to use the latest conventions
> (note, I don't think we have any cli api guarantees?).
> 
> Cc: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Thanks!
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
