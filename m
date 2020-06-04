Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929AA1EE8B9
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgFDQkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 12:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbgFDQkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 12:40:09 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD065C08C5C1;
        Thu,  4 Jun 2020 09:40:09 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 205so6700692qkg.3;
        Thu, 04 Jun 2020 09:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vpxoaRlLXXL6dqAlRHJzpCpNRDw8gKnVpEUqcTzIN4U=;
        b=CH3D4RTtX7stOh46iK+yDuN8h4X1qoxSO/LxA96+iL70npx4lW9WRsnnsGrzf8m8Xy
         wb2ql6FxZVGoTqtIzTdeilT5xeJAkmJ2Ml2r+3OXoF8SoRvc1cLmn3MhEHkyotT9qbnA
         l70iPRZMQ+8kGYSDMnvWuTAh3XvIxntlpURP1ctCO67Dmx2T8x8YzIThvtcPHldZe4YY
         HZDiD6QFouABaMBMDbspJaj2qGlMrzjfoiBWAb28xcUSU0/4Dkz/qCTacC0r19LP7JGE
         kghXRkEwEBrvBT9Y7UlkTsD1uEteuBtjkEku4pS+TxnvOrFgs5CjLNmyHGVxq0yaA8n6
         GFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vpxoaRlLXXL6dqAlRHJzpCpNRDw8gKnVpEUqcTzIN4U=;
        b=NY9SH+BDHyu8nCHh4xIo5vZWbdJFvMmQfRk/cm7bmIrR/QITwyC1fAy+9ZG7xgauIy
         7gXCPfG3pwVAebjkm8cTi+/ZH2Otwx71pbq/u15/rDpgeZLLDF0C9FQVxaBi6E8PMhkH
         vsqh9qdS2tTuOf1Pn7eHg4qGVUtaLFG62CIi4pNe6Q0qyu6cy0B0PREK8VX0tThZgEId
         uIJCaWBGt8SXZY0NDPAikLur8yM9vtcHqgDH6L0m7LpAkSXT4ngTWRWhKeGFIFXW3/87
         04Sh8aWHbVIuSRNq7UOyzoj7WAwxpil6/ni/7xIADxHqi8+JWnRPsFPW1P1j1xqE7vyz
         M5UA==
X-Gm-Message-State: AOAM530dOkxfOZL2BCOBigGTjJTKSIlIQw7OadUjTXSAH1EAtu9+qWGO
        ICU75vNXRQDdolq8QRB6UTk=
X-Google-Smtp-Source: ABdhPJw+p61FGscolshg2xTDrDkUydnbiQ915+ENHYBNmmlyHixI5pUez6hX8yzYkPpdkL4KHt999w==
X-Received: by 2002:a05:620a:158d:: with SMTP id d13mr5636884qkk.327.1591288808968;
        Thu, 04 Jun 2020 09:40:08 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:6c0b:a591:6e4c:f8f6? ([2601:282:803:7700:6c0b:a591:6e4c:f8f6])
        by smtp.googlemail.com with ESMTPSA id x13sm3896454qtq.60.2020.06.04.09.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 09:40:08 -0700 (PDT)
Subject: Re: [PATCH bpf-next V1] bpf: devmap dynamic map-value area based on
 BTF
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Miller <davem@davemloft.net>
References: <159119908343.1649854.17264745504030734400.stgit@firesoul>
 <20200603162257.nxgultkidnb7yb6q@ast-mbp.dhcp.thefacebook.com>
 <20200604174806.29130b81@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <205b3716-e571-b38f-614f-86819d153c4e@gmail.com>
Date:   Thu, 4 Jun 2020 10:40:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200604174806.29130b81@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/20 9:48 AM, Jesper Dangaard Brouer wrote:
> I will NOT send a patch that expose this in uapi/bpf.h.  As I explained
> before, this caused the issues for my userspace application, that
> automatically picked-up struct bpf_devmap_val, and started to fail
> (with no code changes), because it needed minus-1 as input.  I fear
> that this will cause more work for me later, when I have to helpout and
> support end-users on e.g. xdp-newbies list, as it will not be obvious
> to end-users why their programs map-insert start to fail.  I have given
> up, so I will not NACK anyone sending such a patch.
> 
> Why is it we need to support file-descriptor zero as a valid
> file-descriptor for a bpf-prog?

That was a nice property of using the id instead of fd. And the init to
-1 is not unique to this; adopters of the bpf_set_link_xdp_fd_opts for
example have to do the same.
