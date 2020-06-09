Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CBD1F3D09
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 15:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgFINrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 09:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgFINrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 09:47:09 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DF9C05BD1E;
        Tue,  9 Jun 2020 06:47:08 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id t6so7407544otk.9;
        Tue, 09 Jun 2020 06:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qgKoPkdMulK8cD96PHMScD30hE1lFNmXEnKFEDFAepg=;
        b=YKD1A4FcQwSV53erTJO0/LQOfea3xVVq60w/XyKAjQaYh7j7XoVSpVdp2cbLPXYadm
         SB/Al+Eh6QJviW0OmtGMw51zj5xMoybNF0lekrKHKYn2Rtv7NrcRb+tEfJLoeyWE5fUa
         KDhhopnjsl9kf1304Mj+ZzlwbIIPvsczE6g00QZAv+JwHXznZVJ/WcV2nBhumvQ/d+Cm
         y0h26/bROTnoc+X2uP+b7mn93apMBWsJIcKn80iQUYF05NGPnsfRTtMYqCsrxBOnpO3l
         V0Iabt8GeWSZMDbr0zoma3TrrGDijeXnxOPJM+5AAMTSMJnfHtTqszW9oPVSYnshYBIV
         eTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qgKoPkdMulK8cD96PHMScD30hE1lFNmXEnKFEDFAepg=;
        b=mxVtLCmKXaEU5CekjZ9/eC7ICPV1AXrP/DIPmvuDUC/DOlNNVHhiJlaNQjOpgRrOQi
         nr/8X1htvIsmBXepI5xXmIyKSAWaiEe8XbEQb59TjgIx/pShPpBIgHq53qftkz9427ds
         aPu0Rcthmcx/uHJlZDBI2THtrQOdghdErvuUO/F5ES+nonO+PDTWgTLKUuRpPpoZLjgK
         RZ4Y0Gnc+Y0mAxoliUX0cPBG9ZWz5cc+xD7LHOR/OvnxHC/Iwt/910BO2uEK0Z2jqMHY
         iue2Fg6pNFgxeETsPchQ7+rFTGVpYlo7yF+tGkK4V92pyzOxtw5yzF0U8haoUKvcSf6X
         hY3Q==
X-Gm-Message-State: AOAM5317VW6oCgt0MlR+m9Zqgj5OyOtN9xxuapaFSTerQc5OOe+pH3XR
        MVwlvYnfr38RICY7H2kbmbY=
X-Google-Smtp-Source: ABdhPJwyoS15lKTFHDjTs6kqCBVkjBROTRVqrtBlL/R3VlXtid16ISbZnPVV4BRPiSkFxGvalrHs8Q==
X-Received: by 2002:a9d:67c1:: with SMTP id c1mr15006400otn.27.1591710428171;
        Tue, 09 Jun 2020 06:47:08 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:88f9:fca6:94cb:96a4? ([2601:282:803:7700:88f9:fca6:94cb:96a4])
        by smtp.googlemail.com with ESMTPSA id r65sm1044439oie.13.2020.06.09.06.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 06:47:07 -0700 (PDT)
Subject: Re: [PATCH bpf V2 1/2] bpf: devmap adjust uapi for attach bpf program
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <159170947966.2102545.14401752480810420709.stgit@firesoul>
 <159170950687.2102545.7235914718298050113.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a34343ec-2248-111d-9360-f00de212dbcb@gmail.com>
Date:   Tue, 9 Jun 2020 07:47:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <159170950687.2102545.7235914718298050113.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/20 7:31 AM, Jesper Dangaard Brouer wrote:
> This patch remove the minus-1 checks, and have zero mean feature isn't used.
> 

For consistency this should apply to other XDP fd uses as well -- like
IFLA_XDP_EXPECTED_FD and IFLA_XDP_FD.
